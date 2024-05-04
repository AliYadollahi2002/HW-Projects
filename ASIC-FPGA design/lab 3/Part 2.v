#include <stdio.h>
#include "platform.h"
#include <xparameters.h>
#include <xgpio.h>
#define DeviceId 1

void print(char *str);



int main()
{
    init_platform();
    XGpio GpioInput;
    XGpio GpioOutput;

    /*

int XGpio_Initialize ( XGpio * InstancePtr,u16 DeviceId )
     */
    XGpio_Initialize(&GpioInput, XPAR_DIP_SWITCHES_8BITS_DEVICE_ID);
    XGpio_Initialize(&GpioOutput, XPAR_LEDS_8BITS_DEVICE_ID);
    /*
     void XGpio_SetDataDirection ( XGpio * InstancePtr,unsigned Channel,u32 DirectionMask )
     */
    XGpio_SetDataDirection(&GpioInput, 1, 0xff);
    XGpio_SetDataDirection(&GpioOutput, 1, 0x00);
    u32 signal , first , second;
    while(1){
    /*
u32 XGpio_DiscreteRead ( XGpio * InstancePtr,unsigned Channel
    */
    signal = XGpio_DiscreteRead(&GpioInput , 1);
    first = signal % 16;
    second = signal / 16;
    /*
void XGpio_DiscreteWrite ( XGpio * InstancePtr,unsigned Channel,u32 Mask )
    */

    XGpio_DiscreteWrite(&GpioOutput , 1 , first + second);
    }



    return 0;
}