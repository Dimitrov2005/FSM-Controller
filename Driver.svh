class Driver extends uvm_driver #(Transaction);
   
   `uvm_component_utils(Driver)
     virtual iface viface;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction; // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase) ;
     
   endfunction // build_phase

   task run_phase(uvm_phase phase);
       Transaction tr;
      forever
	begin
   
	 //  wait(viface.rst==0);
	   seq_item_port.get_next_item(tr);
	   @(posedge viface.clk)
	       begin   
		  viface.x1<=tr.x1;
		  viface.x2<=tr.x2;
		  viface.cs<=tr.cs;
	       end
	   @(posedge viface.clk)
	     begin
		viface.x1=0;
		viface.x2=0;
		viface.cs<=tr.cs;
	     end
	   
	   seq_item_port.item_done();
	end //
   endtask // run_phase
endclass // Driver
