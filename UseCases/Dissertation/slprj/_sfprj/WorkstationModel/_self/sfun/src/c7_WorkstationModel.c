/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c7_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c7_IN_NO_ACTIVE_CHILD          ((uint8_T)0U)
#define c7_IN_Type2                    ((uint8_T)2U)
#define c7_IN_Type1                    ((uint8_T)1U)

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void initialize_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance);
static void enable_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance);
static void c7_update_debugger_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance, const mxArray *c7_st);
static void c7_set_sim_state_side_effects_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance);
static void finalize_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c7_machineNumber, uint32_T
  c7_chartNumber);
static const mxArray *c7_sf_marshallOut(void *chartInstanceVoid, void *c7_inData);
static int32_T c7_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData);
static const mxArray *c7_b_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData);
static uint8_T c7_b_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_b_tp_Type2, const char_T *c7_identifier);
static uint8_T c7_c_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData);
static const mxArray *c7_c_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData);
static real_T c7_d_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_ProductionState, const char_T *c7_identifier);
static real_T c7_e_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData);
static const mxArray *c7_f_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c7_b_setSimStateSideEffectsInfo, const char_T
  *c7_identifier);
static const mxArray *c7_g_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void init_dsm_address_info(SFc7_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T *c7_ProductionState;
  c7_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c7_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c7_doSetSimStateSideEffects = 0U;
  chartInstance->c7_setSimStateSideEffectsInfo = NULL;
  chartInstance->c7_is_active_Setup_State = 0U;
  chartInstance->c7_is_Setup_State = 0U;
  chartInstance->c7_tp_Setup_State = 0U;
  chartInstance->c7_tp_Type1 = 0U;
  chartInstance->c7_tp_Type2 = 0U;
  chartInstance->c7_is_active_c7_WorkstationModel = 0U;
  if (!(cdrGetOutputPortReusable(chartInstance->S, 1) != 0)) {
    *c7_ProductionState = 0.0;
  }
}

static void initialize_params_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_enable(chartInstance->S, 0, "CallSetup", 0);
}

static void disable_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_disable(chartInstance->S, 0, "CallSetup", 0);
}

static void c7_update_debugger_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance)
{
  uint32_T c7_prevAniVal;
  c7_prevAniVal = sf_debug_get_animation();
  sf_debug_set_animation(0U);
  if (chartInstance->c7_is_active_c7_WorkstationModel == 1) {
    _SFD_CC_CALL(CHART_ACTIVE_TAG, 6U, chartInstance->c7_sfEvent);
  }

  if (chartInstance->c7_is_Setup_State == c7_IN_Type2) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c7_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c7_sfEvent);
  }

  if (chartInstance->c7_is_Setup_State == c7_IN_Type1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
  }

  if (chartInstance->c7_is_active_Setup_State == 1) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c7_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c7_sfEvent);
  }

  sf_debug_set_animation(c7_prevAniVal);
  _SFD_ANIMATE();
}

