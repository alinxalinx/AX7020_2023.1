#include "xil_types.h"
#include "xscugic.h"
#include "xiicps.h"
#include "xparameters.h"
#include "xil_exception.h"
#ifndef TOUCH_H_
#define TOUCH_H_

//GT911 ���ּĴ�������
#define GT_CTRL_REG 	0X8040   	//GT911���ƼĴ���
#define GT_CFGS_REG 	0X8047   	//GT911������ʼ��ַ�Ĵ���
#define GT_CHECK_REG 	0X80FF   	//GT911У��ͼĴ���
#define GT_PID_REG 		0X8140   	//GT911��ƷID�Ĵ���

#define GT_GSTID_REG 	0X814E   	//GT911��ǰ��⵽�Ĵ������
#define GT_TP1_REG 		0X814F  	//��һ�����������ݵ�ַ
#define GT_TP2_REG 		0X8157		//�ڶ������������ݵ�ַ
#define GT_TP3_REG 		0X815F		//���������������ݵ�ַ
#define GT_TP4_REG 		0X8167		//���ĸ����������ݵ�ַ
#define GT_TP5_REG 		0X816F		//��������������ݵ�ַ


int touch_init (XIicPs *pIicIns,XScuGic *XScuGicInstancePtr,u32 Int_Id);
int touch_i2c_read_bytes(u8 *BufferPtr, u16 address, u16 ByteCount);
int touch_i2c_write_bytes(u16 address, char Data);

extern int touch_sig;

#endif /* TOUCH_H_ */
