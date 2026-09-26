# Mobile Adapter network client runtime (the project)

the project owns physical Bank `$30:$6430-$6B20`, immediately after the project protocol templates/core and immediately before the independently-called `$6B21` helper. The exact retail span is 1,777 bytes, SHA-1 `54421670e9e7be6ff1690c261824e6103cef19fe`.

The strongest semantic anchor is `$6430`: it copies the project `MobileAdapter_CloseTCPPacketTemplate` at `$6083`, appends the current adapter/channel byte, finalizes the packet, and enters the common transaction path expecting `$A4` (`MOBILE_COMMAND_CLOSE_TCP_CONNECTION | $80`). It is therefore named `MobileAdapter_StartCloseTCPTransaction`.

The HTTP request-building helpers are behavior-backed by direct use of the project string fragments. `$669B` selects GET versus POST, `$66B0` appends ` HTTP/1.0`, `$66B6` appends `User-Agent: CGB-` plus a four-byte product/version field and two hexadecimal nibbles, and `$66F6` appends the `Content-Length:` field plus CR/LF. The surrounding protocol states remain numeric/neutral where the exact public SDK operation is not proven.

The response parser is also source-separated. `$6817` maintains a five-byte rolling response window, `$67F1` tests for CR/LF, `$6803` tests the CR/LF/dot pattern used by line-oriented mail protocols, `$696E` appends CR/LF, and `$6ABC` parses ASCII decimal digits into a 24-bit accumulator using multiply-by-10 plus digit addition. These contracts support HTTP/SMTP/POP3 response handling without assigning a narrower service name to every state entry.

The next unsourced independently-called helper begins at Bank `$30:$6B21` and should be traced before extending response-parser semantics further.
