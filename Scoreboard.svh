class Scoreboard extends uvm_scoreboard;

   `uvm_component_utils(Scoreboard)

     uvm_tlm_analysis_fifo#(Transaction) fifo;
   byte cnt;
   Transaction tr;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      fifo=new("fifo",this);
   endfunction // build_phase

   
   task run();
      forever 
	begin
	   tr=new("tr");
	   fifo.get(tr);
	   check_fsm(tr.x1,tr.x2)
	end 
   endtask // run 

   function void check_fsm(bit x1, bit x2);
      bit s1=1,s2=0,s3=0;
      if(x1)
	begin
	   s1=0;
	   s2=1;
	   s3=0;
	end
      else  if(x2)
	begin
	   s1=0;s2=
	end
      
      
endfunction // check_fsm
   

   
   function void report_phase(uvm_phase phase);
      $display("total mismatches : %d ",countm);
   endfunction // report_phase
   
   
endclass :Scoreboard