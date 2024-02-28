macro text
	db \1
endm

macro line
	db "[LF]"
    db \1
endm

macro skip
    rept \1
        db "[LF]"
    endr
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