static const mxArray *get_sim_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c7_st;
  const mxArray *c7_y = NULL;
  real_T c7_hoistedGlobal;
  real_T c7_u;
  const mxArray *c7_b_y = NULL;
  uint8_T c7_b_hoistedGlobal;
  uint8_T c7_b_u;
  const mxArray *c7_c_y = NULL;
  uint8_T c7_c_hoistedGlobal;
  uint8_T c7_c_u;
  const mxArray *c7_d_y = NULL;
  uint8_T c7_d_hoistedGlobal;
  uint8_T c7_d_u;
  const mxArray *c7_e_y = NULL;
  real_T *c7_ProductionState;
  c7_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c7_st = NULL;
  c7_st = NULL;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_createcellarray(4), FALSE);
  c7_hoistedGlobal = *c7_ProductionState;
  c7_u = c7_hoistedGlobal;
  c7_b_y = NULL;
  sf_mex_assign(&c7_b_y, sf_mex_create("y", &c7_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 0, c7_b_y);
  c7_b_hoistedGlobal = chartInstance->c7_is_active_c7_WorkstationModel;
  c7_b_u = c7_b_hoistedGlobal;
  c7_c_y = NULL;
  sf_mex_assign(&c7_c_y, sf_mex_create("y", &c7_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 1, c7_c_y);
  c7_c_hoistedGlobal = chartInstance->c7_is_active_Setup_State;
  c7_c_u = c7_c_hoistedGlobal;
  c7_d_y = NULL;
  sf_mex_assign(&c7_d_y, sf_mex_create("y", &c7_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 2, c7_d_y);
  c7_d_hoistedGlobal = chartInstance->c7_is_Setup_State;
  c7_d_u = c7_d_hoistedGlobal;
  c7_e_y = NULL;
  sf_mex_assign(&c7_e_y, sf_mex_create("y", &c7_d_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 3, c7_e_y);
  sf_mex_assign(&c7_st, c7_y, FALSE);
  return c7_st;
}

static void set_sim_state_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance, const mxArray *c7_st)
{
  const mxArray *c7_u;
  real_T *c7_ProductionState;
  c7_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c7_u = sf_mex_dup(c7_st);
  *c7_ProductionState = c7_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c7_u, 0)), "ProductionState");
  chartInstance->c7_is_active_c7_WorkstationModel = c7_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c7_u, 1)),
     "is_active_c7_WorkstationModel");
  chartInstance->c7_is_active_Setup_State = c7_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c7_u, 2)), "is_active_Setup_State");
  chartInstance->c7_is_Setup_State = c7_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c7_u, 3)), "is_Setup_State");
  sf_mex_assign(&chartInstance->c7_setSimStateSideEffectsInfo,
                c7_f_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c7_u, 4)), "setSimStateSideEffectsInfo"), TRUE);
  sf_mex_destroy(&c7_u);
  chartInstance->c7_doSetSimStateSideEffects = 1U;
  c7_update_debugger_state_c7_WorkstationModel(chartInstance);
  sf_mex_destroy(&c7_st);
}

static void c7_set_sim_state_side_effects_c7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance)
{
  if (chartInstance->c7_doSetSimStateSideEffects != 0) {
    if (chartInstance->c7_is_active_Setup_State == 1) {
      chartInstance->c7_tp_Setup_State = 1U;
    } else {
      chartInstance->c7_tp_Setup_State = 0U;
    }

    if (chartInstance->c7_is_Setup_State == c7_IN_Type1) {
      chartInstance->c7_tp_Type1 = 1U;
    } else {
      chartInstance->c7_tp_Type1 = 0U;
    }

    if (chartInstance->c7_is_Setup_State == c7_IN_Type2) {
      chartInstance->c7_tp_Type2 = 1U;
    } else {
      chartInstance->c7_tp_Type2 = 0U;
    }

    chartInstance->c7_doSetSimStateSideEffects = 0U;
  }
}

static void finalize_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
  sf_mex_destroy(&chartInstance->c7_setSimStateSideEffectsInfo);
}

static void sf_c7_WorkstationModel(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
  boolean_T c7_out;
  boolean_T c7_b_out;
  real_T *c7_SetupState;
  real_T *c7_ProductionState;
  c7_SetupState = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  c7_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c7_set_sim_state_side_effects_c7_WorkstationModel(chartInstance);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 6U, chartInstance->c7_sfEvent);
  chartInstance->c7_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 6U, chartInstance->c7_sfEvent);
  if (chartInstance->c7_is_active_c7_WorkstationModel == 0) {
    _SFD_CC_CALL(CHART_ENTER_ENTRY_FUNCTION_TAG, 6U, chartInstance->c7_sfEvent);
    chartInstance->c7_is_active_c7_WorkstationModel = 1U;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 6U, chartInstance->c7_sfEvent);
    chartInstance->c7_is_active_Setup_State = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c7_sfEvent);
    chartInstance->c7_tp_Setup_State = 1U;
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 0U, chartInstance->c7_sfEvent);
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 0U, chartInstance->c7_sfEvent);
    chartInstance->c7_is_Setup_State = c7_IN_Type1;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
    chartInstance->c7_tp_Type1 = 1U;
    sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
  } else {
    _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c7_sfEvent);
    switch (chartInstance->c7_is_Setup_State) {
     case c7_IN_Type1:
      CV_STATE_EVAL(0, 0, 1);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 1U,
                   chartInstance->c7_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 1U,
                   chartInstance->c7_sfEvent);
      c7_out = (CV_TRANSITION_EVAL(1U, (int32_T)_SFD_CCP_CALL(1U, 0,
                  *c7_SetupState == 1.0 != 0U, chartInstance->c7_sfEvent)) != 0);
      if (c7_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
        chartInstance->c7_tp_Type1 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
        chartInstance->c7_is_Setup_State = c7_IN_Type2;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c7_sfEvent);
        chartInstance->c7_tp_Type2 = 1U;
        sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
      } else {
        *c7_ProductionState = 1.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c7_sfEvent);
      break;

     case c7_IN_Type2:
      CV_STATE_EVAL(0, 0, 2);
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 2U,
                   chartInstance->c7_sfEvent);
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 2U,
                   chartInstance->c7_sfEvent);
      c7_b_out = (CV_TRANSITION_EVAL(2U, (int32_T)_SFD_CCP_CALL(2U, 0,
        *c7_SetupState == 2.0 != 0U, chartInstance->c7_sfEvent)) != 0);
      if (c7_b_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 2U, chartInstance->c7_sfEvent);
        chartInstance->c7_tp_Type2 = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c7_sfEvent);
        chartInstance->c7_is_Setup_State = c7_IN_Type1;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
        chartInstance->c7_tp_Type1 = 1U;
        sf_call_output_fcn_call(chartInstance->S, 0, "CallSetup", 0);
      } else {
        *c7_ProductionState = 2.0;
      }

      _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c7_sfEvent);
      break;

     default:
      CV_STATE_EVAL(0, 0, 0);
      chartInstance->c7_is_Setup_State = c7_IN_NO_ACTIVE_CHILD;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c7_sfEvent);
      break;
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c7_sfEvent);
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 6U, chartInstance->c7_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc7_WorkstationModel
  (SFc7_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c7_machineNumber, uint32_T
  c7_chartNumber)
{
}

