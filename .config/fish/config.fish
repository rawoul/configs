# features
set -U fish_features 3.0 3.1 3.4
set -g fish_greeting

# ensure perms
umask 022

# env
fish_add_path ~/bin
set -gx BROWSER firefox
set -gx EDITOR vim
set -gx LESS "-q -R -S"
set -gx LESS_TERMCAP_mb \e\[01\;34m
set -gx LESS_TERMCAP_md \e\[01\;34m
set -gx LESS_TERMCAP_me \e\[0m
set -gx LESS_TERMCAP_se \e\[0m
set -gx LESS_TERMCAP_so \e\[01\;44\;37m
set -gx LESS_TERMCAP_ue \e\[0m
set -gx LESS_TERMCAP_us \e\[00\;36m
set -gx PAGER less

# aliases
if status --is-interactive
    alias du "du -h"
    alias df "df -h"
    alias cp "cp -i"
    alias mv "mv -i"
    alias l "ls -1"
    function ddg
        $BROWSER "https://duckduckgo.com?k1=-1&kp=-2&kd=-1&q="(string escape --style=url "$argv")
    end
    if [ -f /etc/debian_version ]
        function apts; apt-cache search "$argv" | grep -i "$argv"; end
        function aptr; apt remove --purge $argv; end
        function apti; apt install --no-install-recommends $argv; end
    end
end

# colors
if status --is-login
    set -U fish_color_autosuggestion 2e3440
    set -U fish_color_cancel -r
    set -U fish_color_command brcyan
    set -U fish_color_comment 434c5e
    set -U fish_color_cwd blue
    set -U fish_color_cwd_root red
    set -U fish_color_end brgreen
    set -U fish_color_error brred
    set -U fish_color_escape 00a6b2
    set -U fish_color_history_current --bold
    set -U fish_color_host brwhite
    set -U fish_color_match --background=brblue
    set -U fish_color_normal normal
    set -U fish_color_operator green
    set -U fish_color_param brwhite
    set -U fish_color_quote bryellow
    set -U fish_color_redirection brmagenta
    set -U fish_color_search_match --background=203e60
    set -U fish_color_selection white --bold --background=brblack
    set -U fish_color_user blue
    set -U fish_color_valid_path brwhite
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description b3a06d
    set -U fish_pager_color_prefix --bold
    set -U fish_pager_color_progress brblack --background=222222
end

# fzf
if [ -x ~/.vim/bundle/fzf/bin/fzf ]
    fish_add_path ~/.vim/bundle/fzf/bin
    source ~/.vim/bundle/fzf/shell/key-bindings.fish
    set -x FZF_DEFAULT_OPTS --reverse
    fzf_key_bindings
end

# prompt markers
function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end
