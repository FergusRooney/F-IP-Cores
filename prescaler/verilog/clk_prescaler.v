module clk_prescaler(
	input logic rstn_i, en_i, clk_i,
    input logic [2:0] prsc_count_i,
    output logic clk_en_o
);
  logic [3:0] counter = 0;  
  logic clk_en_ff = 0;
  
  assign clk_en_o = clk_en_ff;
  
  always_ff @(posedge clk_i, posedge rstn_i) begin
    if (~rstn_i) begin
      counter <= 0;
    end
    else begin 
      if (en_i) begin
        counter = counter + 1;
        if (counter == prsc_count_i) begin
          counter <= 0;
          clk_en_ff <= ~clk_en_ff;
        end
      end
    end
  end

endmodule;
