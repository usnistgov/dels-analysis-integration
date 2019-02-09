/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c10_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c10_IN_NO_ACTIVE_CHILD         ((uint8_T)0U)
#define c10_IN_Type2                   ((uint8_T)2U)
#define c10_IN_Type1                   ((uint8_T)1U)
#define c10_IN_Available               ((uint8_T)1U)
#define c10_IN_Not_Available           ((uint8_T)2U)
#define c10_IN_M0                      ((uint8_T)1U)
#define c10_IN_M1                      ((uint8_T)2U)

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void initialize_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static void enable_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance);
static void c10_update_debugger_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray *c10_st);
static void c10_set_sim_state_side_effects_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static void finalize_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance);
static void c10_chartstep_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static void initSimStructsc10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c10_machineNumber, uint32_T
  c10_chartNumber);
static const mxArray *c10_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData);
static int32_T c10_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId);
static void c10_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData);
static const mxArray *c10_b_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData);
static uint8_T c10_b_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_b_tp_Type2, const char_T *c10_identifier);
static uint8_T c10_c_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId);
static void c10_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData);
static const mxArray *c10_c_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData);
static real_T c10_d_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_ProductionState, const char_T
  *c10_identifier);
static real_T c10_e_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId);
static void c10_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData);
static const mxArray *c10_f_emlrt_marshallIn
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray
   *c10_b_setSimStateSideEffectsInfo, const char_T *c10_identifier);
static const mxArray *c10_g_emlrt_marshallIn
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray *c10_u,
   const emlrtMsgIdentifier *c10_parentId);
static void init_dsm_address_info(SFc10_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T *c10_ProductionState;
  real_T *c10_Availability;
  c10_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c10_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c10_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c10_doSetSimStateSideEffects = 0U;
  chartInstance->c10_setSimStateSideEffectsInfo = NULL;
  chartInstance->c10_is_active_AvailabilityState = 0U;
  chartInstance->c10_is_AvailabilityState = 0U;
  chartInstance->c10_tp_AvailabilityState = 0U;
  chartInstance->c10_tp_Available = 0U;
  chartInstance->c10_tp_Not_Available = 0U;
  chartInstance->c10_is_active_MaintenanceState = 0U;
  chartInstance->c10_is_MaintenanceState = 0U;
  chartInstance->c10_tp_MaintenanceState = 0U;
  chartInstance->c10_tp_M0 = 0U;
  chartInstance->c10_tp_M1 = 0U;
  chartInstance->c10_is_active_ProductionState = 0U;
  chartInstance->c10_is_ProductionState = 0U;
  chartInstance->c10_tp_ProductionState = 0U;
  chartInstance->c10_tp_Type1 = 0U;
  chartInstance->c10_tp_Type2 = 0U;
  chartInstance->c10_is_active_c10_WorkstationModel = 0U;
  if (!(cdrGetOutputPortReusable(chartInstance->S, 1) != 0)) {
    *c10_ProductionState = 0.0;
  }

  if (!(cdrGetOutputPortReusable(chartInstance->S, 2) != 0)) {
    *c10_Availability = 0.0;
  }
}

static void initialize_params_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_enable(chartInstance->S, 0, "CallSetup", 0);
  sf_call_output_fcn_enable(chartInstance->S, 1, "CallMaintenance", 0);
}

static void disable_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_disable(chartInstance->S, 0, "CallSetup", 0);
  sf_call_output_fcn_disable(chartInstance->S, 1, "CallMaintenance", 0);
}

static void c10_update_debugger_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
  uint32_T c10_prevAniVal;
  c10_prevAniVal = sf_debug_get_animation();
  sf_debug_set_animation(0U);
  if (chartInstance->c10_is_active_c10_WorkstationModel == 1) {
    _SFD_CC_CALL(CHART_ACTIVE_TAG, 9U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_ProductionState == c10_IN_Type2) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_ProductionState == c10_IN_Type1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_active_ProductionState == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_AvailabilityState == c10_IN_Available) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_AvailabilityState == c10_IN_Not_Available) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_active_AvailabilityState == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_active_MaintenanceState == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_MaintenanceState == c10_IN_M0) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
  }

  if (chartInstance->c10_is_MaintenanceState == c10_IN_M1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c10_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c10_sfEvent);
  }

  sf_debug_set_animation(c10_prevAniVal);
  _SFD_ANIMATE();
}

