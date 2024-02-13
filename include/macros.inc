macro section_end
	if @ > \1
		error "Section grew too big!"
	endc
	ds \1 - @
endm
