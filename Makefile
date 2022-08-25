
.PHONY: all
all: dhcp.omm serial.omm modem.omm

# dhcp.omf : dhcp.aii W5100.equ


loader : loader.b
	iix mdbasic loader.b -o loader

mini.bbs : mini.b
	iix mdbasic mini.b -o mini.bbs

%.omm : %.omf
	mpw makebiniigs -org \$$0ff0 -t \$$2b -at \$$8006 -p -s  -o $@ $^



%.omf : %.o
	mpw linkiigs -p -l -x -o $@ $^

%.o : %.aii
	mpw asmiigs -p -l  -o $@ $^