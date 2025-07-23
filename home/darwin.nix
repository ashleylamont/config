{config, pkgs, lib, ...}:
{
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