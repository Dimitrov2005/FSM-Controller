class Monitor extends uvm_monitor;
   `uvm_component_utils(Monitor)

     virtual iface viface;
   uvm_analysis_port # (Transaction) aportMon; // declare analysis port 

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      aportMon=new("aportMon",this); // build analysis port
   endfunction // build_phase

   task run_phase(uvm_phase phase);
      forever
	begin
	   Transaction tr;
	   @(posedge viface.clk)
	     tr=Transaction::type_id::create("tr");
	   tr.x1=viface.x1;
	   tr.x2=viface.x2;
	   tr.cs=viface.cs;
	   //------ end sampling on viface clk ------// 
	   aportMon.write(tr);
	   end

	endtask 
// run_phase
endclass // Monitor