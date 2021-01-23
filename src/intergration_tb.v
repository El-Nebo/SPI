
module tb;
reg clk=1;
reg reset;
reg mas_load;
reg s_load ;
wire check_end ;
wire [7:0] master_data ;
wire [7:0] slave_data ;
wire [7:0] slave_data_1 ;
wire [7:0] slave_data_2 ;
wire [7:0] slave_data_3 ;
reg [7:0] init_master;
reg [7:0] init_slave ;
reg CPOL;
reg CPHA;
reg [1:0] select;

integration uut (.CPOL(CPOL),.CPHA(CPHA) , .init_master(init_master) , .init_slave(init_slave) , .clk(clk) , .reset(reset),
 . mas_load(mas_load),.s_load(s_load),.select(select),.master_data(master_data),.slave_data_1( slave_data_1),
.slave_data_2( slave_data_2),.slave_data_3( slave_data_3),.check_end(check_end));

always	#5 clk<= ~clk;

reg tclk = 1;
reg [31:0] count;
reg [31:0] error;
reg [22:0] testvectors[1000:0];
reg [7:0] last_master_data ;
reg [7:0] last_slave_data ;


always #200 tclk <=~ tclk;

assign slave_data = (select == 1)? slave_data_1:
		    (select == 2)? slave_data_2:
		    (select == 3)? slave_data_3:	8'b00000000;
initial begin
	$readmemb("full_tb_input.tv", testvectors); 
	count = 0; error = 0; 
	init_master = 8'b11111111;
	init_slave = 8'b00000000;
	CPOL = 0; CPHA = 0;
	reset = 1;  s_load = 1; mas_load = 1;
	#11; 
	reset = 0; s_load = 0;
end

//1 CPOL CPHA select mas_load s_load inti_master init_slave 
//0 CPOL CPHA select mas_load s_load 
always @(posedge tclk)
begin
	if(testvectors[count][22] == 1) begin
	#1;	{CPOL,CPHA,select,mas_load,s_load,init_master,init_slave} = testvectors[count][21:0];
	end else begin
	#1;	{CPOL,CPHA,select,mas_load,s_load} = testvectors[count][21:16];
	end
	reset = 1;	
	#11;
	reset = 0;
	if(mas_load == 1)	last_master_data = init_master;
	else			last_master_data = master_data;
	if(s_load == 1)		last_slave_data = init_slave;
	else			last_slave_data = slave_data;
	
	
end

always @(negedge tclk)
	begin
		if (slave_data !== last_master_data || master_data !== last_slave_data)
		begin
			$display("Error: inputs = ", count);
			$display(" master outputs = %b (%b exp)",master_data,last_master_data);
			$display(" slave outputs = %b (%b exp)" , slave_data,last_slave_data);
			error = error + 1;
		end

		count = count + 1;
		if (testvectors[count] === 23'bx)
		begin
			$display("%d tests completed with %d errors",
			count, error);
			$finish; 
		end
	end
endmodule