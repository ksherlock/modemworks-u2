
	'************************
	'*                      *
	'*  MINI BBS  (C) 1985  *
	'*                      *
	'* THIS PROGRAM IS IN   *
	'* NO WAY TO BE THOUGHT *
	'* OF AS A REAL MESSAGE *
	'* SYSTEM.  IT MAKES    *
	'* USE OF ALL PERTINENT *
	'* MODEMWORKS COMMANDS  *
	'* AND IS AN EXAMPLE OF *
	'* A SCALED DOWN BBS.   *
	'*                      *
	'*  -- MORGAN DAVIS --  *
	'*                      *
	'************************
	'^J^JSET UP EVENT TRAPPING^J
	onerr goto _1080_
	& when not on line goto _410_
	'^J^JDECLARE VARIABLES^J
	msg$ = "MESSAGES"
	' NAME OF MAILBOX FILE
	hello$ = "HELLO"
	'NAME OF 'HELLO' FILE
	o = 0
	a = 1
	b = 2
	c = 3
	d = 4
	d$ = chr$ (d)
	c$ = chr$ (13)
	y$(0) = "No"
	y$(1) = "Yes"
	'^J^JSET UP SCREEN AND I/O^J
	& scrn( 2)
	& fn o,car
	if car then 
		goto _640_
	endif
	home 
	& read "Enter today's entry password: ",a$
	& ucase(a$)
	& store a$ to a

_410_:
	& pop 
	& hangup
	& clear 
	'CARRIER LOSS ENTRY POINT
	& pr 3
	& in 3
	'I/O FOR CONSOLE ONLY
	& int = c,27
	'  CTRL-C, ESC
	& timer(300)
	'APPROX. 5 MINUTE TIMEOUT DELAY
	& timer stop 
	& int stop 
	' INITIALLY TURNED OFF
	& restore 0 to a$
	cl = val (a$)
	print c$c$"MW: Calls "cl
	'^J^JWAIT FOR CALL OR KEYPRESS^J
	print "MW: Waiting ";
	& wait for call ,i
	on i goto _610_
	print "-keyboard"c$
	print "View your messages";
	gosub _1040_
	on not y goto _580_
	if y then 
		print 
		& list msg$
	endif
	print "Delete your mail";
	gosub _1040_
	if y then 
		print d$"DELETE"msg$
	endif

_580_:
	print c$"Do you want to log in";
	gosub _1040_
	on y goto _730_
	end 
	'^J^JWAIT FOR CONNECT AND GET PASSWORD^J

_610_:
	print "-ring ";
	& pickup
	& wait for carrier,result
	on result > 0 goto _410_
	print "-online ";

_640_:
	& chk on 
	'TURN CARRIER CHECKING ON
	& timer on 
	& on int goto _410_
	& int on 
	& pr 2
	& in 2
	print c$
	print "Login please: ";
	& pr 1
	& read lg$
	& pr 2
	print 
	& ucase(lg$)
	& restore 1 to a$
	& ucase(a$)
	if a$ < > lg$ then 
		print c$"Sorry.  ";
		goto _850_
	endif
	'^J^JLOG CALLER IN^J
	gosub _975_
	& time(t$)
	print "Today is "t$c$
	print "You are caller #"cl;c$
	& store str$ (cl + a) to 0
	& on int goto _800_

_730_:
	print "Commands are:"c$
	print "(B)ye       -- Hangup and leave"
	print "(E)nter     -- Enter a message"
	print "(V)iew      -- View the 'hello' file"
	print "(C)hat      -- Enter a chat loop"
	print "(?) or (H)  -- This list of commands"
	'^J^JGET A BBS COMMAND^J

_800_:
	& pop 
	print c$">>";
	get a$
	& ucase(a$)
	on a$ = c$ goto _800_
	& pos ("BEVC?HM",a$),p
	if not p then 
		print "Eh?";
		goto _800_
	endif
	& str$ (b,8)
	on p gosub _840_,_870_,_970_,_990_,_730_,_730_,_1020_
	goto _800_
	'^J^JGOODBYE ROUTINE^J

_840_:
	print "Bye";
	gosub _1040_
	if not y then 
		return 
	endif

_850_:
	& time(t$)
	print "It's "t$".  Goodbye...  ";
	goto _410_
	'^J^JENTER A MESSAGE ROUTINE^J

_870_:
	print "Enter Msg"c$
	& read "Your name: ",from$
	if from$ = "" then 
		return 
	endif
	print c$"Begin Message, Type / alone when done:"
	& time(t$)
	print d$"APPEND"msg$
	print "From: "from$
	print "Date: "t$c$
	& rept
	& read a$
	if a$ < > "/" then 
		print a$
	endif
	& until(a$ = "/")
	print "------"c$
	print d$"CLOSE"
	print c$"Your message has been saved."
	return 
	'^J^JVIEW A FILE ROUTINE^J

_970_:
	print "View HELLO file..."c$

_975_:
	& list hello$
	return 
	'^J^JCHAT LOOP ROUTINE^J

_990_:
	print "Chat (Type / alone to exit)"c$
	i$ = ""
	& rept
	& read (79,i$),a$
	& until(a$ = "/")
	return 
	'^J^JHIDDEN READ MAIL FEATURE^J

_1020_:
	print "Mail"c$
	& list msg$
	return 
	'^J^JGET A YES/NO RESPONSE^J

_1040_:
	print "? (y/n) ";
	& rept
	get a$
	& ucase(a$)
	& until(a$ = "Y" or a$ = "N")
	y = a$ = "Y"
	print y$(y)
	return 
	'^J^JERROR HANDLING ROUTINE^J

_1080_:
	& onerr e,l
	print chr$ (4)"CLOSE"
	'CLOSE ANY OPEN FILES
	if e = 6 or e = 7 then 
		print "File not on disk"
		goto _800_
	endif
	print "Error "e" at "l
	goto _800_
