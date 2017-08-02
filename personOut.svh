class personOut extends uvm_sequence#(Transaction);
   
   `uvm_object_utils(personOut)
     Transaction tr;
   int num=1; bit s1=1,s2=0;

   function new(string name ="");
      super.new(name);
   endfunction // new

   task body();
      repeat(num)
	begin
	   tr=new("");
	   start_item(tr);
	  if(s1) 
	     begin
	     assert(tr.randomize() with {tr.x1==0;
				       tr.x2==1;})
	     else
	       `uvm_error("S2ER","s2 error during randomization");
             s1=0;
             s2=1;
            end
	   
	  else if(s2)
	    begin
	    assert(tr.randomize() with {tr.x1==1;
				       tr.x2==0;})
	     else
	       `uvm_error("S2ER","s2 error during randomization");
             s2=0;
             s1=1;
            end 

           finish_item(tr);
       end
   endtask // body

endclass // personIn
