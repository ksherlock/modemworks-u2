
	#include <ModemWorks.h>

	print "^DPREFIX /MWU2"
	print "^DPR#3"
	print "^D-OMM.LOADER"
	&load get "modules/ModemWorks"
	&load get "modules/AmperWorks"

	&poke 768, $38, $20, $1F, $FE, $66, $00, $60
	call 768
	iigs = peek($00) < $80
	if iigs then
		& load get "modules/TimeGS"
		& load get "modules/StoreGS"
	else
		&load get "modules/Time"
		&load get "modules/Store"
	endif

	&load get "modules/SerialU2"
	&load get "modules/ModemU2"

	&load get "modules/Console"
	&load get "modules/Terminal"

'	& load get "modules/Compat"

	print "Initializing Uthernet..."
	' initialize "modem" in slot 3.
	& slot(3)
