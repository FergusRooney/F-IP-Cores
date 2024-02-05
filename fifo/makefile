TOPLEVEL_LANG ?= verilog
CORE_NAME ?= fifo

ifeq ($(TOPLEVEL_LANG),verilog)
    SIM ?= icarus
else ifeq ($(TOPLEVEL_LANG),vhdl)
	SIM ?= ghdl	
endif

PWD=$(shell pwd)

#export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

ifeq ($(TOPLEVEL_LANG),verilog)
	VERILOG_SOURCES = $(PWD)/verilog/$(CORE_NAME).v
else ifeq ($(TOPLEVEL_LANG),vhdl)
	VHDL_SOURCES =  $(PWD)/vhdl/$(CORE_NAME).vhd
	ifeq ($(SIM),ghdl)
		COMPILE_ARGS += --std=08
else
	$(error A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := $(CORE_NAME)
MODULE   := test_$(CORE_NAME)

include $(shell cocotb-config --makefiles)/Makefile.sim

