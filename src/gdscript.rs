use std::net::Ipv4Addr;

use zed_extension_api::{
    self as zed,
    serde_json::{self, Value},
    DebugAdapterBinary, Result, StartDebuggingRequestArguments,
    StartDebuggingRequestArgumentsRequest, TcpArguments,
};

struct GDScriptExtension;

impl zed::Extension for GDScriptExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let (os, _) = zed::current_platform();
        let nc_command = if os == zed::Os::Windows {
            worktree.which("ncat").or_else(|| worktree.which("nc"))
        } else {
            worktree.which("nc").or_else(|| worktree.which("ncat"))
        };

        let path = nc_command
            .ok_or_else(|| "nc or ncat must be installed and available on your PATH".to_string())?;

        let lsp_settings = zed::settings::LspSettings::for_worktree("gdscript", worktree);
        let mut args = None;

        if let Ok(lsp_settings) = lsp_settings {
            if let Some(binary) = lsp_settings.binary {
                args = binary.arguments;
            }
        }

        Ok(zed::Command {
            command: path,
            args: args.unwrap_or(vec!["127.0.0.1".to_string(), "6005".to_string()]),
            env: Default::default(),
        })
    }

    fn get_dap_binary(
        &mut self,
        adapter_name: String,
        config: zed::DebugTaskDefinition,
        _user_provided_debug_adapter_path: Option<String>,
        _worktree: &zed::Worktree,
    ) -> Result<DebugAdapterBinary, String> {
        let configuration = serde_json::from_str::<serde_json::Value>(&config.config)
            .map_err(|e| format!("Error parsing the config: {e}"))?;

        let request = self.dap_request_kind(adapter_name, configuration.clone())?;

        let host = configuration
            .get("host")
            .and_then(|host| host.as_str().and_then(|host| host.parse().ok()))
            .unwrap_or(Ipv4Addr::new(127, 0, 0, 1))
            .to_bits();

        let port = configuration
            .get("port")
            .and_then(|port| port.as_u64())
            .unwrap_or(6006) as u16;

        Ok(DebugAdapterBinary {
            command: None,
            arguments: vec![],
            envs: Default::default(),
            cwd: None,

            connection: Some(TcpArguments {
                host,
                port,
                timeout: None,
            }),

            request_args: StartDebuggingRequestArguments {
                configuration: config.config,
                request,
            },
        })
    }

    fn dap_request_kind(
        &mut self,
        _adapter_name: String,
        value: Value,
    ) -> Result<StartDebuggingRequestArgumentsRequest, String> {
        value
            .get("request")
            .and_then(|v| v.as_str())
            .ok_or("`request` was not specified".into())
            .and_then(|request| match request {
                "launch" => Ok(StartDebuggingRequestArgumentsRequest::Launch),
                "attach" => Ok(StartDebuggingRequestArgumentsRequest::Attach),
                _ => Err("`request` must be either `launch` or `attach`".into()),
            })
    }
}

zed::register_extension!(GDScriptExtension);
