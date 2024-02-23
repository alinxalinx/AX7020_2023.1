`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: myj                                                                 //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//     WEB: http://www.alinx.com/                                                //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2019/10/31     myj         1.0         Original
//*******************************************************************************/

module rtc_osd(
	input                       rst_n,  	//��λ�ź�
	input                       pclk,		//����ʱ��
	input [23:0]				rtc_data,	//RTC����
	input                       i_hs, 		//��ͬ�������ź�   
	input                       i_vs,   	//��ͬ�������ź�
	input                       i_de,		//ͼ����Ч�����ź�
	input[23:0]                 i_data, 	//ͼ�����������ź�
	output                      o_hs,   	//��ͬ������ź�    
	output                      o_vs,   	//��ͬ������ź� 
	output                      o_de,   	//ͼ����Ч����ź� 
	output[23:0]                o_data  	//ͼ����������ź�
);
localparam OSD_X_START 	= 	12'd9  ;	//X��ʼ����
localparam OSD_Y_START 	= 	12'd9  ;	//Y��ʼ����
localparam OSD_GAP 		= 	12'd16 ;	//�����ַ�������ص�
localparam OSD_WIDTH   	=  	12'd16 ;	//����OSD�Ŀ�ȣ��ɸ����ַ������������
localparam OSD_HEGIHT  	=  	12'd32 ;	//����OSD�ĸ߶ȣ��ɸ����ַ������������

wire [11:0] 		pos_x;		//X����
wire [11:0] 		pos_y;		//Y����
wire        		pos_hs;
wire        		pos_vs;
wire        		pos_de;
wire [23:0] 		pos_data;
reg	 [23:0]  		v_data;
     
reg	 [11:0]  		osd_x	[7:0] ;
reg	 [11:0]  		osd_y;
reg	 [15:0]  		osd_ram_addr	[7:0] ;
reg  [7:0]      	region_active;
reg  [7:0]      	region_active_d0;

reg        			pos_vs_d0;
reg        			pos_vs_d1;
	
reg	 [3:0]			char_addr_sel ;		//�ַ���ѡ�� ʮ����0-9��Ӧ���֡�0-9����ʮ����10��Ӧ��:��
reg	 [5:0]			char_addr ;			//�ַ��ĵ�ַ
wire [7:0]			char_data ;			//�ַ�����

assign o_data 	= v_data;
assign o_hs 	= pos_hs;
assign o_vs 	= pos_vs;
assign o_de 	= pos_de;

always@(posedge pclk)
	begin
		pos_vs_d0 <= pos_vs;
		pos_vs_d1 <= pos_vs_d0;
	end
//generate����8����ʾ����24Сʱ����ʾ��ʱ�������:��8������
genvar i ;
generate
	for (i = 0 ;i < 8 ; i = i + 1)
	begin : osd_region
		//OSD�������ã���ʼ����Ϊ��9��9���������С�������ɵ��ַ���������
		always@(posedge pclk)
		begin
			if(pos_y >= OSD_Y_START && pos_y <= OSD_Y_START + OSD_HEGIHT - 12'd1 
				&& pos_x >= OSD_X_START + OSD_WIDTH*i && pos_x  <= OSD_X_START + OSD_WIDTH*(i+1) - 12'd1)
				region_active[i] <= 1'b1;
			else
				region_active[i] <= 1'b0;
		end
		//��ʱһ������
		always@(posedge pclk)
		begin
			region_active_d0[i] <= region_active[i];
		end	
		
		
		//����OSD�ļ�����
		always@(posedge pclk)
		begin
			if(region_active_d0[i] == 1'b1)
				osd_x[i] <= osd_x[i] + 12'd1;
			else
				osd_x[i] <= 12'd0;
		end
		//����ROM�Ķ���ַ����region_active��Чʱ����ַ��1
		always@(posedge pclk)
		begin
			if(pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0)
				osd_ram_addr[i] <= 16'd0;
			else if(region_active[i] == 1'b1)
				osd_ram_addr[i] <= osd_ram_addr[i] + 16'd1;
		end	
		
	end		
endgenerate
//�ַ������жϣ���ɫ����
always@(posedge pclk)
begin
	case(region_active_d0)
		8'b0000_0001 : begin
						if(char_data[osd_x[0][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0000_0010 : begin
						if(char_data[osd_x[1][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0000_0100 : begin
						if(char_data[osd_x[2][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0000_1000 : begin
						if(char_data[osd_x[3][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0001_0000 : begin
						if(char_data[osd_x[4][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0010_0000 : begin
						if(char_data[osd_x[5][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b0100_0000 : begin
						if(char_data[osd_x[6][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		8'b1000_0000 : begin
						if(char_data[osd_x[7][2:0]] == 1'b1)  //���bitλ�Ƿ���1�������1������������Ϊ��ɫ
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //���򱣳�ԭ����ֵ
					   end
		default	: v_data <= pos_data;
	endcase
end

//����rtc�����ݽ������룬ΪBCD���룬����ֱ�����ַ���ѡ���źŶԽ�
always @(*)
begin
	case(region_active)
		8'b0000_0001 : char_addr_sel <= rtc_data[23:20] ;	//hour
		8'b0000_0010 : char_addr_sel <= rtc_data[19:16] ;
		8'b0000_0100 : char_addr_sel <= 4'd10 ;  			//:
		8'b0000_1000 : char_addr_sel <= rtc_data[15:12] ;	//minute
		8'b0001_0000 : char_addr_sel <= rtc_data[11:8] ;
		8'b0010_0000 : char_addr_sel <= 4'd10 ;	 			//:
		8'b0100_0000 : char_addr_sel <= rtc_data[7:4] ;		//second
		8'b1000_0000 : char_addr_sel <= rtc_data[3:0] ;
		default :	char_addr_sel <= 6'd0 ;
	endcase
end
//�ַ���ַ����
always @(*)
begin
	case(region_active)
		8'b0000_0001 : char_addr <= osd_ram_addr[0][15:3] ;
		8'b0000_0010 : char_addr <= osd_ram_addr[1][15:3] ;
		8'b0000_0100 : char_addr <= osd_ram_addr[2][15:3] ;
		8'b0000_1000 : char_addr <= osd_ram_addr[3][15:3] ;
		8'b0001_0000 : char_addr <= osd_ram_addr[4][15:3] ;
		8'b0010_0000 : char_addr <= osd_ram_addr[5][15:3] ;
		8'b0100_0000 : char_addr <= osd_ram_addr[6][15:3] ;
		8'b1000_0000 : char_addr <= osd_ram_addr[7][15:3] ;
		default :	char_addr <= 6'd0 ;
	endcase
end




//ʵ�����ַ���
char_repo  char_repo_inst(
	.clk			(pclk),
	.char_addr_sel	(char_addr_sel),
	.char_addr		(char_addr),
	.char_data      (char_data)

    );


timing_gen_xy timing_gen_xy_m0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);

endmodule
