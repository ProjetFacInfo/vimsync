function fuzzy-cd
	set dir (find -L . $fuzzy_exclude -type d -printf '%P\n' | fzf)/
	test -d "$dir" && c "$dir"
end

