`timescale 1ns / 1ps

module tb_cpuPipelined;

    logic clk;
    logic reset;

    cpuPipelined dut (
        .clk(clk),
        .reset(reset)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        reset = 1'b1;
        repeat (5) @(posedge clk);
        reset = 1'b0;
    end

    int cycle;
    int MAX_CYCLES = 10000;

    function automatic string regname(input logic [4:0] r);
        return $sformatf("x%0d", r);
    endfunction
    
    always_ff @(posedge clk) begin
        if (!reset) begin
            if (dut.exmem_memWrite) begin
                $display("[cycle %0d] DMEM WRITE: addr=0x%08h (word=%0d) data=0x%08h (%0d)",
                         cycle,
                         dut.exmem_aluY,
                         dut.exmem_aluY[31:2],
                         dut.exmem_store,
                         $signed(dut.exmem_store));
            end
        end
    end
    
    always_ff @(posedge clk) begin
        if (reset) begin
            cycle <= 0;
        end else begin
            cycle <= cycle + 1;

            if (dut.regWriteW && (dut.rdW != 0)) begin
                $display("[cycle %0d] WB: %s <= 0x%08h (%0d)",
                         cycle, regname(dut.rdW), dut.wdW, $signed(dut.wdW));
            end

            if (cycle >= MAX_CYCLES) begin
                $display("TIMEOUT: reached MAX_CYCLES=%0d, stopping.", MAX_CYCLES);
                $finish;
            end
        end
    end

    initial begin
        wait (reset == 1'b0);
    
        wait (dut.u_rf.registers[19] == 32'd999);
    
        repeat (20) @(posedge clk);
    
        $display("=== FINAL REG CHECKS ===");
        if (dut.u_rf.registers[3]  !== 32'd15)    $fatal(1, "x3 expected 15, got %0d (0x%08h)",  dut.u_rf.registers[3],  dut.u_rf.registers[3]);
        if (dut.u_rf.registers[4]  !== 32'd5)     $fatal(1, "x4 expected 5, got %0d (0x%08h)",   dut.u_rf.registers[4],  dut.u_rf.registers[4]);
        if (dut.u_rf.registers[5]  !== 32'd0)     $fatal(1, "x5 expected 0, got %0d (0x%08h)",   dut.u_rf.registers[5],  dut.u_rf.registers[5]);
        if (dut.u_rf.registers[6]  !== 32'd15)    $fatal(1, "x6 expected 15, got %0d (0x%08h)",  dut.u_rf.registers[6],  dut.u_rf.registers[6]);
        if (dut.u_rf.registers[7]  !== 32'd15)    $fatal(1, "x7 expected 15, got %0d (0x%08h)",  dut.u_rf.registers[7],  dut.u_rf.registers[7]);
        if (dut.u_rf.registers[8]  !== 32'd1)     $fatal(1, "x8 expected 1, got %0d (0x%08h)",   dut.u_rf.registers[8],  dut.u_rf.registers[8]);
        if (dut.u_rf.registers[9]  !== 32'd31)    $fatal(1, "x9 expected 31, got %0d (0x%08h)",  dut.u_rf.registers[9],  dut.u_rf.registers[9]);
    
        if (dut.u_rf.registers[11] !== 32'd111)   $fatal(1, "x11 expected 111, got %0d (0x%08h)", dut.u_rf.registers[11], dut.u_rf.registers[11]);
        if (dut.u_rf.registers[14] !== 32'd1)     $fatal(1, "x14 expected 1, got %0d (0x%08h)",  dut.u_rf.registers[14], dut.u_rf.registers[14]);
    
        if (dut.u_rf.registers[15] !== 32'd15)    $fatal(1, "x15 expected 15, got %0d (0x%08h)", dut.u_rf.registers[15], dut.u_rf.registers[15]);
        if (dut.u_rf.registers[16] !== 32'd5)     $fatal(1, "x16 expected 5, got %0d (0x%08h)",  dut.u_rf.registers[16], dut.u_rf.registers[16]);
        if (dut.u_rf.registers[17] !== 32'd31)    $fatal(1, "x17 expected 31, got %0d (0x%08h)", dut.u_rf.registers[17], dut.u_rf.registers[17]);
        if (dut.u_rf.registers[18] !== 32'd36)    $fatal(1, "x18 expected 36, got %0d (0x%08h)", dut.u_rf.registers[18], dut.u_rf.registers[18]);
    
        if (dut.u_rf.registers[19] !== 32'd999)   $fatal(1, "x19 expected 999, got %0d (0x%08h)", dut.u_rf.registers[19], dut.u_rf.registers[19]);
    
        if (dut.u_rf.registers[21] !== 32'd123)
            $fatal(1, "x21 expected 123, got 0x%08h", dut.u_rf.registers[21]);
    
        $display("=== FINAL MEM CHECKS ===");
        if (dut.u_dmem.mem[0] !== 32'd15)         $fatal(1, "mem[0] expected 15, got %0d (0x%08h)", dut.u_dmem.mem[0], dut.u_dmem.mem[0]);
        if (dut.u_dmem.mem[1] !== 32'd5)          $fatal(1, "mem[4] expected 5, got %0d (0x%08h)",  dut.u_dmem.mem[1], dut.u_dmem.mem[1]);
        if (dut.u_dmem.mem[2] !== 32'd31)         $fatal(1, "mem[8] expected 31, got %0d (0x%08h)", dut.u_dmem.mem[2], dut.u_dmem.mem[2]);
        if (dut.u_dmem.mem[3] !== 32'd36)         $fatal(1, "mem[12] expected 36, got %0d (0x%08h)",dut.u_dmem.mem[3], dut.u_dmem.mem[3]);
        if (dut.u_dmem.mem[4] !== 32'd123)        $fatal(1, "mem[16] expected 0x00001234, got 0x%08h", dut.u_dmem.mem[4]);
    
        $display("PASS: full CPU test program checks passed.");
        $finish;
    end

endmodule