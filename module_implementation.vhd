----------------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineer: Federica Bucchieri e Rei Barjami
-- 
-- Create Date: 03/04/2020 10:19:07 AM
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: project_reti_logiche
-- Target Devices: 
-- Tool Versions: 
-- Description: progetto di Reti logiche a.s. 2019/2020
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR (7 downto 0));
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component DataPath is
    Port(
    i_clk : in STD_LOGIC;
    i_res : in STD_LOGIC; 
    wz_num: in STD_LOGIC_VECTOR (2 downto 0);
    i_data : in STD_LOGIC_VECTOR (7 downto 0);
    o_data : out STD_LOGIC_VECTOR (7 downto 0);     
    RegAddr_load: in STD_LOGIC;
    RegTemp_load: in STD_LOGIC;
    wz_bit : inout STD_LOGIC   
    );   
end component;
-- signals
signal RegAddr_load : STD_LOGIC;
signal RegTemp_load : STD_LOGIC; 
signal WZ_NUM : STD_LOGIC_VECTOR (2 downto 0);
signal WZ_BIT : STD_LOGIC;
type S is (S0, S1, S2, addressInitializing,addressSetting,set1,c1,set2,c2,set3,c3,set4,c4,set5,c5,set6,c6,set7,c7,set8,c8,writeSetting,finalState,waitState,waitingResp); 
signal cur_state, next_state,Ts : S;
signal bo: STD_LOGIC;

begin
    DATAPATH0: DataPath port map (
        i_clk,
        i_rst,
        WZ_NUM, 
        i_data,
        o_data,
        RegAddr_load,
        RegTemp_load,
        WZ_BIT
    );

    -- processo per il restart 
    process (i_clk, i_rst)
    begin
        if( i_rst = '1') then 
            cur_state <= S0;
       elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state; 
       end if; 
   end process; 
   
   -- processo per la definizione del passaggio da uno stato all'altro
   process (cur_state, i_start, WZ_BIT) 
   begin
        next_state <= cur_state; 
        case cur_state is
            when waitingResp=>
                 next_state <=Ts;
            when WaitState=>
                 next_state <=waitingResp;
            when S0 =>
                if i_start = '1' then
                  next_state<=s1;
                end if;
            when S1 => 
                next_state<=s2;
            when S2 =>
                 next_state<=addressSetting;
            when addressSetting=>
                next_state<=addressInitializing;
            when addressInitializing =>
                next_state<=set1;
            when set1 =>
                 ts<=c1;
                 next_state<=waitState;
            when c1 =>
                 if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set2;
                 end if;
            when set2 =>
                 ts<=c2;
                 next_state<=waitState;    
            when c2 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set3;
                 end if;
                 
            when set3 =>
                 ts<=c3;
                 next_state<=waitState;    
            when c3 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set4;
                 end if;
                 
           when set4 =>
                 ts<=c4;
                 next_state<=waitState;    
            when c4 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set5;
                 end if;
                 
            when set5 =>
                 ts<=c5;
                 next_state<=waitState;    
            when c5 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set6;
                 end if;
                 
            when set6 =>
                 ts<=c6;
                 next_state<=waitState;    
            when c6 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set7;
                 end if;
                 
            when set7 =>
                 ts<=c7;
                 next_state<=waitState;    
            when c7 =>
                if wz_bit='1' then
                    next_state<=writeSetting;
                 else
                    next_state<=set8;
                 end if;
                 
            when set8 =>
                 ts<=c8;
                 next_state<=waitState;    
            when c8 =>
                    next_state<=writeSetting;
                    
            when writeSetting=>
                 next_state<=finalState;
            when finalState=>
                 if(i_start='0') then
                    next_state<=s0;
                 end if;
        end case;
    end process;     
    
    -- gestione segnali 
    process(cur_state)
    begin
        RegAddr_load <= '0';
        RegTemp_load <= '0';
        o_we <= '0';
        
        case cur_state is
            when S0 => 
                o_done <= '0';
                o_en <= '0';
                o_we<='0';
                RegAddr_load <= '0';
                RegTemp_load <= '0';
            when S1 =>
                o_en<='1';
                o_we<='0';
                o_done<='0';
                RegAddr_load <= '0';
                RegTemp_load <= '0';
            when S2 =>
               o_address<="0000000000001000";
               o_en<='1';
               o_we<='0';
               o_done<='0';
               RegAddr_load <= '0';
               RegTemp_load <= '0';
            when addressSetting=>
               o_done<='0';
               RegAddr_load <= '1';
               RegTemp_load <= '0';
            when addressInitializing =>
                o_done<='0';
                RegAddr_load<='1';
                RegTemp_load<='0';
            when set1 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000000"; 
                wz_num<="000";         
            when c1 =>
                o_done<='0';
                wz_num<="000"; 
                RegTemp_load<='1';  
            when set2 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000001"; 
                wz_num<="001"; 
            when c2 =>
                o_done<='0';
                wz_num<="001"; 
                RegTemp_load<='1';  
            when set3 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000010"; 
                wz_num<="010"; 
            when c3 =>
                o_done<='0';
                wz_num<="010"; 
                RegTemp_load<='1';
            when set4 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000011"; 
                wz_num<="011"; 
            when c4 =>
                o_done<='0';
                wz_num<="011";
                RegTemp_load<='1';
                
             when set5 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000100"; 
                wz_num<="100"; 
            when c5 =>
                o_done<='0';
                wz_num<="100";
                RegTemp_load<='1';
                
             when set6 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000101"; 
                wz_num<="011"; 
            when c6 =>
                o_done<='0';
                wz_num<="101";
                RegTemp_load<='1';
                
            when set7 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000110"; 
                wz_num<="110"; 
            when c7 =>
                o_done<='0';
                wz_num<="110";
                RegTemp_load<='1';
                
             when set8 =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';  
                o_address<="0000000000000111"; 
                wz_num<="111"; 
            when c8 =>
                o_done<='0';
                wz_num<="111";
                RegTemp_load<='1';
            --when S8 =>
                    
            --when S9 =>
               
            --when S10 =>
                
            --when S11 =>
                
            --when S12 => 
            
            when writeSetting=>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='0';
                o_address<="0000000000001001";
                o_en<='1';
                o_we<='1';
            when finalState=>
                RegAddr_load<='0';
                RegTemp_load<='0';
                o_address<="0000000000001001";
                o_en<='1';
                o_we<='1';
                o_done<='1';
            when WaitState =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='1'; 
            when WaitingResp =>
                o_done<='0';
                RegAddr_load<='0';
                RegTemp_load<='1'; 
           
        end case;
    end process;                
                                            
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataPath is
    Port(
    i_clk : in STD_LOGIC;
    i_res : in STD_LOGIC; 
    wz_num: in STD_LOGIC_VECTOR (2 downto 0);
    i_data : in STD_LOGIC_VECTOR (7 downto 0);
    o_data : out STD_LOGIC_VECTOR (7 downto 0);     
    RegAddr_load: in STD_LOGIC;
    RegTemp_load: in STD_LOGIC;
    wz_bit : inout STD_LOGIC   
    );
    
