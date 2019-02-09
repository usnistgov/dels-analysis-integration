/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c12_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c12_IN_NO_ACTIVE_CHILD         ((uint8_T)0U)
#define c12_IN_Available               ((uint8_T)1U)
#define c12_IN_Not_Available           ((uint8_T)2U)

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void initialize_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance);
static void enable_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance);
static void c12_update_debugger_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray *c12_st);
static void c12_set_sim_state_side_effects_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance);
static void finalize_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c12_machineNumber, uint32_T
  c12_chartNumber);
static const mxArray *c12_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData);
static int32_T c12_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId);
static void c12_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData);
static const mxArray *c12_b_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData);
static uint8_T c12_b_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_b_tp_Available, const char_T
  *c12_identifier);
static uint8_T c12_c_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId);
static void c12_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData);
static const mxArray *c12_c_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData);
static real_T c12_d_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_Availability, const char_T *c12_identifier);
static real_T c12_e_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId);
static void c12_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData);
static const mxArray *c12_f_emlrt_marshallIn
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray
   *c12_b_setSimStateSideEffectsInfo, const char_T *c12_identifier);
static const mxArray *c12_g_emlrt_marshallIn
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray *c12_u,
   const emlrtMsgIdentifier *c12_parentId);
static void init_dsm_address_info(SFc12_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T *c12_Availability;
  c12_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c12_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c12_doSetSimStateSideEffects = 0U;
  chartInstance->c12_setSimStateSideEffectsInfo = NULL;
  chartInstance->c12_tp_Available = 0U;
  chartInstance->c12_tp_Not_Available = 0U;
  chartInstance->c12_is_active_c12_WorkstationModel = 0U;
  chartInstance->c12_is_c12_WorkstationModel = 0U;
  if (!(cdrGetOutputPortReusable(chartInstance->S, 1) != 0)) {
    *c12_Availability = 0.0;
  }
}

static void initialize_params_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c12_update_debugger_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance)
{
  uint32_T c12_prevAniVal;
  c12_prevAniVal = sf_debug_get_animation();
  sf_debug_set_animation(0U);
  if (chartInstance->c12_is_active_c12_WorkstationModel == 1) {
    _SFD_CC_CALL(CHART_ACTIVE_TAG, 11U, chartInstance->c12_sfEvent);
  }

  if (chartInstance->c12_is_c12_WorkstationModel == c12_IN_Available) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
  }

  if (chartInstance->c12_is_c12_WorkstationModel == c12_IN_Not_Available) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c12_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c12_sfEvent);
  }

  sf_debug_set_animation(c12_prevAniVal);
  _SFD_ANIMATE();
}

static const mxArray *get_sim_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c12_st;
  const mxArray *c12_y = NULL;
  real_T c12_hoistedGlobal;
  real_T c12_u;
  const mxArray *c12_b_y = NULL;
  uint8_T c12_b_hoistedGlobal;
  uint8_T c12_b_u;
  const mxArray *c12_c_y = NULL;
  uint8_T c12_c_hoistedGlobal;
  uint8_T c12_c_u;
  const mxArray *c12_d_y = NULL;
  real_T *c12_Availability;
  c12_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c12_st = NULL;
  c12_st = NULL;
  c12_y = NULL;
  sf_mex_assign(&c12_y, sf_mex_createcellarray(3), FALSE);
  c12_hoistedGlobal = *c12_Availability;
  c12_u = c12_hoistedGlobal;
  c12_b_y = NULL;
  sf_mex_assign(&c12_b_y, sf_mex_create("y", &c12_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c12_y, 0, c12_b_y);
  c12_b_hoistedGlobal = chartInstance->c12_is_active_c12_WorkstationModel;
  c12_b_u = c12_b_hoistedGlobal;
  c12_c_y = NULL;
  sf_mex_assign(&c12_c_y, sf_mex_create("y", &c12_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c12_y, 1, c12_c_y);
  c12_c_hoistedGlobal = chartInstance->c12_is_c12_WorkstationModel;
  c12_c_u = c12_c_hoistedGlobal;
  c12_d_y = NULL;
  sf_mex_assign(&c12_d_y, sf_mex_create("y", &c12_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c12_y, 2, c12_d_y);
  sf_mex_assign(&c12_st, c12_y, FALSE);
  return c12_st;
}

static void set_sim_state_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray *c12_st)
{
  const mxArray *c12_u;
  real_T *c12_Availability;
  c12_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c12_u = sf_mex_dup(c12_st);
  *c12_Availability = c12_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c12_u, 0)), "Availability");
  chartInstance->c12_is_active_c12_WorkstationModel = c12_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c12_u, 1)),
     "is_active_c12_WorkstationModel");
  chartInstance->c12_is_c12_WorkstationModel = c12_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c12_u, 2)),
     "is_c12_WorkstationModel");
  sf_mex_assign(&chartInstance->c12_setSimStateSideEffectsInfo,
                c12_f_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c12_u, 3)), "setSimStateSideEffectsInfo"), TRUE);
  sf_mex_destroy(&c12_u);
  chartInstance->c12_doSetSimStateSideEffects = 1U;
  c12_update_debugger_state_c12_WorkstationModel(chartInstance);
  sf_mex_destroy(&c12_st);
}

