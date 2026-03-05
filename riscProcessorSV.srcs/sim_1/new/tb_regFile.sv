`timescale 1ns / 1ps

module tb_regFile;

logic clk;
logic we;

logic [4:0] regAdd1;
logic [4:0] regAdd2;
logic [4:0] rd;
logic [31:0] wd;

logic [31:0] ro1;
logic [31:0] ro2;

regFilSV DUT(
    .clk(clk),
    .we(we),
    .regAdd1(regAdd1),
    .regAdd2(regAdd2),
    .rd(rd),
    .wd(wd),
    .ro1(ro1),
    .ro2(ro2)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    we = 1;

    // write register 1
    rd = 5'd1;
    wd = 32'd42;
    #10;

    // write register 2
    rd = 5'd2;
    wd = 32'd10;
    #10;

    // read them
    we = 0;
    regAdd1 = 5'd1;
    regAdd2 = 5'd2;
    #10;

    $finish;

end

endmodule