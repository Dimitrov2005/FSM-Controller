class personOut extends uvm_sequence#(Transaction);
   `uvm_object_utils(personOut)

     Transaction tr;
   int num =1;
   function new(string name ="");
      super.new(name);
   endfunction // new

   task body();
      repeat(num)
	begin
	   tr=new("");
	   start_item(tr);

	   assert(tr.randomize() with {tr.x1==0;
				       tr.x2==1;})
	     else
	       `uvm_error("S2ER","s2 error during randomization");
      
          finish_item(tr);
         end
   endtask // body
endclass // personOut

	   