end DataPath;

architecture Behavioral of DataPath is
    signal RegAddr : STD_LOGIC_VECTOR (7 downto 0); 
    signal RegTemp: STD_LOGIC_VECTOR (7 downto 0);
    signal sub: STD_LOGIC_VECTOR (7 downto 0);
    signal wz_offset: STD_LOGIC_VECTOR (3 downto 0);
    signal concat: STD_LOGIC_VECTOR ( 7 downto 0);
    
begin
    RegAddr(7)<='0';
    RegTemp(7)<='0';
-- caricamento registro address
    process(i_clk, i_res)
    begin
        if(i_res = '1') then
            RegAddr <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(RegAddr_load = '1') then
                RegAddr(6 downto 0) <= i_data(6 downto 0);
            end if;
        end if;
    end process; 

-- caricamento registro temporaneo    
    process(i_clk, i_res)
    begin
        if(i_res = '1') then
            RegTemp <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(RegTemp_load = '1') then
                RegTemp(6 downto 0) <= i_data(6 downto 0);
                
                if( sub="00000000" or sub ="00000001" or sub ="00000010" or sub="00000011") then
                    wz_bit<='1';
                else
                    wz_bit<='0';
                end if;
            end if;
        end if;
    end process; 
    
-- sottrazione 
    sub<=RegAddr-RegTemp;
-- confronto e minore di 4
-- decoder   
    with sub select
        wz_offset<= "0001" when "00000000",
                    "0010" when "00000001",
                    "0100" when "00000010",
                    "1000" when "00000011",
                    "0000" when others;
--concatenazione    
    concat<=wz_bit&wz_num&wz_offset;
    
    with wz_bit select
        o_data<= concat when '1',
                 RegAddr when '0',
                 "XXXXXXXX" when others;
                 
end Behavioral;
