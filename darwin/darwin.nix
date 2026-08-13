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
        # Home Manager exports the native prefix and Oh My Zsh's brew plugin
        # adds its completion path before its single compinit invocation.
        # Avoid running `brew shellenv` again in every interactive shell.
        enableZshIntegration = false;
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
        # App Store exclusives — neither has a homebrew-cask, so they can't be
        # `casks`. These entries are only ever no-ops: `brew bundle` checks
        # app_id_installed? first and skips without invoking mas at all.
        #
        # They cannot perform a *first* install during activation. mas escalates
        # before doing anything — AppStoreAction.swift does
        #     guard getuid() == 0 else { try sudo(...); return }
        # spawning `sudo <mas> install --force <id>` and blocking on waitpid with
        # no timeout. During activation the Homebrew bundle is already inside
        # `sudo --user=...` with no usable tty, so that inner sudo never
        # authenticates and the whole switch wedges — taking home-manager, which
        # runs after the bundle, with it.
        #
        # To install a new one: `sudo mas install <id>` by hand. Being root
        # already skips the re-spawn, so it just works.
        masApps = {
            "Amphetamine" = 937984704;
            "Magnet" = 441258766;
        };
    };

    # nix-homebrew also enables its own `brew shellenv` hook by default.
    # HOMEBREW_PREFIX and PATH are already provided declaratively.
    nix-homebrew.enableZshIntegration = false;

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

    programs.zsh = {
        enable = true;

        # Home Manager/Oh My Zsh owns the prompt and completion lifecycle.
        # Running nix-darwin's defaults first duplicates compinit (including a
        # separate unversioned dump) and makes cold terminal startup expensive.
        enableGlobalCompInit = false;
        enableBashCompletion = false;
        promptInit = "";
    };
}
