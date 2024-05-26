module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        
        // State transition logic
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        if (areset == 1'b0) begin
            state = B;
        end else 
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        state = A;
                    end else 
                        state = B;
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        state = B;
                    end else 
                        state = A;
                    end
                end
               
            endcase;
         end
        // State flip-flops with asynchronous reset

                
    assign out = (state == A ? 1'b0 : state == B ? 1'b0 : 1'b0);
    // Output logic
    // assign out = (state == ...);

endmodule