static void c12_set_sim_state_side_effects_c12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance)
{
  if (chartInstance->c12_doSetSimStateSideEffects != 0) {
    if (chartInstance->c12_is_c12_WorkstationModel == c12_IN_Available) {
      chartInstance->c12_tp_Available = 1U;
    } else {
      chartInstance->c12_tp_Available = 0U;
    }

    if (chartInstance->c12_is_c12_WorkstationModel == c12_IN_Not_Available) {
      chartInstance->c12_tp_Not_Available = 1U;
    } else {
      chartInstance->c12_tp_Not_Available = 0U;
    }

    chartInstance->c12_doSetSimStateSideEffects = 0U;
  }
}

static void finalize_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
  sf_mex_destroy(&chartInstance->c12_setSimStateSideEffectsInfo);
}

static void sf_c12_WorkstationModel(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
  boolean_T c12_temp;
  boolean_T c12_out;
  boolean_T c12_b_temp;
  boolean_T c12_b_out;
  real_T *c12_Busy;
  real_T *c12_QueueLength;
  real_T *c12_Availability;
  c12_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c12_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c12_Busy = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  c12_set_sim_state_side_effects_c12_WorkstationModel(chartInstance);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 11U, chartInstance->c12_sfEvent);
  chartInstance->c12_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 11U, chartInstance->c12_sfEvent);
  if (chartInstance->c12_is_active_c12_WorkstationModel == 0) {
    _SFD_CC_CALL(CHART_ENTER_ENTRY_FUNCTION_TAG, 11U, chartInstance->c12_sfEvent);
    chartInstance->c12_is_active_c12_WorkstationModel = 1U;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 11U, chartInstance->c12_sfEvent);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 0U,
                 chartInstance->c12_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
    chartInstance->c12_is_c12_WorkstationModel = c12_IN_Available;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
    chartInstance->c12_tp_Available = 1U;
    *c12_Availability = 1.0;
  } else {
    switch (chartInstance->c12_is_c12_WorkstationModel) {
     case c12_IN_Available:
      CV_CHART_EVAL(11, 0, 1);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 0U,
                   chartInstance->c12_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 1U,
                   chartInstance->c12_sfEvent);
      c12_temp = (_SFD_CCP_CALL(1U, 0, *c12_Busy == 1.0 != 0U,
        chartInstance->c12_sfEvent) != 0);
      if (!c12_temp) {
        c12_temp = (_SFD_CCP_CALL(1U, 1, *c12_QueueLength > 0.0 != 0U,
          chartInstance->c12_sfEvent) != 0);
      }

      c12_out = (CV_TRANSITION_EVAL(1U, (int32_T)c12_temp) != 0);
      if (c12_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 1U, chartInstance->c12_sfEvent);
        chartInstance->c12_tp_Available = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
        chartInstance->c12_is_c12_WorkstationModel = c12_IN_Not_Available;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c12_sfEvent);
        chartInstance->c12_tp_Not_Available = 1U;
        *c12_Availability = 0.0;
      } else {
        *c12_Availability = 1.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c12_sfEvent);
      break;

     case c12_IN_Not_Available:
      CV_CHART_EVAL(11, 0, 2);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 1U,
                   chartInstance->c12_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 2U,
                   chartInstance->c12_sfEvent);
      c12_b_temp = (_SFD_CCP_CALL(2U, 0, *c12_Busy == 0.0 != 0U,
        chartInstance->c12_sfEvent) != 0);
      if (c12_b_temp) {
        c12_b_temp = (_SFD_CCP_CALL(2U, 1, *c12_QueueLength == 0.0 != 0U,
          chartInstance->c12_sfEvent) != 0);
      }

      c12_b_out = (CV_TRANSITION_EVAL(2U, (int32_T)c12_b_temp) != 0);
      if (c12_b_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 2U, chartInstance->c12_sfEvent);
        chartInstance->c12_tp_Not_Available = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c12_sfEvent);
        chartInstance->c12_is_c12_WorkstationModel = c12_IN_Available;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
        chartInstance->c12_tp_Available = 1U;
        *c12_Availability = 1.0;
      } else {
        *c12_Availability = 0.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c12_sfEvent);
      break;

     default:
      CV_CHART_EVAL(11, 0, 0);
      chartInstance->c12_is_c12_WorkstationModel = c12_IN_NO_ACTIVE_CHILD;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c12_sfEvent);
      break;
    }
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 11U, chartInstance->c12_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc12_WorkstationModel
  (SFc12_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c12_machineNumber, uint32_T
  c12_chartNumber)
{
}

