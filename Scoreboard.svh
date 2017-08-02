class Scoreboard extends uvm_scoreboard;

   `uvm_component_utils(Scoreboard)

     uvm_tlm_analysis_fifo#(Transaction) fifo;
   byte cnt=0;
   Transaction tr;
   int 	mism=0;
   static bit [2:0] curSt, nSt=1;
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
	   $display("TRANSACTION x1 %b x2 %b", tr.x1, tr.x2);
	   check_fsm(tr.x1,tr.x2);
	end 
   endtask // run 

   function void check_fsm(bit x1, bit x2);
      parameter s1=1,
		  s2=2,
      		  s3=4;
      case(nSt)
	s1 :
	  if(x1)
	    begin
	    nSt=s2;
	`uvm_info("S1->S2",$sformatf("TRANSITION, nst = %d",nSt),UVM_NONE);
	       end
	  else if(x2)
	    begin
	    nSt=s3;	`uvm_info("S1->S3",$sformatf("TRANSITION, nst=%d",nSt),UVM_NONE);
	    end
	
	  else nSt=s1;

	s2:
	  if(x1)
	    begin
	       nSt=s1; 	`uvm_info("S2->S1","TRANSITION",UVM_NONE);
	    end
	
	  else if(x2)
	    begin
	 
	       nSt=s1;	
	       `uvm_info("S2->S1+cnt","TRANSITION",UVM_NONE);
	       cnt = (cnt==255 ? cnt:cnt++);
	    end
	  else nSt=s2;
      
	s3:
	  if(x2)begin
	     nSt=s1;
	     `uvm_info("S3->S1","TRANSITION",UVM_NONE);
	     end
	  else if(x1) 
	    begin
	       nSt=s1; 
	       `uvm_info ("S3->S1-cnt","TRANSITION",UVM_NONE); 
	       cnt=(cnt==0?cnt:cnt--);
	    end
	  else nSt=s3;
	default:nSt=s1;
      endcase // case (curSt)
	
      if((!tr.cs)&&cnt)
	`uvm_warning("SCBCS",$sformatf("---- CS = %b , Cnt = %d",tr.cs,cnt));
      
      
endfunction // check_fsm
   

   
   function void report_phase(uvm_phase phase);
      $display("total electricity wasted : %d ",mism);
   endfunction // report_phase
   
   
endclass :Scoreboard