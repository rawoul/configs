## file creation mask
umask 022

## resource limits
unlimit
limit -s stack 8192 core 0

## fortune
#echo -n "[1;38m"
#fortune starwars futurama
#echo -n "[0m"

## keychain
if which keychain > /dev/null; then
    eval `keychain --nogui --quiet --inherit any-once --eval id_rsa`
fi

################################################################################
## helpers
###

_has() {
    whence $1 >/dev/null
}

_append_to_path() {
    if [ -d $1 -a -z ${path[(r)$1]} ]; then
	path=($1 $path);
    fi
}

################################################################################
## environment
###

## mail
#export MAIL=~/.maildir/received

## pager
export READNULLCMD=less
export LESS="-q -R -S"
#export LESSCHARSET=latin1
export LESS_TERMCAP_mb=$'\E[01;34m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;36m'
export PAGER=less
export MANPAGER=less

export EDITOR="vim"
export CVSEDITOR="vim"
export VISUAL="gvim"

export BROWSER="firefox"

export PATH="${HOME}/bin:$PATH"

################################################################################
## zsh options
###

setopt	NO_all_export		\
	always_to_end		\
	auto_cd			\
	auto_list		\
	auto_menu		\
	auto_name_dirs		\
	NO_auto_param_slash	\
	auto_pushd		\
	NO_auto_resume		\
	NO_beep			\
	NO_cdable_vars		\
	NO_chase_dots		\
	NO_chase_links		\
	complete_aliases	\
	complete_in_word	\
	correct			\
	NO_correct_all		\
	equals			\
	extended_glob		\
	glob_complete		\
	NO_hist_allow_clobber	\
	hist_expire_dups_first	\
	hist_find_no_dups	\
	hist_ignore_all_dups	\
	hist_ignore_dups	\
	hist_ignore_space	\
	hist_no_functions	\
	hist_no_store		\
	hist_reduce_blanks	\
	hist_save_no_dups	\
	hist_verify		\
	NO_hup			\
	NO_inc_append_history	\
	interactive_comments	\
	list_packed		\
	NO_list_rows_first	\
	NO_list_types		\
	long_list_jobs		\
	magic_equal_subst	\
	NO_mail_warning		\
	null_glob		\
	numeric_glob_sort	\
	NO_path_dirs		\
	print_eight_bit		\
	pushd_ignore_dups	\
	pushd_minus		\
	pushd_silent		\
	rc_quotes		\
	NO_share_history

## history
HISTFILE=${HOME}/.zhistory
HISTSIZE=5000
SAVEHIST=5000

## directory stack
DIRSTACKSIZE=10

## watchs for logins/logouts
LOGCHECK=60
WATCHFMT="%n has %a %l from %M at %t"
WATCH=all

## super mv \o/
autoload zmv

################################################################################
## aliases
###

## disable globbing on some commands
for com in alias expr which zmv; do
	alias $com="noglob $com"
done

## disable auto correction on some commands
for com in cp mkdir mv rm; do
	alias $com="nocorrect $com"
done

## default aliases
alias ..='cd ..'
alias 'cd..'='cd ..'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls -1'
alias ll='ls -lh'
alias la='ls -lA'
alias du='du -h'
alias df='df -h'
alias cp='cp -i'
alias mv='mv -i'
alias mmv='zmv -W'
alias mcp='zmv -C -W'

## gentoo aliases
if [[ -f /etc/gentoo-release ]]; then
	alias em='emerge'
	alias ep='emerge -pvt'
	alias ea='emerge -av'
	alias es='eix'
	alias ec='CONFIG_PROTECT="-*" emerge -C'
fi

## debian aliases
if [[ -f /etc/debian_version ]]; then
	function apts() { apt-cache search "$@" | grep -i "$@" }
	alias apti='apt-get install'
	alias aptr='apt-get remove --purge'
	alias aptu='apt-get update'
fi