const mxArray *sf_c12_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c12_nameCaptureInfo = NULL;
  c12_nameCaptureInfo = NULL;
  sf_mex_assign(&c12_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c12_nameCaptureInfo;
}

static const mxArray *c12_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData)
{
  const mxArray *c12_mxArrayOutData = NULL;
  int32_T c12_u;
  const mxArray *c12_y = NULL;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_mxArrayOutData = NULL;
  c12_u = *(int32_T *)c12_inData;
  c12_y = NULL;
  sf_mex_assign(&c12_y, sf_mex_create("y", &c12_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c12_mxArrayOutData, c12_y, FALSE);
  return c12_mxArrayOutData;
}

static int32_T c12_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId)
{
  int32_T c12_y;
  int32_T c12_i0;
  sf_mex_import(c12_parentId, sf_mex_dup(c12_u), &c12_i0, 1, 6, 0U, 0, 0U, 0);
  c12_y = c12_i0;
  sf_mex_destroy(&c12_u);
  return c12_y;
}

static void c12_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData)
{
  const mxArray *c12_b_sfEvent;
  const char_T *c12_identifier;
  emlrtMsgIdentifier c12_thisId;
  int32_T c12_y;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_b_sfEvent = sf_mex_dup(c12_mxArrayInData);
  c12_identifier = c12_varName;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  c12_y = c12_emlrt_marshallIn(chartInstance, sf_mex_dup(c12_b_sfEvent),
    &c12_thisId);
  sf_mex_destroy(&c12_b_sfEvent);
  *(int32_T *)c12_outData = c12_y;
  sf_mex_destroy(&c12_mxArrayInData);
}

static const mxArray *c12_b_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData)
{
  const mxArray *c12_mxArrayOutData = NULL;
  uint8_T c12_u;
  const mxArray *c12_y = NULL;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_mxArrayOutData = NULL;
  c12_u = *(uint8_T *)c12_inData;
  c12_y = NULL;
  sf_mex_assign(&c12_y, sf_mex_create("y", &c12_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c12_mxArrayOutData, c12_y, FALSE);
  return c12_mxArrayOutData;
}

static uint8_T c12_b_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_b_tp_Available, const char_T
  *c12_identifier)
{
  uint8_T c12_y;
  emlrtMsgIdentifier c12_thisId;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  c12_y = c12_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c12_b_tp_Available),
    &c12_thisId);
  sf_mex_destroy(&c12_b_tp_Available);
  return c12_y;
}

