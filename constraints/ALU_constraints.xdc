## This file is a general .xdc for the Nexys4 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

set_property PACKAGE_PIN E3 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name clk -period 10.00 -waveform {0 5} [get_ports clk]
	
##USB HID (PS/2)
##Bank = 35, Pin name = IO_L13P_T2_MRCC_35,					Sch name = PS2_CLK
set_property PACKAGE_PIN F4 [get_ports kb_clk]						
	set_property IOSTANDARD LVCMOS33 [get_ports kb_clk]
	set_property PULLUP true [get_ports kb_clk]
###Bank = 35, Pin name = IO_L10N_T1_AD15N_35,				Sch name = PS2_DATA
set_property PACKAGE_PIN B2 [get_ports kb_data]					
	set_property IOSTANDARD LVCMOS33 [get_ports kb_data]	
	set_property PULLUP true [get_ports kb_data]

#Bank = 34, Pin name = IO_L11N_T1_SRCC_15,						Sch name = btnC
set_property PACKAGE_PIN E16 [get_ports {BTNC}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {BTNC}]

#Bank = 34, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,			Sch name = btnL
set_property PACKAGE_PIN T16 [get_ports {BTNL }]					
	set_property IOSTANDARD LVCMOS33 [get_ports {BTNL}]	
	
##VGA connections
set_property PACKAGE_PIN A3 [get_ports {rgb_out[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[11]}]	
set_property PACKAGE_PIN B4 [get_ports {rgb_out[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[10]}]
set_property PACKAGE_PIN C5 [get_ports {rgb_out[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[9]}]
set_property PACKAGE_PIN A4 [get_ports {rgb_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[8]}]

set_property PACKAGE_PIN C6 [get_ports {rgb_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[7]}]	
set_property PACKAGE_PIN A5 [get_ports {rgb_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[6]}]
set_property PACKAGE_PIN B6 [get_ports {rgb_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[5]}]
set_property PACKAGE_PIN A6 [get_ports {rgb_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[4]}]

set_property PACKAGE_PIN B7 [get_ports {rgb_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[3]}]	
set_property PACKAGE_PIN C7 [get_ports {rgb_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[2]}]
set_property PACKAGE_PIN D7 [get_ports {rgb_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[1]}]
set_property PACKAGE_PIN D8 [get_ports {rgb_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_out[0]}]

#HSYNC and VSYNC
set_property PACKAGE_PIN B11 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]
set_property PACKAGE_PIN B12 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
	
set_property PACKAGE_PIN P4 [get_ports {reset}]
        set_property IOSTANDARD LVCMOS33 [get_ports {reset}]	


set_property CFGBVS Vcco [current_design]
        set_property config_voltage 3.3 [current_design]