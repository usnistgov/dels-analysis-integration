#ifndef __c7_WorkstationModel_h__
#define __c7_WorkstationModel_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  int32_T c7_sfEvent;
  uint8_T c7_tp_Type2;
  uint8_T c7_tp_Type1;
  uint8_T c7_tp_Setup_State;
  boolean_T c7_isStable;
  uint8_T c7_is_active_c7_WorkstationModel;
  uint8_T c7_is_active_Setup_State;
  uint8_T c7_is_Setup_State;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  uint8_T c7_doSetSimStateSideEffects;
  const mxArray *c7_setSimStateSideEffectsInfo;
} SFc7_WorkstationModelInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c7_WorkstationModel_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c7_WorkstationModel_get_check_sum(mxArray *plhs[]);
extern void c7_WorkstationModel_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
