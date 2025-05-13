{
    description = "Ashley's environment configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

        # Lix
        lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
        lix-module.inputs.nixpkgs.follows = "nixpkgs";

        # Nix-Darwin
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, nix-darwin, home-manager, lix-module }@inputs:
    let
        system = "aarch64-darwin";
    in
    {
        homeModules.default = import ./home/core.nix;
        darwinModules.default = import ./darwin/darwin.nix;
        darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
            inherit system;
            pkgs = import nixpkgs {
                inherit system;
            };
            modules = [
                self.darwinModules.default
                home-manager.darwinModules.home-manager
                ({pkgs, ...}: {
                    users.users.ashley = {
                        home = "/Users/alamont";
                        shell = pkgs.zsh;
                    };

                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;

                        users.ashley.imports = [
                            self.homeModules.default
                        ];
                    };
                })
            ];
        };
    };
}