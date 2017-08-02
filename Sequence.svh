class Sequence extends uvm_sequence#(Transaction);
   `uvm_object_utils(Sequence)

     Transaction tr;
     typedef enum int {IN=0,INRET=1,OUT=2,OUTRET=3} state;
      byte cntIn=0,cntOut=0;
      bit  s1=1,s2=0,e,f;
      int  num =1;
     rand state state_h;
      function new(string name ="");
	 super.new(name);
      endfunction // new
      
      task body();  
	 repeat(num) 
	   begin	
         tr=new("");	 
	 start_item(tr);
	 case (state_h)
	   0:	 
	     if(s1) 
	       begin
		  assert(tr.randomize() with {tr.x1==1;
					      tr.x2==0;})
		    else
		      `uvm_error("IN","IN error during randomization");
                     s1=0;
                     s2=1;
                 end
	   
	     else if(s2)
	       begin
		  assert(tr.randomize() with {tr.x1==0;
					      tr.x2==1;})	   
			 else
			 `uvm_error("IN2","IN2 error during randomization");
			 s2=0;
			 s1=1;
                         cntIn++;
	       end
	     
			 
	        1: if(s1)
		  begin
			 assert(tr.randomize() with {tr.x1==1;
						     tr.x2==0;})
			 else
			   `uvm_error("INRET","INRET error during randomization");
                  end
	   
	        2:
			 if(s1) 
			 begin
			 assert(tr.randomize() with {tr.x1==0;
						     tr.x2==1;})
			 else
			 `uvm_error("OUT","OUT error during randomization");
			 s1=0;
			 s2=1;
			 end
			 
			 else if(s2)
			 begin
			 assert(tr.randomize() with {tr.x1==1;
						     tr.x2==0;})
			 else
			 `uvm_error("OUt2","OUT2 error during randomization");
			 s2=0;
			 s1=1;
                         cntOut++;
			 end
			 
			 
	   3: if(s2) begin
			 assert(tr.randomize() with {tr.x1==0;
						     tr.x2==1;})
			 else
			 `uvm_error("OUTRET","OUTRET error during randomization");
		     end
			 endcase // case (state)
	     // if(cntIn<255) f=1; else f=0;
	      if(cntOut>=255) e=1; else e=0;
			 finish_item(tr);
	 end // repeat (num)
			 
	 endtask // body
			 
endclass // Sequence
			 