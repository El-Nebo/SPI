module master_tb;
reg MISO ;
reg clk =1;
reg CPOL ;
reg CPHA;
reg reset;
reg [7:0] initialize_data;
reg load ;
wire [7:0] master_data;
wire sclk;
wire MOSI;
wire cs1 ;
wire cs2 ;
wire cs3 ;
wire check1;
reg [1:0] select ;
master mas (.CPOL(CPOL) , .CPHA(CPHA) , .clk(clk) , .reset(reset) , .select(select) , .MISO(MISO) , .initialize_data (initialize_data) , .load(load) , .master_data(master_data) , .sclk(sclk) , .MOSI(MOSI) , .cs1(cs1) , .cs2(cs2)  ,.cs3(cs3), .check1(check1)); 
always	#5 clk<= ~clk;
initial 
begin
initialize_data = 8'b11111111;
MISO=0;
CPOL = 0;
CPHA=0;
reset = 1 ;
load=1;
$display ("reseting master data to 11111111 , MISO to 0");
#11
reset=0;
$display("Checking master in  mode 0");
#200 
if (master_data==8'b00000000)
$display ("Successful , master_data=00000000");
else
$display ("faild");
CPOL = 0;
CPHA=1;
reset = 1 ;
load=1; 
$display ("reseting master data to 11111111 , MISO to 0"); 
#11
reset=0;
$display("Checking master in  mode 1");
#200 
if (master_data==8'b00000000)
$display ("Successful , master_data=00000000");
else
$display ("faild");
CPOL = 1;
CPHA=1;
reset = 1 ;
load=1;
$display ("reseting master data to 11111111 , MISO to 0");
#11
reset=0;
$display("Checking master in mode 2 ");
#200 
if (master_data==8'b00000000)
$display ("Successful , master_data=00000000");
else
$display ("faild");
CPOL = 1;
CPHA=0;
reset = 1 ;
load=1;
$display ("reseting master data to 11111111 , MISO to 0");
#11
reset=0;
$display("Checking master in mode 3 ");
#200 
if (master_data==8'b00000000)
$display ("Successful , master_data=00000000");
else
$display ("faild");
end
endmodule
