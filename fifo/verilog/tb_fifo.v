`timescale 1ns / 1ps 
module test;

    parameter 
        data_word_size = 8,
        fifo_elements = 16,
        period = 10;

    /* Make a regular pulsing clock. */
    reg clk = 1'b0, clk_en = 1'b0, reset = 1'b0;
    wire w_full, w_empty;
    reg [data_word_size-1 : 0] w_data = 0;
    wire [data_word_size-1 : 0] r_data;
    reg w_en = 1'b0;
    reg r_en = 1'b0;
    reg [data_word_size-1 : 0] fifo_reg [fifo_elements-1 : 0];

    always #(period/2) clk = !clk;

    fifo #(data_word_size, fifo_elements, 1'b0)  fifo1(clk, reset, clk_en,r_en, w_en, w_data, r_data , r_empty, w_full); 

    task test_read_write();
    begin
        clk_en <= 1'b1;
        # 10;
        @(posedge clk)
        w_data <= 15;
        w_en <= 1'b1;
        @(posedge clk);
        w_data <= 69;
        @(posedge clk);
        w_data <= 42;
        @(posedge clk);
        w_en <= 1'b0;
        # 30;

        @(posedge clk);
        r_en <= 1'b1;
        @(posedge clk);
        @(posedge clk);
        if (r_data != 15) begin
            $error ("Data 1 not equal to 15, equal to %d",  r_data);
        end
        @(posedge clk);
        if (r_data != 69)
            $error ("Data 2 not equal to 69, equal to %d ", r_data);
        @(posedge clk);
        if (r_data != 42)
            $error ("Data 2 not equal to 42, equal to %d", r_data);
        # 20;
        if (r_empty != 1'b1)
            $error ("Read_empty should be asserted when reading from empty fifo");
        r_en <= 1'b0;
        #25;
    end
    endtask

    
    initial #5000 $finish;


    integer idx;

    
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, test);
        
        // Ugly way to dump out fifo contents for simulation for iverilog and gtkwave
        for (idx = 0; idx < fifo_elements; idx = idx + 1) $dumpvars(0, fifo1.fifo_reg[idx]);

        reset <= 1'b0;
        #10;
        reset <= 1'b1;
        #10;

        test_read_write();

        $finish;  // Terminate simulation
        $stop;
    end
			  
endmodule // test