static const mxArray *get_sim_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c10_st;
  const mxArray *c10_y = NULL;
  real_T c10_hoistedGlobal;
  real_T c10_u;
  const mxArray *c10_b_y = NULL;
  real_T c10_b_hoistedGlobal;
  real_T c10_b_u;
  const mxArray *c10_c_y = NULL;
  uint8_T c10_c_hoistedGlobal;
  uint8_T c10_c_u;
  const mxArray *c10_d_y = NULL;
  uint8_T c10_d_hoistedGlobal;
  uint8_T c10_d_u;
  const mxArray *c10_e_y = NULL;
  uint8_T c10_e_hoistedGlobal;
  uint8_T c10_e_u;
  const mxArray *c10_f_y = NULL;
  uint8_T c10_f_hoistedGlobal;
  uint8_T c10_f_u;
  const mxArray *c10_g_y = NULL;
  uint8_T c10_g_hoistedGlobal;
  uint8_T c10_g_u;
  const mxArray *c10_h_y = NULL;
  uint8_T c10_h_hoistedGlobal;
  uint8_T c10_h_u;
  const mxArray *c10_i_y = NULL;
  uint8_T c10_i_hoistedGlobal;
  uint8_T c10_i_u;
  const mxArray *c10_j_y = NULL;
  real_T *c10_Availability;
  real_T *c10_ProductionState;
  c10_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c10_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c10_st = NULL;
  c10_st = NULL;
  c10_y = NULL;
  sf_mex_assign(&c10_y, sf_mex_createcellarray(9), FALSE);
  c10_hoistedGlobal = *c10_Availability;
  c10_u = c10_hoistedGlobal;
  c10_b_y = NULL;
  sf_mex_assign(&c10_b_y, sf_mex_create("y", &c10_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 0, c10_b_y);
  c10_b_hoistedGlobal = *c10_ProductionState;
  c10_b_u = c10_b_hoistedGlobal;
  c10_c_y = NULL;
  sf_mex_assign(&c10_c_y, sf_mex_create("y", &c10_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 1, c10_c_y);
  c10_c_hoistedGlobal = chartInstance->c10_is_active_c10_WorkstationModel;
  c10_c_u = c10_c_hoistedGlobal;
  c10_d_y = NULL;
  sf_mex_assign(&c10_d_y, sf_mex_create("y", &c10_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 2, c10_d_y);
  c10_d_hoistedGlobal = chartInstance->c10_is_active_ProductionState;
  c10_d_u = c10_d_hoistedGlobal;
  c10_e_y = NULL;
  sf_mex_assign(&c10_e_y, sf_mex_create("y", &c10_d_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 3, c10_e_y);
  c10_e_hoistedGlobal = chartInstance->c10_is_active_AvailabilityState;
  c10_e_u = c10_e_hoistedGlobal;
  c10_f_y = NULL;
  sf_mex_assign(&c10_f_y, sf_mex_create("y", &c10_e_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 4, c10_f_y);
  c10_f_hoistedGlobal = chartInstance->c10_is_active_MaintenanceState;
  c10_f_u = c10_f_hoistedGlobal;
  c10_g_y = NULL;
  sf_mex_assign(&c10_g_y, sf_mex_create("y", &c10_f_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 5, c10_g_y);
  c10_g_hoistedGlobal = chartInstance->c10_is_ProductionState;
  c10_g_u = c10_g_hoistedGlobal;
  c10_h_y = NULL;
  sf_mex_assign(&c10_h_y, sf_mex_create("y", &c10_g_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 6, c10_h_y);
  c10_h_hoistedGlobal = chartInstance->c10_is_AvailabilityState;
  c10_h_u = c10_h_hoistedGlobal;
  c10_i_y = NULL;
  sf_mex_assign(&c10_i_y, sf_mex_create("y", &c10_h_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 7, c10_i_y);
  c10_i_hoistedGlobal = chartInstance->c10_is_MaintenanceState;
  c10_i_u = c10_i_hoistedGlobal;
  c10_j_y = NULL;
  sf_mex_assign(&c10_j_y, sf_mex_create("y", &c10_i_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c10_y, 8, c10_j_y);
  sf_mex_assign(&c10_st, c10_y, FALSE);
  return c10_st;
}

static void set_sim_state_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray *c10_st)
{
  const mxArray *c10_u;
  real_T *c10_Availability;
  real_T *c10_ProductionState;
  c10_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c10_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c10_u = sf_mex_dup(c10_st);
  *c10_Availability = c10_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c10_u, 0)), "Availability");
  *c10_ProductionState = c10_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c10_u, 1)), "ProductionState");
  chartInstance->c10_is_active_c10_WorkstationModel = c10_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c10_u, 2)),
     "is_active_c10_WorkstationModel");
  chartInstance->c10_is_active_ProductionState = c10_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c10_u, 3)),
     "is_active_ProductionState");
  chartInstance->c10_is_active_AvailabilityState = c10_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c10_u, 4)),
     "is_active_AvailabilityState");
  chartInstance->c10_is_active_MaintenanceState = c10_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c10_u, 5)),
     "is_active_MaintenanceState");
  chartInstance->c10_is_ProductionState = c10_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c10_u, 6)), "is_ProductionState");
  chartInstance->c10_is_AvailabilityState = c10_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c10_u, 7)), "is_AvailabilityState");
  chartInstance->c10_is_MaintenanceState = c10_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c10_u, 8)), "is_MaintenanceState");
  sf_mex_assign(&chartInstance->c10_setSimStateSideEffectsInfo,
                c10_f_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c10_u, 9)), "setSimStateSideEffectsInfo"), TRUE);
  sf_mex_destroy(&c10_u);
  chartInstance->c10_doSetSimStateSideEffects = 1U;
  c10_update_debugger_state_c10_WorkstationModel(chartInstance);
  sf_mex_destroy(&c10_st);
}

