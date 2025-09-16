{self, pkgs, ...}:
{
    # environment.systemPackages = [

    # ];
    nix.settings.experimental-features = "nix-command flakes";
    # system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 5;
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew = {
        enable = true;
        brews = [
            "font-hack-nerd-font"
        ];
        casks = [
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