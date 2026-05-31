{config, pkgs, lib, ...}:
{
    # Use native macOS pinentry (from GPG Suite) so GUI apps like WebStorm,
    # GitButler, etc. can trigger the passphrase dialog without needing X11/GTK.
    services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "iterm2"
                "macos"
            ];
        };
        shellAliases = {
            # MacOS DNS
            flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
        };
    };
}