static void c10_set_sim_state_side_effects_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
  if (chartInstance->c10_doSetSimStateSideEffects != 0) {
    if (chartInstance->c10_is_active_ProductionState == 1) {
      chartInstance->c10_tp_ProductionState = 1U;
    } else {
      chartInstance->c10_tp_ProductionState = 0U;
    }

    if (chartInstance->c10_is_ProductionState == c10_IN_Type1) {
      chartInstance->c10_tp_Type1 = 1U;
    } else {
      chartInstance->c10_tp_Type1 = 0U;
    }

    if (chartInstance->c10_is_ProductionState == c10_IN_Type2) {
      chartInstance->c10_tp_Type2 = 1U;
    } else {
      chartInstance->c10_tp_Type2 = 0U;
    }

    if (chartInstance->c10_is_active_AvailabilityState == 1) {
      chartInstance->c10_tp_AvailabilityState = 1U;
    } else {
      chartInstance->c10_tp_AvailabilityState = 0U;
    }

    if (chartInstance->c10_is_AvailabilityState == c10_IN_Available) {
      chartInstance->c10_tp_Available = 1U;
    } else {
      chartInstance->c10_tp_Available = 0U;
    }

    if (chartInstance->c10_is_AvailabilityState == c10_IN_Not_Available) {
      chartInstance->c10_tp_Not_Available = 1U;
    } else {
      chartInstance->c10_tp_Not_Available = 0U;
    }

    if (chartInstance->c10_is_active_MaintenanceState == 1) {
      chartInstance->c10_tp_MaintenanceState = 1U;
    } else {
      chartInstance->c10_tp_MaintenanceState = 0U;
    }

    if (chartInstance->c10_is_MaintenanceState == c10_IN_M0) {
      chartInstance->c10_tp_M0 = 1U;
    } else {
      chartInstance->c10_tp_M0 = 0U;
    }

    if (chartInstance->c10_is_MaintenanceState == c10_IN_M1) {
      chartInstance->c10_tp_M1 = 1U;
    } else {
      chartInstance->c10_tp_M1 = 0U;
    }

    chartInstance->c10_doSetSimStateSideEffects = 0U;
  }
}

static void finalize_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
  sf_mex_destroy(&chartInstance->c10_setSimStateSideEffectsInfo);
}

