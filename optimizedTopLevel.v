// Code your design here
//top module
module top(clk, start,i, socin1
  ,socin2
  ,socin3
  ,socin4,
  socout1
  ,socout2
  ,socout3
  ,socout4
  ,outReady);
  input i;
  input start;
  input clk;
  input socin1;
  input socin2;
  input socin3;
  input socin4;
  output socout1;
  output socout2;
  output socout3;
  output socout4;
  output outReady;
wire loadOut1
  ,loadOut2
  ,loadOut3
  ,loadOut4
  ,shft
  ,clrCount1
  ,loadDivide1
  ,loadDivide2
  ,loadMultiply
  ,divideDone1
  ,divideDone2
  ,multiplyDone
  ,ngtv
  ,loaded;
  wire [1:0] sel2;
  CONTROLPATH z0 (
   loadOut1
  ,loadOut2
  ,loadOut3
  ,loadOut4
  ,shft
  ,clrCount1
  ,sel2
  ,loadDivide1
  ,loadDivide2
  ,loadMultiply
  ,divideDone1
  ,divideDone2
  ,multiplyDone
  ,ngtv
  ,loaded
  ,start
  ,clk
  ,outDone
);
 DATAPATH z1 (
   i
  ,clk
  ,socin1
  ,socin2
  ,socin3
  ,socin4
  ,shft
  ,loadOut1
  ,loadOut2
  ,loadOut3
  ,loadOut4
  ,clrCount1
  ,sel2
  ,loadDivide1
  ,loadDivide2
  ,loadMultiply
  ,socout1
  ,socout2
  ,socout3
  ,socout4
  ,divideDone1
  ,divideDone2
  ,multiplyDone
  ,outDone
  ,outReady
  ,loaded
  ,ngtv
);
endmodule
//control path
module CONTROLPATH(
   loadOut1
  ,loadOut2
  ,loadOut3
  ,loadOut4
  ,shft
  ,clrCount1
  ,sel2
  ,loadDivide1
  ,loadDivide2
  ,loadMultiply
  ,divideDone1
  ,divideDone2
  ,multiplyDone
  ,ngtv
  ,loaded
  ,start
  ,clk
  ,outDone
);
  input clk;
  input divideDone1;
  input divideDone2;
  input loaded;
  input multiplyDone;
  input ngtv;
  input start;
  input outDone;
  output reg loadOut1;
  output reg loadOut2;
  output reg loadOut3;
  output reg loadOut4;
  output reg clrCount1;
  output reg [1:0] sel2;
  output reg shft;
  output reg loadDivide1;
  output reg loadDivide2;
  output reg loadMultiply;
  reg [4:0] state;
  parameter S0=5'b00000,S1=5'b00001,S2=5'b00010,S3=5'b00011,S4=5'b00100,S5=5'b00101,S6=5'b00110,S7=5'b00111,S8=5'b01000,S9=5'b01001, S10=5'b01010,S11=5'b01011,S12=5'b01100,S13=5'b01101,S14=5'b01110,S15=5'b01111,S16=5'b10000,S17=5'b10001,S18=5'b10010,S19=5'b10011, S20=5'b10100,S21=5'b10101,S22=5'b10110,S23=5'b10111,S24=5'b11000,S25=5'b11001;
  always@(posedge clk)
    case(state)
      S0: if(start == 1) state <= S1;
      S1: state <= S2; // count cleared
      S2: if(loaded) begin if(!ngtv) state <= S3; else state <= S24; end // input loaded
      S3: state <= S4; // divider2 loaded
      S4: if(divideDone2) state <= S5; // division2 performing
      S5: state <= S6; // multiplier loaded
      S6: if(multiplyDone) state <= S7; // multiplication performed
      S7: state <= S8; // outputloaded
      S8: state <= S9; // divider2 loaded
      S9: if(divideDone2) state <= S10; // division2 performing
      S10: state <= S11; // multiplier loaded
      S11: if(multiplyDone) state <= S12; // multiplication performed
      S12: state <= S13; // outputloaded
      S13: state <= S14; // divider2 loaded
      S14: if(divideDone2) state <= S15; // division2 performing
      S15: state <= S16; // multiplier loaded
      S16: if(multiplyDone) state <= S17; // multiplication performed
      S17: state <= S18; // outputloaded
      S18: state <= S19; // divider2 loaded
      S19: if(divideDone2) state <= S20; // division2 performing
      S20: state <= S21; // multiplier loaded
      S21: if(multiplyDone) state <= S22; // multiplication performed
      S22: state <= S23; // outputloaded
      S23: if(outDone) state <= S0;
      S24: state <= S25; // Divider1 loaded
      S25: if(divideDone1) state <= S3;
  default: state <= S0;
    endcase
  always@(state)
    case(state)
      S0: begin loadOut1=0;loadOut2=0;loadOut3=0;loadOut4=0;clrCount1=0;sel2=0;loadDivide1=0;loadDivide2=0;loadMultiply=0;shft=0; end
      S1: clrCount1=1;
      S2: clrCount1=0;
      S3: begin sel2=0;loadDivide2=1;end
      S4: loadDivide2=0;
      S5: loadMultiply=1;
      S6: loadMultiply=0;
      S7: loadOut1=1;
      S8: begin sel2=1;loadOut1=0;loadDivide2=1; end
      S9: loadDivide2=0;
      S10: loadMultiply=1;
      S11: loadMultiply=0;
      S12: loadOut2=1;
      S13: begin sel2=2;loadOut2=0;loadDivide2=1; end
      S14: loadDivide2=0;
      S15: loadMultiply=1;
      S16: loadMultiply=0;
      S17: loadOut3=1;
      S18: begin sel2=3;loadOut3=0;loadDivide2=1; end
      S19: loadDivide2=0;
      S20: loadMultiply=1;
      S21: loadMultiply=0;
      S22: loadOut4=1;
      S23: begin loadOut4=0; shft=1; end
      S24: loadDivide1=1;
      S25: loadDivide1=0;
    endcase
