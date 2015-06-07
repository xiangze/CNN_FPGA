module prodsum3(
		  input 	     clk,
		  input 	     resetn,
		  input signed [9:0] w0,
		  input signed [9:0] w1,
		  input signed [9:0] w2,
		  input signed [9:0] x0,
		  input signed [9:0] x1,
		  input signed [9:0] x2,
		  input 	     clip,
		
		  output signed      reg [9:0] out
		  );

   wire [20:0] 		      no;
   wire [9:0] 		      no_clip;

   assign no=x0*w0+x1*w1+x2+w2;
   assign no_clip=$signed( (no[20]&(!&no[19:18]))?-512:(!no[20]&|no[19:18])?512:{no[20],no[17:9]});
   
   always@(posedge clk or negedge resetn)
     if(!resetn)
       out<=0;
     else if(clip)   
       out<=no_clip;
     else
       out<={no[20:11]};       

endmodule