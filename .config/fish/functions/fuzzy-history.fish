function fuzzy-history
	set element (tac $XDG_DATA_HOME/fish/fish_history | grep -a cmd | cut -c '8-' | sed -E 's/\\\{2}/\\\/g' | fzf)
	if test -n $element
		echo $element | wl-copy -n
	end
end
