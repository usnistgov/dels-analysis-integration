#ifndef __c11_WorkstationModel_h__
#define __c11_WorkstationModel_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  int32_T c11_sfEvent;
  boolean_T c11_isStable;
  boolean_T c11_doneDoubleBufferReInit;
  uint8_T c11_is_active_c11_WorkstationModel;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
} SFc11_WorkstationModelInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c11_WorkstationModel_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c11_WorkstationModel_get_check_sum(mxArray *plhs[]);
extern void c11_WorkstationModel_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
