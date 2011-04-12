/*
 * prj_def.h
 *
 *  Created on: 28.8.2009
 *      Author: Lubos Melichar
 */

 /* !! toto je jediny soubor na kterem jsou knihovny zavisle !!
  * --> prilinkuji prislune zakladni knihovny k danemu hw
  * --> podmineny preklad (podle HW_VERSION etc.)  
  */

#ifndef PRJ_DEF_H_
#define PRJ_DEF_H_

  /* USER DEFINES */ 
  
      /* HW */
      
      #define   HW_RMII_COMM_MODUL                             // Hardware
      
      // 100 - 
      // 110 - prohozene ledky a tlacitka  
      #define   HW_VERSION                        100         // !!relevantni pro podm.preklad!!
      
      //sw
      #define   SW_NAME                           "TestHw"         // Verze hardwaru 1.00
      #define   SW_VERSION                        100         // Verze hardwaru 1.00

  /* END OF USER DEFINES */  
  
  
  #ifdef HW_RMII_COMM_MODUL
      #define   HW_NAME                          "CommModul"  // Verze hardwaru 1.00
      #define   F_CPU                             11059200L   // 11,0592MHz processor
       
      //hw_version string
      #if HW_VERSION == 100
        #define   HW_VERSION_S                      "1.00"      // Verze hardwaru 1.00
      #elif HW_VERSION == 110
        #define   HW_VERSION_S                      "1.10"      // Verze hardwaru 1.00
      #endif
      
      //sw_version string
      #if SW_VERSION == 100
        #define   SW_VERSION_S                      "1.00"      // Verze hardwaru 1.00
      #elif SW_VERSION == 110
        #define   SW_VERSION_S                      "1.10"      // Verze hardwaru 1.00
      #endif  
      
  #endif
  
  
  //
  extern flash char STRING_START_MESSAGE[];
  extern flash char STRING_SEPARATOR[];



#endif /* PRJ_DEF_H_ */
