/*
    FreeRTOS V8.2.1 - Copyright (C) 2015 Real Time Engineers Ltd.
    All rights reserved

    VISIT http://www.FreeRTOS.org TO ENSURE YOU ARE USING THE LATEST VERSION.

    This file is part of the FreeRTOS distribution.

    FreeRTOS is free software; you can redistribute it and/or modify it under
    the terms of the GNU General Public License (version 2) as published by the
    Free Software Foundation >>!AND MODIFIED BY!<< the FreeRTOS exception.

    >>!   NOTE: The modification to the GPL is included to allow you to     !<<
    >>!   distribute a combined work that includes FreeRTOS without being   !<<
    >>!   obliged to provide the source code for proprietary components     !<<
    >>!   outside of the FreeRTOS kernel.                                   !<<

    FreeRTOS is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  Full license text is available on the following
    link: http://www.freertos.org/a00114.html

    1 tab == 4 spaces!

    ***************************************************************************
     *                                                                       *
     *    Having a problem?  Start by reading the FAQ "My application does   *
     *    not run, what could be wrong?".  Have you defined configASSERT()?  *
     *                                                                       *
     *    http://www.FreeRTOS.org/FAQHelp.html                               *
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *    FreeRTOS provides completely free yet professionally developed,    *
     *    robust, strictly quality controlled, supported, and cross          *
     *    platform software that is more than just the market leader, it     *
     *    is the industry's de facto standard.                               *
     *                                                                       *
     *    Help yourself get started quickly while simultaneously helping     *
     *    to support the FreeRTOS project by purchasing a FreeRTOS           *
     *    tutorial book, reference manual, or both:                          *
     *    http://www.FreeRTOS.org/Documentation                              *
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *   Investing in training allows your team to be as productive as       *
     *   possible as early as possible, lowering your overall development    *
     *   cost, and enabling you to bring a more robust product to market     *
     *   earlier than would otherwise be possible.  Richard Barry is both    *
     *   the architect and key author of FreeRTOS, and so also the world's   *
     *   leading authority on what is the world's most popular real time     *
     *   kernel for deeply embedded MCU designs.  Obtaining your training    *
     *   from Richard ensures your team will gain directly from his in-depth *
     *   product knowledge and years of usage experience.  Contact Real Time *
     *   Engineers Ltd to enquire about the FreeRTOS Masterclass, presented  *
     *   by Richard Barry:  http://www.FreeRTOS.org/contact
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *    You are receiving this top quality software for free.  Please play *
     *    fair and reciprocate by reporting any suspected issues and         *
     *    participating in the community forum:                              *
     *    http://www.FreeRTOS.org/support                                    *
     *                                                                       *
     *    Thank you!                                                         *
     *                                                                       *
    ***************************************************************************

    http://www.FreeRTOS.org - Documentation, books, training, latest versions,
    license and Real Time Engineers Ltd. contact details.

    http://www.FreeRTOS.org/plus - A selection of FreeRTOS ecosystem products,
    including FreeRTOS+Trace - an indispensable productivity tool, a DOS
    compatible FAT file system, and our tiny thread aware UDP/IP stack.

    http://www.FreeRTOS.org/labs - Where new FreeRTOS products go to incubate.
    Come and try FreeRTOS+TCP, our new open source TCP/IP stack for FreeRTOS.

    http://www.OpenRTOS.com - Real Time Engineers ltd license FreeRTOS to High
    Integrity Systems ltd. to sell under the OpenRTOS brand.  Low cost OpenRTOS
    licenses offer ticketed support, indemnification and commercial middleware.

    http://www.SafeRTOS.com - High Integrity Systems also provide a safety
    engineered and independently SIL3 certified version for use in safety and
    mission critical applications that require provable dependability.

    1 tab == 4 spaces!
*/

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
/* Xilinx includes. */
#include "xil_printf.h"
#include "xparameters.h"
#include "xgpiops.h"
#include "xgpio.h"

#define TIMER_ID	1
#define DELAY_10_SECONDS	10000UL
#define DELAY_1_SECOND		1000UL
#define DELAY_100_MSECOND   100UL
#define TIMER_CHECK_THRESHOLD	9

#define MIO_0_ID XPAR_PS7_GPIO_0_DEVICE_ID
#define LED_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_OUTPUT     1
XGpioPs GPIO_PTR ;

#define LED_CHANNEL 1
XGpio Gpio_led ;

unsigned int PsLedVal = 0 ;
unsigned int PlLedVal = 0x0 ;
/*-----------------------------------------------------------*/

/* The Tx and Rx tasks as described at the top of this file. */
static void prvTxTask( void *pvParameters );
static void prvRxTask( void *pvParameters );
static void prvPsLedTask( void *pvParameters );
static void prvPlLedTask( void *pvParameters ) ;
/*-----------------------------------------------------------*/
void PsGpioSetup() ;
void PlGpioSetup() ;

/* The queue used by the Tx and Rx tasks, as described at the top of this
file. */
static TaskHandle_t xTxTask;
static TaskHandle_t xRxTask;
static QueueHandle_t xQueue = NULL;

char HWstring[15] = "Hello World";
long RxtaskCntr = 0;
unsigned long IdleCount = 0UL ;

