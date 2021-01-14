SOURCES       := $(shell find . -name '*.v' -not -name '*_tb.v')

DOCKER=docker

PWD = $(shell pwd)
DOCKERARGS = run --rm -v $(PWD):/src -w /src
YOSYS     = $(DOCKER) $(DOCKERARGS) hdlc/yosys yosys
NEXTPNR   = $(DOCKER) $(DOCKERARGS) hdlc/nextpnr:gowin nextpnr-gowin
GOWINPACK = $(DOCKER) $(DOCKERARGS) hdlc/apicula gowin_pack

all: top.fs

top.fs: top.pack
	$(GOWINPACK) -d GW1N-1 -o $@ $^

top.pack: top.json
	$(NEXTPNR) --json top.json --write top.pack --device GW1N-LV1QN48C6/I5 --cst tangnano.cst

top.json:
	$(YOSYS) -p "synth_gowin -json top.json -top top" $(SOURCES)

prog: top.fs
	openFPGALoader -b tangnano $^

clean:
	rm -f *.json *.fs *.pack

.PHONY: %-tangnano-prog clean all