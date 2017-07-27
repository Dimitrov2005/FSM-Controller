class randSeq extends uvm_sequence#(Transaction);
 
   `uvm_object_utils(randSeq)
   Transaction tr;
   int num=32;
   int cnt;

   
   function new(string name ="");
      super.new(name);
  
   endfunction // new

   task body();
      repeat(num)
	begin
	   
	 tr=new("tr");
	   start_item(tr);
	   assert(tr.randomize())
	     else `uvm_fatal("FE","Fatal Error During Randomization");
	   finish_item(tr);	 
	end
      
   endtask // body
   
endclass // randSeq

