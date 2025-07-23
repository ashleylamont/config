{ config, pkgs, lib, ... }:

{
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        git
        zsh
        micro
        oh-my-zsh
        starship
        zsh-autosuggestions
        zsh-syntax-highlighting
        eza
        zoxide
        thefuck
    ];

    programs.git = {
        enable = true;
        userEmail = lib.mkDefault "ashley@ashl.dev";
        userName = "Ashley Lamont";
    };

    programs.zsh = {
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
        initExtraBeforeCompInit = ''
            # Compinit init
            autoload -Uz compinit
            if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
                compinit
            else
                compinit -C
            fi

            # Lazy load slow plugins
            zstyle ':omz:plugins:nvm' lazy yes
        '';
        initExtra = ''
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
        '';
        shellAliases = {
            # Default command replacements
            ls = "eza -l --group-directories-first --icons --hyperlink --almost-all";
            cd = "z";
        };
    };

    programs.starship = {
        enable = true;
        settings = {
            format = ''
                [](#9A348E)\
                $os\
                $username\
                [](bg:#DA627D fg:#9A348E)\
                $directory\
                [](fg:#DA627D bg:#FCA17D)\
                $cmd_duration\
                [](fg:#FCA17D bg:#86BBD8)\
                $c\
                $elixir\
                $elm\
                $golang\
                $gradle\
                $haskell\
                $java\
                $julia\
                $nodejs\
                $nim\
                $rust\
                $scala\
                [](fg:#86BBD8 bg:#06969A)\
                $docker_context\
                [](fg:#06969A bg:#33658A)\
                $time\
                [ ](fg:#33658A)\
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
        };
    };
}