static uint8_T c12_c_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId)
{
  uint8_T c12_y;
  uint8_T c12_u0;
  sf_mex_import(c12_parentId, sf_mex_dup(c12_u), &c12_u0, 1, 3, 0U, 0, 0U, 0);
  c12_y = c12_u0;
  sf_mex_destroy(&c12_u);
  return c12_y;
}

static void c12_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData)
{
  const mxArray *c12_b_tp_Available;
  const char_T *c12_identifier;
  emlrtMsgIdentifier c12_thisId;
  uint8_T c12_y;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_b_tp_Available = sf_mex_dup(c12_mxArrayInData);
  c12_identifier = c12_varName;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  c12_y = c12_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c12_b_tp_Available),
    &c12_thisId);
  sf_mex_destroy(&c12_b_tp_Available);
  *(uint8_T *)c12_outData = c12_y;
  sf_mex_destroy(&c12_mxArrayInData);
}

static const mxArray *c12_c_sf_marshallOut(void *chartInstanceVoid, void
  *c12_inData)
{
  const mxArray *c12_mxArrayOutData = NULL;
  real_T c12_u;
  const mxArray *c12_y = NULL;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_mxArrayOutData = NULL;
  c12_u = *(real_T *)c12_inData;
  c12_y = NULL;
  sf_mex_assign(&c12_y, sf_mex_create("y", &c12_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c12_mxArrayOutData, c12_y, FALSE);
  return c12_mxArrayOutData;
}

static real_T c12_d_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_Availability, const char_T *c12_identifier)
{
  real_T c12_y;
  emlrtMsgIdentifier c12_thisId;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  c12_y = c12_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c12_Availability),
    &c12_thisId);
  sf_mex_destroy(&c12_Availability);
  return c12_y;
}

static real_T c12_e_emlrt_marshallIn(SFc12_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c12_u, const emlrtMsgIdentifier *c12_parentId)
{
  real_T c12_y;
  real_T c12_d0;
  sf_mex_import(c12_parentId, sf_mex_dup(c12_u), &c12_d0, 1, 0, 0U, 0, 0U, 0);
  c12_y = c12_d0;
  sf_mex_destroy(&c12_u);
  return c12_y;
}

static void c12_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c12_mxArrayInData, const char_T *c12_varName, void *c12_outData)
{
  const mxArray *c12_Availability;
  const char_T *c12_identifier;
  emlrtMsgIdentifier c12_thisId;
  real_T c12_y;
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c12_Availability = sf_mex_dup(c12_mxArrayInData);
  c12_identifier = c12_varName;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  c12_y = c12_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c12_Availability),
    &c12_thisId);
  sf_mex_destroy(&c12_Availability);
  *(real_T *)c12_outData = c12_y;
  sf_mex_destroy(&c12_mxArrayInData);
}

static const mxArray *c12_f_emlrt_marshallIn
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray
   *c12_b_setSimStateSideEffectsInfo, const char_T *c12_identifier)
{
  const mxArray *c12_y = NULL;
  emlrtMsgIdentifier c12_thisId;
  c12_y = NULL;
  c12_thisId.fIdentifier = c12_identifier;
  c12_thisId.fParent = NULL;
  sf_mex_assign(&c12_y, c12_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c12_b_setSimStateSideEffectsInfo), &c12_thisId), FALSE);
  sf_mex_destroy(&c12_b_setSimStateSideEffectsInfo);
  return c12_y;
}

static const mxArray *c12_g_emlrt_marshallIn
  (SFc12_WorkstationModelInstanceStruct *chartInstance, const mxArray *c12_u,
   const emlrtMsgIdentifier *c12_parentId)
{
  const mxArray *c12_y = NULL;
  c12_y = NULL;
  sf_mex_assign(&c12_y, sf_mex_duplicatearraysafe(&c12_u), FALSE);
  sf_mex_destroy(&c12_u);
  return c12_y;
}