static void sf_c10_WorkstationModel(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
  c10_set_sim_state_side_effects_c10_WorkstationModel(chartInstance);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 9U, chartInstance->c10_sfEvent);
  chartInstance->c10_sfEvent = CALL_EVENT;
  c10_chartstep_c10_WorkstationModel(chartInstance);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c10_chartstep_c10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
  boolean_T c10_out;
  boolean_T c10_b_out;
  boolean_T c10_temp;
  boolean_T c10_c_out;
  boolean_T c10_b_temp;
  boolean_T c10_d_out;
  boolean_T c10_e_out;
  boolean_T c10_f_out;
  real_T *c10_SetupState;
  real_T *c10_ProductionState;
  real_T *c10_Busy;
  real_T *c10_QueueLength;
  real_T *c10_Availability;
  real_T *c10_CompletedJobCount;
  c10_CompletedJobCount = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
  c10_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c10_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c10_Busy = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c10_SetupState = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  c10_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 9U, chartInstance->c10_sfEvent);
  if (chartInstance->c10_is_active_c10_WorkstationModel == 0) {
    _SFD_CC_CALL(CHART_ENTER_ENTRY_FUNCTION_TAG, 9U, chartInstance->c10_sfEvent);
    chartInstance->c10_is_active_c10_WorkstationModel = 1U;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 9U, chartInstance->c10_sfEvent);
    chartInstance->c10_is_active_ProductionState = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_ProductionState = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 0U,
                 chartInstance->c10_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 0U, chartInstance->c10_sfEvent);
    chartInstance->c10_is_ProductionState = c10_IN_Type1;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_Type1 = 1U;
    sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
    chartInstance->c10_is_active_AvailabilityState = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_AvailabilityState = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 3U,
                 chartInstance->c10_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 3U, chartInstance->c10_sfEvent);
    chartInstance->c10_is_AvailabilityState = c10_IN_Available;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_Available = 1U;
    *c10_Availability = 1.0;
    chartInstance->c10_is_active_MaintenanceState = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_MaintenanceState = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 6U,
                 chartInstance->c10_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 6U, chartInstance->c10_sfEvent);
    chartInstance->c10_is_MaintenanceState = c10_IN_M0;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
    chartInstance->c10_tp_M0 = 1U;
  } else {
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 6U, chartInstance->c10_sfEvent);
    switch (chartInstance->c10_is_ProductionState) {
     case c10_IN_Type1:
      CV_STATE_EVAL(6, 0, 1);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 7U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 1U,
                   chartInstance->c10_sfEvent);
      c10_out = (CV_TRANSITION_EVAL(1U, (int32_T)_SFD_CCP_CALL(1U, 0,
        *c10_SetupState == 2.0 != 0U, chartInstance->c10_sfEvent)) != 0);
      if (c10_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Type1 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_ProductionState = c10_IN_Type2;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Type2 = 1U;
        sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
      } else {
        *c10_ProductionState = 1.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 7U, chartInstance->c10_sfEvent);
      break;

     case c10_IN_Type2:
      CV_STATE_EVAL(6, 0, 2);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 8U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 2U,
                   chartInstance->c10_sfEvent);
      c10_b_out = (CV_TRANSITION_EVAL(2U, (int32_T)_SFD_CCP_CALL(2U, 0,
        *c10_SetupState == 1.0 != 0U, chartInstance->c10_sfEvent)) != 0);
      if (c10_b_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 2U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Type2 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_ProductionState = c10_IN_Type1;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Type1 = 1U;
        sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
      } else {
        *c10_ProductionState = 2.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 8U, chartInstance->c10_sfEvent);
      break;

     default:
      CV_STATE_EVAL(6, 0, 0);
      chartInstance->c10_is_ProductionState = c10_IN_NO_ACTIVE_CHILD;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
      break;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 6U, chartInstance->c10_sfEvent);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c10_sfEvent);
    switch (chartInstance->c10_is_AvailabilityState) {
     case c10_IN_Available:
      CV_STATE_EVAL(0, 0, 1);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 1U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 5U,
                   chartInstance->c10_sfEvent);
      c10_temp = (_SFD_CCP_CALL(5U, 0, *c10_Busy == 1.0 != 0U,
        chartInstance->c10_sfEvent) != 0);
      if (!c10_temp) {
        c10_temp = (_SFD_CCP_CALL(5U, 1, *c10_QueueLength > 0.0 != 0U,
          chartInstance->c10_sfEvent) != 0);
      }

      c10_c_out = (CV_TRANSITION_EVAL(5U, (int32_T)c10_temp) != 0);
      if (c10_c_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 5U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Available = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_AvailabilityState = c10_IN_Not_Available;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Not_Available = 1U;
        *c10_Availability = 0.0;
      } else {
        *c10_Availability = 1.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c10_sfEvent);
      break;

     case c10_IN_Not_Available:
      CV_STATE_EVAL(0, 0, 2);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 2U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 4U,
                   chartInstance->c10_sfEvent);
      c10_b_temp = (_SFD_CCP_CALL(4U, 0, *c10_Busy == 0.0 != 0U,
        chartInstance->c10_sfEvent) != 0);
      if (c10_b_temp) {
        c10_b_temp = (_SFD_CCP_CALL(4U, 1, *c10_QueueLength == 0.0 != 0U,
          chartInstance->c10_sfEvent) != 0);
      }

      c10_d_out = (CV_TRANSITION_EVAL(4U, (int32_T)c10_b_temp) != 0);
      if (c10_d_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Not_Available = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_AvailabilityState = c10_IN_Available;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_Available = 1U;
        *c10_Availability = 1.0;
      } else {
        *c10_Availability = 0.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c10_sfEvent);
      break;

     default:
      CV_STATE_EVAL(0, 0, 0);
      chartInstance->c10_is_AvailabilityState = c10_IN_NO_ACTIVE_CHILD;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c10_sfEvent);
      break;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c10_sfEvent);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 3U, chartInstance->c10_sfEvent);
    switch (chartInstance->c10_is_MaintenanceState) {
     case c10_IN_M0:
      CV_STATE_EVAL(3, 0, 1);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 4U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 7U,
                   chartInstance->c10_sfEvent);
      c10_e_out = (CV_TRANSITION_EVAL(7U, (int32_T)_SFD_CCP_CALL(7U, 0,
        *c10_CompletedJobCount == 10.0 != 0U, chartInstance->c10_sfEvent)) != 0);
      if (c10_e_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 7U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_M0 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_MaintenanceState = c10_IN_M1;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_M1 = 1U;
        sf_call_output_fcn_call(chartInstance->S, 1, "CallMaintenance", 0);
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c10_sfEvent);
      break;

     case c10_IN_M1:
      CV_STATE_EVAL(3, 0, 2);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 5U,
                   chartInstance->c10_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 8U,
                   chartInstance->c10_sfEvent);
      c10_f_out = (CV_TRANSITION_EVAL(8U, (int32_T)_SFD_CCP_CALL(8U, 0,
        *c10_CompletedJobCount == 0.0 != 0U, chartInstance->c10_sfEvent)) != 0);
      if (c10_f_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 8U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_M1 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c10_sfEvent);
        chartInstance->c10_is_MaintenanceState = c10_IN_M0;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
        chartInstance->c10_tp_M0 = 1U;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 5U, chartInstance->c10_sfEvent);
      break;

     default:
      CV_STATE_EVAL(3, 0, 0);
      chartInstance->c10_is_MaintenanceState = c10_IN_NO_ACTIVE_CHILD;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c10_sfEvent);
      break;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 3U, chartInstance->c10_sfEvent);
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 9U, chartInstance->c10_sfEvent);
}

