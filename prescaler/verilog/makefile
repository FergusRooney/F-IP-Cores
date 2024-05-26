# vhdl files
FILES = .

# testbench
TESTBENCHFILE = tb_${tb}
WORKDIR = work

#Iverilog CONFIG
iverilog = iverilog
iverilog_flags = -g2012

STOP_TIME = 200us


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
	dir
	iverilog ${iverilog_flags} -o $(WORKDIR)/${tb}.vvp  tb_${tb}.v ${tb}.v 
	
run:
	@vvp $(WORKDIR)/${tb}.vvp
	move ${tb}.vcd work

view:
	@$(WAVEFORM_VIEWER) --dump=$(WORKDIR)/$(tb).vcd

clean:
	@if exist $(WORKDIR) ( \
		rmdir /s /q $(WORKDIR) \
	)

