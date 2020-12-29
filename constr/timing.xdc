
## Common Timing Constraints (indepedent of spi_clk frequency
create_generated_clock -name SCK -source [get_pins u_qspi_sram_ctrl/clk_output_buffer/C] -divide_by 1 -invert [get_ports SCK]
set_output_delay -clock [get_clocks SCK] -fall -min -add_delay -49.270 [get_ports CS_N]
set_output_delay -clock [get_clocks SCK] -fall -max -add_delay 25.870 [get_ports CS_N]
set_output_delay -clock [get_clocks SCK] -min -add_delay -9.270 [get_ports HOLD_N_SIO3]
set_output_delay -clock [get_clocks SCK] -max -add_delay 10.870 [get_ports HOLD_N_SIO3]
set_output_delay -clock [get_clocks SCK] -min -add_delay -9.270 [get_ports SIO2]
set_output_delay -clock [get_clocks SCK] -max -add_delay 10.870 [get_ports SIO2]
set_output_delay -clock [get_clocks SCK] -min -add_delay -9.270 [get_ports SI_SIO0]
set_output_delay -clock [get_clocks SCK] -max -add_delay 10.870 [get_ports SI_SIO0]
set_output_delay -clock [get_clocks SCK] -min -add_delay -9.270 [get_ports SO_SIO1]
set_output_delay -clock [get_clocks SCK] -max -add_delay 10.870 [get_ports SO_SIO1]


## 20 MHz SPI Clock (Hardware Tested, Rated FMax for 23LC1024, needs timing waivers)

#create_clock -period 50.000 -name VIRTUAL_clk_out20_clk_wiz_0 -waveform {0.000 25.000}
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -min -add_delay 50.730 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -max -add_delay 50.870 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -min -add_delay 50.730 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -max -add_delay 50.870 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -min -add_delay 50.730 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -max -add_delay 50.870 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -min -add_delay 50.730 [get_ports SO_SIO1]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out20_clk_wiz_0] -max -add_delay 50.870 [get_ports SO_SIO1]


## 10 MHz SPI Clock (Hardware Tested, passes timing)
#create_clock -period 100.000 -name VIRTUAL_clk_out10_clk_wiz_0 -waveform {0.000 50.000}
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -min -add_delay 75.730 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -max -add_delay 75.870 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -min -add_delay 75.730 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -max -add_delay 75.870 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -min -add_delay 75.730 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -max -add_delay 75.870 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -min -add_delay 75.730 [get_ports SO_SIO1]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out10_clk_wiz_0] -max -add_delay 75.870 [get_ports SO_SIO1]


## 15 MHz SPI Clock (Hardware Tested, passes timing)
#create_clock -period 66.667 -name VIRTUAL_clk_out15_clk_wiz_0 -waveform {0.000 33.333}
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -min -add_delay 58.730 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -max -add_delay 58.870 [get_ports HOLD_N_SIO3]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -min -add_delay 58.730 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -max -add_delay 58.870 [get_ports SIO2]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -min -add_delay 58.730 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -max -add_delay 58.870 [get_ports SI_SIO0]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -min -add_delay 58.730 [get_ports SO_SIO1]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out15_clk_wiz_0] -max -add_delay 58.870 [get_ports SO_SIO1]


## 22MHz SPI Clock (Hardware Tested, needs timing waivers)
create_clock -period 45.455 -name VIRTUAL_clk_out22_clk_wiz_0 -waveform {0.000 22.727}
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -min -add_delay 48.460 [get_ports HOLD_N_SIO3]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -max -add_delay 48.600 [get_ports HOLD_N_SIO3]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -min -add_delay 48.460 [get_ports SIO2]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -max -add_delay 48.600 [get_ports SIO2]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -min -add_delay 48.460 [get_ports SI_SIO0]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -max -add_delay 48.600 [get_ports SI_SIO0]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -min -add_delay 48.460 [get_ports SO_SIO1]
set_input_delay -clock [get_clocks VIRTUAL_clk_out22_clk_wiz_0] -max -add_delay 48.600 [get_ports SO_SIO1]
