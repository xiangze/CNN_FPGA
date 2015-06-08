module filter_l(
		input 			       clk,
		input 			       resetn,
		input 			       clip,
		input 			       relu,
		input [7:0] 		       relu_c,

		{% for l in ls %}
		{% for m in n2[l] %} {% for k in n1[l] %}
	        {% for i in fn %} {% for j in fn %}
		 input signed [{{width-1}}:0]  w{{l}}_{{m}}_{{k}}_{{j}}_{{i}},
 	         {% endfor %} {% endfor %}
 		 input signed [{{width-1}}:0]  b{{l}}_{{m}}_{{k}};
 		 {% endfor %} {% endfor %}
  		 {% endfor %}
		
		 {% for k in n1[0] %}
		 input signed [{{width-1}}:0] x{{k}},
		 {% endfor %}
		
		 {% for k in n2[-1] %} 
		 output signed [{{width-1}}:0] out{{k}}
		 {% endfor %}
		 );
   
   		 {% for l in ls %}
		   
		  {% for m in n2[l] %}
		    wire [{{width-1}}:0] x{{l}}_{{m}};
                  {% endfor %}
		  {% for k in n1[l] %}
		    wire [{{width-1}}:0] out{{l}}_{{k}};
 		  {% endfor %}
		    //assert(n1[l]==n2[l-1])
		  {% for m in n2[l] %}
		    {% if l==0 %}
		      assign x{{l}}_{{m}}=out{{l}}_{{m}};
                    {% else %} 
 		      assign x{{l}}_{{m}}=x{{m}};
                    {% endif %}
                  {% endfor %}
		    
		   filter_n2_line filter_n2_{{l}}(
					  .clk(clk), .resetn(resetn),.clip(clip),
					  {% for m in n2 %} {% for k in n1 %}
					  {% for i in fn %} {% for j in fn %}
					  .w{{l}}_{{m}}_{{k}}_{{j}}_{{i}}(w{{l}}_{{m}}_{{k}}_{{j}}_{{i}}[{{width-1}}:0]  ),
					  {% endfor %} {% endfor %}
					  .b{{m}}_{{k}}(b{{l}}_{{m}}_{{k}}[{{width-1}}:0]);
					  {% endfor %} {% endfor %}
						  
					  {% for k in n1[l] %}
					  .x{{k}}(x{{l}}_{{k}}[{{width-1}}:0]),
					  {% endfor %}
						  
					  {% for k in n2[l] %} 
					  .out{{k}}(out{{l}}_{{k}}[{{width-1}}:0] )
					  {% endfor %}
						  
					  .relu(relu),.relu_c(relu_c[7:0])
					  );
		 {% endfor %}

		 {% for k in n2[-1] %} 		   
		   assign out{{k}}=out{{lnum-1}}_{{k}};
		 {% endfor %}
			      
endmodule