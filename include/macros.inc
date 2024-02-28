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

macro farcall
    rst $28
    if _NARG >= 2
        db \1
        shift
    else
        db bank(\1)
    endc
    dw \1
endm

macro lb
    ld \1, \2 << 8 | \3
endm