static void initSimStructsc10_WorkstationModel
  (SFc10_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c10_machineNumber, uint32_T
  c10_chartNumber)
{
}

const mxArray *sf_c10_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c10_nameCaptureInfo = NULL;
  c10_nameCaptureInfo = NULL;
  sf_mex_assign(&c10_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c10_nameCaptureInfo;
}

static const mxArray *c10_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData)
{
  const mxArray *c10_mxArrayOutData = NULL;
  int32_T c10_u;
  const mxArray *c10_y = NULL;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_mxArrayOutData = NULL;
  c10_u = *(int32_T *)c10_inData;
  c10_y = NULL;
  sf_mex_assign(&c10_y, sf_mex_create("y", &c10_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c10_mxArrayOutData, c10_y, FALSE);
  return c10_mxArrayOutData;
}

static int32_T c10_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId)
{
  int32_T c10_y;
  int32_T c10_i0;
  sf_mex_import(c10_parentId, sf_mex_dup(c10_u), &c10_i0, 1, 6, 0U, 0, 0U, 0);
  c10_y = c10_i0;
  sf_mex_destroy(&c10_u);
  return c10_y;
}

static void c10_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData)
{
  const mxArray *c10_b_sfEvent;
  const char_T *c10_identifier;
  emlrtMsgIdentifier c10_thisId;
  int32_T c10_y;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_b_sfEvent = sf_mex_dup(c10_mxArrayInData);
  c10_identifier = c10_varName;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  c10_y = c10_emlrt_marshallIn(chartInstance, sf_mex_dup(c10_b_sfEvent),
    &c10_thisId);
  sf_mex_destroy(&c10_b_sfEvent);
  *(int32_T *)c10_outData = c10_y;
  sf_mex_destroy(&c10_mxArrayInData);
}