const mxArray *sf_c7_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c7_nameCaptureInfo = NULL;
  c7_nameCaptureInfo = NULL;
  sf_mex_assign(&c7_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c7_nameCaptureInfo;
}

static const mxArray *c7_sf_marshallOut(void *chartInstanceVoid, void *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  int32_T c7_u;
  const mxArray *c7_y = NULL;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  c7_u = *(int32_T *)c7_inData;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", &c7_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

static int32_T c7_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  int32_T c7_y;
  int32_T c7_i0;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_i0, 1, 6, 0U, 0, 0U, 0);
  c7_y = c7_i0;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData)
{
  const mxArray *c7_b_sfEvent;
  const char_T *c7_identifier;
  emlrtMsgIdentifier c7_thisId;
  int32_T c7_y;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_b_sfEvent = sf_mex_dup(c7_mxArrayInData);
  c7_identifier = c7_varName;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_b_sfEvent), &c7_thisId);
  sf_mex_destroy(&c7_b_sfEvent);
  *(int32_T *)c7_outData = c7_y;
  sf_mex_destroy(&c7_mxArrayInData);
}

static const mxArray *c7_b_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  uint8_T c7_u;
  const mxArray *c7_y = NULL;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  c7_u = *(uint8_T *)c7_inData;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", &c7_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

static uint8_T c7_b_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_b_tp_Type2, const char_T *c7_identifier)
{
  uint8_T c7_y;
  emlrtMsgIdentifier c7_thisId;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_b_tp_Type2),
    &c7_thisId);
  sf_mex_destroy(&c7_b_tp_Type2);
  return c7_y;
}

static uint8_T c7_c_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  uint8_T c7_y;
  uint8_T c7_u0;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_u0, 1, 3, 0U, 0, 0U, 0);
  c7_y = c7_u0;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData)
{
  const mxArray *c7_b_tp_Type2;
  const char_T *c7_identifier;
  emlrtMsgIdentifier c7_thisId;
  uint8_T c7_y;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_b_tp_Type2 = sf_mex_dup(c7_mxArrayInData);
  c7_identifier = c7_varName;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_b_tp_Type2),
    &c7_thisId);
  sf_mex_destroy(&c7_b_tp_Type2);
  *(uint8_T *)c7_outData = c7_y;
  sf_mex_destroy(&c7_mxArrayInData);
}

static const mxArray *c7_c_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  real_T c7_u;
  const mxArray *c7_y = NULL;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  c7_u = *(real_T *)c7_inData;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", &c7_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

static real_T c7_d_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_ProductionState, const char_T *c7_identifier)
{
  real_T c7_y;
  emlrtMsgIdentifier c7_thisId;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_ProductionState),
    &c7_thisId);
  sf_mex_destroy(&c7_ProductionState);
  return c7_y;
}

