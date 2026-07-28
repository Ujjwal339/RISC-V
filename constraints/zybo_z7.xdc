set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];


set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #Sch=btn[0]


set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #Sch=led[0]
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #Sch=led[1]
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #Sch=led[2]
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #Sch=led[3]


set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { led6_r }]; #Sch=led6_r
set_property -dict { PACKAGE_PIN F17 IOSTANDARD LVCMOS33 } [get_ports { led6_g }]; #Sch=led6_g
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { led6_b }]; #Sch=led6_b
