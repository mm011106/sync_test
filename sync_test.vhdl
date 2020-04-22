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

constant ECD_NUMBER:		integer :=50;
constant ECD_Q_WIDTH:		integer	:=6;

--  internal signal
signal 	Q_BURST:		std_logic_vector(BURST_Q_WIDTH-1 downto 0);		--  burst wave counter
signal 	Q_ECD:			std_logic_vector(ECD_Q_WIDTH-1 downto 0);

signal	BURST_SYNC:		std_logic:='0';	-- Sync signal (internal)
signal	ECD_SYNC:		std_logic:='0';
signal	ECD_CLK:			std_logic;

signal	BURST_INH:		std_logic:='0';
signal	ECD_INH:			std_logic:='0';


begin

	BURST_COUNTER: entity work.COUNTER_INC
		generic map (WIDTH => BURST_Q_WIDTH, COUNT => (BURST_MARK + BURST_SPACE - 1) )
		port map    (EN => nRES , CLK => CLK, Q => Q_BURST);

	ECD_COUNTER: entity work.COUNTER_INC
		generic map (WIDTH => ECD_Q_WIDTH, COUNT => (ECD_NUMBER ) )
		port map    (EN => nRES , CLK => ECD_CLK, Q => Q_ECD);

	-- assart BURST_SYNC when Q_BURST count more than SYNC_PULSE_START : determine the pulse width of SYNC
	process (Q_BURST) begin
--		if ( Q_BURST >= CONV_std_logic_vector(SYNC_PULSE_START,BURST_Q_WIDTH-1) ) then
		if ( Q_BURST >= SYNC_PULSE_START ) then	

			BURST_SYNC	<= '1';
		else
			BURST_SYNC <= '0';
		end if;

--		if Q_BURST = CONV_std_logic_vector(0,BURST_Q_WIDTH-1) then
		if Q_BURST = 0 then

			ECD_CLK <='1';
		else
			ECD_CLK <='0';
		end if;
		
--		if ( Q_BURST <= CONV_std_logic_vector(BURST_SPACE-1,BURST_Q_WIDTH-1) ) then
		if ( Q_BURST <= BURST_SPACE-1 ) then
			BURST_INH	<= '1';
		else
			BURST_INH 	<= '0';
		end if;

	end process;
	
	process (Q_ECD) begin
--		if ( Q_ECD = CONV_std_logic_vector(ECD_NUMBER,ECD_Q_WIDTH) ) then
		if ( Q_ECD = ECD_NUMBER ) then
			ECD_SYNC <= '1';
		else
			ECD_SYNC <= '0';
		end if;
		
--		if ( Q_ECD = CONV_std_logic_vector(ECD_NUMBER,ECD_Q_WIDTH) ) then
		if ( Q_ECD = ECD_NUMBER ) then
			ECD_INH	<= '1';
		else
			ECD_INH 	<= '0';
		end if;
		
	end process;
	
	INH <= BURST_INH or ECD_INH;
	SYNC <= BURST_SYNC and ECD_SYNC; 

end Behavioral;
