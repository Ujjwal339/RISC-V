`timescale 1ns/1ps
module regfile (
    input  wire        clk,
    input  wire         we,
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);

    reg [31:0] regs [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'h0;
    end

    always @(posedge clk) begin
        if (we && rd_addr != 5'd0)
            regs[rd_addr] <= rd_data;
    end


    assign rs1_data = (we && rd_addr != 5'd0 && rd_addr == rs1_addr) ? rd_data :
                       (rs1_addr == 5'd0) ? 32'h0 : regs[rs1_addr];
    assign rs2_data = (we && rd_addr != 5'd0 && rd_addr == rs2_addr) ? rd_data :
                       (rs2_addr == 5'd0) ? 32'h0 : regs[rs2_addr];

endmodule
