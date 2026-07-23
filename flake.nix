{
    description = "Ashley's environment configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

        # worktrunk on nixos-26.05 is stuck on 0.50.0; herdr-worktrunk needs >=0.60.0 for its
        # switch/create shortcuts, so pull just that package from unstable instead.
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Lix
        lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
        lix-module.inputs.nixpkgs.follows = "nixpkgs";

        # Herdr - https://herdr.dev/
        herdr.url = "github:ogulcancelik/herdr";
        herdr.inputs.nixpkgs.follows = "nixpkgs";

        # Herdr plugin wiring worktrunk's worktree picker into Herdr - https://github.com/devashish2203/herdr-worktrunk
        herdr-worktrunk = {
            url = "github:devashish2203/herdr-worktrunk";
            flake = false;
        };

        # Nix-Darwin
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager/release-26.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Nix-homebrew
        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };
        homebrew-cask = {
            url = "github:Homebrew/homebrew-cask";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, lix-module, nix-homebrew, homebrew-core, homebrew-cask, herdr, herdr-worktrunk, ... }@inputs:
    {
        homeModules.default = { pkgs, lib, ... }: {
            imports = [ ./home/core.nix ];
            home.packages = [
                herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
                nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.worktrunk
            ];

            # Registers the herdr-worktrunk plugin (fzf picker for worktrunk worktrees) with herdr.
            # `plugin link` works offline and re-registers cleanly, so unlink-then-link on every
            # activation keeps it in sync with the pinned flake input without erroring on relink.
            home.activation.herdrWorktrunkPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                herdrBin="${herdr.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/herdr"
                $DRY_RUN_CMD "$herdrBin" plugin unlink worktrunk >/dev/null 2>&1 || true
                $DRY_RUN_CMD "$herdrBin" plugin link ${herdr-worktrunk} $VERBOSE_ARG
            '';
        };
        homeDarwinModules.default = import ./home/darwin.nix;
        darwinModules.default = import ./darwin/darwin.nix;

        homebrewTaps.default = {
            "homebrew/homebrew-core" = homebrew-core;
            "homebrew/homebrew-cask" = homebrew-cask;
        };

        # Home Manager configuration for Fedora (Linux). Does not include any darwin-specific modules.
        homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [
                self.homeModules.default
                {
                    home.username = "ashley";
                    home.homeDirectory = "/home/ashley";
                    home.sessionPath = nixpkgs.lib.optional (builtins.pathExists "/usr/local/cuda/bin")
                        "/usr/local/cuda/bin";
                    home.sessionVariables = nixpkgs.lib.optionalAttrs (builtins.pathExists "/usr/local/cuda/lib64") {
                        LD_LIBRARY_PATH = "/usr/local/cuda/lib64";
                    };
                }
            ];
        };

        darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs {
                system = "aarch64-darwin";
            };
            modules = [
                home-manager.darwinModules.home-manager
                nix-homebrew.darwinModules.nix-homebrew
                ({pkgs, ...}: {
                    users.users.ashley = {
                        home = "/Users/ashley";
                        shell = pkgs.zsh;
                    };
                    system.primaryUser = "ashley";

                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;

                        backupFileExtension = "hm-bak";

                        users.ashley.imports = [
                            self.homeModules.default
                            self.homeDarwinModules.default
                        ];
                    };

                    # Manage Homebrew with nix-homebrew
                    nix-homebrew = {
                        enable = true;
                        enableRosetta = false;
                        user = "ashley";
                        autoMigrate = true;
                        taps = self.homebrewTaps.default;
                    };
                })
                self.darwinModules.default
            ];
        };
    };
}
