`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module fifo_test
	(
		input 		clk,		         //50MHzʱ��
		input 		rst_n	             //��λ�źţ��͵�ƽ��Ч	
	);


reg	 [15:0] 		w_data			;	   		//FIFOд����
wire      			wr_en			;	   		//FIFOдʹ��
wire      			rd_en			;	   		//FIFO��ʹ��
wire [15:0] 		r_data			;			//FIFO������
wire       			full			;  			//FIFO���ź� 
wire       			empty			;  			//FIFO���ź� 
wire [8:0]  		rd_data_count	;  			//�ɶ���������	
wire [8:0]  		wr_data_count	;  			//��д����������
	
wire				clk_100M 		;			//PLL����100MHzʱ��
wire				clk_75M 		;			//PLL����100MHzʱ��
wire				locked 			;			//PLL lock�źţ�����Ϊϵͳ��λ�źţ��ߵ�ƽ��ʾlockס
wire				fifo_rst_n 		;			//fifo��λ�ź�, �͵�ƽ��Ч

wire				wr_clk 			;			//дFIFOʱ��
wire				rd_clk 			;			//��FIFOʱ��
reg	[7:0]			wcnt 			;			//дFIFO��λ��ȴ�������
reg	[7:0]			rcnt 			;			//��FIFO��λ��ȴ�������

//����PLL������100MHz��75MHzʱ��
clk_wiz_0 fifo_pll
 (
  // Clock out ports
  .clk_out1(clk_100M),     	 	// output clk_out1
  .clk_out2(clk_75M),    		// output clk_out2
  // Status and control signals
  .reset(~rst_n), 			 	// input reset
  .locked(locked),       		// output locked
  // Clock in ports
  .clk_in1(clk)					// input clk_in1
  );      			

assign fifo_rst_n 	= locked	;	//��PLL��LOCK�źŸ�ֵ��fifo�ĸ�λ�ź�
assign wr_clk 		= clk_100M 	;	//��100MHzʱ�Ӹ�ֵ��дʱ��
assign rd_clk 		= clk_75M 	;	//��75MHzʱ�Ӹ�ֵ����ʱ��


/* дFIFO״̬�� */
localparam      W_IDLE      = 1	;
localparam      W_FIFO     	= 2	; 

reg[2:0]  write_state;
reg[2:0]  next_write_state;

always@(posedge wr_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		write_state <= W_IDLE;
	else
		write_state <= next_write_state;
end

always@(*)
begin
	case(write_state)
		W_IDLE:
			begin
				if(wcnt == 8'd79)               //��λ��ȴ�һ��ʱ�䣬safety circuitģʽ�µ�����ʱ��60������
					next_write_state <= W_FIFO;
				else
					next_write_state <= W_IDLE;
			end
		W_FIFO:
			next_write_state <= W_FIFO;			//һֱ��дFIFO״̬
		default:
			next_write_state <= W_IDLE;
	endcase
end
//��IDLE״̬�£�Ҳ���Ǹ�λ֮�󣬼���������
always@(posedge wr_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		wcnt <= 8'd0;
	else if (write_state == W_IDLE)
		wcnt <= wcnt + 1'b1 ;
	else
		wcnt <= 8'd0;
end
//��дFIFO״̬�£������������FIFO��д����
assign wr_en = (write_state == W_FIFO) ? ~full : 1'b0; 
//��дʹ����Ч����£�д����ֵ��1
always@(posedge wr_clk or negedge fifo_rst_n)
begin
	if(!fifo_rst_n)
		w_data <= 16'd1;
	else if (wr_en)
		w_data <= w_data + 1'b1;
end

/* ��FIFO״̬�� */

localparam      R_IDLE      = 1	;
localparam      R_FIFO     	= 2	; 
reg[2:0]  read_state;
reg[2:0]  next_read_state;

///����FIFO��������
always@(posedge rd_clk or negedge fifo_rst_n)
begin
	if(!fifo_rst_n)
		read_state <= R_IDLE;
	else
		read_state <= next_read_state;
end

always@(*)
begin
	case(read_state)
		R_IDLE:
			begin
				if (rcnt == 8'd59)             	//��λ��ȴ�һ��ʱ�䣬safety circuitģʽ�µ�����ʱ��60������
					next_read_state <= R_FIFO;
				else
					next_read_state <= R_IDLE;
			end
		R_FIFO:	
			next_read_state <= R_FIFO ;			//һֱ�ڶ�FIFO״̬
		default:
			next_read_state <= R_IDLE;
	endcase
end

//��IDLE״̬�£�Ҳ���Ǹ�λ֮�󣬼���������
always@(posedge rd_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		rcnt <= 8'd0;
	else if (write_state == W_IDLE)
		rcnt <= rcnt + 1'b1 ;
	else
		rcnt <= 8'd0;
end
//�ڶ�FIFO״̬�£�������վʹ�FIFO�ж�����
assign rd_en = (read_state == R_FIFO) ? ~empty : 1'b0; 

//-----------------------------------------------------------
//ʵ����FIFO
fifo_ip fifo_ip_inst 
(
  .rst            (~fifo_rst_n    	),   // input rst
  .wr_clk         (wr_clk          	),   // input wr_clk
  .rd_clk         (rd_clk          	),   // input rd_clk
  .din            (w_data       	),   // input [15 : 0] din
  .wr_en          (wr_en        	),   // input wr_en
  .rd_en          (rd_en        	),   // input rd_en
  .dout           (r_data       	),   // output [15 : 0] dout
  .full           (full         	),   // output full
  .empty          (empty        	),   // output empty
  .rd_data_count  (rd_data_count	),   // output [8 : 0] rd_data_count
  .wr_data_count  (wr_data_count	)    // output [8 : 0] wr_data_count
);

//дͨ���߼�������
ila_m0 ila_wfifo (
	.clk		(wr_clk			), 
	.probe0		(w_data			), 	
	.probe1		(wr_en			), 	
	.probe2		(full			), 		
	.probe3		(wr_data_count	)
);
//��ͨ���߼�������
ila_m0 ila_rfifo (
	.clk		(rd_clk			), 
	.probe0		(r_data			), 	
	.probe1		(rd_en			), 	
	.probe2		(empty			), 		
	.probe3		(rd_data_count	)
);
 	
endmodule

