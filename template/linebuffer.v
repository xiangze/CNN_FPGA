module linebuffer(
		  input 	      clk,
		  input 	      ren,
		  input 	      wen,
		  input [9:0] 	      waddr;
		  input [9:0] 	      raddr;
		  
		  input signed [9:0]  in,
		  output signed [9:0] out
		  );
   
   reg [9:0] 			      regs[1920-1:0];
   
   always@(posedge clk)
     if(ren)
       out<=regs[raddr];

   always@(posedge clk)
     if(ren)
       regs[waddr]<=in;

endmodule