static const mxArray *c10_b_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData)
{
  const mxArray *c10_mxArrayOutData = NULL;
  uint8_T c10_u;
  const mxArray *c10_y = NULL;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_mxArrayOutData = NULL;
  c10_u = *(uint8_T *)c10_inData;
  c10_y = NULL;
  sf_mex_assign(&c10_y, sf_mex_create("y", &c10_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c10_mxArrayOutData, c10_y, FALSE);
  return c10_mxArrayOutData;
}

static uint8_T c10_b_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_b_tp_Type2, const char_T *c10_identifier)
{
  uint8_T c10_y;
  emlrtMsgIdentifier c10_thisId;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  c10_y = c10_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c10_b_tp_Type2),
    &c10_thisId);
  sf_mex_destroy(&c10_b_tp_Type2);
  return c10_y;
}

static uint8_T c10_c_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId)
{
  uint8_T c10_y;
  uint8_T c10_u0;
  sf_mex_import(c10_parentId, sf_mex_dup(c10_u), &c10_u0, 1, 3, 0U, 0, 0U, 0);
  c10_y = c10_u0;
  sf_mex_destroy(&c10_u);
  return c10_y;
}

static void c10_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData)
{
  const mxArray *c10_b_tp_Type2;
  const char_T *c10_identifier;
  emlrtMsgIdentifier c10_thisId;
  uint8_T c10_y;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_b_tp_Type2 = sf_mex_dup(c10_mxArrayInData);
  c10_identifier = c10_varName;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  c10_y = c10_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c10_b_tp_Type2),
    &c10_thisId);
  sf_mex_destroy(&c10_b_tp_Type2);
  *(uint8_T *)c10_outData = c10_y;
  sf_mex_destroy(&c10_mxArrayInData);
}

static const mxArray *c10_c_sf_marshallOut(void *chartInstanceVoid, void
  *c10_inData)
{
  const mxArray *c10_mxArrayOutData = NULL;
  real_T c10_u;
  const mxArray *c10_y = NULL;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_mxArrayOutData = NULL;
  c10_u = *(real_T *)c10_inData;
  c10_y = NULL;
  sf_mex_assign(&c10_y, sf_mex_create("y", &c10_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c10_mxArrayOutData, c10_y, FALSE);
  return c10_mxArrayOutData;
}

static real_T c10_d_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_ProductionState, const char_T
  *c10_identifier)
{
  real_T c10_y;
  emlrtMsgIdentifier c10_thisId;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  c10_y = c10_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c10_ProductionState),
    &c10_thisId);
  sf_mex_destroy(&c10_ProductionState);
  return c10_y;
}

static real_T c10_e_emlrt_marshallIn(SFc10_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c10_u, const emlrtMsgIdentifier *c10_parentId)
{
  real_T c10_y;
  real_T c10_d0;
  sf_mex_import(c10_parentId, sf_mex_dup(c10_u), &c10_d0, 1, 0, 0U, 0, 0U, 0);
  c10_y = c10_d0;
  sf_mex_destroy(&c10_u);
  return c10_y;
}

static void c10_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c10_mxArrayInData, const char_T *c10_varName, void *c10_outData)
{
  const mxArray *c10_ProductionState;
  const char_T *c10_identifier;
  emlrtMsgIdentifier c10_thisId;
  real_T c10_y;
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c10_ProductionState = sf_mex_dup(c10_mxArrayInData);
  c10_identifier = c10_varName;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  c10_y = c10_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c10_ProductionState),
    &c10_thisId);
  sf_mex_destroy(&c10_ProductionState);
  *(real_T *)c10_outData = c10_y;
  sf_mex_destroy(&c10_mxArrayInData);
}

