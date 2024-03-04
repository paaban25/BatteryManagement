timescale 1ns / 1ps

module FloatingMultiplication #(parameter XLEN=32)
                                (input [XLEN-1:0]A,
                                 input [XLEN-1:0]B,
                                 input clk,
                                 output reg  [XLEN-1:0] result);

reg [23:0] A_Mantissa,B_Mantissa;
reg [22:0] Mantissa;
reg [47:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent,Exponent;
reg A_sign,B_sign,Sign;
reg [32:0] Temp;
reg [6:0] exp_adjust;
always@(*)
begin
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23];
A_sign = A[31];
  
B_Mantissa = {1'b1,B[22:0]};
B_Exponent = B[30:23];
B_sign = B[31];

Temp_Exponent = A_Exponent+B_Exponent-127;
Temp_Mantissa = A_Mantissa*B_Mantissa;
Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];
Exponent = Temp_Mantissa[47] ? Temp_Exponent+1'b1 : Temp_Exponent;
Sign = A_sign^B_sign;
result = {Sign,Exponent,Mantissa};
end
endmodule



`timescale 1ns / 1ps

module testbench;

    // Parameters
    parameter XLEN = 32;

    // Signals
    reg [XLEN-1:0] A;
    reg [XLEN-1:0] B;
    reg clk = 0;
    wire [XLEN-1:0] result;

    // Instantiate the module
    FloatingMultiplication #(XLEN) dut(
        .A(A),
        .B(B),
        .clk(clk),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk; // Toggle every 5 time units

    // Test stimulus
    initial begin
        // Test Case 1: A = 3.0, B = 1.5
        A = 32'b01000000101000000000000000000000; // A = 3.0
        B = 32'b01000000010000000000000000000000; // B = 1.5
        #10; // Allow for some time for computation

        // Add more test cases here

        $finish; // End simulation
    end

    // Monitor
    

    

    // Dump VCD file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        #1; // Delay to allow initialization before dumping starts
    end

endmodule
