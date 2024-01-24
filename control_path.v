module control_path(start,soc,done,gt,eq,lt,eqz,sel,clk)
  input start,gt,lt,eq;
  input[31:0] soc [3:0];
  output eqz,sel,done;
  
  parameter S0=3'b000,S1=3'b001, S2=3'b010, S3=3'b011,S4=3'100,S5=3'b101,S6=3'b110;
  
  reg [2:0] state;
  
  always@(posedge clk)
    begin
      case(state)
        S0:if(start)state<=S1;
        S1:state<=S2;
        S2:begin
          if(gt) state<=S3;
          else if(lt) state<=S4;
          else state<=S5; 
        end
        S3:state<=S6;
        S4:state<=S6;
        S5:state<=S6;
        S6:state<=S6;
        default: state<=S6;
      endcase
    end
  
  always @(state)
    begin
      case(state)
        S0:begin done<=1'b0; sel=1'b0; eqz=1'b0; end
        S1:begin done<=1'b0; sel=1'b0; eqz=1'b0; end
        S2:begin done<=1'b0; sel=1'b0; eqz=1'b0; end
        S3:begin done<=1'b0; sel=1'b0; eqz=1'b0; end
        S4:begin done<=1'b0; sel=1'b1; eqz=1'b0; end
        S5:begin done<=1'b0; sel=1'b0; eqz=1'b1; end
        S6:begin done<=1'b1; end
        
      endcase
    end
  
endmodule