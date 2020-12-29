
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz/inst/clk_out10]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_axis_cmd_driver/error_counter[0]} {u_axis_cmd_driver/error_counter[1]} {u_axis_cmd_driver/error_counter[2]} {u_axis_cmd_driver/error_counter[3]} {u_axis_cmd_driver/error_counter[4]} {u_axis_cmd_driver/error_counter[5]} {u_axis_cmd_driver/error_counter[6]} {u_axis_cmd_driver/error_counter[7]} {u_axis_cmd_driver/error_counter[8]} {u_axis_cmd_driver/error_counter[9]} {u_axis_cmd_driver/error_counter[10]} {u_axis_cmd_driver/error_counter[11]} {u_axis_cmd_driver/error_counter[12]} {u_axis_cmd_driver/error_counter[13]} {u_axis_cmd_driver/error_counter[14]} {u_axis_cmd_driver/error_counter[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_qspi_sram_ctrl/clk_counter[0]} {u_qspi_sram_ctrl/clk_counter[1]} {u_qspi_sram_ctrl/clk_counter[2]} {u_qspi_sram_ctrl/clk_counter[3]} {u_qspi_sram_ctrl/clk_counter[4]} {u_qspi_sram_ctrl/clk_counter[5]} {u_qspi_sram_ctrl/clk_counter[6]} {u_qspi_sram_ctrl/clk_counter[7]} {u_qspi_sram_ctrl/clk_counter[8]} {u_qspi_sram_ctrl/clk_counter[9]} {u_qspi_sram_ctrl/clk_counter[10]} {u_qspi_sram_ctrl/clk_counter[11]} {u_qspi_sram_ctrl/clk_counter[12]} {u_qspi_sram_ctrl/clk_counter[13]} {u_qspi_sram_ctrl/clk_counter[14]} {u_qspi_sram_ctrl/clk_counter[15]} {u_qspi_sram_ctrl/clk_counter[16]} {u_qspi_sram_ctrl/clk_counter[17]} {u_qspi_sram_ctrl/clk_counter[18]} {u_qspi_sram_ctrl/clk_counter[19]} {u_qspi_sram_ctrl/clk_counter[20]} {u_qspi_sram_ctrl/clk_counter[21]} {u_qspi_sram_ctrl/clk_counter[22]} {u_qspi_sram_ctrl/clk_counter[23]} {u_qspi_sram_ctrl/clk_counter[24]} {u_qspi_sram_ctrl/clk_counter[25]} {u_qspi_sram_ctrl/clk_counter[26]} {u_qspi_sram_ctrl/clk_counter[27]} {u_qspi_sram_ctrl/clk_counter[28]} {u_qspi_sram_ctrl/clk_counter[29]} {u_qspi_sram_ctrl/clk_counter[30]} {u_qspi_sram_ctrl/clk_counter[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_axis_cmd_driver/cmd_address_out[0]} {u_axis_cmd_driver/cmd_address_out[1]} {u_axis_cmd_driver/cmd_address_out[2]} {u_axis_cmd_driver/cmd_address_out[3]} {u_axis_cmd_driver/cmd_address_out[4]} {u_axis_cmd_driver/cmd_address_out[5]} {u_axis_cmd_driver/cmd_address_out[6]} {u_axis_cmd_driver/cmd_address_out[7]} {u_axis_cmd_driver/cmd_address_out[8]} {u_axis_cmd_driver/cmd_address_out[9]} {u_axis_cmd_driver/cmd_address_out[10]} {u_axis_cmd_driver/cmd_address_out[11]} {u_axis_cmd_driver/cmd_address_out[12]} {u_axis_cmd_driver/cmd_address_out[13]} {u_axis_cmd_driver/cmd_address_out[14]} {u_axis_cmd_driver/cmd_address_out[15]} {u_axis_cmd_driver/cmd_address_out[16]} {u_axis_cmd_driver/cmd_address_out[17]} {u_axis_cmd_driver/cmd_address_out[18]} {u_axis_cmd_driver/cmd_address_out[19]} {u_axis_cmd_driver/cmd_address_out[20]} {u_axis_cmd_driver/cmd_address_out[21]} {u_axis_cmd_driver/cmd_address_out[22]} {u_axis_cmd_driver/cmd_address_out[23]} {u_axis_cmd_driver/cmd_address_out[24]} {u_axis_cmd_driver/cmd_address_out[25]} {u_axis_cmd_driver/cmd_address_out[26]} {u_axis_cmd_driver/cmd_address_out[27]} {u_axis_cmd_driver/cmd_address_out[28]} {u_axis_cmd_driver/cmd_address_out[29]} {u_axis_cmd_driver/cmd_address_out[30]} {u_axis_cmd_driver/cmd_address_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_axis_cmd_driver/rom_addr[0]} {u_axis_cmd_driver/rom_addr[1]} {u_axis_cmd_driver/rom_addr[2]} {u_axis_cmd_driver/rom_addr[3]} {u_axis_cmd_driver/rom_addr[4]} {u_axis_cmd_driver/rom_addr[5]} {u_axis_cmd_driver/rom_addr[6]} {u_axis_cmd_driver/rom_addr[7]} {u_axis_cmd_driver/rom_addr[8]} {u_axis_cmd_driver/rom_addr[9]} {u_axis_cmd_driver/rom_addr[10]} {u_axis_cmd_driver/rom_addr[11]} {u_axis_cmd_driver/rom_addr[12]} {u_axis_cmd_driver/rom_addr[13]} {u_axis_cmd_driver/rom_addr[14]} {u_axis_cmd_driver/rom_addr[15]} {u_axis_cmd_driver/rom_addr[16]} {u_axis_cmd_driver/rom_addr[17]} {u_axis_cmd_driver/rom_addr[18]} {u_axis_cmd_driver/rom_addr[19]} {u_axis_cmd_driver/rom_addr[20]} {u_axis_cmd_driver/rom_addr[21]} {u_axis_cmd_driver/rom_addr[22]} {u_axis_cmd_driver/rom_addr[23]} {u_axis_cmd_driver/rom_addr[24]} {u_axis_cmd_driver/rom_addr[25]} {u_axis_cmd_driver/rom_addr[26]} {u_axis_cmd_driver/rom_addr[27]} {u_axis_cmd_driver/rom_addr[28]} {u_axis_cmd_driver/rom_addr[29]} {u_axis_cmd_driver/rom_addr[30]} {u_axis_cmd_driver/rom_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 68 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_axis_cmd_driver/rom_data[0]} {u_axis_cmd_driver/rom_data[1]} {u_axis_cmd_driver/rom_data[2]} {u_axis_cmd_driver/rom_data[3]} {u_axis_cmd_driver/rom_data[4]} {u_axis_cmd_driver/rom_data[5]} {u_axis_cmd_driver/rom_data[6]} {u_axis_cmd_driver/rom_data[7]} {u_axis_cmd_driver/rom_data[8]} {u_axis_cmd_driver/rom_data[9]} {u_axis_cmd_driver/rom_data[10]} {u_axis_cmd_driver/rom_data[11]} {u_axis_cmd_driver/rom_data[12]} {u_axis_cmd_driver/rom_data[13]} {u_axis_cmd_driver/rom_data[14]} {u_axis_cmd_driver/rom_data[15]} {u_axis_cmd_driver/rom_data[16]} {u_axis_cmd_driver/rom_data[17]} {u_axis_cmd_driver/rom_data[18]} {u_axis_cmd_driver/rom_data[19]} {u_axis_cmd_driver/rom_data[20]} {u_axis_cmd_driver/rom_data[21]} {u_axis_cmd_driver/rom_data[22]} {u_axis_cmd_driver/rom_data[23]} {u_axis_cmd_driver/rom_data[24]} {u_axis_cmd_driver/rom_data[25]} {u_axis_cmd_driver/rom_data[26]} {u_axis_cmd_driver/rom_data[27]} {u_axis_cmd_driver/rom_data[28]} {u_axis_cmd_driver/rom_data[29]} {u_axis_cmd_driver/rom_data[30]} {u_axis_cmd_driver/rom_data[31]} {u_axis_cmd_driver/rom_data[32]} {u_axis_cmd_driver/rom_data[33]} {u_axis_cmd_driver/rom_data[34]} {u_axis_cmd_driver/rom_data[35]} {u_axis_cmd_driver/rom_data[36]} {u_axis_cmd_driver/rom_data[37]} {u_axis_cmd_driver/rom_data[38]} {u_axis_cmd_driver/rom_data[39]} {u_axis_cmd_driver/rom_data[40]} {u_axis_cmd_driver/rom_data[41]} {u_axis_cmd_driver/rom_data[42]} {u_axis_cmd_driver/rom_data[43]} {u_axis_cmd_driver/rom_data[44]} {u_axis_cmd_driver/rom_data[45]} {u_axis_cmd_driver/rom_data[46]} {u_axis_cmd_driver/rom_data[47]} {u_axis_cmd_driver/rom_data[48]} {u_axis_cmd_driver/rom_data[49]} {u_axis_cmd_driver/rom_data[50]} {u_axis_cmd_driver/rom_data[51]} {u_axis_cmd_driver/rom_data[52]} {u_axis_cmd_driver/rom_data[53]} {u_axis_cmd_driver/rom_data[54]} {u_axis_cmd_driver/rom_data[55]} {u_axis_cmd_driver/rom_data[56]} {u_axis_cmd_driver/rom_data[57]} {u_axis_cmd_driver/rom_data[58]} {u_axis_cmd_driver/rom_data[59]} {u_axis_cmd_driver/rom_data[60]} {u_axis_cmd_driver/rom_data[61]} {u_axis_cmd_driver/rom_data[62]} {u_axis_cmd_driver/rom_data[63]} {u_axis_cmd_driver/rom_data[64]} {u_axis_cmd_driver/rom_data[65]} {u_axis_cmd_driver/rom_data[66]} {u_axis_cmd_driver/rom_data[67]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 2 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_axis_cmd_driver/state[0]} {u_axis_cmd_driver/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_axis_cmd_driver/cmd_data_out[0]} {u_axis_cmd_driver/cmd_data_out[1]} {u_axis_cmd_driver/cmd_data_out[2]} {u_axis_cmd_driver/cmd_data_out[3]} {u_axis_cmd_driver/cmd_data_out[4]} {u_axis_cmd_driver/cmd_data_out[5]} {u_axis_cmd_driver/cmd_data_out[6]} {u_axis_cmd_driver/cmd_data_out[7]} {u_axis_cmd_driver/cmd_data_out[8]} {u_axis_cmd_driver/cmd_data_out[9]} {u_axis_cmd_driver/cmd_data_out[10]} {u_axis_cmd_driver/cmd_data_out[11]} {u_axis_cmd_driver/cmd_data_out[12]} {u_axis_cmd_driver/cmd_data_out[13]} {u_axis_cmd_driver/cmd_data_out[14]} {u_axis_cmd_driver/cmd_data_out[15]} {u_axis_cmd_driver/cmd_data_out[16]} {u_axis_cmd_driver/cmd_data_out[17]} {u_axis_cmd_driver/cmd_data_out[18]} {u_axis_cmd_driver/cmd_data_out[19]} {u_axis_cmd_driver/cmd_data_out[20]} {u_axis_cmd_driver/cmd_data_out[21]} {u_axis_cmd_driver/cmd_data_out[22]} {u_axis_cmd_driver/cmd_data_out[23]} {u_axis_cmd_driver/cmd_data_out[24]} {u_axis_cmd_driver/cmd_data_out[25]} {u_axis_cmd_driver/cmd_data_out[26]} {u_axis_cmd_driver/cmd_data_out[27]} {u_axis_cmd_driver/cmd_data_out[28]} {u_axis_cmd_driver/cmd_data_out[29]} {u_axis_cmd_driver/cmd_data_out[30]} {u_axis_cmd_driver/cmd_data_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 64 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_qspi_sram_ctrl/data_shifter_out[0]} {u_qspi_sram_ctrl/data_shifter_out[1]} {u_qspi_sram_ctrl/data_shifter_out[2]} {u_qspi_sram_ctrl/data_shifter_out[3]} {u_qspi_sram_ctrl/data_shifter_out[4]} {u_qspi_sram_ctrl/data_shifter_out[5]} {u_qspi_sram_ctrl/data_shifter_out[6]} {u_qspi_sram_ctrl/data_shifter_out[7]} {u_qspi_sram_ctrl/data_shifter_out[8]} {u_qspi_sram_ctrl/data_shifter_out[9]} {u_qspi_sram_ctrl/data_shifter_out[10]} {u_qspi_sram_ctrl/data_shifter_out[11]} {u_qspi_sram_ctrl/data_shifter_out[12]} {u_qspi_sram_ctrl/data_shifter_out[13]} {u_qspi_sram_ctrl/data_shifter_out[14]} {u_qspi_sram_ctrl/data_shifter_out[15]} {u_qspi_sram_ctrl/data_shifter_out[16]} {u_qspi_sram_ctrl/data_shifter_out[17]} {u_qspi_sram_ctrl/data_shifter_out[18]} {u_qspi_sram_ctrl/data_shifter_out[19]} {u_qspi_sram_ctrl/data_shifter_out[20]} {u_qspi_sram_ctrl/data_shifter_out[21]} {u_qspi_sram_ctrl/data_shifter_out[22]} {u_qspi_sram_ctrl/data_shifter_out[23]} {u_qspi_sram_ctrl/data_shifter_out[24]} {u_qspi_sram_ctrl/data_shifter_out[25]} {u_qspi_sram_ctrl/data_shifter_out[26]} {u_qspi_sram_ctrl/data_shifter_out[27]} {u_qspi_sram_ctrl/data_shifter_out[28]} {u_qspi_sram_ctrl/data_shifter_out[29]} {u_qspi_sram_ctrl/data_shifter_out[30]} {u_qspi_sram_ctrl/data_shifter_out[31]} {u_qspi_sram_ctrl/data_shifter_out[32]} {u_qspi_sram_ctrl/data_shifter_out[33]} {u_qspi_sram_ctrl/data_shifter_out[34]} {u_qspi_sram_ctrl/data_shifter_out[35]} {u_qspi_sram_ctrl/data_shifter_out[36]} {u_qspi_sram_ctrl/data_shifter_out[37]} {u_qspi_sram_ctrl/data_shifter_out[38]} {u_qspi_sram_ctrl/data_shifter_out[39]} {u_qspi_sram_ctrl/data_shifter_out[40]} {u_qspi_sram_ctrl/data_shifter_out[41]} {u_qspi_sram_ctrl/data_shifter_out[42]} {u_qspi_sram_ctrl/data_shifter_out[43]} {u_qspi_sram_ctrl/data_shifter_out[44]} {u_qspi_sram_ctrl/data_shifter_out[45]} {u_qspi_sram_ctrl/data_shifter_out[46]} {u_qspi_sram_ctrl/data_shifter_out[47]} {u_qspi_sram_ctrl/data_shifter_out[48]} {u_qspi_sram_ctrl/data_shifter_out[49]} {u_qspi_sram_ctrl/data_shifter_out[50]} {u_qspi_sram_ctrl/data_shifter_out[51]} {u_qspi_sram_ctrl/data_shifter_out[52]} {u_qspi_sram_ctrl/data_shifter_out[53]} {u_qspi_sram_ctrl/data_shifter_out[54]} {u_qspi_sram_ctrl/data_shifter_out[55]} {u_qspi_sram_ctrl/data_shifter_out[56]} {u_qspi_sram_ctrl/data_shifter_out[57]} {u_qspi_sram_ctrl/data_shifter_out[58]} {u_qspi_sram_ctrl/data_shifter_out[59]} {u_qspi_sram_ctrl/data_shifter_out[60]} {u_qspi_sram_ctrl/data_shifter_out[61]} {u_qspi_sram_ctrl/data_shifter_out[62]} {u_qspi_sram_ctrl/data_shifter_out[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {u_qspi_sram_ctrl/io_buf_output_disable[0]} {u_qspi_sram_ctrl/io_buf_output_disable[1]} {u_qspi_sram_ctrl/io_buf_output_disable[2]} {u_qspi_sram_ctrl/io_buf_output_disable[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {u_qspi_sram_ctrl/cmd_wdata_reg[0]} {u_qspi_sram_ctrl/cmd_wdata_reg[1]} {u_qspi_sram_ctrl/cmd_wdata_reg[2]} {u_qspi_sram_ctrl/cmd_wdata_reg[3]} {u_qspi_sram_ctrl/cmd_wdata_reg[4]} {u_qspi_sram_ctrl/cmd_wdata_reg[5]} {u_qspi_sram_ctrl/cmd_wdata_reg[6]} {u_qspi_sram_ctrl/cmd_wdata_reg[7]} {u_qspi_sram_ctrl/cmd_wdata_reg[8]} {u_qspi_sram_ctrl/cmd_wdata_reg[9]} {u_qspi_sram_ctrl/cmd_wdata_reg[10]} {u_qspi_sram_ctrl/cmd_wdata_reg[11]} {u_qspi_sram_ctrl/cmd_wdata_reg[12]} {u_qspi_sram_ctrl/cmd_wdata_reg[13]} {u_qspi_sram_ctrl/cmd_wdata_reg[14]} {u_qspi_sram_ctrl/cmd_wdata_reg[15]} {u_qspi_sram_ctrl/cmd_wdata_reg[16]} {u_qspi_sram_ctrl/cmd_wdata_reg[17]} {u_qspi_sram_ctrl/cmd_wdata_reg[18]} {u_qspi_sram_ctrl/cmd_wdata_reg[19]} {u_qspi_sram_ctrl/cmd_wdata_reg[20]} {u_qspi_sram_ctrl/cmd_wdata_reg[21]} {u_qspi_sram_ctrl/cmd_wdata_reg[22]} {u_qspi_sram_ctrl/cmd_wdata_reg[23]} {u_qspi_sram_ctrl/cmd_wdata_reg[24]} {u_qspi_sram_ctrl/cmd_wdata_reg[25]} {u_qspi_sram_ctrl/cmd_wdata_reg[26]} {u_qspi_sram_ctrl/cmd_wdata_reg[27]} {u_qspi_sram_ctrl/cmd_wdata_reg[28]} {u_qspi_sram_ctrl/cmd_wdata_reg[29]} {u_qspi_sram_ctrl/cmd_wdata_reg[30]} {u_qspi_sram_ctrl/cmd_wdata_reg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {u_qspi_sram_ctrl/serial_out[0]} {u_qspi_sram_ctrl/serial_out[1]} {u_qspi_sram_ctrl/serial_out[2]} {u_qspi_sram_ctrl/serial_out[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {u_qspi_sram_ctrl/state[0]} {u_qspi_sram_ctrl/state[1]} {u_qspi_sram_ctrl/state[2]} {u_qspi_sram_ctrl/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 4 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {u_qspi_sram_ctrl/serial_in[0]} {u_qspi_sram_ctrl/serial_in[1]} {u_qspi_sram_ctrl/serial_in[2]} {u_qspi_sram_ctrl/serial_in[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {u_qspi_sram_ctrl/data_shifter_in[0]} {u_qspi_sram_ctrl/data_shifter_in[1]} {u_qspi_sram_ctrl/data_shifter_in[2]} {u_qspi_sram_ctrl/data_shifter_in[3]} {u_qspi_sram_ctrl/data_shifter_in[4]} {u_qspi_sram_ctrl/data_shifter_in[5]} {u_qspi_sram_ctrl/data_shifter_in[6]} {u_qspi_sram_ctrl/data_shifter_in[7]} {u_qspi_sram_ctrl/data_shifter_in[8]} {u_qspi_sram_ctrl/data_shifter_in[9]} {u_qspi_sram_ctrl/data_shifter_in[10]} {u_qspi_sram_ctrl/data_shifter_in[11]} {u_qspi_sram_ctrl/data_shifter_in[12]} {u_qspi_sram_ctrl/data_shifter_in[13]} {u_qspi_sram_ctrl/data_shifter_in[14]} {u_qspi_sram_ctrl/data_shifter_in[15]} {u_qspi_sram_ctrl/data_shifter_in[16]} {u_qspi_sram_ctrl/data_shifter_in[17]} {u_qspi_sram_ctrl/data_shifter_in[18]} {u_qspi_sram_ctrl/data_shifter_in[19]} {u_qspi_sram_ctrl/data_shifter_in[20]} {u_qspi_sram_ctrl/data_shifter_in[21]} {u_qspi_sram_ctrl/data_shifter_in[22]} {u_qspi_sram_ctrl/data_shifter_in[23]} {u_qspi_sram_ctrl/data_shifter_in[24]} {u_qspi_sram_ctrl/data_shifter_in[25]} {u_qspi_sram_ctrl/data_shifter_in[26]} {u_qspi_sram_ctrl/data_shifter_in[27]} {u_qspi_sram_ctrl/data_shifter_in[28]} {u_qspi_sram_ctrl/data_shifter_in[29]} {u_qspi_sram_ctrl/data_shifter_in[30]} {u_qspi_sram_ctrl/data_shifter_in[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {u_qspi_sram_ctrl/rsp_rdata_out[0]} {u_qspi_sram_ctrl/rsp_rdata_out[1]} {u_qspi_sram_ctrl/rsp_rdata_out[2]} {u_qspi_sram_ctrl/rsp_rdata_out[3]} {u_qspi_sram_ctrl/rsp_rdata_out[4]} {u_qspi_sram_ctrl/rsp_rdata_out[5]} {u_qspi_sram_ctrl/rsp_rdata_out[6]} {u_qspi_sram_ctrl/rsp_rdata_out[7]} {u_qspi_sram_ctrl/rsp_rdata_out[8]} {u_qspi_sram_ctrl/rsp_rdata_out[9]} {u_qspi_sram_ctrl/rsp_rdata_out[10]} {u_qspi_sram_ctrl/rsp_rdata_out[11]} {u_qspi_sram_ctrl/rsp_rdata_out[12]} {u_qspi_sram_ctrl/rsp_rdata_out[13]} {u_qspi_sram_ctrl/rsp_rdata_out[14]} {u_qspi_sram_ctrl/rsp_rdata_out[15]} {u_qspi_sram_ctrl/rsp_rdata_out[16]} {u_qspi_sram_ctrl/rsp_rdata_out[17]} {u_qspi_sram_ctrl/rsp_rdata_out[18]} {u_qspi_sram_ctrl/rsp_rdata_out[19]} {u_qspi_sram_ctrl/rsp_rdata_out[20]} {u_qspi_sram_ctrl/rsp_rdata_out[21]} {u_qspi_sram_ctrl/rsp_rdata_out[22]} {u_qspi_sram_ctrl/rsp_rdata_out[23]} {u_qspi_sram_ctrl/rsp_rdata_out[24]} {u_qspi_sram_ctrl/rsp_rdata_out[25]} {u_qspi_sram_ctrl/rsp_rdata_out[26]} {u_qspi_sram_ctrl/rsp_rdata_out[27]} {u_qspi_sram_ctrl/rsp_rdata_out[28]} {u_qspi_sram_ctrl/rsp_rdata_out[29]} {u_qspi_sram_ctrl/rsp_rdata_out[30]} {u_qspi_sram_ctrl/rsp_rdata_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 17 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {u_qspi_sram_ctrl/cmd_address_reg[0]} {u_qspi_sram_ctrl/cmd_address_reg[1]} {u_qspi_sram_ctrl/cmd_address_reg[2]} {u_qspi_sram_ctrl/cmd_address_reg[3]} {u_qspi_sram_ctrl/cmd_address_reg[4]} {u_qspi_sram_ctrl/cmd_address_reg[5]} {u_qspi_sram_ctrl/cmd_address_reg[6]} {u_qspi_sram_ctrl/cmd_address_reg[7]} {u_qspi_sram_ctrl/cmd_address_reg[8]} {u_qspi_sram_ctrl/cmd_address_reg[9]} {u_qspi_sram_ctrl/cmd_address_reg[10]} {u_qspi_sram_ctrl/cmd_address_reg[11]} {u_qspi_sram_ctrl/cmd_address_reg[12]} {u_qspi_sram_ctrl/cmd_address_reg[13]} {u_qspi_sram_ctrl/cmd_address_reg[14]} {u_qspi_sram_ctrl/cmd_address_reg[15]} {u_qspi_sram_ctrl/cmd_address_reg[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list u_axis_cmd_driver/all_cmds_done_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list u_axis_cmd_driver/cmd_ready_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list u_axis_cmd_driver/cmd_rw_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list u_qspi_sram_ctrl/cmd_rw_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list u_axis_cmd_driver/cmd_valid_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list u_qspi_sram_ctrl/CS_N]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_axis_cmd_driver/rom_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_axis_cmd_driver/rsp_ready_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list u_qspi_sram_ctrl/rsp_valid_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list u_qspi_sram_ctrl/SCK_EN]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list sys_reset]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets spi_clk]
