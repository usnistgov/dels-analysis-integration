/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c5_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c5_IN_NO_ACTIVE_CHILD          ((uint8_T)0U)
#define c5_IN_Empty                    ((uint8_T)1U)
#define c5_IN_NotEmpty                 ((uint8_T)2U)
#define c5_IN_Available                ((uint8_T)1U)
#define c5_IN_Unavailable              ((uint8_T)2U)
#define c5_IN_DoNothing                ((uint8_T)2U)
#define c5_IN_CallReview               ((uint8_T)1U)

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void initialize_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance);
static void enable_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void c5_update_debugger_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance, const mxArray *c5_st);
static void c5_set_sim_state_side_effects_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance);
static void finalize_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance);
static void c5_CallReview_Control(SFc5_WorkstationModelInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber);
static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData);
static int32_T c5_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static uint8_T c5_b_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_b_tp_Queue, const char_T *c5_identifier);
static uint8_T c5_c_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static real_T c5_d_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_b_Availability_start, const char_T
  *c5_identifier);
static real_T c5_e_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static const mxArray *c5_f_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c5_b_setSimStateSideEffectsInfo, const char_T
  *c5_identifier);
static const mxArray *c5_g_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void init_dsm_address_info(SFc5_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  chartInstance->c5_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c5_doSetSimStateSideEffects = 0U;
  chartInstance->c5_setSimStateSideEffectsInfo = NULL;
  chartInstance->c5_is_active_CallReview_Control = 0U;
  chartInstance->c5_tp_CallReview_Control = 0U;
  chartInstance->c5_is_active_CallReview = 0U;
  chartInstance->c5_is_CallReview = 0U;
  chartInstance->c5_tp_CallReview = 0U;
  chartInstance->c5_b_tp_CallReview = 0U;
  chartInstance->c5_tp_DoNothing = 0U;
  chartInstance->c5_is_active_Queue = 0U;
  chartInstance->c5_is_Queue = 0U;
  chartInstance->c5_tp_Queue = 0U;
  chartInstance->c5_tp_Empty = 0U;
  chartInstance->c5_tp_NotEmpty = 0U;
  chartInstance->c5_is_active_Resource = 0U;
  chartInstance->c5_is_Resource = 0U;
  chartInstance->c5_tp_Resource = 0U;
  chartInstance->c5_tp_Available = 0U;
  chartInstance->c5_tp_Unavailable = 0U;
  chartInstance->c5_is_active_c5_WorkstationModel = 0U;
}

static void initialize_params_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_enable(chartInstance->S, 0, "CallReview", 0);
}

static void disable_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_disable(chartInstance->S, 0, "CallReview", 0);
}

static void c5_update_debugger_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance)
{
  uint32_T c5_prevAniVal;
  c5_prevAniVal = sf_debug_get_animation();
  sf_debug_set_animation(0U);
  if (chartInstance->c5_is_active_c5_WorkstationModel == 1) {
    _SFD_CC_CALL(CHART_ACTIVE_TAG, 4U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_active_Queue == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_Queue == c5_IN_Empty) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_Queue == c5_IN_NotEmpty) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_Resource == c5_IN_Available) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_Resource == c5_IN_Unavailable) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 9U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 9U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_active_Resource == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_active_CallReview_Control == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_active_CallReview == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_CallReview == c5_IN_DoNothing) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
  }

  if (chartInstance->c5_is_CallReview == c5_IN_CallReview) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
  }

  sf_debug_set_animation(c5_prevAniVal);
  _SFD_ANIMATE();
}

