function fish_prompt
    set -l hi_color blue
    set -l text_color brwhite
    if [ $USER = root ]
        set text_color red
    end

    set -l host_color $text_color
    if test -n "$SSH_TTY"
        set host_color yellow
    end

    set_color --bold
    if [ $USER != rawoul ]
        echo -n (set_color $text_color)"$USER"(set_color $hi_color)'@'
    end
    echo -n (set_color $host_color)(prompt_hostname)(set_color $hi_color)' ❯ '(set_color $text_color)(prompt_pwd)(set_color $hi_color)' ❯❯ '
    set_color normal
end