static real_T c7_e_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  real_T c7_y;
  real_T c7_d0;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_d0, 1, 0, 0U, 0, 0U, 0);
  c7_y = c7_d0;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData)
{
  const mxArray *c7_ProductionState;
  const char_T *c7_identifier;
  emlrtMsgIdentifier c7_thisId;
  real_T c7_y;
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c7_ProductionState = sf_mex_dup(c7_mxArrayInData);
  c7_identifier = c7_varName;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_ProductionState),
    &c7_thisId);
  sf_mex_destroy(&c7_ProductionState);
  *(real_T *)c7_outData = c7_y;
  sf_mex_destroy(&c7_mxArrayInData);
}

static const mxArray *c7_f_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c7_b_setSimStateSideEffectsInfo, const char_T
  *c7_identifier)
{
  const mxArray *c7_y = NULL;
  emlrtMsgIdentifier c7_thisId;
  c7_y = NULL;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  sf_mex_assign(&c7_y, c7_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c7_b_setSimStateSideEffectsInfo), &c7_thisId), FALSE);
  sf_mex_destroy(&c7_b_setSimStateSideEffectsInfo);
  return c7_y;
}

static const mxArray *c7_g_emlrt_marshallIn(SFc7_WorkstationModelInstanceStruct *
  chartInstance, const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  const mxArray *c7_y = NULL;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_duplicatearraysafe(&c7_u), FALSE);
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void init_dsm_address_info(SFc7_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c7_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3411245675U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(599507615U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1217313648U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1093213945U);
}

mxArray *sf_c7_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("kGUUkVIQiGCGPnG4pb89kG");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
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

static const mxArray *sf_get_sim_state_info_c7_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x4'type','srcId','name','auxInfo'{{M[1],M[18],T\"ProductionState\",},{M[8],M[0],T\"is_active_c7_WorkstationModel\",},{M[8],M[28],T\"is_active_Setup_State\",},{M[9],M[28],T\"is_Setup_State\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 4, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c7_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc7_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc7_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           7,
           3,
           3,
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
          _SFD_SET_DATA_PROPS(0,2,0,1,"ProductionState");
          _SFD_SET_DATA_PROPS(1,1,1,0,"SetupState");
          _SFD_EVENT_SCOPE(0,2);
          _SFD_STATE_INFO(0,0,1);
          _SFD_STATE_INFO(1,0,0);
          _SFD_STATE_INFO(2,0,0);
          _SFD_CH_SUBSTATE_COUNT(1);
          _SFD_CH_SUBSTATE_DECOMP(1);
          _SFD_CH_SUBSTATE_INDEX(0,0);
          _SFD_ST_SUBSTATE_COUNT(0,2);
          _SFD_ST_SUBSTATE_INDEX(0,0,1);
          _SFD_ST_SUBSTATE_INDEX(0,1,2);
          _SFD_ST_SUBSTATE_COUNT(1,0);
          _SFD_ST_SUBSTATE_COUNT(2,0);
        }

        _SFD_CV_INIT_CHART(1,0,0,0);

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

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c7_c_sf_marshallOut,(MexInFcnForType)c7_c_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c7_c_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c7_ProductionState;
          real_T *c7_SetupState;
          c7_SetupState = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          c7_ProductionState = (real_T *)ssGetOutputPortSignal(chartInstance->S,
            1);
          _SFD_SET_DATA_VALUE_PTR(0U, c7_ProductionState);
          _SFD_SET_DATA_VALUE_PTR(1U, c7_SetupState);
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
  return "Zu1JrlTnBJgIdYhSJm7QsF";
}

static void sf_opaque_initialize_c7_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c7_WorkstationModel(void *chartInstanceVar)
{
  enable_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c7_WorkstationModel(void *chartInstanceVar)
{
  disable_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c7_WorkstationModel(void *chartInstanceVar)
{
  sf_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c7_WorkstationModel(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c7_WorkstationModel
    ((SFc7_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c7_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c7_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c7_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c7_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c7_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c7_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c7_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c7_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc7_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c7_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c7_WorkstationModel((SFc7_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c7_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      7);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,7,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,7,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_mark_output_events_with_multiple_callers(S,sf_get_instance_specialization
      (),infoStruct,7,1);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,7,1);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,7,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,7);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(2402680542U));
  ssSetChecksum1(S,(3423761167U));
  ssSetChecksum2(S,(1799792092U));
  ssSetChecksum3(S,(1555961755U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c7_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Stateflow");
  }
}

static void mdlStart_c7_WorkstationModel(SimStruct *S)
{
  SFc7_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc7_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc7_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc7_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c7_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c7_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c7_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c7_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c7_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c7_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c7_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c7_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c7_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c7_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c7_WorkstationModel;
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

void c7_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c7_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c7_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c7_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c7_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
