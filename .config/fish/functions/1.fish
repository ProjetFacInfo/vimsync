function 1
  xkbcomp $HOME/.config/xkb/latin-programmer-dvorak $DISPLAY; xmodmap -e 'keycode 135 = Super_R'
end
