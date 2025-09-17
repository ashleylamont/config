{ config, pkgs, lib, ... }:

{
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        git # version control
        zsh # better shell than bash
        micro # better editor than nano
        oh-my-zsh # better zsh than zsh
        starship # zsh prompt / theme
        zsh-autosuggestions
        zsh-syntax-highlighting 
        eza # ls replacement
        zoxide # cd replacement
        thefuck # command correction
        tldr # simplified man pages
        uv # python env management
        bat # cat replacement
        delta # git diff viewer
        dust # du replacement
        duf # df replacement
        broot # tree viewer
        fzf # fuzzy finder
        fd # find replacement
        ripgrep # grep replacement
        choose # cut/awk alternative
        jq # json parser
        bottom # system monitoring
        glances # process monitoring
        gping # ping with graph
        mtr # network diagnostics
        rustscan # nmap alternative
        procs # ps replacement
        httpie # HTTP client
        curlie # cURL replacement
        doggo # DNS client
        zsh-fzf-tab # Fuzzy finder for Zsh autocompletion
        tokei # SLOC tool
        sapling # Git GUI
        # Node tooling for CLI and GUI apps (standard channel version)
        nodejs
        yarn
        pnpm
        bun
    ];

    programs.git = {
        enable = true;
        userEmail = lib.mkDefault "ashley@ashl.dev";
        userName = "Ashley Lamont";
        extraConfig = {
            commit.gpgsign = true;
            tap.gpgSign = true;
            user.signingKey = "268A2AC24F2B46C1";
        };
    };

    programs.atuin = {
        enable = true;
        settings = {
            auto_sync = false;
            search_mode = "fuzzy";
        };
    };

    programs.zsh = {
        envExtra = ''
          export USER=''${USER:-$(id -un)}
          export LOGNAME=''${LOGNAME:-$USER}

          if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
            . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
          elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix.sh" ]; then
            . "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
          fi
        '';

        enable = true;
        autosuggestion.enable = true;
        enableCompletion = false; # We want to initialise completions manually
        syntaxHighlighting.enable = true;
        history = {
            size = 100000;
            path = "${config.home.homeDirectory}/.zsh_history";
        };
        oh-my-zsh = {
            enable = true;
            plugins = [
                "dotenv"
                "git"
                "gitfast"
                "alias-finder"
                "aliases"
                "brew"
                "bun"
                "catimg"
                "colored-man-pages"
                "colorize"
                "command-not-found"
                "common-aliases"
                "copyfile"
                "copypath"
                "git-commit"
                "gitignore"
                "history"
                "man"
                "npm"
                "nvm"
                "python"
                "safe-paste"
                "thefuck"
                "yarn"
            ];
        };
        initContent = lib.mkMerge [
            (lib.mkOrder 550 ''
                # Compinit init
                autoload -Uz compinit
                if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
                    compinit
                else
                    compinit -C
                fi

                # We don't lazy-load nvm anymore as it causes issues with PATH and various applications and tools.
                zstyle ':omz:plugins:nvm' lazy no
                
                # Make sure nix profile is loaded
                if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix.sh" ]; then
                    . "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
                fi
            '')
            (lib.mkOrder 1500 ''
            # Configure Alias Finder
            zstyle ':omz:plugins:alias-finder' autoload yes
            zstyle ':omz:plugins:alias-finder' longer yes
            zstyle ':omz:plugins:alias-finder' cheaper yes
            
            # Use nano as the default editor if SSH_CONNECTION is set, else use micro
            if [[ -n $SSH_CONNECTION ]]; then
                export EDITOR='nano'
            else
                export EDITOR='micro'
            fi
            
            # Git shortcut functions
            glatest() {
                gco $(git_main_branch)
                gfo $(git_main_branch)
                gmff
            }
            gmupdate () {
                gfo $(git_main_branch)
                gmom -m "Updating branch with incoming changes from $(git_main_branch)"
                echo "Updated $(git_main_branch) with incoming changes via merge, now run gp to push"
            }
            grbupdate () {
                gfo $(git_main_branch)
                grbom
                echo "Updated $(git_main_branch) with incoming changes via rebase, now run gp --force to push"
            }
            gbranchfiles () {
                fork_point=$(g merge-base --fork-point $(git_main_branch) $(git_current_branch))}
                g diff $fork_point HEAD | diffstat -Cm
            }
            gbranchdiff () {
                fork_point=$(g merge-base --fork-point $(git_main_branch) $(git_current_branch))}
                g diff $fork_point HEAD
            }
            gfixfsmonitor () {
                git config --local core.fsmonitor false
                git status
                git config --local core.fsmonitor true
                git status
            }

            # Thefuck
            eval "$(thefuck --alias)"

            # Zoxide
            eval "$(zoxide init zsh)"

            # Rust init
            if [[ -f "$HOME/.cargo/env" ]]; then
                source "$HOME/.cargo/env"
            fi

            # nvm auto-use
            autoload -U add-zsh-hook

            load-nvmrc() {
                local nvmrc_path
                nvmrc_path="$(nvm_find_nvmrc)"

                if [ -n "$nvmrc_path" ]; then
                    local nvmrc_node_version
                    nvmrc_node_version=$(nvm version "$(cat "''${nvmrc_path}")")

                    if [ "$nvmrc_node_version" = "N/A" ]; then
                    nvm install
                    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
                    nvm use
                    fi
                elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
                    echo "Reverting to nvm default version"
                    nvm use default
                fi
                # Finally, enable corepack to get yarn/pnpm/bun shims working
                corepack enable
            }

            add-zsh-hook chpwd load-nvmrc
            load-nvmrc
            '')
        ];
        shellAliases = {
            # Default command replacements
            ls = "eza -l --group-directories-first --icons --hyperlink --almost-all";
            cd = "z";
            # Modern drop-in-ish replacements
            cat = "bat -pp"; # cat -> bat
            grep = "rg -n -S --color=auto --hidden --no-ignore-vcs --no-heading"; # grep -> ripgrep
            fgrep = "rg -n -F --color=auto --hidden --no-ignore-vcs --no-heading"; # fixed-strings grep
            du = "dust"; # du -> dust
            df = "duf"; # df -> duf
            ps = "procs"; # ps -> procs (interactive use)
            top = "btm"; # top -> bottom
            curl = "curlie"; # curl -> curlie (curl-compatible CLI)
            dig = "doggo"; # dig -> doggo
            tree = "broot --tree"; # tree -> broot tree view
        };
    };

    programs.starship = {
        enable = true;
        settings = {
            format = ''
                [](#9A348E)$os$username[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)
            '';
            
            add_newline = true;

            username = {
                show_always = true;
                style_user = "bg:#9A348E";
                style_root = "bg:#9A348E";
                format = "[$user ]($style)";
                disabled = false;
            };

            os = {
                style = "bg:#9A348E";
                disabled = true;
            };

            directory = {
                style = "bg:#DA627D";
                format = "[ $path ]($style)";
                truncation_length = 3;
                truncation_symbol = "…/";
                substitutions = {
                    "Documents" = "󰈙 ";
                    "Downloads" = " ";
                    "Music" = " ";
                    "Pictures" = " ";
                };
            };

            c = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            docker_context = {
                symbol = " ";
                style = "bg:#06969A";
                format = "[ $symbol $context ]($style)";
            };

            elixir = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            elm = {
                symbol =  " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            cmd_duration = {
                style = "bg:#FCA17D";
                format = "[ took ($duration) ]($style)";
                show_notifications = true;
            };

            golang = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            gradle = {
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            haskell = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            java = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            julia = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            nodejs = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            nim = {
                symbol = "󰆥 ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            rust = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            scala = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            time = {
                disabled = false;
                time_format = "%R";
                style = "bg:#33658A";
                format = "[ ♥ $time ]($style)";
            };

            git_branch = {
                style = "bg:#FCA17D";
                format = "[ $symbol$branch ]($style)";
            };

            git_status = {
                style = "bg:#FCA17D";
                format = "[$all_status$ahead_behind ]($style)";
            };
        };
    };
}