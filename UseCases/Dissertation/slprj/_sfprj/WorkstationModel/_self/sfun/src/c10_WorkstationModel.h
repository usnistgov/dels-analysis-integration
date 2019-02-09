#ifndef __c10_WorkstationModel_h__
#define __c10_WorkstationModel_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  int32_T c10_sfEvent;
  uint8_T c10_tp_Type2;
  uint8_T c10_tp_Type1;
  uint8_T c10_tp_ProductionState;
  uint8_T c10_tp_Available;
  uint8_T c10_tp_Not_Available;
  uint8_T c10_tp_AvailabilityState;
  uint8_T c10_tp_MaintenanceState;
  uint8_T c10_tp_M0;
  uint8_T c10_tp_M1;
  boolean_T c10_isStable;
  uint8_T c10_is_active_c10_WorkstationModel;
  uint8_T c10_is_active_ProductionState;
  uint8_T c10_is_ProductionState;
  uint8_T c10_is_active_AvailabilityState;
  uint8_T c10_is_AvailabilityState;
  uint8_T c10_is_active_MaintenanceState;
  uint8_T c10_is_MaintenanceState;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  uint8_T c10_doSetSimStateSideEffects;
  const mxArray *c10_setSimStateSideEffectsInfo;
} SFc10_WorkstationModelInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c10_WorkstationModel_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c10_WorkstationModel_get_check_sum(mxArray *plhs[]);
extern void c10_WorkstationModel_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
