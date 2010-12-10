rm *.o
rm work-obj93.cf
rm tb_datapath
rm datapath.vcd
rm tb_controle
rm controle.vcd
ghdl -a --ieee=synopsys -fexplicit alu.vhd
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
ghdl -a --ieee=synopsys -fexplicit mips.vhd
ghdl -a --ieee=synopsys -fexplicit tb_controle.vhd
ghdl -e --ieee=synopsys -fexplicit tb_controle
ghdl -e --ieee=synopsys -fexplicit tb_controle
ghdl -r tb_controle --vcd=controle.vcd
gtkwave controle.vcd &
