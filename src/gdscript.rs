use zed::LanguageServerId;
use zed_extension_api::{self as zed, Result};

struct GDScriptExtension;

impl zed::Extension for GDScriptExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let nc_command = if cfg!(target_os = "windows") {
            worktree.which("ncat").or_else(|| worktree.which("nc"))
        } else {
            worktree.which("nc").or_else(|| worktree.which("ncat"))
        };

        let path = nc_command
            .ok_or_else(|| "nc or ncat must be installed and available on your PATH".to_string())?;

        Ok(zed::Command {
            command: path,
            args: vec!["127.0.0.1".to_string(), "6005".to_string()],
            env: Default::default(),
        })
    }
}

zed::register_extension!(GDScriptExtension);
