#include "xil_types.h"
#include "xscutimer.h"

int PS_timer_init(XScuTimer *Timer, u16 DeviceId, u32 timer_load)
{
	int Status;
	XScuTimer_Config *TMRConfigPtr;
	//˽�ж�ʱ����ʼ��
	TMRConfigPtr = XScuTimer_LookupConfig(DeviceId);
	XScuTimer_CfgInitialize(Timer, TMRConfigPtr,TMRConfigPtr->BaseAddr);
	XScuTimer_SelfTest(Timer);
	XScuTimer_LoadTimer(Timer, timer_load);
	//�Զ�װ��
	XScuTimer_EnableAutoReload(Timer);
	//������ʱ��
	XScuTimer_Start(Timer);
	return XST_SUCCESS;
}
