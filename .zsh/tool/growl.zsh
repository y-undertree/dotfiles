## zsh/growl integration: any command that takes longer than 5 seconds
## will trigger a growl notification when it completes.
## https://github.com/patbenatar/dotfiles/blob/master/zsh/growl.zsh

if growlnotify -h &>/dev/null; then
    preexec() {
        zsh_growl_cmd=$1
        zsh_growl_time=`date +%s`
    }

    precmd() {
        if (( $? == 0 )); then
            # message
            zsh_growl_status=done\!\!
        else
            zsh_growl_status=fail
        fi
        if [[ "${zsh_growl_cmd}" != "" ]]; then
            # time
            if (( `date +%s` - ${zsh_growl_time} > 3 )); then
                growlnotify -m ${zsh_growl_cmd} ${zsh_growl_status}
            fi
        fi
        zsh_growl_cmd=
    }
fi
