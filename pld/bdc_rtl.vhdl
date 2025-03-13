library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bdc_timing is
port (
    clk_20mhz     : in  std_logic;
    reset         : in  std_logic;
    hsync_n       : out std_logic;
    vsync_n       : out std_logic;
    display_enable: out std_logic
);
end bdc_timing;

architecture rtl of bdc_timing is
    -- Clock divider signals
    signal clk_div   : unsigned(2 downto 0);
    signal pixel_clk : std_logic;
    
    -- Counter signals
    signal h_count   : unsigned(6 downto 0);
    signal v_count   : unsigned(9 downto 0);
    
    -- Timing constants (divided by 8)
    constant H_DISPLAY : integer := 100;  -- 800/8
    constant H_FRONT  : integer := 5;     -- 40/8
    constant H_SYNC   : integer := 16;    -- 128/8
    constant H_BACK   : integer := 11;    -- 88/8
    constant H_TOTAL  : integer := 132;   -- 1056/8
    
    constant V_DISPLAY : integer := 512;
    constant V_FRONT   : integer := 1;
    constant V_SYNC    : integer := 3;
    constant V_BACK    : integer := 28;
    constant V_TOTAL   : integer := 544;

begin
    -- Clock divider process
    process(clk_20mhz, reset)
    begin
        if reset = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(clk_20mhz) then
            clk_div <= clk_div + 1;
        end if;
    end process;
    
    pixel_clk <= clk_div(2);  -- Divide by 8
    
    -- Horizontal counter
    process(pixel_clk, reset)
    begin
        if reset = '1' then
            h_count <= (others => '0');
        elsif rising_edge(pixel_clk) then
            if h_count = H_TOTAL - 1 then
                h_count <= (others => '0');
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;
    
    -- Vertical counter
    process(pixel_clk, reset)
    begin
        if reset = '1' then
            v_count <= (others => '0');
        elsif rising_edge(pixel_clk) then
            if h_count = H_TOTAL - 1 then
                if v_count = V_TOTAL - 1 then
                    v_count <= (others => '0');
                else
                    v_count <= v_count + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- Generate sync and enable signals
    hsync_n <= '0' when (h_count >= H_DISPLAY + H_FRONT) and 
                        (h_count < H_DISPLAY + H_FRONT + H_SYNC) else '1';
                        
    vsync_n <= '0' when (v_count >= V_DISPLAY + V_FRONT) and
                        (v_count < V_DISPLAY + V_FRONT + V_SYNC) else '1';
                        
    display_enable <= '1' when (h_count < H_DISPLAY) and 
                               (v_count < V_DISPLAY) else '0';

end rtl;