endmodule

//data path
module DATAPATH(
   i
  ,clk
  ,socin1
  ,socin2
  ,socin3
  ,socin4
  ,shft
  ,loadOut1
  ,loadOut2
  ,loadOut3
  ,loadOut4
  ,clrCount1
  ,sel2
  ,loadDivide1
  ,loadDivide2
  ,loadMultiply
  ,socout1
  ,socout2
  ,socout3
  ,socout4
  ,divideDone1
  ,divideDone2
  ,multiplyDone
  ,outDone
  ,outReady
  ,loaded
  ,ngtv
);
  input i;
  input clk;
  input socin1;
  input socin2;
  input socin3;
  input socin4;
  input loadOut1;
  input loadOut2;
  input loadOut3;
  input loadOut4;
  input shft;
  input clrCount1;
  input loadMultiply;
  input loadDivide1;
  input loadDivide2;
  input [1:0] sel2;
  output socout1;
  output ngtv;
  output loaded;
  output socout2;
  output socout3;
  output socout4;
  output divideDone1;
  output divideDone2;
  output outDone;
  output outReady;
  output multiplyDone;
  wire ld1;
  wire ld2;
  wire clk1;
  wire clk2;
  wire [12:0] current;
  wire [9:0] soc1;
  wire [9:0] soc2;
  wire [9:0] soc3;
  wire [9:0] soc4;
  wire [3:0] count;
  wire [10:0] soc_1;
  wire [10:0] soc_2;
  wire [10:0] soc_3;
  wire [10:0] soc_4;
  wire [43:0] mux_out;
  wire [12:0] sum_out;
  wire [25:0] multiplyOut;
  wire outDone1;
  wire outDone2;
  wire outDone3;
  wire outDone4;
  wire outReady1;
  wire outReady2;
  wire outReady3;
  wire outReady4;
  assign outReady = outReady1&outReady2&outReady3&outReady4;
  assign outDone  = outDone1&outDone2&outDone3&outDone4;
  assign clk1 = ld1&clk;
  assign loaded = !ld1;
  assign clk2 = ld2&clk;
  assign sel = current[12];
  assign ngtv = current[12];
  wire [12:0] divideOut;
  wire [12:0] divideIn;
  wire divideDone11;
  wire divideDone12;
  wire divideDone13;
  wire divideDone14;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire [10:0] soc_11;
  wire [10:0] soc_22;
  wire [10:0] soc_33;
  wire [10:0] soc_44;
  assign s1 = |{1'b0,soc1};
  assign s2 = |{1'b0,soc2};
  assign s3 = |{1'b0,soc3};
  assign s4 = |{1'b0,soc4};
  assign divideDone1 = divideDone11&divideDone12&divideDone13&divideDone14;
  SIPO13     S1(current,i,clk1);
  SIPO10     S2(soc1,socin1,clk2);
  SIPO10     S3(soc2,socin2,clk2);
  SIPO10     S4(soc3,socin3,clk2);
  SIPO10     S5(soc4,socin4,clk2);
  COUNTER1   A1(count,clk,clrCount1);
  COMPARATOR C1(count,ld1,ld2);
  DIVIDER1    A2(soc_1,divideDone11,10'd1,soc1,loadDivide1,clk);
  DIVIDER1    A3(soc_2,divideDone12,10'd1,soc2,loadDivide1,clk);
  DIVIDER1    A4(soc_3,divideDone13,10'd1,soc3,loadDivide1,clk);
  DIVIDER1    A5(soc_4,divideDone14,10'd1,soc4,loadDivide1,clk);
  DIVIDER2    A6(divideIn,sum_out,divideOut,loadDivide2,clk,divideDone2);
  MUX1       M1({1'b0,soc1},{1'b0,soc2},{1'b0,soc3},{1'b0,soc4},soc_11,soc_22,soc_33,soc_44,mux_out,sel);
  MUX2       M2(mux_out[43:33],mux_out[32:22],mux_out[21:11],mux_out[10:0],divideIn,sel2);
  MUX3       M3(11'b0,soc_1,s1,soc_11);
  MUX3       M4(11'b0,soc_2,s2,soc_22);
  MUX3       M5(11'b0,soc_3,s3,soc_33);
  MUX3       M6(11'b0,soc_4,s4,soc_44);
  ADDER      W1(mux_out[43:33],mux_out[32:22],mux_out[21:11],mux_out[10:0],sum_out);
  BOOTH      B1(current,{1'b0,divideOut[12:1]},multiplyOut,loadMultiply,clk,multiplyDone);
  PISO       P1(multiplyOut[23:11],socout1,clk,loadOut1,outDone1,outReady1,shft);
  PISO       P2(multiplyOut[23:11],socout2,clk,loadOut2,outDone2,outReady2,shft);
  PISO       P3(multiplyOut[23:11],socout3,clk,loadOut3,outDone3,outReady3,shft);
  PISO       P4(multiplyOut[23:11],socout4,clk,loadOut4,outDone4,outReady4,shft);
endmodule


// This is a module for the Serial In Parallel Out Register
// This is a 13 bit register
module SIPO13(d_out,d_in,clk);
  input d_in,clk;
  output [12:0] d_out;
  reg [12:0] out;
  assign d_out = out;
  always@(posedge clk)
    begin
      out[12] <= d_in;
      out[11:0] <= out[12:1];
    end
endmodule




// This is a module for the Serial In Parallel Out Register
// This is a 13 bit register
module SIPO10(d_out,d_in,clk); // Serial In Paraller Out
  input d_in,clk;
  output [9:0] d_out;
  reg [9:0] out;
  assign d_out = out;
  always@(posedge clk)
    begin
      out[9] <= d_in;
      out[8:0] <= out[9:1];
    end
endmodule


// This is a counter for the Serial In data.
// This will count the number of bits that are going in.
module COUNTER1(d_out,clk,clr);
  input clk,clr;
  output reg [3:0] d_out;
  always@(posedge clk)
    begin
      if(clr)
        d_out <= 0;
      else if(d_out < 13)
        #1 d_out <= d_out + 1;
    end
endmodule





// This is  a comparator, which the compare the counter values and stop further value
// going in the serial in register.
module COMPARATOR(din,ld1,ld2);
  input [3:0] din;
  output ld1,ld2;
  assign ld1 = din<13;
  assign ld2 = din<10;
endmodule


// 10 bit diveder for calculating 1/SOC

module DIVIDER1(d_out,divideDone,numerator,denominator,load,clk);
  input [9:0] numerator,denominator;
  input load,clk;
  output divideDone;
  output [10:0] d_out; // Answer of the Division
  reg [3:0] count; // Count variable for counting steps
  reg [10:0] A; // Register for storing the Dividend
  reg [10:0] Q; // 
  reg [9:0] M; // Divisor constant
  wire [10:0]AM;
  assign AM = A-M;
  assign d_out = Q;
  assign divideDone = (count==10);
  always@(posedge clk)
    begin
      if(load==1)
        begin
          count <= 0;
          A <= {1'b0,numerator};
          M <= denominator;
          Q <= 0;
        end
      else if(count < 11)
        begin
          count <= count +1 ;
          if(A<M)
            begin 
             Q <= Q << 1;
             A <= A << 1;
            end
          else
            begin
              Q <= {Q[9:0],1'b1};
              A <= {AM[9:0],1'b0};
            end
        end
    end
endmodule


// 13 bit / 13 bit division
module DIVIDER2(numerator,denominator,d_out,load,clk,divideDone);
  input [12:0] numerator,denominator;
  input load,clk;
  output [12:0] d_out;
  output divideDone;
  reg [12:0] Q;
  reg[13:0] A;
  reg [12:0] M;
  reg [3:0] count;
  wire [13:0] AM;
  assign AM = A-M;
  assign d_out = Q;
  assign divideDone = (count==13);
  always@(posedge clk)
    begin
      if(load)
        begin
          count <= 0;
          Q <= 0;
          M <= denominator;
          A <= {1'b0,numerator};
        end
      else if(count < 13)
        begin
          count <= count+1;
          if(A < M)
            begin
              Q <= Q << 1;
              A <= A << 1;
            end
          else 
            begin
              A <= {AM[12:0],1'b0};
              Q <= {Q[12:0],1'b1};
            end
         end
    end
endmodule



// module adder for adding 4 11 bit's number.
// This adder will either calculate soc1+soc2+soc3+soc4 or
// soc_1,soc_2,soc_3,soc_4 depending on the MSB of current
module ADDER(in1,in2,in3,in4,out);
  input [10:0] in1;
  input [10:0] in2;
  input [10:0] in3;
  input [10:0] in4;
  output reg [12:0] out;
  always@(*)
    out = {2'b00,in1}+{2'b00,in2}+{2'b00,in3}+{2'b00,in4};
endmodule


// This is a MUX for selecting inputs to the adder.
// Whether it should pass soci or soc_i.
// This will depend on the MSB of current.

module MUX1(in1,in2,in3,in4,in5,in6,in7,in8,out,sel);
  input [10:0] in1;
  input [10:0] in2;
  input [10:0] in3;
  input [10:0] in4;
  input [10:0] in5;
  input [10:0] in6;
  input [10:0] in7;
  input [10:0] in8;
  input sel;
  output reg [43:0] out;
  always@(*)
    out = sel ? {in5,in6,in7,in8}:{in1,in2,in3,in4};
endmodule

module MUX2(in1,in2,in3,in4,out,sel);
  input [10:0] in1;
  input [10:0] in2;
  input [10:0] in3;
  input [10:0] in4;
  input [1:0] sel;
  output reg [10:0] out;
  always@(*)
    case(sel)
      2'b00: out[10:0] = in1[10:0];
      2'b01: out[10:0] = in2[10:0];
      2'b10: out[10:0] = in3[10:0];
      2'b11: out[10:0] = in4[10:0];
    endcase
endmodule

module MUX3(in1,in2,sel,out);
  input [10:0] in1;
  input [10:0] in2;
  input sel;
  output reg [10:0] out;
  always@(*)
    out = sel ? in2:in1;
endmodule

// Booths Multiplier 
module BOOTH(in1,in2,out,load,clk,done);
  input [12:0] in1,in2;
  input clk,load;
  output [25:0] out;
  output done;
  reg [12:0] A;
  reg [12:0] Q;
  reg [12:0] M;
  wire [12:0] AM1;
  wire [12:0] AM2;
  assign AM1 = A+M;
  assign AM2 = A-M;
  assign out = {A,Q};
  reg [3:0] count;
  reg Q_1;
  assign done = (count==13);
  always@(posedge clk)
    begin
      if(load)
        begin
          count <= 0;
          A <= 0;
          M <= in1;
          Q <= in2;
          Q_1 <= 0;
        end
      else if(count < 13)
        begin
          count <= count + 1;
          if(in2 == 4096)
            begin
            A<= 0;
          	Q <= in1;
            end
          else if({Q[0],Q_1} == 2'b00 | {Q[0],Q_1} == 2'b11)
             begin
               A <= {A[12],A[12:1]};
               Q <= {A[0],Q[12:1]};
               Q_1 <= Q[0];
             end
          else if({Q[0],Q_1} == 2'b01)
            begin
              A <= {AM1[12],AM1[12:1]};
              Q <= {AM1[0],Q[12:1]};
              Q_1 <= Q[0];
            end
          else
            begin
              A <= {AM2[12],AM2[12:1]};
              Q <= {AM2[0],Q[12:1]};
              Q_1 <= Q[0];
            end
        end 
    end
endmodule


// Parallel In and Serial Out Register
module PISO(d_in,d_out,clk,load,done,ready,shft);
  input [12:0] d_in;
  input clk;
  input load;
  input shft;
  output d_out;
  output done;
  output ready;
  reg [12:0] out;
  reg [4:0] count;
  assign d_out = out[0];
  assign done = count==13;
  assign ready = !done;
  always@(posedge clk)
    begin
      if(load)
        begin
          out <= d_in;
          count <= 1;
        end
      else if(count < 13 & shft)
        begin
        count <= count+1;
          out <= out >>1;
        end
    end
endmodule