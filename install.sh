#!/bin/sh

if [ "$1" == "--update" ]; then
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


 cd ~/dotfiles/solarized
  git pull
  git checkout upstream
  git pull
  git checkout master
  git rebase upstream
  git push

  exit
fi

cutstring="DO NOT EDIT BELOW THIS LINE"

for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      cutline=`grep -n -m1 "$cutstring" "$target" | sed "s/:.*//"`
      if [ -n "$cutline" ]; then
        cutline=$((cutline-1))
        echo "Updating $target"
        head -n $cutline "$target" > update_tmp
        startline=`sed '1!G;h;$!d' "$name" | grep -n -m1 "$cutstring" | sed "s/:.*//"`
        if [ -n "$startline" ]; then
          tail -n $startline "$name" >> update_tmp
        else
          cat "$name" >> update_tmp
        fi
        mv update_tmp "$target"
      else
        echo "WARNING: $target exists but is not a symlink."
      fi
    fi
  else
    if [ "$name" != 'install.sh' ]; then
      echo "Creating $target"
      if [ -n "$(grep "$cutstring" "$name")" ]; then
        cp "$PWD/$name" "$target"
      else
        ln -s "$PWD/$name" "$target"
      fi
    fi
  fi
done

git submodule init
git submodule update

# dotfiles upstream
git remote add upstream https://github.com/thoughtbot/dotfiles.git
git fetch upstream
git checkout -b upstream upstream/master
git checkout master

# oh-my-zsh upstream setup
cd ~/dotfiles/oh-my-zsh
git remote add upstream https://github.com/robbyrussell/oh-my-zsh.git
git fetch upstream
git checkout -b upstream upstream/master
git checkout master

# Solarized upstream setup
cd ~/dotfiles/solarized
git remote add upstream https://github.com/altercation/solarized.git
git fetch upstream
git checkout -b upstream upstream/master
git checkout master

vim +BundleInstall +qa
