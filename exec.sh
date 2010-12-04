ghdl -a --ieee=synopsys -fexplicit adder.vhd
ghdl -a --ieee=synopsys -fexplicit flopr.vhd
ghdl -a --ieee=synopsys -fexplicit mux2.vhd
ghdl -a --ieee=synopsys -fexplicit signimm.vhd
ghdl -a --ieee=synopsys -fexplicit equal.vhd
ghdl -a --ieee=synopsys -fexplicit rf.vhd
ghdl -a --ieee=synopsys -fexplicit sl2.vhd
ghdl -a --ieee=synopsys -fexplicit maindec.vhd
ghdl -a --ieee=synopsys -fexplicit aludecoder.vhd
ghdl -a --ieee=synopsys -fexplicit controller.vhd
ghdl -a --ieee=synopsys -fexplicit datapath.vhd
ghdl -a --ieee=synopsys -fexplicit tb_datapath.vhd
ghdl -e --ieee=synopsys -fexplicit tb_datapath
ghdl -e --ieee=synopsys -fexplicit tb_datapath
ghdl -r tb_datapath --vcd=datapath.vcd
gtkwave datapath.vcd &