`timescale 1ns/1ps
// Board-level top for the 5-stage RV32I pipeline on the Digilent Zybo Z7.
// Maps clk/rst_n/dbg_status from core_top onto the board's 125 MHz
// oscillator, push button BTN0, the four discrete LEDs, and RGB LED6
// (present on both the Zybo Z7-10 and Zybo Z7-20).
//
// This is PL-only: the Zynq PS (ARM cores, DDR controller, etc.) is not
// used or instantiated anywhere in this design.
module zybo_top (
    input  wire sysclk,   // 125 MHz onboard oscillator, pin K17
    input  wire btn0,     // BTN0, active-high when pressed, pin K18

    output wire [3:0] led,
    output wire led6_r,
    output wire led6_g,
    output wire led6_b
);

    // core_top expects an active-low reset; BTN0 is active-high, so invert.
    wire clk   = sysclk;
    wire rst_n = ~btn0;

    wire [7:0] dbg_status;

    core_top u_core (
        .clk        (clk),
        .rst_n      (rst_n),
        .dbg_status (dbg_status)
    );

    assign led    = dbg_status[3:0];
    assign led6_r = dbg_status[4];
    assign led6_g = dbg_status[5];
    assign led6_b = dbg_status[6];
    // dbg_status[7] is not routed to a pin - only 7 LED-class outputs are
    // available without adding a Pmod. Probe it with an ILA if you need it.

endmodule
