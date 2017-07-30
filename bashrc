# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

export PS1="\[\033[0m\]"
export PS1=$PS1'$(s=$?; test $s -eq 0 && echo -ne \[\033[32m\] || echo -ne \[\033[31m\]; echo -n \($s\))'
export PS1="${PS1}\[\033[33m\] \t"
export PS1=$PS1'$(test $EUID -eq 0 && echo -ne \[\033[31m\] || echo -ne \[\033[32m\]; echo -n " \u@\h")'
export PS1=$PS1'$(s=$(jobs -p | wc -l); test $s -eq 0 || echo -ne "\[\033[31m\] ($s)!")'
export PS1="${PS1}\n\[\033[33m\]\w"
export PS1=$PS1'$(test $EUID -eq 0 && echo -ne \[\033[31m\] || echo -ne \[\033[32m\]; echo -n "\n† ")'
export PS1="$PS1\[\033[0m\] "
