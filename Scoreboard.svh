class Scoreboard extends uvm_scoreboard;

   `uvm_component_utils(Scoreboard)

     uvm_tlm_analysis_fifo#(Transaction) fifo;
   bit [7:0] cnt;
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
	   else if(tr.x1==1)begin
	      pushFull(tr);
	   `uvm_info("TRWREQ","+++++++ WREQ - %h ++++++", UVM_MEDIUM);	 
	      end
	   else if(tr.RREQ==1) begin
	      `uvm_info("TRRREQ",$sformatf("+++++++ RREQ - %h ++++++",tr.RD),UVM_MEDIUM);
	      popEmpt(tr);
	   end
	   
	end 
   endtask // run 

   function void pushFull(Transaction tr); 
      if((tr.WREQ===1'bx))q.delete();
      if(tr.full==0)
	begin 
	   q.push_front(tr.WD);   
	   $display("------SCB TRANS REC  %h qsize= %d--------",tr.WD,q.size());
	end
     else if((q.size()!=256) ~^ (tr.full))
	begin	  
	   `uvm_warning("SCBF",$sformatf("--FIFO FULL ERROR :: fullFifo %b, Qsize : %d :------",tr.full,q.size()));
	   countm++;
	end
      else 
      // overwrite logic
      if((tr.full)&&(tr.WREQ))
	begin
	   q[(q.size())-1]=(tr.WD);
	   `uvm_warning("SCBOW",$sformatf("--------OVERWRITE, qdatatoadd =%h ------",tr.WD));
	end
   
   endfunction // pushFull

   function void popEmpt(Transaction tr);
       if((tr.RREQ===1'bx))q.delete();
     if((tr.empty)&&(tr.RREQ))
	begin
	   `uvm_warning("SCBRWE","--------READ WHILE EMPTY ERROR ------");
	end
      
      i=q.pop_back(); 
     if(tr.RD!=i)
	begin
	   `uvm_warning("SCBD",$sformatf("--------Data Mismatch fifo:%h q:%h ------",tr.RD, i));
	   countm++;
	end
      else  if((q.size()!=0)&&(tr.empty))
	begin
	   `uvm_warning("SCBE","--------FIFO EMPTY ERROR------");
	   countm++;   
	end
      
   endfunction // popEmpt

   
   function void report_phase(uvm_phase phase);
      $display("total mismatches : %d ",countm);
   endfunction // report_phase
   
   
endclass :Scoreboard