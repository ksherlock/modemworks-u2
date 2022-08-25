
.PHONY: all
all: SerialU2 ModemU2

.PHONY: clean
clean:
	$(RM) *.omf *.o ModemU2 SerialU2

# dhcp.omf : dhcp.aii W5100.equ

MAKEBINFLAGS = -org \$$0ff0 -t \$$2b -at \$$8006 -p

SerialU2 : serial.omf
	mpw makebiniigs $(MAKEBINFLAGS)  -o $@ $^

ModemU2 : modem.omf
	mpw makebiniigs $(MAKEBINFLAGS)  -o $@ $^

loader : loader.b
	iix mdbasic loader.b -o loader

mini.bbs : mini.b
	iix mdbasic mini.b -o mini.bbs


%.omf : %.o
	mpw linkiigs -p -l -x -o $@ $^

%.o : %.aii
	mpw asmiigs -p -l  -o $@ $^