static const mxArray *c10_f_emlrt_marshallIn
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray
   *c10_b_setSimStateSideEffectsInfo, const char_T *c10_identifier)
{
  const mxArray *c10_y = NULL;
  emlrtMsgIdentifier c10_thisId;
  c10_y = NULL;
  c10_thisId.fIdentifier = c10_identifier;
  c10_thisId.fParent = NULL;
  sf_mex_assign(&c10_y, c10_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c10_b_setSimStateSideEffectsInfo), &c10_thisId), FALSE);
  sf_mex_destroy(&c10_b_setSimStateSideEffectsInfo);
  return c10_y;
}

static const mxArray *c10_g_emlrt_marshallIn
  (SFc10_WorkstationModelInstanceStruct *chartInstance, const mxArray *c10_u,
   const emlrtMsgIdentifier *c10_parentId)
{
  const mxArray *c10_y = NULL;
  c10_y = NULL;
  sf_mex_assign(&c10_y, sf_mex_duplicatearraysafe(&c10_u), FALSE);
  sf_mex_destroy(&c10_u);
  return c10_y;
}

static void init_dsm_address_info(SFc10_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c10_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1466504032U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1192777855U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2195283339U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1597319122U);
}

mxArray *sf_c10_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("kNjEqAbRKaKQe7wEWEEgiH");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,4,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c10_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x9'type','srcId','name','auxInfo'{{M[1],M[49],T\"Availability\",},{M[1],M[18],T\"ProductionState\",},{M[8],M[0],T\"is_active_c10_WorkstationModel\",},{M[8],M[28],T\"is_active_ProductionState\",},{M[8],M[46],T\"is_active_AvailabilityState\",},{M[8],M[50],T\"is_active_MaintenanceState\",},{M[9],M[28],T\"is_ProductionState\",},{M[9],M[46],T\"is_AvailabilityState\",},{M[9],M[50],T\"is_MaintenanceState\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 9, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c10_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc10_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc10_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           10,
           9,
           9,
           6,
           2,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_WorkstationModelMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (_WorkstationModelMachineNumber_,chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(_WorkstationModelMachineNumber_,
            chartInstance->chartNumber,
            2,
            2,
            2);
          _SFD_SET_DATA_PROPS(0,2,0,1,"ProductionState");
          _SFD_SET_DATA_PROPS(1,1,1,0,"SetupState");
          _SFD_SET_DATA_PROPS(2,1,1,0,"Busy");
          _SFD_SET_DATA_PROPS(3,1,1,0,"QueueLength");
          _SFD_SET_DATA_PROPS(4,2,0,1,"Availability");
          _SFD_SET_DATA_PROPS(5,1,1,0,"CompletedJobCount");
          _SFD_EVENT_SCOPE(0,2);
          _SFD_EVENT_SCOPE(1,2);
          _SFD_STATE_INFO(0,0,1);
          _SFD_STATE_INFO(1,0,0);
          _SFD_STATE_INFO(2,0,0);
          _SFD_STATE_INFO(3,0,1);
          _SFD_STATE_INFO(4,0,0);
          _SFD_STATE_INFO(5,0,0);
          _SFD_STATE_INFO(6,0,1);
          _SFD_STATE_INFO(7,0,0);
          _SFD_STATE_INFO(8,0,0);
          _SFD_CH_SUBSTATE_COUNT(3);
          _SFD_CH_SUBSTATE_DECOMP(1);
          _SFD_CH_SUBSTATE_INDEX(0,6);
          _SFD_CH_SUBSTATE_INDEX(1,0);
          _SFD_CH_SUBSTATE_INDEX(2,3);
          _SFD_ST_SUBSTATE_COUNT(6,2);
          _SFD_ST_SUBSTATE_INDEX(6,0,7);
          _SFD_ST_SUBSTATE_INDEX(6,1,8);
          _SFD_ST_SUBSTATE_COUNT(7,0);
          _SFD_ST_SUBSTATE_COUNT(8,0);
          _SFD_ST_SUBSTATE_COUNT(0,2);
          _SFD_ST_SUBSTATE_INDEX(0,0,1);
          _SFD_ST_SUBSTATE_INDEX(0,1,2);
          _SFD_ST_SUBSTATE_COUNT(1,0);
          _SFD_ST_SUBSTATE_COUNT(2,0);
          _SFD_ST_SUBSTATE_COUNT(3,2);
          _SFD_ST_SUBSTATE_INDEX(3,0,4);
          _SFD_ST_SUBSTATE_INDEX(3,1,5);
          _SFD_ST_SUBSTATE_COUNT(4,0);
          _SFD_ST_SUBSTATE_COUNT(5,0);
        }

        _SFD_CV_INIT_CHART(3,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(1,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(2,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(3,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(4,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(5,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(6,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(7,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(8,0,0,0,0,0,NULL,NULL);
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(2,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(1,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);
        _SFD_CV_INIT_TRANS(3,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1, 14 };

          static unsigned int sEndGuardMap[] = { 10, 29 };

          static int sPostFixPredicateTree[] = { 0, 1, -3 };

          _SFD_CV_INIT_TRANS(4,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1, 13 };

          static unsigned int sEndGuardMap[] = { 9, 27 };

          static int sPostFixPredicateTree[] = { 0, 1, -2 };

          _SFD_CV_INIT_TRANS(5,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(6,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 23 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(7,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 22 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(8,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_TRANS_COV_WTS(2,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          _SFD_TRANS_COV_MAPS(2,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(1,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          _SFD_TRANS_COV_MAPS(1,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(0,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(3,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(3,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(4,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 14 };

          static unsigned int sEndGuardMap[] = { 10, 29 };

          _SFD_TRANS_COV_MAPS(4,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(5,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 13 };

          static unsigned int sEndGuardMap[] = { 9, 27 };

          _SFD_TRANS_COV_MAPS(5,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(6,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(6,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(7,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 23 };

          _SFD_TRANS_COV_MAPS(7,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(8,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 22 };

          _SFD_TRANS_COV_MAPS(8,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)
          c10_c_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)
          c10_c_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c10_c_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c10_ProductionState;
          real_T *c10_SetupState;
          real_T *c10_Busy;
          real_T *c10_QueueLength;
          real_T *c10_Availability;
          real_T *c10_CompletedJobCount;
          c10_CompletedJobCount = (real_T *)ssGetInputPortSignal
            (chartInstance->S, 3);
          c10_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
          c10_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
          c10_Busy = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c10_SetupState = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          c10_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S,
            1);
          _SFD_SET_DATA_VALUE_PTR(0U, c10_ProductionState);
          _SFD_SET_DATA_VALUE_PTR(1U, c10_SetupState);
          _SFD_SET_DATA_VALUE_PTR(2U, c10_Busy);
          _SFD_SET_DATA_VALUE_PTR(3U, c10_QueueLength);
          _SFD_SET_DATA_VALUE_PTR(4U, c10_Availability);
          _SFD_SET_DATA_VALUE_PTR(5U, c10_CompletedJobCount);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(_WorkstationModelMachineNumber_,
        chartInstance->chartNumber,chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization()
{
  return "JYtZBdMCJtqMKJ8coTMm6D";
}

static void sf_opaque_initialize_c10_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c10_WorkstationModel(void *chartInstanceVar)
{
  enable_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c10_WorkstationModel(void *chartInstanceVar)
{
  disable_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c10_WorkstationModel(void *chartInstanceVar)
{
  sf_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c10_WorkstationModel(SimStruct*
  S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c10_WorkstationModel
    ((SFc10_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c10_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c10_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c10_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c10_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c10_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c10_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c10_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c10_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc10_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c10_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c10_WorkstationModel((SFc10_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c10_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      10);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,10,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,10,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_mark_output_events_with_multiple_callers(S,sf_get_instance_specialization
      (),infoStruct,10,2);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 3, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,10,4);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,10,2);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,10);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(182105952U));
  ssSetChecksum1(S,(208066104U));
  ssSetChecksum2(S,(3730691056U));
  ssSetChecksum3(S,(3135752220U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c10_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Stateflow");
  }
}

static void mdlStart_c10_WorkstationModel(SimStruct *S)
{
  SFc10_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc10_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc10_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc10_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c10_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c10_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c10_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c10_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c10_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c10_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c10_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c10_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c10_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c10_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c10_WorkstationModel;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c10_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c10_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c10_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c10_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c10_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
