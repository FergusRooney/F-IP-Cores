module fifo #(parameter data_word_size_g = 8,
                        num_fifo_elements_g = 16,
                        reset_pol_g = 1'b0
            )( 
            input clk_i, rst_i, clk_en_i, r_en_i, w_en_i,
            input [data_word_size_g-1 : 0] w_data_i,
            output wire [data_word_size_g-1 : 0] r_data_o,
            output wire r_empty_o, w_full_o
            );
            
    reg [data_word_size_g-1 : 0] fifo_reg [num_fifo_elements_g-1 : 0];
    reg [num_fifo_elements_g-1 : 0] fifo_counter = {num_fifo_elements_g{1'b0}};


    reg [data_word_size_g-1 : 0] r_data_reg = 0;

    reg [$clog2(num_fifo_elements_g)-1 : 0] r_ptr = 0;
    reg [$clog2(num_fifo_elements_g)-1 : 0] w_ptr = 0;

    always @(posedge clk_i)
        if (rst_i == reset_pol_g) begin
            fifo_counter <= {num_fifo_elements_g{1'b0}};
            w_ptr  <= 0;
            r_ptr <= 0;
        end else if (clk_en_i == 1) begin
            if (w_en_i && ~w_full_o) begin
                fifo_reg[w_ptr] = w_data_i;
                fifo_counter = fifo_counter + 1;
                if (w_ptr == num_fifo_elements_g) 
                    w_ptr <= 0;
                else 
                    w_ptr <= w_ptr + 1;
            end

            if (r_en_i && ~r_empty_o) begin
                r_data_reg <= fifo_reg[r_ptr];
                fifo_counter <= fifo_counter - 1;
                if  (r_ptr == num_fifo_elements_g)
                    r_ptr <= 0;
                else  
                    r_ptr <= r_ptr + 1;
            end
        end

    assign r_data_o = r_data_reg;
	assign w_full_o = fifo_counter == num_fifo_elements_g ? 1'b1 : 1'b0; 
    assign r_empty_o = fifo_counter == 0 ? 1'b1 : 1'b0;


    // integer idx; // Dump out fifo contents for simulation
    // initial begin
    //   $dumpfile("dump1.vcd");
    //   for (idx = 0; idx < num_fifo_elements_g; idx = idx + 1) $dumpvars(0, fifo_reg[idx]);
    // end
 
endmodule 
