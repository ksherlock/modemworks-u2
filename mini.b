
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

#include <ModemWorks.h>
#include <AmperWorks.h>

#define CountCell 0
#define PasswordCell 1

	'^J^JSET UP EVENT TRAPPING^J
	onerr goto ErrorHandler
	& on hangup  goto HangupHandler

	'^J^JDECLARE VARIABLES^J
	msg$ = "MESSAGES" ' NAME OF MAILBOX FILE
	hello$ = "HELLO" 'NAME OF 'HELLO' FILE
	cr$ = chr$ (13)
	y$(0) = "No"
	y$(1) = "Yes"

	'^J^JSET UP SCREEN AND I/O^J
	& scrn(2)
	& fn fnOnline,car
	on car goto Online
	home 
	& read "Enter today's entry password: ",a$
	& ucase(a$)
	& store a$ to PasswordCell

HangupHandler:
	'CARRIER LOSS ENTRY POINT
	& pop 
	& hangup
	& clear

	'I/O FOR CONSOLE ONLY
	& pr 3
	& in 3
	& int = 3,27 ' CTRL-C, ESC
	& timer(300) 'APPROX. 5 MINUTE TIMEOUT DELAY
	& timer stop 
	& int stop  ' INITIALLY TURNED OFF
	& restore CountCell to a$
	cl = val (a$)
	print "^M^MMW: Calls " cl
	'^J^JWAIT FOR CALL OR KEYPRESS^J
	print "MW: Waiting ";
	& wait for call , i
	on i goto AnswerCall
	print "-keyboard^M"
	print "View your messages";
	gosub GetYN
	on not y goto _580_
	if y then 
		print 
		& list msg$
	endif
	print "Delete your mail";
	gosub GetYN
	if y then 
		print "^DDELETE"msg$
	endif

_580_:
	print "^MDo you want to log in";
	gosub GetYN
	on y goto Help
	end 


	'^J^JWAIT FOR CONNECT AND GET PASSWORD^J
AnswerCall:
	print "-ring ";
	& pickup
	& wait for carrier,result
	on result > 0 goto HangupHandler
	print "-online ";

Online:
	'TURN CARRIER CHECKING ON
	& chk on 
	& timer on 
	& on int goto HangupHandler
	& int on 
	& pr 2
	& in 2
	print "^MLogin please: ";
	& pr 1
	& read lg$
	& pr 2
	print 
	& ucase(lg$)
	& restore PasswordCell to a$
	& ucase(a$)
	if a$ < > lg$ then 
		print "^MSorry.  ";
		goto _850_
	endif

	'^J^JLOG CALLER IN^J
	gosub PrintHello
	& time(t$)
	print "Today is " t$ cr$
	print "You are caller #" cl ; cr$
	& store str$ (cl + 1) to CountCell
	& on int goto ReadCommand

Help:
	print "Commands are:^M"
	print "(B)ye       -- Hangup and leave"
	print "(E)nter     -- Enter a message"
	print "(V)iew      -- View the 'hello' file"
	print "(C)hat      -- Enter a chat loop"
	print "(?) or (H)  -- This list of commands"


	'^J^JGET A BBS COMMAND^J
ReadCommand:
	& pop 
	print "^M>>";
	get a$
	& ucase(a$)
	on a$ = cr$ goto ReadCommand
	& pos ("BEVC?HM",a$),p
	if not p then 
		print "Eh?";
		goto ReadCommand
	endif
	& hlin 2,8 ' backspace, backspace
	on p gosub Bye,Enter,View,Chat,Help,Help,Mail
	goto ReadCommand


	'^J^JGOODBYE ROUTINE^J
Bye:
	print "Bye";
	gosub GetYN
	if not y then 
		return 
	endif

_850_:
	& time(t$)
	print "It's "t$".  Goodbye...  ";
	goto HangupHandler


	'^J^JENTER A MESSAGE ROUTINE^J
Enter:
	print "Enter Msg^M"
	& read "Your name: ",from$
	if from$ = "" then 
		return 
	endif
	print "^MBegin Message, Type / alone when done:"
	& time(t$)
	print "^DAPPEND"msg$
	print "From: "from$
	print "Date: "t$cr$
	& rept
	& read a$
	if a$ < > "/" then 
		print a$
	endif
	& until(a$ = "/")
	print "------^M"
	print "^DCLOSE"
	print "^MYour message has been saved."
	return


	'^J^JVIEW A FILE ROUTINE^J
View:
	print "View HELLO file...^M"

PrintHello:
	& list hello$
	return


	'^J^JCHAT LOOP ROUTINE^J
Chat:
	print "Chat (Type / alone to exit)^M"
	i$ = ""
	& rept
	& read (79,i$),a$
	& until(a$ = "/")
	return 


	'^J^JHIDDEN READ MAIL FEATURE^J
Mail:
	print "Mail^M"
	& list msg$
	return 


	'^J^JGET A YES/NO RESPONSE^J
GetYN:
	print "? (y/n) ";
	& rept
	get a$
	& ucase(a$)
	& until(a$ = "Y" or a$ = "N")
	y = a$ = "Y"
	print y$(y)
	return


	'^J^JERROR HANDLING ROUTINE^J
ErrorHandler:
	& onerr e,l
	print "^DCLOSE"
	'CLOSE ANY OPEN FILES
	if e = 6 or e = 7 then 
		print "File not on disk"
		goto ReadCommand
	endif
	print "Error "e" at "l
	goto ReadCommand
