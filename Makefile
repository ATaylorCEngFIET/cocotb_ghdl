TOPLEVEL_LANG ?= vhdl
PWD=$(shell pwd)
TOPDIR=$(PWD)/
SIM = ghdl
WAVES ?= 1
COCOTB_HDL_TIMEUNIT = 1ps
COCOTB_HDL_TIMEPRECISION = 1ps
SIM_ARGS+=--vcd=protocol.vcd
VHDL_SOURCES += $(PWD)/uart_pkg.vhd
VHDL_SOURCES += $(PWD)/uart.vhd
VHDL_SOURCES += $(PWD)/protocol.vhd
VHDL_SOURCES += $(PWD)/top.vhd
TOPLEVEL = top
MODULE   = debug_top
include $(shell cocotb-config --makefiles)/Makefile.sim