LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity fifo is
    generic (
        --! Size of single fifo data element
        data_width_g : positive := 16; 
        --! Number of elements in the fifo
        fifo_size_g : positive := 16; 
        --! Choose reset polarity for the core. '0' = active low, '1' = active high
        rst_polarity_g : std_ulogic := '0'
    );
    port (
        
        clk_i   : in std_ulogic;
        --! Active high clock enable
        clk_en_i : in std_ulogic;
        --! Synchronous reset signal will clear the fifo
        rst_i : in std_ulogic;

        --! When w_en_i is asserted, the data in w_data_i will be added to the fifo at the rising edge of clk_i
        w_en_i : in std_ulogic := '0';
        w_data_i : in unsigned(data_width_g -1 downto 0);
        --! When the fifo is full, w_full will assert and no new data will be accepted
        w_full_o : out std_ulogic;  
        
        --! When r_en_i is asserted, the data in r_data_o will be read to r_data_o and removed from the fifo
        r_en_i : in std_ulogic := '0';
        r_data_o : out unsigned(data_width_g-1 downto 0);
        --! When r_empy_o is asserted, the fifo is empty and the data on r_data_o is invalid
        r_empty_o : out  std_ulogic
        
    );
end entity fifo;

architecture rtl of fifo is
    type fifo_mem_g is array(0 to fifo_size_g) of unsigned(data_width_g -1 downto 0); 
    signal fifo_memory : fifo_mem_g :=  (others => to_unsigned(0, data_width_g));  

    signal r_ptr : positive range 0 to fifo_size_g := 0;
    signal w_ptr : positive range 0 to fifo_size_g := 0;

	signal words_in_fifo : positive range 0 to fifo_size_g := 0;

    signal w_full : std_ulogic := '0';
    signal r_empty : std_ulogic := '0';
begin

    fifo_proc : process (clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = rst_polarity_g then
                -- this is not possible if 
                fifo_memory <=  (others => to_unsigned(0, data_width_g)); 
                w_ptr <= 0;
                r_ptr <= 0; 
            elsif clk_en_i then

				if w_en_i and not w_full then 
					words_in_fifo <= words_in_fifo +1;
				end if;
				
				if r_en_i and not r_empty then 
					words_in_fifo <= words_in_fifo -1;
				end if;

                if w_en_i then 
                    if w_ptr = fifo_size_g -1 then
						w_ptr <= 0;
					else
                        w_ptr <= w_ptr+1;
                    end if;
					fifo_memory(w_ptr) <= w_data_i;
                end if;

                if r_en_i then
					r_data_o <= fifo_memory(r_ptr);
                    if r_ptr = fifo_size_g -1 then
						r_ptr <= 0;
					else
						r_ptr <= r_ptr+1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    w_full_o <= w_full;
    r_empty_o <= r_empty;
	w_full <= '1' when words_in_fifo = fifo_size_g else '0';
	r_empty <= '1' when words_in_fifo = 0 else '0';

end architecture;