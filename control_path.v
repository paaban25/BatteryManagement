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