static const mxArray *get_sim_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c5_st;
  const mxArray *c5_y = NULL;
  uint8_T c5_hoistedGlobal;
  uint8_T c5_u;
  const mxArray *c5_b_y = NULL;
  uint8_T c5_b_hoistedGlobal;
  uint8_T c5_b_u;
  const mxArray *c5_c_y = NULL;
  uint8_T c5_c_hoistedGlobal;
  uint8_T c5_c_u;
  const mxArray *c5_d_y = NULL;
  uint8_T c5_d_hoistedGlobal;
  uint8_T c5_d_u;
  const mxArray *c5_e_y = NULL;
  uint8_T c5_e_hoistedGlobal;
  uint8_T c5_e_u;
  const mxArray *c5_f_y = NULL;
  uint8_T c5_f_hoistedGlobal;
  uint8_T c5_f_u;
  const mxArray *c5_g_y = NULL;
  uint8_T c5_g_hoistedGlobal;
  uint8_T c5_g_u;
  const mxArray *c5_h_y = NULL;
  uint8_T c5_h_hoistedGlobal;
  uint8_T c5_h_u;
  const mxArray *c5_i_y = NULL;
  real_T c5_i_hoistedGlobal;
  real_T c5_i_u;
  const mxArray *c5_j_y = NULL;
  real_T c5_j_hoistedGlobal;
  real_T c5_j_u;
  const mxArray *c5_k_y = NULL;
  c5_st = NULL;
  c5_st = NULL;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_createcellarray(10), FALSE);
  c5_hoistedGlobal = chartInstance->c5_is_active_c5_WorkstationModel;
  c5_u = c5_hoistedGlobal;
  c5_b_y = NULL;
  sf_mex_assign(&c5_b_y, sf_mex_create("y", &c5_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 0, c5_b_y);
  c5_b_hoistedGlobal = chartInstance->c5_is_active_Queue;
  c5_b_u = c5_b_hoistedGlobal;
  c5_c_y = NULL;
  sf_mex_assign(&c5_c_y, sf_mex_create("y", &c5_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 1, c5_c_y);
  c5_c_hoistedGlobal = chartInstance->c5_is_active_Resource;
  c5_c_u = c5_c_hoistedGlobal;
  c5_d_y = NULL;
  sf_mex_assign(&c5_d_y, sf_mex_create("y", &c5_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 2, c5_d_y);
  c5_d_hoistedGlobal = chartInstance->c5_is_active_CallReview_Control;
  c5_d_u = c5_d_hoistedGlobal;
  c5_e_y = NULL;
  sf_mex_assign(&c5_e_y, sf_mex_create("y", &c5_d_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 3, c5_e_y);
  c5_e_hoistedGlobal = chartInstance->c5_is_active_CallReview;
  c5_e_u = c5_e_hoistedGlobal;
  c5_f_y = NULL;
  sf_mex_assign(&c5_f_y, sf_mex_create("y", &c5_e_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 4, c5_f_y);
  c5_f_hoistedGlobal = chartInstance->c5_is_Queue;
  c5_f_u = c5_f_hoistedGlobal;
  c5_g_y = NULL;
  sf_mex_assign(&c5_g_y, sf_mex_create("y", &c5_f_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 5, c5_g_y);
  c5_g_hoistedGlobal = chartInstance->c5_is_Resource;
  c5_g_u = c5_g_hoistedGlobal;
  c5_h_y = NULL;
  sf_mex_assign(&c5_h_y, sf_mex_create("y", &c5_g_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 6, c5_h_y);
  c5_h_hoistedGlobal = chartInstance->c5_is_CallReview;
  c5_h_u = c5_h_hoistedGlobal;
  c5_i_y = NULL;
  sf_mex_assign(&c5_i_y, sf_mex_create("y", &c5_h_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 7, c5_i_y);
  c5_i_hoistedGlobal = chartInstance->c5_Availability_start;
  c5_i_u = c5_i_hoistedGlobal;
  c5_j_y = NULL;
  sf_mex_assign(&c5_j_y, sf_mex_create("y", &c5_i_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 8, c5_j_y);
  c5_j_hoistedGlobal = chartInstance->c5_QueueLength_start;
  c5_j_u = c5_j_hoistedGlobal;
  c5_k_y = NULL;
  sf_mex_assign(&c5_k_y, sf_mex_create("y", &c5_j_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 9, c5_k_y);
  sf_mex_assign(&c5_st, c5_y, FALSE);
  return c5_st;
}

static void set_sim_state_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance, const mxArray *c5_st)
{
  const mxArray *c5_u;
  c5_u = sf_mex_dup(c5_st);
  chartInstance->c5_is_active_c5_WorkstationModel = c5_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c5_u, 0)),
     "is_active_c5_WorkstationModel");
  chartInstance->c5_is_active_Queue = c5_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 1)), "is_active_Queue");
  chartInstance->c5_is_active_Resource = c5_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 2)), "is_active_Resource");
  chartInstance->c5_is_active_CallReview_Control = c5_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c5_u, 3)),
     "is_active_CallReview_Control");
  chartInstance->c5_is_active_CallReview = c5_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 4)), "is_active_CallReview");
  chartInstance->c5_is_Queue = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c5_u, 5)), "is_Queue");
  chartInstance->c5_is_Resource = c5_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 6)), "is_Resource");
  chartInstance->c5_is_CallReview = c5_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 7)), "is_CallReview");
  chartInstance->c5_Availability_start = c5_d_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 8)), "Availability_start");
  chartInstance->c5_QueueLength_start = c5_d_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 9)), "QueueLength_start");
  sf_mex_assign(&chartInstance->c5_setSimStateSideEffectsInfo,
                c5_f_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c5_u, 10)), "setSimStateSideEffectsInfo"), TRUE);
  sf_mex_destroy(&c5_u);
  chartInstance->c5_doSetSimStateSideEffects = 1U;
  c5_update_debugger_state_c5_WorkstationModel(chartInstance);
  sf_mex_destroy(&c5_st);
}

