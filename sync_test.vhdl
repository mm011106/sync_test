-- ファントムドライバの回路を作るためのテスト
-- 　シーケンサ回路のパラメタライゼーションの検討
--

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity SEQUENCER is
		-- generic ( N	:	integer	:= 4); -- word length 2**N e.g. 16bit incase of N=4
		port	(
					-- inputs
					nRES	: in std_logic;
					CLK	: in std_logic;

				  -- outputs
					SYNC, INH	: out std_logic

			);
end SEQUENCER;


architecture Behavioral of SEQUENCER is

constant BURST_MARK : 	integer := 2;
constant BURST_SPACE:	integer := 1;
constant BURST_Q_WIDTH: integer := 2;

constant SYNC_PULSE_START: integer := 1;

--  internal signal
signal 	Q_BURST:		std_logic_vector(BURST_Q_WIDTH-1 downto 0);		--  burst wave counter

-- signal	Q_SEQ:		std_logic_vector(N+1 downto 0);		-- Sequience counter
-- signal 	ADD_COUNT:	std_logic_vector(1 downto 0);			-- Address counter for COMMAND words
-- signal	S_REG:		std_logic_vector(2**N-1 downto 0);	-- Output Register

signal	INT_SYNC:			std_logic;	-- Sync signal (internal)
signal	INT_CLK:		std_logic;



begin

	BURST_COUNTER: entity work.COUNTER_INC
		generic map (WIDTH => BURST_Q_WIDTH, COUNT => (BURST_MARK + BURST_SPACE - 1) )
		port map    (EN => nRES , CLK => CLK, Q => Q_BURST);

	-- assart INT_SYNC when Q_BURST count more than SYNC_PULSE_START : determine the pulse width of SYNC
	process (Q_BURST) begin
		if ( Q_BURST >= CONV_std_logic_vector(SYNC_PULSE_START,BURST_Q_WIDTH) ) then
			INT_SYNC	<= '1';
		else 
			INT_SYNC <= '0';
		end if;		
	end process;
	
--	INT_SYNC	<=	Q_BURST(1);
	INT_CLK	<=	Q_BURST(0);

	INH <= Q_BURST(0);
	SYNC <= INT_SYNC;


end Behavioral;
