#!/bin/bash
#
#
# Updates dotfiles and oh-my-zsh from personal git and upstream

cd ~/dotfiles
git pull
git checkout upstream
git pull
git checkout master
git rebase upstream
git push

cd ~/dotfiles/oh-my-zsh
git pull
git checkout upstream
git pull
git checkout master
git rebase upstream
git push