static void c5_set_sim_state_side_effects_c5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance)
{
  if (chartInstance->c5_doSetSimStateSideEffects != 0) {
    if (chartInstance->c5_is_active_CallReview_Control == 1) {
      chartInstance->c5_tp_CallReview_Control = 1U;
    } else {
      chartInstance->c5_tp_CallReview_Control = 0U;
    }

    if (chartInstance->c5_is_active_Queue == 1) {
      chartInstance->c5_tp_Queue = 1U;
    } else {
      chartInstance->c5_tp_Queue = 0U;
    }

    if (chartInstance->c5_is_Queue == c5_IN_Empty) {
      chartInstance->c5_tp_Empty = 1U;
    } else {
      chartInstance->c5_tp_Empty = 0U;
    }

    if (chartInstance->c5_is_Queue == c5_IN_NotEmpty) {
      chartInstance->c5_tp_NotEmpty = 1U;
    } else {
      chartInstance->c5_tp_NotEmpty = 0U;
    }

    if (chartInstance->c5_is_active_Resource == 1) {
      chartInstance->c5_tp_Resource = 1U;
    } else {
      chartInstance->c5_tp_Resource = 0U;
    }

    if (chartInstance->c5_is_Resource == c5_IN_Available) {
      chartInstance->c5_tp_Available = 1U;
    } else {
      chartInstance->c5_tp_Available = 0U;
    }

    if (chartInstance->c5_is_Resource == c5_IN_Unavailable) {
      chartInstance->c5_tp_Unavailable = 1U;
    } else {
      chartInstance->c5_tp_Unavailable = 0U;
    }

    if (chartInstance->c5_is_active_CallReview == 1) {
      chartInstance->c5_tp_CallReview = 1U;
    } else {
      chartInstance->c5_tp_CallReview = 0U;
    }

    if (chartInstance->c5_is_CallReview == c5_IN_CallReview) {
      chartInstance->c5_b_tp_CallReview = 1U;
    } else {
      chartInstance->c5_b_tp_CallReview = 0U;
    }

    if (chartInstance->c5_is_CallReview == c5_IN_DoNothing) {
      chartInstance->c5_tp_DoNothing = 1U;
    } else {
      chartInstance->c5_tp_DoNothing = 0U;
    }

    chartInstance->c5_doSetSimStateSideEffects = 0U;
  }
}

static void finalize_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  sf_mex_destroy(&chartInstance->c5_setSimStateSideEffectsInfo);
}

