{
    description = "Ashley's environment configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Nix-Darwin
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        # Lix
        lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
        lix-module.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, nix-darwin, lix-module }@inputs:
    let
        systems = [
            "x86_64-darwin"
            "aarch64-darwin"
        ];
        pkgsFor = sys:
            import nixpkgs {
                system = sys;
            };
        hmMods = [
            # ./home/core.nix
        ];
        currentUser = builtins.getEnv "USER";
    in
    {
        hmMods = hmMods;
        ### Standalone Linux Home-Manager Hosts ###
        homeConfigurations.standaloneLinux = 
            home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsFor "x86_64-linux";
                modules = hmMods;
            };
        ### Nix-Darwin Home-Manager Hosts ###
        darwinConfigurations.darwin = 
            nix-darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                modules = [
                    # ./darwin/darwin.nix
                    home-manager.darwinModules.home-manager
                    {
                        home-manager.users.${currentUser}.imports = hmMods;
                    }
                ];
            };
        
    };
}