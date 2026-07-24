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

        # Herdr plugin: fzf overlay over every installed plugin's actions - https://github.com/JanTvrdik/herdr-command-palette
        herdr-command-palette = {
            url = "github:JanTvrdik/herdr-command-palette";
            flake = false;
        };

        # Herdr plugin: git-aware file viewer / diff pane - https://github.com/smarzban/herdr-file-viewer
        # Pinned to the release tag whose prebuilt binary hash is baked in below (see
        # herdrFileViewerBinary) - bump both together when updating.
        herdr-file-viewer-src = {
            url = "github:smarzban/herdr-file-viewer/v1.14.0";
            flake = false;
        };

        # Herdr plugin: review an agent's diff and send comments back to it - https://github.com/persiyanov/herdr-reviewr
        # Pinned to the release tag whose prebuilt binary hash is baked in below (see
        # herdrReviewrBinary) - bump both together when updating.
        herdr-reviewr-src = {
            url = "github:persiyanov/herdr-reviewr/v0.22.1";
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

    outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, lix-module, nix-homebrew, homebrew-core, homebrew-cask, herdr, herdr-worktrunk, herdr-command-palette, herdr-file-viewer-src, herdr-reviewr-src, ... }@inputs:
    {
        homeModules.default = { pkgs, lib, ... }:
        let
            system = pkgs.stdenv.hostPlatform.system;
            herdrBinPath = "${herdr.packages.${system}.default}/bin/herdr";

            # herdr-file-viewer and herdr-reviewr ship prebuilt release binaries, but herdr only
            # downloads those itself on `plugin install` (which needs network + a mutable managed
            # checkout) - `plugin link` skips that build step entirely. So we fetch the same
            # per-platform release asset ourselves and assemble a plugin dir with the binary
            # already in place, then link that instead of the bare source tree.
            herdrFileViewerBinary = {
                aarch64-darwin = pkgs.fetchurl {
                    url = "https://github.com/smarzban/herdr-file-viewer/releases/download/v1.14.0/herdr-file-viewer-aarch64-apple-darwin";
                    sha256 = "b2ea1630444ead2be0b824d112452fef747908ff20a2abd11f1f0d011ee9016c";
                };
                x86_64-linux = pkgs.fetchurl {
                    url = "https://github.com/smarzban/herdr-file-viewer/releases/download/v1.14.0/herdr-file-viewer-x86_64-unknown-linux-musl";
                    sha256 = "65d82dbbde6a4f7844332340a527118011649ac65346ce6b27dad399b733b2ae";
                };
            }.${system};

            herdrFileViewerPlugin = pkgs.runCommand "herdr-file-viewer-plugin" { } ''
                cp -r ${herdr-file-viewer-src} $out
                chmod -R u+w $out
                mkdir -p $out/target/release
                cp ${herdrFileViewerBinary} $out/target/release/herdr-file-viewer
                chmod +x $out/target/release/herdr-file-viewer
            '';

            herdrReviewrBinary = {
                aarch64-darwin = pkgs.fetchurl {
                    url = "https://github.com/persiyanov/herdr-reviewr/releases/download/v0.22.1/herdr-reviewr-aarch64-apple-darwin.tar.gz";
                    sha256 = "b97cfcda47619a7cbe0c751cbfe73a9bb8c7364103e2c2d27a9aa9bbbab7b0dc";
                };
                x86_64-linux = pkgs.fetchurl {
                    url = "https://github.com/persiyanov/herdr-reviewr/releases/download/v0.22.1/herdr-reviewr-x86_64-unknown-linux-gnu.tar.gz";
                    sha256 = "c9df3d7e9a9e7fb053645d58337495772c979d8f4b2dd7592af3ccb01bae11eb";
                };
            }.${system};

            herdrReviewrPlugin = pkgs.runCommand "herdr-reviewr-plugin" { } ''
                cp -r ${herdr-reviewr-src} $out
                chmod -R u+w $out
                mkdir -p $out/bin
                tar -xzf ${herdrReviewrBinary} -C $out/bin
                chmod +x $out/bin/herdr-reviewr
            '';
        in {
            imports = [ ./home/core.nix ];
            home.packages = [
                herdr.packages.${system}.default
                nixpkgs-unstable.legacyPackages.${system}.worktrunk
            ];

            # Registers each herdr plugin with herdr. `plugin link` works offline and re-registers
            # cleanly, so unlink-then-link (by manifest id) on every activation keeps them in sync
            # with their pinned flake inputs/derivations without erroring on relink.
            home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                linkHerdrPlugin() {
                    $DRY_RUN_CMD "${herdrBinPath}" plugin unlink "$1" >/dev/null 2>&1 || true
                    $DRY_RUN_CMD "${herdrBinPath}" plugin link "$2" $VERBOSE_ARG
                }
                linkHerdrPlugin worktrunk ${herdr-worktrunk}
                linkHerdrPlugin jt.command-palette ${herdr-command-palette}
                linkHerdrPlugin herdr-file-viewer ${herdrFileViewerPlugin}
                linkHerdrPlugin persiyanov.reviewr ${herdrReviewrPlugin}
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
