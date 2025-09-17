{ config, pkgs, lib, ... }:
{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = 5; # nix-darwin state version (keep as-is unless upgrading semantics)
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew = {
        enable = true;
        # brews = [
        # ];
        casks = [
            "font-hack-nerd-font"
            "alt-tab"
            "bartender"
            "iterm2"
            "spotify"
            "visual-studio-code"
            "middle"
            "raycast"
            "spotmenu"
            "vlc"
            "docker"
            "docker-desktop"
            "mockoon"
            "scroll-reverser"
            "stats"
            "meetingbar"
            "gpg-suite-no-mail"
        ];
    };

    environment.shells = [
        pkgs.bashInteractive
        pkgs.zsh
    ];

    programs.zsh.enable = true;
}