#!/usr/bin/bash

vim_ps_count=`ps aux | grep vim | grep -v 'grep' | wc -l`
vim_swap_count=`ls /home/waves/.local/share/nvim/swap/ | wc -l`

if [ $vim_ps_count -gt 0 ]
then
  echo "There are several vim/nvim programs is running !!"
  echo "Please close all vim/neovim ..."
else
  echo "There are $vim_swap_count useless swap(s), cleaning all the swaps ..."
  rm -f ~/.local/share/nvim/swap/*
  echo "done"
fi
