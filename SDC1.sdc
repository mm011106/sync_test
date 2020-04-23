create_clock -name CLK -period 12500 [get_ports {CLK}]
create_generated_clock -name ECDCLK -source [get_ports {CLK}] -divide_by 3 [get_nets {BURST_COUNTER|Q_INT[1]}]