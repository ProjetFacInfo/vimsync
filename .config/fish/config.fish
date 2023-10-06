if status is-login
	eval (dircolors -c "$XDG_CONFIG_HOME"/dircolors/dracula | string replace 'setenv' 'set -x')
	# set -x GCC_COLORS 'error 01;31:warning 01;35:note 01;36:caret 01;32:locus 01:quote 01'
	# set -x FZF_DEFAULT_OPTS ' --color fg:#f8f8f2,bg:#282a36,hl:#bd93f9
	# --color fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
	# --color info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
	# --color marker:#ff79c6,spinner:#ffb86c,header:#6272a4
	# --layout reverse
	# --height 20%'

	if test -z "$DISPLAY" && test (tty) = /dev/tty1
		Hyprland-wrapper
	end
end

if status is-interactive
	set -U fuzzy_exclude \( -name '.mozilla' -o -name 'qmk_firmware' -o -name 'Signal' -o -name '.nix-defexpr' -o -regex '.*\(c\|C\)ache.*' -o -name '.git' \) -prune -o

	fish_vi_key_bindings
	# This should be equivalent te fish_vi_cursor
	set fish_cursor_default block
	set fish_cursor_insert line
	set fish_cursor_replace_one underscore
	set fish_cursor_visual block

	for mode in default normal insert 
		# I would just use open but right now it opens it in the browser too and segfaults.
		# I'll switch to it once I use home-manager in nixos and mimeapps work correctly
		bind -M $mode \cg "dolphin ." # g for gui

		bind -M $mode \cr "printf '\n'; fuzzy-cd; commandline -f repaint" # r stand for directory in french
		bind -M $mode \ch "printf '\n'; fuzzy-history; commandline -f repaint"
		bind -M $mode \cf "printf '\n'; fuzzy-files; commandline -f repaint"
		bind -M $mode \cp "printf '\n'; fuzzy-path; commandline -f repaint"
	end

	bind -M insert \ca "accept-autosuggestion" # a for accept
end