## clean directory
purge () {
	FILES=(*~(N) .*~(N) \#*\#(N) *.o(N) a.out(N) *.core(N) *.cmo(N) *.cmi(N) .*.swp(N))
	NBFILES=${#FILES}
	if [[ $NBFILES > 0 ]]; then
		rm -f ${FILES}
		echo ">> $(pwd) purged, $NBFILES files removed"
	else
		echo "!! No file match"
	fi
}

## remove \r in files
dos2unix()
{
	sed -i -e 's/\r$//' "$@"
}

## print dir and job name in term title
case $TERM in
	xterm*|rxvt*)
	precmd()  { print -Pn "\e]0;%n@%m: %~\a\r" }
	preexec() { print -Pn "\e]0;%n@%m: $1\a\r" }
	;;
esac

################################################################################
## binds
##

bindkey -e
if [[ $TERM = rxvt* ]]; then
	bindkey "[7~" beginning-of-line	# Home
	bindkey "[8~" end-of-line		# End
else
	bindkey "[H" beginning-of-line	# Home
	bindkey "[F" end-of-line		# End
fi
bindkey "[3~" delete-char		# Del
bindkey "[2~" overwrite-mode		# Insert
bindkey "[5~" beginning-of-history	# PgUp
bindkey "[6~" end-of-history		# PgDn

################################################################################
## completion
###

## init colors for ls and completion
if [[ -x `which dircolors` ]]; then
	if [[ -f /etc/DIR_COLORS ]]; then
		eval $(dircolors -b /etc/DIR_COLORS)
	else
		eval $(dircolors -b)
	fi
fi
if [[ -z $LS_COLORS ]]; then
	LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:'
	export LS_COLORS
fi

## Turn on completion
autoload -U compinit && compinit -i

## filename suffixes to ignore during completion
#fignore=(.o)

## use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

## completers
zstyle ':completion:*' completer _expand _complete _correct _approximate _ignored

## allow one error in approximate completer
zstyle ':completion:*:approximate:*' max-errors 1 numeric

## don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

## group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select=3
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}:: %d (errors: %e)%f'
zstyle ':completion:*:descriptions' format '%F{yellow}:: %d%f'
zstyle ':completion:*:messages' format '%F{purple}:: %d%f'
zstyle ':completion:*:warnings' format '%F{red}:: no matches found%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format '%F{yellow}:: %d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

## case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

## colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## menu completion only if the prefix is valid
zstyle ':completion:*' insert-unambiguous true

## show original command in list
zstyle ':completion:*' original true

## remve trailing slashes after a directory
zstyle ':completion:*' squeeze-slashes true

## on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:processes-names' command 'ps -au$USER -o comm='

## complete ssh known hosts
local _myhosts;
_myhosts=( ${${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ }:#\!*}
${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*} );
zstyle ':completion:*' hosts $_myhosts

## show completion list without asking
LISTPROMPT=''

################################################################################
## prompt
###

setopt prompt_subst

## set colors
for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval $color='%B%F{${(L)color}}'
done

DEF='%f%b'
MCOLOR=$BLUE

local prompt_begin="${MCOLOR}[%(!.${RED}.${WHITE})%n${MCOLOR}@${WHITE}%m\
${MCOLOR}]${DEF}"

PS1="$prompt_begin ${MCOLOR}[${WHITE}%20<...<%~%<<${MCOLOR}]${DEF} "

PS2="$prompt_begin ${MCOLOR}%_>${DEF} "

PS3="$prompt_begin ${MCOLOR}?>${DEF} "

RPROMPT=" ${MCOLOR}[%(?.${GREEN}\\o/.${RED}\\o_${DEF} ${WHITE}%139(?,Seg \
fault,%130(?,Interrupt,%138(?,Bus Error,%?)))${DEF} ${RED}_o/)${MCOLOR}]\
${DEF} ${MCOLOR}[${WHITE}%D{%H:%M}${MCOLOR}]${DEF}"

SPROMPT="zsh: correct ${YELLOW}%R$DEF to ${YELLOW}%r${DEF}%b ? ([${YELLOW}Y\
${DEF}]es/[${YELLOW}N${DEF}]o/[${YELLOW}E${DEF}]dit/[${YELLOW}A${DEF}]bort) "

################################################################################
## fzf
###

if [ -e ~/.vim/bundle/fzf ]; then
    _append_to_path ~/.vim/bundle/fzf/bin
    if _has fzf; then
	source ~/.vim/bundle/fzf/shell/key-bindings.zsh
	[[ $- == *i* ]] && source ~/.vim/bundle/fzf/shell/completion.zsh
	FZF_DEFAULT_OPTS="--reverse"
    fi
fi
