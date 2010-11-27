ghdl -a --ieee=synopsys -fexplicit adder.vhd
ghdl -a --ieee=synopsys -fexplicit flopr.vhd
ghdl -a --ieee=synopsys -fexplicit mux2.vhd
ghdl -a --ieee=synopsys -fexplicit datapath.vhd
ghdl -a --ieee=synopsys -fexplicit tb_datapath.vhd
ghdl -e --ieee=synopsys -fexplicit tb_datapath
ghdl -r tb_datapath --vcd=datapath.vcd
gtkwave datapath.vcd &
