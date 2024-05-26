module tb_clk_prescaler;
  // Parameters for the testbench
  localparam integer CLK_PERIOD = 10; // Clock period in time units

  // DUT (Device Under Test) signals
  logic rstn_i;
  logic en_i;
  logic clk_i;
  logic [2:0] prsc_count_i;
  logic clk_en_o;

  // Instantiate the DUT
  clk_prescaler dut (
    .rstn_i(rstn_i),
    .en_i(en_i),
    .clk_i(clk_i),
    .prsc_count_i(prsc_count_i),
    .clk_en_o(clk_en_o)
  );

  // Clock generation
  always begin
    # (CLK_PERIOD / 2) clk_i = ~clk_i;
  end

  // Testbench procedure
  initial begin
    // Initialize signals
    clk_i = 0;
    rstn_i = 0;
    en_i = 0;
    prsc_count_i = 3'b000;

    // Apply reset
    rstn_i = 1;
    # (2 * CLK_PERIOD);
    rstn_i = 0;
    # (2 * CLK_PERIOD);
    rstn_i = 1;
    # (2 * CLK_PERIOD);

    // Test case 1: Basic functionality check
    prsc_count_i = 3'b010; // Set prescaler count
    en_i = 1; // Enable the counter
    # (20 * CLK_PERIOD); // Wait for a few clock cycles


    // Test case 2: Change prescaler count
    prsc_count_i = 3'b011;
    # (20 * CLK_PERIOD);

     // Test case 2: Change prescaler count
    prsc_count_i = 3'b100;
    # (20 * CLK_PERIOD);

    // Finish simulation
    $finish;
  end

  // Monitor signals
  initial begin
    $dumpfile("clk_prescaler.vcd");
    $dumpvars(0, tb_clk_prescaler);
    $monitor("Time: %0t | rstn_i: %b | en_i: %b | clk_i: %b | prsc_count_i: %b | clk_en_o: %b", 
              $time, rstn_i, en_i, clk_i, prsc_count_i, clk_en_o);
  end

endmodule