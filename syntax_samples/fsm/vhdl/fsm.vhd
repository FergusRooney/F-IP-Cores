LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fsm is
    port (
        clk_i   : in std_ulogic;
        rst_i : in std_ulogic;
        in_i : in std_ulogic;
        out_i : in std_ulogic
        
    );
end entity;


architecture rtl of fsm is
    type state_t is (A, B, C, D);
    signal state : state_t := A;

begin



    process(clk_i) begin 
        if rst_i = '0' then
            state <= A;
        else
            case state is 
                when A => 
                    if (in_i = '1') then 
                        state <= B;
                    end if; 
                when B =>
                    if (in_i = '1') then
                        state <= C;
                    end if;
                when C =>
                    if (in_i = '1') then
                        state <= D;
                    end if;
                when D =>
                    if (in_i = '1') then
                        state <= A;
                    end if;
                when others =>
                    state <= B;
            end case;
        end if;
    end process;

    

end architecture;