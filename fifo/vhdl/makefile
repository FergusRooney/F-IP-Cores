# vhdl files
FILES = .

# testbench
TESTBENCHFILE = tb_${tb}
WORKDIR = work

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --std=08 --workdir=$(WORKDIR)

STOP_TIME = 200us
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave
# WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

make:
ifeq ($(strip $(tb)),)
	@echo "testbench not set. Use tb=<value> to set it."
	@exit 1
endif
	@mkdir $(WORKDIR)
	@$(GHDL_CMD) -a $(GHDL_FLAGS) fifo.vhd
	@$(GHDL_CMD) -a $(GHDL_FLAGS) tb_fifo.vhd
	@$(GHDL_CMD) -e $(GHDL_FLAGS) tb_fifo

run:
	@$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=$(WORKDIR) $(TESTBENCHFILE) --wave=$(TESTBENCHFILE).ghw $(GHDL_SIM_OPT) 
	@move ${TESTBENCHFILE}.ghw work

view:
	@$(WAVEFORM_VIEWER) --dump=$(WORKDIR)/$(TESTBENCHFILE).ghw

clean:
	@if exist work (rmdir /S /Q work)

