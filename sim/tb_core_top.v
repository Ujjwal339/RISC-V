`timescale 1ns/1ps

module tb_core_top;

    reg clk = 0;
    reg rst_n = 0;
    wire [7:0] dbg_status;

    core_top dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .dbg_status (dbg_status)
    );

    always #5 clk = ~clk;

    integer cycle;
    integer errors = 0;
    integer stall_count    = 0;
    integer redirect_count = 0;

    always @(posedge clk) begin
        if (dut.stall)        stall_count    = stall_count    + 1;
        if (dut.pc_redirect)  redirect_count = redirect_count + 1;
    end

    task check32(input [8*16-1:0] name, input [31:0] actual, input [31:0] expected);
        begin
            if (actual !== expected) begin
                $display("FAIL: %0s = %0d (0x%h), expected %0d (0x%h)",
                          name, actual, actual, expected, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s = %0d", name, actual);
            end
        end
    endtask

    initial begin
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        for (cycle = 0; cycle < 100; cycle = cycle + 1) begin
            @(posedge clk);
            $display("t=%0t cyc=%0d pc_if=%h instr_id=%h valid_ex=%b stall=%b redirect=%b",
                      $time, cycle, dut.pc_if, dut.instr_id, dut.valid_ex,
                      dut.stall, dut.pc_redirect);
        end

        $display("---------------------------------------------------------");
        $display("Register file checks");
        $display("---------------------------------------------------------");
        check32("x1",  dut.u_regfile.regs[1],  32'd5);
        check32("x2",  dut.u_regfile.regs[2],  32'd10);
        check32("x3",  dut.u_regfile.regs[3],  32'd15);
        check32("x4",  dut.u_regfile.regs[4],  32'd10);
        check32("x5",  dut.u_regfile.regs[5],  32'd15);
        check32("x6",  dut.u_regfile.regs[6],  32'd20);
        check32("x7",  dut.u_regfile.regs[7],  32'd7);
        check32("x8",  dut.u_regfile.regs[8],  32'h34);
        check32("x22 (skipped by jal)", dut.u_regfile.regs[22], 32'd0);
        check32("x9",  dut.u_regfile.regs[9],  32'd42);
        check32("x10 (loop counter, final)", dut.u_regfile.regs[10], 32'd3);
        check32("x11 (loop bound)",          dut.u_regfile.regs[11], 32'd3);
        check32("x20 (flushed by beq)", dut.u_regfile.regs[20], 32'd0);
        check32("x21 (flushed by beq)", dut.u_regfile.regs[21], 32'd0);

        $display("---------------------------------------------------------");
        $display("Data memory check");
        $display("---------------------------------------------------------");
        check32("dmem[0]", dut.u_dmem.mem[0], 32'd15);

        $display("---------------------------------------------------------");
        $display("Hazard/control-flow event counts");
        $display("---------------------------------------------------------");
        if (stall_count !== 1) begin
            $display("FAIL: stall_count = %0d, expected 1", stall_count);
            errors = errors + 1;
        end else
            $display("PASS: stall_count = 1");
        if (redirect_count !== 4) begin
            $display("FAIL: redirect_count = %0d, expected 4", redirect_count);
            errors = errors + 1;
        end else
            $display("PASS: redirect_count = 4");

        $display("---------------------------------------------------------");
        if (errors == 0)
            $display("ALL CHECKS PASSED");
        else
            $display("%0d CHECK(S) FAILED", errors);
        $display("Simulation finished at t=%0t", $time);
        $finish;
    end

endmodule
