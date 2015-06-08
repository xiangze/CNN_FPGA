module linebuffer(
		  input 			clk,
		  input 			ren,
		  input 			wen,
		  input [{{lnlinewidth-1}}:0] 	waddr;
		  input [{{lnlinewidth-1}}:0] 	raddr;
		  
		  input signed [{{width-1}}:0] 	in,
		  output signed [{{width-1}}:0] out
		  );
   
   reg [{{width-1}}:0] 				regs[{{linewidth-1}}:0];
   
   always@(posedge clk)
     if(ren)
       out<=regs[raddr];

   always@(posedge clk)
     if(wen)
       regs[waddr]<=in;

endmodule
