
# ModemWorks (MDG) Serial / Modem modules for the Uthernet II

ModemWorks is a set of Ampersand commands for AppleSoft BASIC which enables easy modem access for telecom software or BBSes. (The ProLine BBS was based on ModemWorks).  This project enables the Uthernet II TCP card to be used from ModemWorks (and, thus, ProLine).


## Usage

Currently, hardcoded for slot 3.

In general, this is a drop-in replacement for a normal Serial port / Modem driver.  You will need to configure the IP address (see below) before usage.

Inbound "calls" are on TCP port 6502.  This is a raw socket, (no Telnet codes, etc).

```
10 & WAIT FOR CALL, ok : IF NOT ok THEN END
20 & PICKUP
30 & WAIT FOR CARRIER, ok
...
999 & HANGUP
```

Outbound "calls" use the ip address and port specified (no DNS, yet).


```
10 & CALL "127.0.0.1:6502" : REM there's no place like home
20 & WAIT FOR CARRIER, ok
...
999 & HANGUP
```

See the ModemWorks manual for more information on usage.


## New & commands:

`& MAC(strexpr)`

Sets the hardware MAC address.

`& MAC GET strvar`

Returns the MAC address.

`& IP GET strvar, strvar, strvar, strvar`

Returns the ip address, net mask, gateway, and dns server

`& IP PEEK strvar`

Returns the peer ip address

`& IP(strexpr, strexpr, strexpr, strexpr)`

Sets the ip address, net mask, gateway, and dns server

`& DHCP , numericvar`

Performs DHPC query and sets the IP address, etc.  Returns 0 on error, 1 on success.

`& BOOTP , numericvar`

Performs BOOTP query and sets the IP address, etc. Returns 0 on error, 1 on success.

