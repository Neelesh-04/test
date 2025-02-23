import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Testbench")

    # Generate 10 MHz clock (period = 100 ns, half-period = 50 ns)
    clock = Clock(dut.clk, 100, units="ns")  
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut._log.info("Applying Reset")
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)  # Small wait before asserting reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)

    # Test Case 1: mode = 1, write_en = 1, read_en = 0
    dut._log.info("Test Case 1: Writing Data")
    dut.mode.value = 1
    dut.write_en.value = 1
    dut.read_en.value = 0
    await ClockCycles(dut.clk, 30)  # 3000 ns

    # Test Case 2: mode = 1, write_en = 0, read_en = 1
    dut._log.info("Test Case 2: Reading Data")
    dut.write_en.value = 0
    dut.read_en.value = 1
    await ClockCycles(dut.clk, 30)  # 3000 ns

    # Test Case 3: mode = 0, write_en = 1, read_en = 0
    dut._log.info("Test Case 3: Writing Data in Different Mode")
    dut.mode.value = 0
    dut.write_en.value = 1
    dut.read_en.value = 0
    await ClockCycles(dut.clk, 30)  # 3000 ns

    # Test Case 4: mode = 0, write_en = 0, read_en = 1
    dut._log.info("Test Case 4: Reading Data in Different Mode")
    dut.write_en.value = 0
    dut.read_en.value = 1
    await ClockCycles(dut.clk, 30)  # 3000 ns

    # Test Case 5: Idle State
    dut._log.info("Test Case 5: Idle Mode")
    dut.write_en.value = 0
    dut.read_en.value = 0
    await ClockCycles(dut.clk, 500)  # 50,000 ns

    dut._log.info("All test cases completed successfully")
