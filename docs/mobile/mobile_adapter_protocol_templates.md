# Mobile Adapter protocol templates and first state core

the project owns Bank `$30:$6000-$642F` (1,072 retail bytes, SHA-1 `a39ba4ae68250d2849a4c95f1a6e39de031e8a24`). The data half at `$6000-$614D` is now explicit: packet templates use the established `$99,$66` serial signature and command IDs for Begin/End Session, Dial/Hang-up, Telephone Status, ISP Login/Logout, configuration read/write, DNS Query, Wait for Telephone Call, Transfer Data, and TCP open/close.

The same data region contains literal application-protocol fragments used by the Mobile networking code: SMTP (`HELO`, `MAIL FROM:<`, `RCPT TO:<`, `DATA`, `QUIT`), POP3 (`USER`, `PASS`, `STAT`, `LIST`, `RETR`, `DELE`, `TOP`), and HTTP (`GET`, `POST`, `HTTP/1.0`, `User-Agent: CGB-`, `Content-Length:`). This confirms the Bank `$30` runtime contains not just the serial driver but higher-level mail/web client machinery.

`$614E-$642F` is the first executable consumer/state layer after those tables. `$614E` is called by the project timer/LCD service and dispatches protocol state through driver command/state bytes. Stable direct-call/jump boundaries at `$625D/$6269/$636B` are source labels, but their narrower public SDK meanings remain intentionally conservative until downstream consumers are decoded.

The next independently-called boundary is `$6430`; it is left separate rather than absorbing another helper family into this tranche.
