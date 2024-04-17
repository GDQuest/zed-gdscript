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
        let path = worktree
            .which("nc")
            .ok_or_else(|| "nc must be installed and available on your $PATH".to_string())?;

        Ok(zed::Command {
            command: path,
            args: vec!["127.0.0.1".to_string(), "6005".to_string()],
            env: Default::default(),
        })
    }
}

zed::register_extension!(GDScriptExtension);
