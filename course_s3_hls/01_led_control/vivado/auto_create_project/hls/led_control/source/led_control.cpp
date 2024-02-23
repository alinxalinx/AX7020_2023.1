#include <ap_int.h>

void led_control(ap_int<1> &led)
{
#pragma HLS interface ap_none port=led
#pragma HLS interface ap_ctrl_none port=return
	led = 0;
	for(int i=0; i<50000000; i++)
	{
		if(i==25000000)
		led = ~led;
	}
}