int main( void )
{

	xil_printf( "Hello from Freertos example main\r\n" );
	PsGpioSetup() ;
	PlGpioSetup() ;

	xTaskCreate( 	prvTxTask, 					/* The function that implements the task. */
					( const char * ) "Tx", 		/* Text name for the task, provided to assist debugging only. */
					configMINIMAL_STACK_SIZE, 	/* The stack allocated to the task. */
					NULL, 						/* The task parameter is not used, so set to NULL. */
					tskIDLE_PRIORITY,			/* The task runs at the idle priority. */
					&xTxTask );

	xTaskCreate( prvRxTask,
				 ( const char * ) "GB",
				 configMINIMAL_STACK_SIZE,
				 NULL,
				 tskIDLE_PRIORITY + 1,
				 &xRxTask );

	xTaskCreate( prvPsLedTask,
				( const char * ) "Ps Led",
				configMINIMAL_STACK_SIZE,
				NULL,
				tskIDLE_PRIORITY + 1,
				NULL);
	xTaskCreate( prvPlLedTask,
					( const char * ) "PL Led",
					configMINIMAL_STACK_SIZE,
					NULL,
					tskIDLE_PRIORITY + 1,
					NULL);

	/* Create the queue used by the tasks.  The Rx task has a higher priority
	than the Tx task, so will preempt the Tx task and remove values from the
	queue as soon as the Tx task writes to the queue - therefore the queue can
	never have more than one item in it. */
	xQueue = xQueueCreate( 	1,						/* There is only one space in the queue. */
							sizeof( HWstring ) );	/* Each space in the queue is large enough to hold a uint32_t. */

	/* Check the queue was created. */
	configASSERT( xQueue );


	/* Start the tasks and timer running. */
	vTaskStartScheduler();

	/* If all is well, the scheduler will now be running, and the following line
	will never be reached.  If the following line does execute, then there was
	insufficient FreeRTOS heap memory available for the idle and/or timer tasks
	to be created.  See the memory management section on the FreeRTOS web site
	for more details. */
	for( ;; );
}


/*-----------------------------------------------------------*/
static void prvTxTask( void *pvParameters )
{
const TickType_t x1second = pdMS_TO_TICKS( DELAY_1_SECOND );

	for( ;; )
	{
		/* Delay for 1 second. */
		vTaskDelay( x1second );

		/* Send the next value on the queue.  The queue should always be
		empty at this point so a block time of 0 is used. */
		xQueueSend( xQueue,			/* The queue being written to. */
					HWstring, /* The address of the data being sent. */
					0UL );			/* The block time. */
	}
}

/*-----------------------------------------------------------*/
static void prvRxTask( void *pvParameters )
{
char Recdstring[15] = "";

	for( ;; )
	{
		/* Block to wait for data arriving on the queue. */
		xQueueReceive( 	xQueue,				/* The queue being read. */
						Recdstring,	/* Data is read into this address. */
						portMAX_DELAY );	/* Wait without a timeout for data. */

		/* Print the received data. */
		xil_printf( "Rx task received string from Tx task: %s\r\n", Recdstring );
		xil_printf( "Rx task Counter is %d\r\n", RxtaskCntr );
		RxtaskCntr++;
	}
}



void PsGpioSetup()
{
	int Status ;
	XGpioPs_Config *GpioCfg ;

	GpioCfg = XGpioPs_LookupConfig(MIO_0_ID) ;
	Status = XGpioPs_CfgInitialize(&GPIO_PTR, GpioCfg, GpioCfg->BaseAddr) ;
	if (Status != XST_SUCCESS)
	{
		xil_printf("PS GPIO Configuration failed!\r\n") ;
	}
	/* set MIO 0 as output */
	XGpioPs_SetDirectionPin(&GPIO_PTR, 0, GPIO_OUTPUT) ;
	/* enable MIO 0 output */
	XGpioPs_SetOutputEnablePin(&GPIO_PTR, 0, GPIO_OUTPUT) ;
}


/*-----------------------------------------------------------*/
static void prvPsLedTask( void *pvParameters )
{
const TickType_t x1second = pdMS_TO_TICKS( DELAY_100_MSECOND );

	for( ;; )
	{
		XGpioPs_WritePin(&GPIO_PTR, 0, PsLedVal) ;
		PsLedVal = ~PsLedVal ;

		/* Delay for 100 millisecond. */
		vTaskDelay( x1second );
	}
}


void vApplicationIdleHook( void )
{
	/* This hook function does nothing but increment a counter. */
	IdleCount++;
}

void PlGpioSetup()
{
	int Status ;
	/* initial gpio led */
	Status = XGpio_Initialize(&Gpio_led, LED_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		xil_printf("PL GPIO Configuration failed!\r\n") ;

	/* set led as output */
	XGpio_SetDataDirection(&Gpio_led, LED_CHANNEL, 0x0);

}

/*-----------------------------------------------------------*/
static void prvPlLedTask( void *pvParameters )
{
const TickType_t x1second = pdMS_TO_TICKS( DELAY_1_SECOND );

	for( ;; )
	{
		XGpio_DiscreteWrite(&Gpio_led, LED_CHANNEL, PlLedVal);
		PlLedVal = ~PlLedVal ;

		/* Delay for 1 second. */
		vTaskDelay( x1second );
	}
}
