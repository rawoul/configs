function fish_right_prompt
    # Show failed status
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l status_color (set_color --bold red)
    set -l prompt_status (__fish_print_pipestatus "✘ " "" "|" "$status_color" "$status_color" $last_pipestatus)
    echo -n "$prompt_status"

    if not command -sq git
        set_color normal
        return
    end

    # Get the git directory for later use.
    # Return if not inside a Git repository work tree.
    if not set -l git_dir (command git --no-optional-locks rev-parse --git-dir 2>/dev/null)
        set_color normal
        return
    end

    # Get the current action ("merge", "rebase", etc.)
    # and if there's one get the current commit hash too.
    set -l commit ''
    if set -l action (fish_print_git_action "$git_dir")
        set commit (command git --no-optional-locks rev-parse HEAD 2> /dev/null | string sub -l 7)
    end

    # Get either the branch name or a branch descriptor.
    set -l branch_detached 0
    if not set -l branch (command git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
        set branch_detached 1
        set branch (command git --no-optional-locks describe --tags HEAD 2>/dev/null)
    end

    # Get the stash status.
    # (git stash list) is very slow. => Avoid using it.
    set -l status_stashed 0
    if test -f "$git_dir/refs/stash"
        set status_stashed 1
    else if test -r "$git_dir/commondir"
        read -l commondir <"$git_dir/commondir"
        if test -f "$commondir/refs/stash"
            set status_stashed 1
        end
    end

    set_color -o brblack

    if test -n "$branch"
        if test $branch_detached -ne 0
            set_color brmagenta
        else
            set_color green
        end
        echo -n "  $branch"
    end
    if test -n "$commit"
        echo -n ' '(set_color yellow)" $commit"
    end
    if test -n "$action"
        set_color normal
        echo -n (set_color white)':'(set_color -o brred)"$action"
    end
    if test $status_stashed -ne 0
        echo -n ' '(set_color cyan)'⊙'
    end

    set_color normal
end
