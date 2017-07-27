module lamp(output reg cs,input x1,x2,clk,rst);
   bit [7:0]count;
   parameter   s1=3'b000,
		 s2=3'b010,
		 s3=3'b100;

   reg [2:0] state, next;

   always@(posedge clk or posedge rst)
     if(rst) 
	  state<=3'b0;
     else
       state<=next;

   always @(*)
     begin
	next=3'bx;
	case(state)
	  s1: if(x1) next=s2;
	  else if(x2) next=s3;

	  s2: if(x1) next=s1;
	  else if(x2) 
	    begin
	       count=count+1;
	       next=s1;
	    end
	  s3: if(x2) next=s1;
	  else if(x1) 
	    begin
	       count = count-1;
	       next=s1;
	    end
	endcase // case (state)
     end // always @ (state or x1 or x2)

   always @(posedge clk or posedge rst)
     begin
	if(rst) 
	  begin
	  count<=8'b0;
	     cs=1'b0;
	  end
	
	else
	  begin 
	   case(state)
	     s1: if(count) cs=1'b1;
	     else cs=1'b0;
	   endcase // case (state)
	  end  
    end
endmodule // lamp


/*
 module test_lamp();
   wire cs;
   reg 	x1,x2,clk,rst;
   lamp l1(cs,x1,x2,clk,rst);

   always #5 clk=~clk;
   
   initial
     begin
	clk=0;rst=0;
	#10 rst=1;
	#11 rst=0;
	x1=1;
	x2=0;
	#13 x2=1;x1=0;
	#20 x2=0;
	#100 $finish();
     end // initial begin
 
endmodule // test_lamp
*/