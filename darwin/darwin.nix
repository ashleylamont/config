{ config, pkgs, lib, ... }:
{
    # macOS installs Nix via the Determinate installer, which manages its own
    # nix-daemon/nix.conf. nix-darwin's built-in Nix management conflicts with
    # that (both trying to own the daemon plist and /etc/nix/nix.conf), so it
    # must be disabled here. This also makes nix.settings below a no-op for
    # nix.conf generation - Determinate already enables nix-command/flakes by
    # default, so it's kept only as documentation of the expected settings.
    nix.enable = false;
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
            "mas" # Mac App Store CLI, for the App Store apps noted below
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
            "obsidian"
            "jetbrains-toolbox"
        ];
        # Amphetamine (937984704) and Magnet (441258766) are App Store exclusives —
        # no homebrew-cask exists for either, so they can't be `casks`. They were
        # briefly `masApps`, but `mas install` needs the app to already be in this
        # Apple ID's purchase history; for anything else it hangs indefinitely
        # inside its own `sudo` without ever starting the download, which takes the
        # whole activation (and home-manager, which runs after the Homebrew bundle)
        # down with it. Install both from the App Store by hand, then a masApps
        # block becomes a safe no-op if you want them declared here.
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