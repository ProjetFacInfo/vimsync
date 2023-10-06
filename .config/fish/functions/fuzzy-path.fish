function fuzzy-path
	set path $PWD(find -L . $fuzzy_exclude -type f -o -type d -printf '%P\n' | fzf | cut -c '2-')
	printf $path | wl-copy
end
