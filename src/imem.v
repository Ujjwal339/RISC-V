`timescale 1ns/1ps

module imem #(
    parameter DEPTH = 256
)(

    input  wire [31:0] addr,
    output wire [31:0] rdata
);

    reg [31:0] mem [0:DEPTH-1];

    initial begin
        $readmemh("imem_init.hex", mem);
    end

    assign rdata = mem[addr[$clog2(DEPTH)+1:2]];

endmodule
