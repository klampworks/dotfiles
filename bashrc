# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# (0) 12:14:32 user@localhost
# ~/dotfiles
# † 
export PS1="\[\033[0m\]"
export PS1=$PS1'$(s=$?; test $s -eq 0 && echo -ne \[\033[32m\] || echo -ne \[\033[31m\]; echo -n \($s\))'
export PS1="${PS1}\[\033[33m\] \t"
export PS1=$PS1'$(test $EUID -eq 0 && echo -ne \[\033[31m\] || echo -ne \[\033[32m\]; echo -n " \u@\h")'
export PS1=$PS1'$(s=$(jobs -p | wc -l); test $s -eq 0 || echo -ne "\[\033[31m\] ($s)!")'
export PS1="${PS1}\n\[\033[33m\]\w"
export PS1=$PS1'$(test $EUID -eq 0 && echo -ne \[\033[31m\] || echo -ne \[\033[32m\]; echo -n "\n†")'
export PS1="$PS1\[\033[0m\] "

export EDITOR="vim"

# Enable Vim keybindings for Bash command line.
set -o vi

#Disable START/STOP output control (the Ctrl-Q/Ctrl-S bullshit).
stty ixany
stty ixoff -ixon

# Coloured search for Gentoo packages
function eix_search()
{
  EIX_LIMIT=0 eix --format '(green)<category>/<name>:(red) <description>\n' "$@"
}

function fix_date()
{
    if [[ -z "$1" ]]
    then
        echo "Usage: fix_date <ip|hostname> [Linux|BSD]"
        echo " Linux date syntax is default."
        echo ""
        echo " e.g.: fix_date 192.168.100.5"
        echo " => ssh root@192.168.100.5 \"date -s @$(date +%s)\""
        echo " e.g.: fix_date my-bsd-host bsd"
        echo " => ssh root@my-bsd-host \"date $(date +%y%m%d%H%M)\""
        return
    fi

    if [[ "$2" = "bsd" || "$2" = "BSD" ]]
    then
      ssh root@"$1" "date $(date +%y%m%d%H%M)"
    else
      ssh root@"$1" "date -s @$(date +%s)"
    fi
}

# Send stdout to X11 Clipboard
# e.g. `cat my_email.txt | x`
alias x='xsel -b'

# Disable the big obnoxious startup banner.
alias gdb="gdb -q"

# When Dolphin is started outside KDE it will not display any icons.
# Here is a fix for that.
alias dolphin="XDG_CURRENT_DESKTOP=GNOME dolphin"

. ~/.local-bashrc
