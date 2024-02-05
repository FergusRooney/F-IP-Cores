import cocotb
from cocotb.clock import Clock
import os
import sys
from pathlib import Path
from cocotb.runner import get_runner
from cocotb import triggers
from cocotb.triggers import Timer, RisingEdge, ClockCycles

core_name = "fifo"

# module fifo #(parameter data_word_size_g = 8,
#                         num_fifo_elements_g = 16,
#                         reset_pol_g = 1'b0
#             )( 
#             input clk_i, rst_i, clk_en_i, r_en_i, w_en_i,
#             input [data_word_size_g-1 : 0] w_data_i,
#             output wire [data_word_size_g-1 : 0] r_data_o,
#             output wire r_empty_o, w_full_o
#             );
        

async def initialise_fifo(dut):
    # By default, rst is active low
    dut.rst_i = 0
    dut.r_en_i = 0
    dut.w_en_i = 0
    dut.clk_en_i = 0
    dut.w_data_i = 0
    await cocotb.triggers.Timer(10, units="ns")
    dut.rst_i <= 1
    await cocotb.triggers.Timer(10, units="ns")

@cocotb.test()
async def test_read_write(dut):
    test_data = [55,23,128,43,132,132,65,99,155,33,123,59,5,2 ]
    clk = dut.clk_i
    

    # Start clock and initialise signals
    cocotb.start_soon(Clock(clk, 1, units="ns").start())
    await initialise_fifo(dut)
    dut.clk_en_i = 1 # Enable clock to start FIFO
    dut.w_en_i = 1 # Enable write

    for data in test_data:
        dut.w_data_i = data
        await RisingEdge(clk)
    dut.w_en_i = 0 # Disable write
    if dut.w_full_o == 1:
        raise ValueError("Should not be full")
    if dut.r_empty_o == 1:
        raise ValueError("Fifo should not be empty")
    
    await ClockCycles(clk, 10)

    fifo_recieved = []
    dut.r_en_i = 1
    await RisingEdge(clk)
    for data in test_data:
        await RisingEdge(clk)
        fifo_recieved.append(dut.r_data_o.value.integer)

    if fifo_recieved != test_data:
        raise ValueError(f"Did not recieve correct data. Expected:{test_data} \nBut got: {fifo_recieved}")
    
    await ClockCycles(clk, 15)
    if dut.r_empty_o == 0:
        raise ValueError("Fifo should be empty")




def test_adder_runner():
    """Simulate the adder example using the Python runner.

    This file can be run directly or via pytest discovery.
    """
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve()

    verilog_sources = []
    vhdl_sources = []

    if hdl_toplevel_lang == "verilog":
        verilog_sources = [proj_path / "verilog" / f"{core_name}.v"]
    else:
        vhdl_sources = [proj_path / "vhdl" / f"{core_name}.v"]

    build_test_args = []
    if hdl_toplevel_lang == "vhdl" and sim == "xcelium":
        build_test_args = ["-v93"]

    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "tests"))

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        vhdl_sources=vhdl_sources,
        hdl_toplevel=f"{core_name}",
        always=True,
        build_args=build_test_args,
    )
    runner.test(
        hdl_toplevel=f"{core_name}", test_module=f"test_{core_name}", test_args=build_test_args
    )

if __name__ == "__main__":
    test_adder_runner()