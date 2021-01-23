module slave_tb;
reg clk = 1 ,CPOL,CPHA,reset,mload,MISOtemp;
reg [7:0] initialize_data;
wire [7:0] master_data;
wire sclk, MOSItemp, cs1 , cs2 , cs3 ,check;
reg [1:0] select ;
master mas (.CPOL(CPOL) , .CPHA(CPHA) , .clk(clk) , .reset(reset) , .select(select) , 
	    .MISO(MISOtemp) , .initialize_data (initialize_data) , .load(mload) , 
	    .master_data(master_data) , .sclk(sclk) , .MOSI(MOSItemp) , .cs1(cs1) , 	
	    .cs2(cs2) , .cs3(cs3) , .check1(check)); 
always #5 clk = ~clk;
///////////////////////////////////////////////////////////////////////////////////////////
// master is called to obtain sclk and check which are essential for slave to work 
//////////////////////////////////////////////////////////////////////////////////////////
reg load,MOSI,cs;
reg [7:0] slave_init_data;
wire MISO;
wire [7:0] slave_data;


slave slave1 (.sclk(sclk) , .CPHA(CPHA) , .CPOL(CPOL) , .check1(check) ,.cs(cs),
              .init_data(slave_init_data) , .load(load) , 
              .MOSI(MOSI) , .slave_data(slave_data) , .MISO(MISO));


initial begin 
cs = 0;

slave_init_data = 8'b11111111;
MOSI = 0;
//////////mode 0/////////////
load = 1;
CPOL = 0;
CPHA = 0;
reset = 1;
$display("reseting slave data to 11111111, MOSI to 0");
#11;
load = 0;
reset = 0;
$display("checking slave in mode 0 ");
#200;
if(slave_data == 8'b00000000)	$display("successful, slave data = 00000000");
else 	$display("failed");

//////////mode 1/////////////
load = 1;
CPOL = 0;
CPHA = 1;
reset = 1;
$display("reseting slave data to 11111111, MOSI to 0");
#11;
load = 0;
reset = 0;
$display("checking slave in mode 1");
#200;
if(slave_data == 8'b00000000)	$display("successful, slave data = 00000000");
else 	$display("failed");

//////////mode 2/////////////
load = 1;
CPOL = 1;
CPHA = 1;
reset = 1;
$display("reseting slave data to 11111111, MOSI to 0");
#11;
load = 0;
reset = 0;
$display("checking slave in mode 2");
#200;
if(slave_data == 8'b00000000)	$display("successful, slave data = 00000000");
else 	$display("failed");

//////////mode 3/////////////
load = 1;
CPOL = 1;
CPHA = 0;
reset = 1;
$display("reseting slave data to 11111111, MOSI to 0");
#11;
load = 0;
reset = 0;
$display("checking slave in mode 3");
#200;
if(slave_data == 8'b00000000)	$display("successful, slave data = 00000000");
else 	$display("failed");

end 
endmodule
