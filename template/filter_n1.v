module filter_n1_{{nn1}}(
		  input 		       clk,
		  input 		       resetn,
		  input 		       clip,
		  input 		       relu,
		  input [7:0] 		       relu_c,
  					       {% for k in n1 %}
  					       {% for i in fn %} {% for j in fn %}
		  input signed [{{width-1}}:0] w{{k}}_{{j}}_{{i}},
					       {%- endfor %} {%- endfor %} {%- endfor %}
					       {% for k in n1 %} 
					       {% for i in fn %} {% for j in fn %}
		  input signed [{{width-1}}:0] x{{k}}_{{j}}_{{i}},
					       {%- endfor %} {%- endfor %}
					       {%- endfor %}
		 
  					       {% for k in n1 %}
		  input signed [{{width-1}}:0] b{{k}};
		  {%- endfor %} 
		  output signed reg [9:0] out
		 );

   {% for k in n1 %}   
     wire [{{width-1}}:0] out{{k}};
     filter3x3 filter_{{k}}(
			    .clk(clk), .resetn(resetn),
			    .relu(0),.relu_c(0),
  			    {% for i in fn %} {% for j in fn %}
			    .w_{{j}}_{{i}}(w{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			    .x_{{j}}_{{i}}(x{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			    {%- endfor %}   {%- endfor %}
			    .b(b{{k}}[{{width-1}}:0])
			    .out(out{{k}}[{{width-1}}:0]));
   {%- endfor %}
     
   {% for l in ln1 %}   
     {% for k in ii[l] %}   
       reg [{{width-1}}:0]  out_{{l}}_{{k}};
       wire [{{width*2}}:0] nout_{{l}}_{{k}};
       wire [{{width-1}}:0] nout_clip_{{l}}_{{k}};
   
       assign nout_{{l}}_{{k}}
	 =out_{{l-1}}_{{k*4}}+out_{{l-1}}_{{k*4+1}}+out_{{l-1}}_{{k*4+2}}+out_{{l-1}}_{{k*4+3}};
   
       assign no_clip_{{l}}_{{k}}
	 =$signed((no[20]&(!&no[19:18]))?-512:(!no[20]&|no[19:18])?512:{no[20],no[17:9]});
   
       always@(posedge clk or negedge resetn)
	 if(!resetn)
	   out_{{l}}_{{k}}<=0;
	 else if(clip)   
	   out<=no_clip_{{l}}_{{k}}
	 else
	   out<={no_{{l}}_{{k}}[20:11]};       
   {%- endfor %}
   {%- endfor %}
		
   wire [{{width*2}}:0] no;
   wire [{{width-1}}:0] no_clip;
   wire [{{width-1+8}}:0] no_nrelu;
   
   assign no=out_0+out1+out2+out3;
   assign no_clip=$signed((no[20]&(!&no[19:18]))?-512:(!no[20]&|no[19:18])?512:{no[20],no[17:9]});
   assign no_nrelu=no_clip*relu_c;
   
   always@(posedge clk or negedge resetn)
     if(!resetn)
       out<=0;
     else if(relu)   
       out<=(no_clip[{{width-1}}]?0:no_clip)+(~no_clip[{{width-1}}]?0:no_nrelu[{{width-1+8}}:8]);
     else if(clip)   
       out<=no_clip;
     else
       out<={no[20:11]};       

endmodule