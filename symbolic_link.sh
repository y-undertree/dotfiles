#!/bin/bash

DOT_FILES=".vimrc .vim .gitconfig"

for filename in ${DOT_FILES}; do
    if [ -f $HOME/$filename -o -d $HOME/$filename ]; then
	echo "$HOME/$filename  exsist"
    else
       	ln -s $PWD/$filename $HOME/$filename
        echo "ln -s $PWD/$filename $HOME/$filename create symbolic link"
    fi
done

# git complete
echo "source /usr/share/doc/git-1.7.1/contrib/completion/git-completion.bash" >> ~/.bash_profile

# branch 補完
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
