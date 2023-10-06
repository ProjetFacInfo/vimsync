function fuzzy-files
	if test (count $argv) -gt 0
		open $argv
	else
		set file (find -L . $fuzzy_exclude -type f -printf '%P\n' | fzf)
		if test -n "$file"
			open $file
		end
	end
end
