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
