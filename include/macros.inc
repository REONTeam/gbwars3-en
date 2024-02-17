macro section_end
	if @ > \1
		def slack = @ - \1
		fail "Section grew too big! slack = {slack}"
	endc
	ds \1 - @
endm
