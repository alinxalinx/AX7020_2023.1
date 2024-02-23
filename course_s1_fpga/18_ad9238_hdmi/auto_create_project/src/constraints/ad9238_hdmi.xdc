############## clock and reset define##################
create_clock -period 20 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]
set_property PACKAGE_PIN U18 [get_ports {sys_clk}]

set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]
set_property PACKAGE_PIN N15 [get_ports {rst_n}]
############## HDMI_O###########################
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_n]
set_property PACKAGE_PIN N18 [get_ports TMDS_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[0]}]
set_property PACKAGE_PIN V20 [get_ports {TMDS_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[1]}]
set_property PACKAGE_PIN T20 [get_ports {TMDS_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[2]}]
set_property PACKAGE_PIN N20 [get_ports {TMDS_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[2]}]
set_property PACKAGE_PIN V16 [get_ports hdmi_oen]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_oen]

##############AX7020 and AX7010  J11##################
set_property PACKAGE_PIN F17 [get_ports  ad9238_clk_ch1]
set_property PACKAGE_PIN F16 [get_ports {ad9238_data_ch1[0]}]
set_property PACKAGE_PIN F20 [get_ports {ad9238_data_ch1[1]}]
set_property PACKAGE_PIN F19 [get_ports {ad9238_data_ch1[2]}]
set_property PACKAGE_PIN G20 [get_ports {ad9238_data_ch1[3]}]
set_property PACKAGE_PIN G19 [get_ports {ad9238_data_ch1[4]}]
set_property PACKAGE_PIN H18 [get_ports {ad9238_data_ch1[5]}]
set_property PACKAGE_PIN J18 [get_ports {ad9238_data_ch1[6]}]
set_property PACKAGE_PIN L20 [get_ports {ad9238_data_ch1[7]}]
set_property PACKAGE_PIN L19 [get_ports {ad9238_data_ch1[8]}]
set_property PACKAGE_PIN M20 [get_ports {ad9238_data_ch1[9]}]
set_property PACKAGE_PIN M19 [get_ports {ad9238_data_ch1[10]}]
set_property PACKAGE_PIN K18 [get_ports {ad9238_data_ch1[11]}]


set_property PACKAGE_PIN H17 [get_ports  ad9238_clk_ch0]
set_property PACKAGE_PIN H20 [get_ports {ad9238_data_ch0[1]}]
set_property PACKAGE_PIN J20 [get_ports {ad9238_data_ch0[0]}]
set_property PACKAGE_PIN L17 [get_ports {ad9238_data_ch0[3]}]
set_property PACKAGE_PIN L16 [get_ports {ad9238_data_ch0[2]}]
set_property PACKAGE_PIN M18 [get_ports {ad9238_data_ch0[5]}]
set_property PACKAGE_PIN M17 [get_ports {ad9238_data_ch0[4]}]
set_property PACKAGE_PIN D20 [get_ports {ad9238_data_ch0[7]}]
set_property PACKAGE_PIN D19 [get_ports {ad9238_data_ch0[6]}]
set_property PACKAGE_PIN E19 [get_ports {ad9238_data_ch0[9]}]
set_property PACKAGE_PIN E18 [get_ports {ad9238_data_ch0[8]}]
set_property PACKAGE_PIN G18 [get_ports {ad9238_data_ch0[11]}]
set_property PACKAGE_PIN G17 [get_ports {ad9238_data_ch0[10]}]



set_property IOSTANDARD LVCMOS33 [get_ports ad9238_clk_ch0]
set_property IOSTANDARD LVCMOS33 [get_ports {ad9238_data_ch0[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports ad9238_clk_ch1]
set_property IOSTANDARD LVCMOS33 [get_ports {ad9238_data_ch1[*]}]

set_property IOB true [get_ports ad9238_data_ch1[*]]
set_property IOB true [get_ports ad9238_data_ch0[*]]