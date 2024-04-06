`timescale 1ns/1ns // Specify timescale

module control_path(input gt,lt,eq,
                   output reg sel,eqt);
  always@*
    begin
      case({gt,lt,eq})
        3'b001:begin sel=1'b0; eqt=1'b1; end
        3'b010:begin sel=1'b1; eqt=1'b0; end
        3'b100:begin sel=1'b0; eqt=1'b0; end
      endcase
    end
  
  
endmodule


// Code your design here
module ZeroComparator(
  input [31:0] in,
  output reg gt,
  output reg lt,
  output reg eq
);

  always @* begin
    // IEEE 754 representation of zero for single precision (32 bits)
    if (in == 32'b00000000_00000000_00000000_00000000) begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b1;
    end
    // Check if the number is positive (including positive zero)
    else if (in[31] == 0 && |in[30:23] != 8'b00000000) begin
      gt <= 1'b1;
      lt <= 1'b0;
      eq <= 1'b0;
    end
    // Check if the number is negative
    else if (in[31] == 1) begin
      gt <= 1'b0;
      lt <= 1'b1;
      eq <= 1'b0;
    end
    // Handle negative zero separately
    else if (in[31] == 0 && |in[30:0] == 0) begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b1;
    end
    // All other cases
    else begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b0;
    end
  end

endmodule



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
integer i;
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
for (i = 0; i < 256; i = i + 1) begin
    if (!Temp_Mantissa[23]) begin
        Temp_Mantissa = Temp_Mantissa << 1;
        exp_adjust = exp_adjust - 1'b1;
    end else begin
        // Terminate the loop by setting i to MAX_ITERATIONS
        i = 256;
    end
end
    end
Sign = A_sign;
Mantissa = Temp_Mantissa[22:0];
Exponent = exp_adjust;
result = {Sign,Exponent,Mantissa};
//Temp_Mantissa = (A_sign ~^ B_sign) ? (carry ? Temp_Mantissa>>1 : Temp_Mantissa) : (0); 
//Temp_Exponent = carry ? A_Exponent + 1'b1 : A_Exponent; 
//Temp_sign = A_sign;
//result = {Temp_sign,Temp_Exponent,Temp_Mantissa[22:0]};
end
endmodule

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

module FloatingReciprocal#(parameter XLEN=32)
                        (
                         input [XLEN-1:0]B,
                         input clk,
                         
                          output [XLEN-1:0] reciprocal);
                         
reg [23:0] A_Mantissa,B_Mantissa;
reg [22:0] Mantissa;
wire [7:0] exp;
reg [23:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;
reg [7:0] A_adjust,B_adjust;
reg A_sign,B_sign,Sign;
reg [32:0] Temp;
wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug;
//wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;
reg [6:0] exp_adjust;
reg [XLEN-1:0] B_scaled; 
reg en1,en2,en3,en4,en5;
reg dummy;
/*----Initial value----*/
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1)); //verified
assign debug = {1'b1,temp1[30:0]};
  FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.result(x0),.clk(clk));

/*----First Iteration----*/
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
  FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.result(temp3),.clk(clk));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

/*----Second Iteration----*/
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
  FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.result(temp5),.clk(clk));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

/*----Third Iteration----*/
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
  FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.result(temp7),.clk(clk));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

/*----Reciprocal : 1/B----*/
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};


endmodule





module MUX (
  input wire [31:0] data0,
  input wire [31:0] data1,
  input wire select,
  output reg [31:0] mux_output
);

  always @* begin
    if (select)
      mux_output = data1;
    else
      mux_output = data0;
  end

endmodule





module FloatingDivision#(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         input clk,
                         
                         output [XLEN-1:0] result);
                         
reg [23:0] A_Mantissa,B_Mantissa;
reg [22:0] Mantissa;
wire [7:0] exp;
reg [23:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;
reg [7:0] A_adjust,B_adjust;
reg A_sign,B_sign,Sign;
reg [32:0] Temp;
wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;
reg [6:0] exp_adjust;
reg [XLEN-1:0] B_scaled; 
reg en1,en2,en3,en4,en5;
reg dummy;
  
/*----Initial value----*/
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1)); //verified
assign debug = {1'b1,temp1[30:0]};
  FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.result(x0),.clk(clk));

/*----First Iteration----*/
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
  FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.result(temp3),.clk(clk));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

/*----Second Iteration----*/
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
  FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.result(temp5),.clk(clk));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

/*----Third Iteration----*/
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
  FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.result(temp7),.clk(clk));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

/*----Reciprocal : 1/B----*/
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};

/*----Multiplication A*1/B----*/
FloatingMultiplication M8(.A(A),.B(reciprocal),.clk(clk),.result(result));
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



module DEN_GEN(
    input mode,
    input [31:0] soc1, soc2, soc3, soc4,
    output [31:0] den,
    input clk
);

    // Declare two-dimensional array SOC
    reg [31:0] SOC [0:3]; // Array of 4 elements, each element is 32 bits wide

    // Assign input soc to SOC array
    always @* begin
        SOC[0] = soc1;
        SOC[1] = soc2;
        SOC[2] = soc3;
        SOC[3] = soc4;
    end
  
    wire [31:0] inverse [0:3];
    wire [31:0] addent [0:3];
  
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen
            FloatingReciprocal F(.B(SOC[i]), .clk(clk), .reciprocal(inverse[i]));
            MUX M(.data0(SOC[i]), .data1(inverse[i]), .select(mode), .mux_output(addent[i]));
        end
    endgenerate

    AdderN Addition(
        .A(addent[0]),
        .B(addent[1]),
        .C(addent[2]),
        .D(addent[3]),
        .clk(clk),
        .result(den)
    );
  
endmodule



module datapath(
  input [31:0] soc1,input [31:0]soc2,input [31:0] soc3,input [31:0] soc4,input [31:0]I,input sel,input eqz,
  output  gt,lt,eq,
  output [31:0] I1,I2,I3,I4);
  reg clk;
  
  
  ZeroComparator Zero(.in(I),.gt(gt),.lt(lt),.eq(eq));
  
  
   wire [31:0] resp[0:3];
  wire [31:0] muxOut[0:3];
  wire [31:0] den;
  wire [31:0] Quotient[0:3];
  wire [31:0] MultipliedCurrent [0:3];
  reg [31:0] zero=32'h00000000;
  
  wire [31:0] SOC [0:3];
  
  wire [31:0]iOut [0:3];

assign SOC[0] = soc1;
assign SOC[1] = soc2;
assign SOC[2] = soc3;
assign SOC[3] = soc4;
  
  genvar iterations;
  generate
    for (iterations = 0; iterations < 4; iterations = iterations + 1) begin : Modules_1
      FloatingReciprocal Reciprocator(.B(SOC[iterations]), .reciprocal(resp[iterations]),.clk(clk));
      MUX Multiplexers(.data0(SOC[iterations]), .data1(resp[iterations]), .select(sel), .mux_output(muxOut[iterations]));
    end
  endgenerate
  
  
  DEN_GEN Denominator(.mode(sel),.soc1(soc1),.soc2(soc2),.soc3(soc3),.soc4(soc4),.den(den),.clk(clk));
  
  
    genvar div_num;
  generate
    for (div_num = 0; div_num < 4; div_num = div_num + 1) begin : Modules_2
      FloatingDivision Divide(.A(muxOut[div_num]),.B(den),.result(Quotient[div_num]),.clk(clk));
      
      FloatingMultiplication Multiply (.A(Quotient[div_num]),.B(I),.clk(clk),.result(MultipliedCurrent[div_num]));
      MUX Multiplexers(
        .data0(MultipliedCurrent[div_num]), 
  .data1(zero), 
  .select(eqz), 
  .mux_output(iOut[div_num])
);  
    end
  endgenerate
                       
                       assign I1=iOut[0];
                       assign I2=iOut[1];
                       assign I3=iOut[2];
                       assign I4=iOut[3];
endmodule


module topLevel(input[31:0] soc1,soc2,soc3,soc4,I,
                output [31:0] i1,i2,i3,i4);
  
  wire sel,eqt,gt,lt,eq;
  
  datapath DP(.soc1(soc1),.soc2(soc2),.soc3(soc3),.soc4(soc4),.I(I),.sel(sel),.eqz(eqt),.gt(gt),.eq(eq),.lt(lt),.I1(i1),.I2(i2),.I3(i3),.I4(i4));
  control_path CP(.eq(eq),.gt(gt),.lt(lt),.eqt(eqt),.sel(sel));
  
  
  
endmodule