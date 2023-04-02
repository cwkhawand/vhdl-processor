library IEEE;
use IEEE.std_logic_1164.all;

entity VECTORED_INTERRUPT_CONTROLLER is
  port (
    Clk      : in std_logic;
    Reset    : in std_logic;
    IRQ_SERV : in std_logic;
    IRQ0     : in std_logic;
    IRQ1     : in std_logic;
    IRQ      : out std_logic;
    VICPC    : out std_logic_vector(31 downto 0)
  );
end VECTORED_INTERRUPT_CONTROLLER;

architecture RTL of VECTORED_INTERRUPT_CONTROLLER is
    signal IRQ0_memo, IRQ1_memo : std_logic;
begin
VICPC <= x"00000009" when IRQ0_memo = '1' else
         x"00000015" when IRQ1_memo = '1' else
         x"00000000";

IRQ <= IRQ0_memo or IRQ1_memo;

sampling: process(Clk, Reset)
    variable IRQ0_before, IRQ1_before : std_logic;
begin
    if (Reset = '1') then
        IRQ0_memo <= '0';
        IRQ1_memo <= '0';
    elsif (rising_edge(Clk)) then
        if (IRQ0_before = '0' and IRQ0 = '1') then
            IRQ0_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQ0_memo <= '0';
        end if;

        if (IRQ1_before = '0' and IRQ1 = '1') then
            IRQ1_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQ1_memo <= '0';
        end if;

        IRQ0_before := IRQ0;
        IRQ1_before := IRQ1;
    end if;
end process;
end RTL;