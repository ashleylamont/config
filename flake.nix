{
    description = "Ashley's environment configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

        # Lix
        lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
        lix-module.inputs.nixpkgs.follows = "nixpkgs";

        # Nix-Darwin
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager/release-25.05";
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

    outputs = { self, nixpkgs, nix-darwin, home-manager, lix-module, nix-homebrew, ... }@inputs:
    {
        homeModules.default = import ./home/core.nix;
        homeDarwinModules.default = import ./home/darwin.nix;
        darwinModules.default = import ./darwin/darwin.nix;

        # Home Manager configuration for Fedora (Linux). Does not include any darwin-specific modules.
        homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [
                self.homeModules.default
                {
                    home.username = "ashley";
                    home.homeDirectory = "/home/ashley";
                }
            ];
        };

        darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs {
                system = "aarch64-darwin";
            };
            modules = [
                self.darwinModules.default
                home-manager.darwinModules.home-manager
                nix-homebrew.darwinModules.nix-homebrew
                ({pkgs, ...}: {
                    users.users.ashley = {
                        home = "/Users/ashley";
                        shell = pkgs.zsh;
                    };

                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;

                        backupFileExtension = "hm-backup";

                        users.ashley.imports = [
                            self.homeModules.default
                            self.homeDarwinModules.default
                        ];
                    };

                    # Manage Homebrew with nix-homebrew
                    nix-homebrew = {
                        enable = true;
                        enableRosetta = true; # Apple Silicon
                        user = "ashley";
                        autoMigrate = true;
                    };
                })
            ];
        };
    };
}