module fsm (
    input clk_i, rst_i, in_i,
    output out_i
);

localparam a=0, b=1, c=2, d=3;
reg [1:0] state;

always @ (posedge clk_i) begin
    // Synchronous reset
    if (rst_i == 1'b0) begin
        state <= a; // A is reset state
    end else begin
        case (state) 
            a: begin
                if (in == 1'b1) begin
                    state <= B;
                end
            end
            b: begin
                if (in == 1'b1) begin
                    state <= C;
                end
            end
            c: begin
                if (in == 1'b1) begin
                    state <= d;
                end
            end


        endcase;

    end

end



endmodule