static void sf_c5_WorkstationModel(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T *c5_QueueLength;
  real_T *c5_Availability;
  c5_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c5_Availability = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  c5_set_sim_state_side_effects_c5_WorkstationModel(chartInstance);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  chartInstance->c5_sfEvent = CALL_EVENT;
  chartInstance->c5_QueueLength_prev = chartInstance->c5_QueueLength_start;
  chartInstance->c5_QueueLength_start = *c5_QueueLength;
  chartInstance->c5_Availability_prev = chartInstance->c5_Availability_start;
  chartInstance->c5_Availability_start = *c5_Availability;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  if (chartInstance->c5_is_active_c5_WorkstationModel == 0) {
    chartInstance->c5_QueueLength_prev = *c5_QueueLength;
    chartInstance->c5_Availability_prev = *c5_Availability;
    _SFD_CC_CALL(CHART_ENTER_ENTRY_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
    chartInstance->c5_is_active_c5_WorkstationModel = 1U;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
    chartInstance->c5_is_active_CallReview_Control = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_CallReview_Control = 1U;
    chartInstance->c5_is_active_Queue = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_Queue = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 1U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 1U, chartInstance->c5_sfEvent);
    chartInstance->c5_is_Queue = c5_IN_Empty;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_Empty = 1U;
    chartInstance->c5_is_active_Resource = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_Resource = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 5U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
    chartInstance->c5_is_Resource = c5_IN_Available;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_Available = 1U;
    chartInstance->c5_is_active_CallReview = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_CallReview = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 8U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
    chartInstance->c5_is_CallReview = c5_IN_DoNothing;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
    chartInstance->c5_tp_DoNothing = 1U;
  } else {
    c5_CallReview_Control(chartInstance);
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc5_WorkstationModel
  (SFc5_WorkstationModelInstanceStruct *chartInstance)
{
}

static void c5_CallReview_Control(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
  boolean_T c5_out;
  boolean_T c5_b_out;
  boolean_T c5_c_out;
  boolean_T c5_d_out;
  boolean_T c5_temp;
  boolean_T c5_e_out;
  boolean_T c5_b_temp;
  boolean_T c5_f_out;
  boolean_T c5_c_temp;
  boolean_T c5_g_out;
  real_T *c5_QueueLength;
  real_T *c5_Availability;
  c5_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c5_Availability = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c5_sfEvent);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  switch (chartInstance->c5_is_Queue) {
   case c5_IN_Empty:
    CV_STATE_EVAL(4, 0, 1);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 5U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 0U, chartInstance->c5_sfEvent);
    c5_out = (CV_TRANSITION_EVAL(0U, (int32_T)_SFD_CCP_CALL(0U, 0,
                *c5_QueueLength > 0.0 != 0U, chartInstance->c5_sfEvent)) != 0);
    if (c5_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 0U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Empty = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_Queue = c5_IN_NotEmpty;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_NotEmpty = 1U;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 5U, chartInstance->c5_sfEvent);
    break;

   case c5_IN_NotEmpty:
    CV_STATE_EVAL(4, 0, 2);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 6U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 2U, chartInstance->c5_sfEvent);
    c5_b_out = (CV_TRANSITION_EVAL(2U, (int32_T)_SFD_CCP_CALL(2U, 0,
      *c5_QueueLength == 0.0 != 0U, chartInstance->c5_sfEvent)) != 0);
    if (c5_b_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_NotEmpty = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_Queue = c5_IN_Empty;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Empty = 1U;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 6U, chartInstance->c5_sfEvent);
    break;

   default:
    CV_STATE_EVAL(4, 0, 0);
    chartInstance->c5_is_Queue = c5_IN_NO_ACTIVE_CHILD;
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c5_sfEvent);
    break;
  }

  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 7U, chartInstance->c5_sfEvent);
  switch (chartInstance->c5_is_Resource) {
   case c5_IN_Available:
    CV_STATE_EVAL(7, 0, 1);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 8U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 4U, chartInstance->c5_sfEvent);
    c5_c_out = (CV_TRANSITION_EVAL(4U, (int32_T)_SFD_CCP_CALL(4U, 0,
      *c5_Availability == 0.0 != 0U, chartInstance->c5_sfEvent)) != 0);
    if (c5_c_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 4U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Available = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_Resource = c5_IN_Unavailable;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 9U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Unavailable = 1U;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 8U, chartInstance->c5_sfEvent);
    break;

   case c5_IN_Unavailable:
    CV_STATE_EVAL(7, 0, 2);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 9U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 3U, chartInstance->c5_sfEvent);
    c5_d_out = (CV_TRANSITION_EVAL(3U, (int32_T)_SFD_CCP_CALL(3U, 0,
      *c5_Availability > 0.0 != 0U, chartInstance->c5_sfEvent)) != 0);
    if (c5_d_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Unavailable = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 9U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_Resource = c5_IN_Available;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_Available = 1U;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 9U, chartInstance->c5_sfEvent);
    break;

   default:
    CV_STATE_EVAL(7, 0, 0);
    chartInstance->c5_is_Resource = c5_IN_NO_ACTIVE_CHILD;
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c5_sfEvent);
    break;
  }

  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 7U, chartInstance->c5_sfEvent);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 1U, chartInstance->c5_sfEvent);
  switch (chartInstance->c5_is_CallReview) {
   case c5_IN_CallReview:
    CV_STATE_EVAL(1, 0, 1);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 2U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 7U, chartInstance->c5_sfEvent);
    c5_temp = (_SFD_CCP_CALL(7U, 0, chartInstance->c5_is_Queue == c5_IN_Empty !=
                0U, chartInstance->c5_sfEvent) != 0);
    if (!c5_temp) {
      c5_temp = (_SFD_CCP_CALL(7U, 1, chartInstance->c5_is_Resource ==
                  c5_IN_Unavailable != 0U, chartInstance->c5_sfEvent) != 0);
    }

    c5_e_out = (CV_TRANSITION_EVAL(7U, (int32_T)c5_temp) != 0);
    if (c5_e_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 7U, chartInstance->c5_sfEvent);
      chartInstance->c5_b_tp_CallReview = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_CallReview = c5_IN_DoNothing;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_DoNothing = 1U;
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 9U,
                   chartInstance->c5_sfEvent);
      c5_b_temp = (_SFD_CCP_CALL(9U, 0, chartInstance->c5_QueueLength_prev !=
        chartInstance->c5_QueueLength_start != 0U, chartInstance->c5_sfEvent) !=
                   0);
      if (!c5_b_temp) {
        c5_b_temp = (_SFD_CCP_CALL(9U, 1, chartInstance->c5_Availability_prev !=
          chartInstance->c5_Availability_start != 0U, chartInstance->c5_sfEvent)
                     != 0);
      }

      c5_f_out = (CV_TRANSITION_EVAL(9U, (int32_T)c5_b_temp) != 0);
      if (c5_f_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 9U, chartInstance->c5_sfEvent);
        chartInstance->c5_b_tp_CallReview = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
        chartInstance->c5_is_CallReview = c5_IN_CallReview;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
        chartInstance->c5_b_tp_CallReview = 1U;
        sf_call_output_fcn_call(chartInstance->S, 0, "CallReview", 0);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c5_sfEvent);
    break;

   case c5_IN_DoNothing:
    CV_STATE_EVAL(1, 0, 2);
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 3U, chartInstance->c5_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 6U, chartInstance->c5_sfEvent);
    c5_c_temp = (_SFD_CCP_CALL(6U, 0, chartInstance->c5_is_Queue ==
      c5_IN_NotEmpty != 0U, chartInstance->c5_sfEvent) != 0);
    if (c5_c_temp) {
      c5_c_temp = (_SFD_CCP_CALL(6U, 1, chartInstance->c5_is_Resource ==
        c5_IN_Available != 0U, chartInstance->c5_sfEvent) != 0);
    }

    c5_g_out = (CV_TRANSITION_EVAL(6U, (int32_T)c5_c_temp) != 0);
    if (c5_g_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 6U, chartInstance->c5_sfEvent);
      chartInstance->c5_tp_DoNothing = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c5_sfEvent);
      chartInstance->c5_is_CallReview = c5_IN_CallReview;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
      chartInstance->c5_b_tp_CallReview = 1U;
      sf_call_output_fcn_call(chartInstance->S, 0, "CallReview", 0);
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 3U, chartInstance->c5_sfEvent);
    break;

   default:
    CV_STATE_EVAL(1, 0, 0);
    chartInstance->c5_is_CallReview = c5_IN_NO_ACTIVE_CHILD;
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c5_sfEvent);
    break;
  }

  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c5_sfEvent);
  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c5_sfEvent);
}

