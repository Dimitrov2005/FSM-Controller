class personIn extends uvm_sequence#(Transaction);
   
   `uvm_object_utils(personIn)
     Transaction tr;
   int num=1;

   function new(string name ="");
      super.new(name);
   endfunction // new

   task body();
      repeat(num)
	begin
	   tr=new("");
	   start_item(tr);
	   assert(tr.randomize() with {tr.x1==1;
				       tr.x2==0;})
	     else `uvm_error("PIRF","personIn randomization failed");

           finish_item(tr);
       end
   endtask // body

endclass // personIn
