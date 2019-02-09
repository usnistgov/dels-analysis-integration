#ifndef __c5_WorkstationModel_h__
#define __c5_WorkstationModel_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  int32_T c5_sfEvent;
  uint8_T c5_tp_Queue;
  uint8_T c5_tp_Empty;
  uint8_T c5_tp_NotEmpty;
  uint8_T c5_tp_Available;
  uint8_T c5_tp_Unavailable;
  uint8_T c5_tp_Resource;
  uint8_T c5_tp_CallReview_Control;
  uint8_T c5_tp_CallReview;
  uint8_T c5_tp_DoNothing;
  uint8_T c5_b_tp_CallReview;
  boolean_T c5_isStable;
  uint8_T c5_is_active_c5_WorkstationModel;
  uint8_T c5_is_active_Queue;
  uint8_T c5_is_Queue;
  uint8_T c5_is_active_Resource;
  uint8_T c5_is_Resource;
  uint8_T c5_is_active_CallReview_Control;
  uint8_T c5_is_active_CallReview;
  uint8_T c5_is_CallReview;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  real_T c5_QueueLength_prev;
  real_T c5_QueueLength_start;
  real_T c5_Availability_prev;
  real_T c5_Availability_start;
  uint8_T c5_doSetSimStateSideEffects;
  const mxArray *c5_setSimStateSideEffectsInfo;
} SFc5_WorkstationModelInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c5_WorkstationModel_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c5_WorkstationModel_get_check_sum(mxArray *plhs[]);
extern void c5_WorkstationModel_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