static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber)
{
}

const mxArray *sf_c5_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c5_nameCaptureInfo = NULL;
  c5_nameCaptureInfo = NULL;
  sf_mex_assign(&c5_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c5_nameCaptureInfo;
}

static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  int32_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(int32_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static int32_T c5_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  int32_T c5_y;
  int32_T c5_i0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_i0, 1, 6, 0U, 0, 0U, 0);
  c5_y = c5_i0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_sfEvent;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  int32_T c5_y;
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c5_b_sfEvent = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_sfEvent), &c5_thisId);
  sf_mex_destroy(&c5_b_sfEvent);
  *(int32_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  uint8_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(uint8_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static uint8_T c5_b_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_b_tp_Queue, const char_T *c5_identifier)
{
  uint8_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_tp_Queue),
    &c5_thisId);
  sf_mex_destroy(&c5_b_tp_Queue);
  return c5_y;
}

static uint8_T c5_c_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  uint8_T c5_y;
  uint8_T c5_u0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_u0, 1, 3, 0U, 0, 0U, 0);
  c5_y = c5_u0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_tp_Queue;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  uint8_T c5_y;
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c5_b_tp_Queue = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_tp_Queue),
    &c5_thisId);
  sf_mex_destroy(&c5_b_tp_Queue);
  *(uint8_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  real_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(real_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static real_T c5_d_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_b_Availability_start, const char_T
  *c5_identifier)
{
  real_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_Availability_start),
    &c5_thisId);
  sf_mex_destroy(&c5_b_Availability_start);
  return c5_y;
}

