### clone and patch nerd-fonts icons to font

``` shell
sudo apt install python3-fontforge fontforge

git clone --filter=blob:none --sparse http://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add bin css images src
#  maybe move font-patcher env python to env python3
cd some-font-directory
ls | grep "ttf" | xargs -I xxx /path/to/nerd-fonts/font-patcher -c xxx
# if want single width font:
#   ls | grep "ttf" | xargs -I xxx /path/to/nerd-fonts/font-patcher -c -s xxx
```

- Use Recursive 1.079 not 1.08x or higher
