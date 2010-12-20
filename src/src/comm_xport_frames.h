/*
 * 
 */

#ifndef _COMM_XPORT_USER_H
#define _COMM_XPORT_USER_H

#include "comm_xport.h"
#include "messmodules.h"

typedef struct{
    byte command;
    byte size;
    byte* pData; 
}tXPORT_FRAMES_DEF;

//tMESSMODUL_VALUES** ppMm_values;

flash tXPORT_FRAMES_DEF XPORT_FRAMES_DEF[] = {

//  |command                |size   |pData
    {CMD_MM_GET_FREQUENCY,      2,      (byte *)&sMm.sModule[0].values.frequence   },
    {CMD_MM_GET_TEMPERATURE,    2,      0   }
};


#endif // _COMM_XPORT_USER_H