static real_T c5_e_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  real_T c5_y;
  real_T c5_d0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_d0, 1, 0, 0U, 0, 0U, 0);
  c5_y = c5_d0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static const mxArray *c5_f_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c5_b_setSimStateSideEffectsInfo, const char_T
  *c5_identifier)
{
  const mxArray *c5_y = NULL;
  emlrtMsgIdentifier c5_thisId;
  c5_y = NULL;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  sf_mex_assign(&c5_y, c5_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c5_b_setSimStateSideEffectsInfo), &c5_thisId), FALSE);
  sf_mex_destroy(&c5_b_setSimStateSideEffectsInfo);
  return c5_y;
}

static const mxArray *c5_g_emlrt_marshallIn(SFc5_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  const mxArray *c5_y = NULL;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_duplicatearraysafe(&c5_u), FALSE);
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void init_dsm_address_info(SFc5_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c5_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3285054358U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(240773782U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3792794539U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3359559234U);
}

mxArray *sf_c5_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("eBEEm4ul1tmU4emgHfbkp");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
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
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c5_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x10'type','srcId','name','auxInfo'{{M[8],M[0],T\"is_active_c5_WorkstationModel\",},{M[8],M[28],T\"is_active_Queue\",},{M[8],M[35],T\"is_active_Resource\",},{M[8],M[71],T\"is_active_CallReview_Control\",},{M[8],M[76],T\"is_active_CallReview\",},{M[9],M[28],T\"is_Queue\",},{M[9],M[35],T\"is_Resource\",},{M[9],M[76],T\"is_CallReview\",},{M[12],M[90],T\"Availability_start\",},{M[12],M[91],T\"QueueLength_start\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 10, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c5_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc5_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc5_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           5,
           10,
           10,
           2,
           1,
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
            1,
            1,
            1);
          _SFD_SET_DATA_PROPS(0,1,1,0,"Availability");
          _SFD_SET_DATA_PROPS(1,1,1,0,"QueueLength");
          _SFD_EVENT_SCOPE(0,2);
          _SFD_STATE_INFO(0,1,1);
          _SFD_STATE_INFO(1,0,1);
          _SFD_STATE_INFO(2,0,0);
          _SFD_STATE_INFO(3,0,0);
          _SFD_STATE_INFO(4,0,1);
          _SFD_STATE_INFO(5,0,0);
          _SFD_STATE_INFO(6,0,0);
          _SFD_STATE_INFO(7,0,1);
          _SFD_STATE_INFO(8,0,0);
          _SFD_STATE_INFO(9,0,0);
          _SFD_CH_SUBSTATE_COUNT(1);
          _SFD_CH_SUBSTATE_DECOMP(1);
          _SFD_CH_SUBSTATE_INDEX(0,0);
          _SFD_ST_SUBSTATE_COUNT(0,3);
          _SFD_ST_SUBSTATE_INDEX(0,0,4);
          _SFD_ST_SUBSTATE_INDEX(0,1,7);
          _SFD_ST_SUBSTATE_INDEX(0,2,1);
          _SFD_ST_SUBSTATE_COUNT(4,2);
          _SFD_ST_SUBSTATE_INDEX(4,0,5);
          _SFD_ST_SUBSTATE_INDEX(4,1,6);
          _SFD_ST_SUBSTATE_COUNT(5,0);
          _SFD_ST_SUBSTATE_COUNT(6,0);
          _SFD_ST_SUBSTATE_COUNT(7,2);
          _SFD_ST_SUBSTATE_INDEX(7,0,8);
          _SFD_ST_SUBSTATE_INDEX(7,1,9);
          _SFD_ST_SUBSTATE_COUNT(8,0);
          _SFD_ST_SUBSTATE_COUNT(9,0);
          _SFD_ST_SUBSTATE_COUNT(1,2);
          _SFD_ST_SUBSTATE_INDEX(1,0,2);
          _SFD_ST_SUBSTATE_INDEX(1,1,3);
          _SFD_ST_SUBSTATE_COUNT(2,0);
          _SFD_ST_SUBSTATE_COUNT(3,0);
        }

        _SFD_CV_INIT_CHART(1,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,3,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(1,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(2,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(3,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(4,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(5,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(6,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(7,2,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(8,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(9,0,0,0,0,0,NULL,NULL);
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(0,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(1,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(2,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(4,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(3,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(5,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1, 23 };

          static unsigned int sEndGuardMap[] = { 19, 45 };

          static int sPostFixPredicateTree[] = { 0, 1, -3 };

          _SFD_CV_INIT_TRANS(6,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1, 20 };

          static unsigned int sEndGuardMap[] = { 16, 44 };

          static int sPostFixPredicateTree[] = { 0, 1, -2 };

          _SFD_CV_INIT_TRANS(7,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(8,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1, 28 };

          static unsigned int sEndGuardMap[] = { 24, 52 };

          static int sPostFixPredicateTree[] = { 0, 1, -2 };

          _SFD_CV_INIT_TRANS(9,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_TRANS_COV_WTS(0,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 15 };

          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(1,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(1,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(2,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          _SFD_TRANS_COV_MAPS(2,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(4,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          _SFD_TRANS_COV_MAPS(4,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(3,0,1,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          _SFD_TRANS_COV_MAPS(3,
                              0,NULL,NULL,
                              1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(5,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(5,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(6,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 23 };

          static unsigned int sEndGuardMap[] = { 19, 45 };

          _SFD_TRANS_COV_MAPS(6,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(7,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 20 };

          static unsigned int sEndGuardMap[] = { 16, 44 };

          _SFD_TRANS_COV_MAPS(7,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(8,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(8,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(9,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 28 };

          static unsigned int sEndGuardMap[] = { 24, 52 };

          _SFD_TRANS_COV_MAPS(9,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c5_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c5_c_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c5_Availability;
          real_T *c5_QueueLength;
          c5_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c5_Availability = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c5_Availability);
          _SFD_SET_DATA_VALUE_PTR(1U, c5_QueueLength);
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
  return "IULxJImerjIggJZFyvUlSH";
}

static void sf_opaque_initialize_c5_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c5_WorkstationModel(void *chartInstanceVar)
{
  enable_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c5_WorkstationModel(void *chartInstanceVar)
{
  disable_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c5_WorkstationModel(void *chartInstanceVar)
{
  sf_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c5_WorkstationModel(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c5_WorkstationModel
    ((SFc5_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c5_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c5_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c5_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c5_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c5_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c5_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc5_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c5_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c5_WorkstationModel((SFc5_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c5_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      5);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,5,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,5,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_mark_output_events_with_multiple_callers(S,sf_get_instance_specialization
      (),infoStruct,5,1);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,5,2);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,5);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(4113611933U));
  ssSetChecksum1(S,(4210754135U));
  ssSetChecksum2(S,(2775991624U));
  ssSetChecksum3(S,(1157940215U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c5_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Stateflow");
  }
}

static void mdlStart_c5_WorkstationModel(SimStruct *S)
{
  SFc5_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc5_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc5_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c5_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c5_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c5_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c5_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c5_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c5_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c5_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c5_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c5_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c5_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c5_WorkstationModel;
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

void c5_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c5_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c5_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c5_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c5_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
