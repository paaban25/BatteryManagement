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


//TestBench
`timescale 1ns / 1ps

module FloatingAddition_TB;

    // Parameters
    parameter XLEN = 32; // Define the width of A and B
    
    // Inputs
    reg [XLEN-1:0] A;
    reg [XLEN-1:0] B;
    reg clk;
    
    // Outputs
    wire [XLEN-1:0] result;
    wire overflow;
    wire underflow;
    wire exception;

    // Instantiate the module under test
    FloatingAddition #(XLEN) dut(
        .A(A),
        .B(B),
        .clk(clk),
        .overflow(overflow),
        .underflow(underflow),
        .exception(exception),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 time units

    // Stimulus
    initial begin
        // Initialize inputs
        A = 32'h3F800000; // 1.0 in IEEE 754 single-precision format
        B = 32'h40000000; // 2.0 in IEEE 754 single-precision format

        // Dump variables to VCD file
        $dumpfile("dump.vcd");
        $dumpvars;

        // Wait for some time to observe outputs
        #100;

        // Finish simulation
        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("A = %h, B = %h, Result = %h", A, B, result);
    end

endmodule