static void init_dsm_address_info(SFc12_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c12_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3093019509U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2577714477U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3149321240U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1542566434U);
}

mxArray *sf_c12_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("uk3UGQXkBHQiQXaol9MWoH");
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
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

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
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c12_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x3'type','srcId','name','auxInfo'{{M[1],M[3],T\"Availability\",},{M[8],M[0],T\"is_active_c12_WorkstationModel\",},{M[9],M[0],T\"is_c12_WorkstationModel\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 3, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c12_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc12_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc12_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           12,
           2,
           3,
           3,
           0,
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
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"Busy");
          _SFD_SET_DATA_PROPS(1,1,1,0,"QueueLength");
          _SFD_SET_DATA_PROPS(2,2,0,1,"Availability");
          _SFD_STATE_INFO(0,0,0);
          _SFD_STATE_INFO(1,0,0);
          _SFD_CH_SUBSTATE_COUNT(2);
          _SFD_CH_SUBSTATE_DECOMP(0);
          _SFD_CH_SUBSTATE_INDEX(0,0);
          _SFD_CH_SUBSTATE_INDEX(1,1);
          _SFD_ST_SUBSTATE_COUNT(0,0);
          _SFD_ST_SUBSTATE_COUNT(1,0);
        }

        _SFD_CV_INIT_CHART(2,1,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(1,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1, 13 };

          static unsigned int sEndGuardMap[] = { 9, 27 };

          static int sPostFixPredicateTree[] = { 0, 1, -2 };

          _SFD_CV_INIT_TRANS(1,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1, 14 };

          static unsigned int sEndGuardMap[] = { 10, 29 };

          static int sPostFixPredicateTree[] = { 0, 1, -3 };

          _SFD_CV_INIT_TRANS(2,2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),3,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_TRANS_COV_WTS(0,0,0,0,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(1,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 13 };

          static unsigned int sEndGuardMap[] = { 9, 27 };

          _SFD_TRANS_COV_MAPS(1,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_TRANS_COV_WTS(2,0,2,0,0);
        if (chartAlreadyPresent==0) {
          static unsigned int sStartGuardMap[] = { 1, 14 };

          static unsigned int sEndGuardMap[] = { 10, 29 };

          _SFD_TRANS_COV_MAPS(2,
                              0,NULL,NULL,
                              2,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
                              0,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c12_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c12_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c12_c_sf_marshallOut,(MexInFcnForType)
          c12_c_sf_marshallIn);

        {
          real_T *c12_Busy;
          real_T *c12_QueueLength;
          real_T *c12_Availability;
          c12_Availability = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c12_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c12_Busy = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c12_Busy);
          _SFD_SET_DATA_VALUE_PTR(1U, c12_QueueLength);
          _SFD_SET_DATA_VALUE_PTR(2U, c12_Availability);
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
  return "dmu9P6kn0XgVsRwD2izqB";
}

static void sf_opaque_initialize_c12_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c12_WorkstationModel(void *chartInstanceVar)
{
  enable_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c12_WorkstationModel(void *chartInstanceVar)
{
  disable_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c12_WorkstationModel(void *chartInstanceVar)
{
  sf_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c12_WorkstationModel(SimStruct*
  S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c12_WorkstationModel
    ((SFc12_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c12_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c12_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c12_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c12_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c12_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c12_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c12_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c12_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc12_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c12_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c12_WorkstationModel((SFc12_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c12_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      12);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,12,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,12,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,12,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,12,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,12);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(593593177U));
  ssSetChecksum1(S,(2540782394U));
  ssSetChecksum2(S,(4160071898U));
  ssSetChecksum3(S,(2984844461U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c12_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Stateflow");
  }
}

static void mdlStart_c12_WorkstationModel(SimStruct *S)
{
  SFc12_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc12_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc12_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc12_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c12_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c12_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c12_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c12_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c12_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c12_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c12_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c12_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c12_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c12_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c12_WorkstationModel;
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

void c12_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c12_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c12_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c12_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c12_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
