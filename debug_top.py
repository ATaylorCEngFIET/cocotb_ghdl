import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotbext.uart import UartSource, UartSink
from cocotbext.axi import (AxiLiteRam,AxiLiteBus)


async def reset_dut(reset, duration_ns):
    reset.value = 0
    await Timer(duration_ns, units="ns")
    reset.value = 1
    reset._log.debug("Reset complete")


@cocotb.test()
async def run_test(dut):
    PERIOD = 10
    global clk
    cocotb.start_soon(Clock(dut.clk, PERIOD, units="ns").start())
    clk = dut.clk
    dut.rx.value = 1
    await reset_dut(dut.reset, 50)
    dut._log.debug("After reset")
    await Timer(500*PERIOD, units='ns')
    uart_source = UartSource(dut.rx, baud=115200, bits=8,stop_bits=4)
    uart_sink = UartSink(dut.tx, baud=115200, bits=8)
    axi_master = AxiLiteRam(AxiLiteBus.from_prefix(dut, "axi"), dut.clk, dut.reset, size=2**16)
    dut._log.info("Running test 1")
    data_uart = [0x09,0xC0, 0x00, 0x00, 0x00,0x01,0x55,0xaa,0x12,0x34]
    await uart_source.write(data_uart)
    await Timer(0.5*PERIOD, units='ms')
    data_uart = [0x05,0xC0, 0x00, 0x00, 0x00,0x01]#0x55,0xaa,0x12,0x34]
    await uart_source.write(data_uart)
    #await Timer(1500, units='us')
    #data = await uart_sink.read()