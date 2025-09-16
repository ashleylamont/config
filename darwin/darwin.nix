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
        # brews = [];
        casks = [
            "gpg-suite-no-mail"
        ];
    };

    environment.shells = [
        pkgs.bashInteractive
        pkgs.zsh
    ];

    programs.zsh.enable = true;
}