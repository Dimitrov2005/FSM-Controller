module top;
  import uvm_pkg::*; 
`include "uvm_macros.svh"
   import pack::*;
   bit clk,rst;
   iface iface1(clk,rst);
   virtual iface viface=iface1;

   
   lamp DUT(.cs(iface1.cs),
	    .x1(iface1.x1),
	    .x2(iface1.x2),
	    .rst(iface1.rst),
	    .clk(iface1.clk)
	    );
   initial
     begin
	clk=0;
	rst=0;
	#1ps rst=1;
	#2ps rst=0;
	
     end
  
 always #5ps clk=~clk;

   initial 
     begin
	uvm_config_db #(virtual iface)::set  (null,"","viface",viface);
       // run_test("testF");
	run_test("my_test");
     end

   
endmodule:top // top
