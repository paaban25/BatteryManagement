`timescale 1ns / 1ps
module FloatingAddition #(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         input clk,
                         output reg  [XLEN-1:0] result);

reg [23:0] A_Mantissa,B_Mantissa;
reg [23:0] Temp_Mantissa;
reg [22:0] Mantissa;
reg [7:0] Exponent;
reg Sign;
wire MSB;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg A_sign,B_sign,Temp_sign;
reg [32:0] Temp;
reg carry;
reg [2:0] one_hot;
reg comp;
reg [7:0] exp_adjust;
always @(*)
begin

comp =  (A[30:23] >= B[30:23])? 1'b1 : 1'b0;
  
A_Mantissa = comp ? {1'b1,A[22:0]} : {1'b1,B[22:0]};
A_Exponent = comp ? A[30:23] : B[30:23];
A_sign = comp ? A[31] : B[31];
  
B_Mantissa = comp ? {1'b1,B[22:0]} : {1'b1,A[22:0]};
B_Exponent = comp ? B[30:23] : A[30:23];
B_sign = comp ? B[31] : A[31];

diff_Exponent = A_Exponent-B_Exponent;
B_Mantissa = (B_Mantissa >> diff_Exponent);
{carry,Temp_Mantissa} =  (A_sign ~^ B_sign)? A_Mantissa + B_Mantissa : A_Mantissa-B_Mantissa ; 
exp_adjust = A_Exponent;
if(carry)
    begin
        Temp_Mantissa = Temp_Mantissa>>1;
        exp_adjust = exp_adjust+1'b1;
    end
else
    begin
    while(!Temp_Mantissa[23])
        begin
           Temp_Mantissa = Temp_Mantissa<<1;
           exp_adjust =  exp_adjust-1'b1;
        end
    end
Sign = A_sign;
Mantissa = Temp_Mantissa[22:0];
Exponent = exp_adjust;
result = {Sign,Exponent,Mantissa};

end
endmodule

module AdderN(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [31:0] D,
    input clk,
    output reg [31:0] result
);

    wire [31:0] ab_result, cd_result, abcd_result;

    // Instantiate FloatingAddition module for A+B
    FloatingAddition add_AB (
        .A(A),
        .B(B),
        .clk(clk),
        .result(ab_result)
    );

    // Instantiate FloatingAddition module for C+D
    FloatingAddition add_CD (
        .A(C),
        .B(D),
        .clk(clk),
        .result(cd_result)
    );

    // Instantiate FloatingAddition module for (A+B)+(C+D)
    FloatingAddition add_ABCD (
        .A(ab_result),
        .B(cd_result),
        .clk(clk),
        .result(abcd_result)
    );

    // Output is the result of (A+B)+(C+D)
  always @(*) begin
        result <= abcd_result;
    end

endmodule



//TestBench
`timescale 1ns / 1ps

module tb_AdderN;

    // Parameters
    parameter XLEN = 32;

    // Inputs
    reg [XLEN-1:0] A, B, C, D;
    reg clk;

    // Outputs
    wire [XLEN-1:0] result;

    // Instantiate the AdderN module
    AdderN uut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        A = 32'h40e9999a;  // Value of 1.0 in IEEE 754 single-precision format
        B = 32'h40d9999a;  // Value of 2.0 in IEEE 754 single-precision format
        C = 32'h40666666;  // Value of 3.0 in IEEE 754 single-precision format
        D = 32'h40266666;  // Value of 4.0 in IEEE 754 single-precision format

        // Wait for a few clock cycles for stability
        #10;

        // Display header
        $display("Time\tA\tB\tC\tD\tResult");

        // Apply inputs and display results
        

        // End simulation
        $dumpfile("waveforms.vcd");
        $dumpvars(0, tb_AdderN);
        $display("Waveforms dumped to waveforms.vcd");
        $finish;
    end

endmodule
