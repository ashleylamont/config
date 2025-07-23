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

    programs.starship.enable = true;
}