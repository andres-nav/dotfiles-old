set fish_greeting

fish_config theme choose fish\ default

if type -q direnv
    direnv hook fish | source
end

fzf_configure_bindings --directory=\cd

alias lf lfcd

abbr -a nr nix run nixpkgs#

if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end
