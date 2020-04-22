library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sim is
end sim;

architecture SEQUENCER of sim is
component SEQUENCER
	port(
		-- inputs
		nRES	: in std_logic;	-- This input MUST be Shumitt mode
		CLK	: in std_logic;

		--	DDS control
		SYNC, INH	: out std_logic
										-- Please refer the manual of AD9834(analog devices)
	);
end component;

signal tb_CLK   	: std_logic:='0';
signal tb_nRES  	: std_logic:='0';

signal tb_SYNC, tb_INH	: std_logic:='0';


-- signal for initiating end of simulation.
signal SIM_END 		: boolean := false;

-- CLK
constant PERIOD_A : time := 50 ns;

-- total period of this simulation
constant PERIOD_B : time := 1500 us;

begin
	DUT:SEQUENCER
 		port map(

			CLK => tb_CLK,
			nRES => tb_nRES,
			INH => tb_INH,
			SYNC => tb_SYNC
		);

	process
	begin
		wait for PERIOD_A;
		-- Enable counters
		tb_nRES <= '1';

		loop
			wait for PERIOD_A;

			tb_CLK <= not(tb_CLK);

			if (SIM_END) then
				wait;
			end if;
		end loop;

	end process;

-- Controlling the total simulation period of time
	process
	begin
			wait for PERIOD_B;
			SIM_END <= true;
			wait;
	end process;

end SEQUENCER;
