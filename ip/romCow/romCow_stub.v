// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.4 (win64) Build 1071353 Tue Nov 18 18:29:27 MST 2014
// Date        : Tue Oct 27 20:07:46 2015
// Host        : PAX-4 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub C:/Lab4/Lab4.srcs/sources_1/ip/romCow/romCow_stub.v
// Design      : romCow
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.4" *)
module romCow(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[15:0],douta[2:0]" */;
  input clka;
  input [15:0]addra;
  output [2:0]douta;
endmodule
