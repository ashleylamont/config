{ config, pkgs, lib, ... }:
{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = 5; # nix-darwin state version (keep as-is unless upgrading semantics)
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = false;
            upgrade = true;
        };
        brews = [
            "watch" # no cross-platform nixpkgs equivalent on Darwin
            "pipx" # nixpkgs' pipx currently fails its own tests building from source on aarch64-darwin
        ];
        casks = [
            "font-hack-nerd-font"
            "font-commit-mono-nerd-font"
            "alt-tab"
            "iterm2"
            "visual-studio-code"
            "middle"
            "raycast"
            "spotmenu"
            "vlc"
            "docker-desktop"
            "mockoon"
            "scroll-reverser"
            "stats"
            "meetingbar"
            "gpg-suite-no-mail"
            "bruno"
            "keycastr"
            "pgadmin4"
            "spotify" # cask has occasionally had signing issues - watch for install failures
            "obsidian"
            "amphetamine" # Mac App Store app - cask install needs `mas` + an authenticated App Store session
            "magnet" # Mac App Store app - cask install needs `mas` + an authenticated App Store session
            "jetbrains-toolbox"
        ];
    };

    system.defaults = {
        dock = {
            autohide = true;
            tilesize = 47;
        };
        finder = {
            ShowStatusBar = true;
            FXPreferredViewStyle = "Nlsv";
        };
        NSGlobalDomain = {
            AppleShowAllExtensions = true;
            NSAutomaticCapitalizationEnabled = false;
            AppleInterfaceStyleSwitchesAutomatically = true;
        };
        trackpad = {
            Clicking = false;
        };
    };

    environment.shells = [
        pkgs.bashInteractive
        pkgs.zsh
    ];

    programs.zsh.enable = true;
}