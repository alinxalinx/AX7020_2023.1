/*
 * wave.h
 *
 *  Created on: 2018��7��19��
 *      Author: Administrator
 */

#ifndef WAVE_H_
#define WAVE_H_

#include <math.h>
#include "xil_types.h"

void GetSinWave(int point, int max_amp, int amp_val, u16 *sin_tab) ;
void GetSquareWave(int point, int max_amp, int amp_val, u16 *Square_tab) ;
void GetTriangleWave(int point, int max_amp, int amp_val, u16 *Triangle_tab) ;
void GetSawtoothWave(int point, int max_amp, int amp_val, u16 *Sawtooth_tab) ;
void GetSubSawtoothWave(int point, int max_amp, int amp_val, u16 *SubSawtooth_tab) ;

#endif /* WAVE_H_ */
