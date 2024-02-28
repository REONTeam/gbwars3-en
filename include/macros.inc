macro text
	db \1
    db "[ED]"
endm

macro start
	db \1
endm

macro cont
	db "[LF]"
    db \1
endm

macro skip
	REPT \1
	db "[LF]"
	ENDR
endm

macro done
    db "[ED]"
endm

macro section_end
	if @ > \1
		def slack = @ - \1
		fail "Section grew too big! slack = {slack}"
	endc
	ds \1 - @
endm
