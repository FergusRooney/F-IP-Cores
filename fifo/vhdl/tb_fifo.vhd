LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity tb_fifo is
	generic (
        --! Size of single fifo data element
        data_width_g : positive := 16; 
        --! Number of elements in the fifo
        fifo_size_g : positive := 16; 

        --! Choose reset polarity for the core. '0' = active low, '1' = active high
        rst_polarity_g : std_ulogic := '0'
    );
end entity tb_fifo;

architecture rtl of tb_fifo is
	constant clk_period_c : time := 1 us;

	signal tb_clk_i   :  std_ulogic := '0';
        --! Active high clock enable
	signal tb_clk_en_i : std_ulogic;
	--! Synchronous reset signal will clear the fifo
	signal tb_rst_i : std_ulogic;

	--! When w_en_i is asserted, the data in w_data_i will be added to the fifo at the rising edge of clk_i
	signal tb_w_en_i :  std_ulogic := '0';
	signal tb_w_data_i :  unsigned(data_width_g -1 downto 0);
	--! When the fifo is full, w_full will assert and no new data will be accepted
	signal tb_w_full_o : std_ulogic;  
	
	--! When r_en_i is asserted, the data in r_data_o will be read to r_data_o and removed from the fifo
	signal tb_r_en_i : std_ulogic := '0';
	signal tb_r_data_o : unsigned(data_width_g-1 downto 0);
	--! When r_empy_o is asserted, the fifo is empty and the data on r_data_o is invalid
	signal tb_r_empty_o : std_ulogic;
begin
	tb_clk_i <= not tb_clk_i after clk_period_c/2;
	tb : process 
	begin
		tb_rst_i <= '0';
		wait for 5 * clk_period_c;
		tb_rst_i <= '1';
		wait for 5 * clk_period_c;
		tb_clk_en_i <= '1';
		wait for 10 * clk_period_c;
		tb_w_en_i <= '0';
		tb_w_en_i <= '1';
		for i in 10 to 20 loop
			tb_w_data_i <=to_unsigned(i, data_width_g);
			wait until rising_edge(tb_clk_i);
		end loop;
		tb_w_en_i <= '0';
		wait for 10 * clk_period_c;

		tb_r_en_i <= '1';
		for i in 10 to 20 loop
			wait until rising_edge(tb_clk_i);
		end loop;
		tb_r_en_i <= '0';
		wait for 10 * clk_period_c;
		tb_r_en_i <= '1';
		tb_w_en_i <= '1';
		for i in 0 to 15 loop
			tb_w_data_i <=to_unsigned(i, data_width_g);
			wait until rising_edge(tb_clk_i);
		end loop;
		tb_r_en_i <= '0';
		tb_w_en_i <= '0';
		wait for 15 * clk_period_c;

	end process;

	fifo : entity work.fifo
		generic map (
			data_width_g => data_width_g,
			
			fifo_size_g => fifo_size_g,
			rst_polarity_g => rst_polarity_g
		)
		port map (
			clk_i    => tb_clk_i,
			clk_en_i  => tb_clk_en_i, 
			rst_i  => tb_rst_i, 
			w_en_i  => tb_w_en_i, 
			w_data_i  => tb_w_data_i, 
			w_full_o  => tb_w_full_o, 
			r_en_i => tb_r_en_i,
			r_data_o => tb_r_data_o,
			r_empty_o  => tb_r_empty_o 
		);
	

end architecture;