#ifndef __c12_WorkstationModel_h__
#define __c12_WorkstationModel_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  int32_T c12_sfEvent;
  uint8_T c12_tp_Available;
  uint8_T c12_tp_Not_Available;
  boolean_T c12_isStable;
  uint8_T c12_is_active_c12_WorkstationModel;
  uint8_T c12_is_c12_WorkstationModel;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  uint8_T c12_doSetSimStateSideEffects;
  const mxArray *c12_setSimStateSideEffectsInfo;
} SFc12_WorkstationModelInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c12_WorkstationModel_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c12_WorkstationModel_get_check_sum(mxArray *plhs[]);
extern void c12_WorkstationModel_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
