/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c8_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c8_debug_family_names[7] = { "aVarTruthTableCondition_1",
  "aVarTruthTableCondition_2", "nargin", "nargout", "CustomerClass", "JobClass",
  "QueueRoute" };

/* Function Declarations */
static void initialize_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance);
static void enable_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance);
static void c8_update_debugger_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance, const mxArray *c8_st);
static void finalize_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c8_machineNumber, uint32_T
  c8_chartNumber);
static const mxArray *c8_sf_marshallOut(void *chartInstanceVoid, void *c8_inData);
static real_T c8_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_QueueRoute, const char_T *c8_identifier);
static real_T c8_b_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId);
static void c8_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData);
static const mxArray *c8_b_sf_marshallOut(void *chartInstanceVoid, void
  *c8_inData);
static boolean_T c8_c_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId);
static void c8_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData);
static const mxArray *c8_c_sf_marshallOut(void *chartInstanceVoid, void
  *c8_inData);
static int32_T c8_d_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId);
static void c8_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData);
static uint8_T c8_e_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_b_is_active_c8_WorkstationModel, const
  char_T *c8_identifier);
static uint8_T c8_f_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId);
static void init_dsm_address_info(SFc8_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
  chartInstance->c8_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c8_is_active_c8_WorkstationModel = 0U;
}

static void initialize_params_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c8_update_debugger_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c8_st;
  const mxArray *c8_y = NULL;
  real_T c8_hoistedGlobal;
  real_T c8_u;
  const mxArray *c8_b_y = NULL;
  uint8_T c8_b_hoistedGlobal;
  uint8_T c8_b_u;
  const mxArray *c8_c_y = NULL;
  real_T *c8_QueueRoute;
  c8_QueueRoute = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c8_st = NULL;
  c8_st = NULL;
  c8_y = NULL;
  sf_mex_assign(&c8_y, sf_mex_createcellarray(2), FALSE);
  c8_hoistedGlobal = *c8_QueueRoute;
  c8_u = c8_hoistedGlobal;
  c8_b_y = NULL;
  sf_mex_assign(&c8_b_y, sf_mex_create("y", &c8_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c8_y, 0, c8_b_y);
  c8_b_hoistedGlobal = chartInstance->c8_is_active_c8_WorkstationModel;
  c8_b_u = c8_b_hoistedGlobal;
  c8_c_y = NULL;
  sf_mex_assign(&c8_c_y, sf_mex_create("y", &c8_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c8_y, 1, c8_c_y);
  sf_mex_assign(&c8_st, c8_y, FALSE);
  return c8_st;
}

static void set_sim_state_c8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance, const mxArray *c8_st)
{
  const mxArray *c8_u;
  real_T *c8_QueueRoute;
  c8_QueueRoute = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c8_doneDoubleBufferReInit = TRUE;
  c8_u = sf_mex_dup(c8_st);
  *c8_QueueRoute = c8_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c8_u, 0)), "QueueRoute");
  chartInstance->c8_is_active_c8_WorkstationModel = c8_e_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c8_u, 1)),
     "is_active_c8_WorkstationModel");
  sf_mex_destroy(&c8_u);
  c8_update_debugger_state_c8_WorkstationModel(chartInstance);
  sf_mex_destroy(&c8_st);
}

static void finalize_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
}

static void sf_c8_WorkstationModel(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T c8_hoistedGlobal;
  real_T c8_b_hoistedGlobal;
  real_T c8_CustomerClass;
  real_T c8_JobClass;
  uint32_T c8_debug_family_var_map[7];
  boolean_T c8_aVarTruthTableCondition_1;
  boolean_T c8_aVarTruthTableCondition_2;
  real_T c8_nargin = 2.0;
  real_T c8_nargout = 1.0;
  real_T c8_QueueRoute;
  real_T *c8_b_CustomerClass;
  real_T *c8_b_QueueRoute;
  real_T *c8_b_JobClass;
  boolean_T guard1 = FALSE;
  boolean_T guard2 = FALSE;
  boolean_T guard3 = FALSE;
  c8_b_JobClass = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c8_b_QueueRoute = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c8_b_CustomerClass = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 7U, chartInstance->c8_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c8_b_CustomerClass, 0U);
  _SFD_DATA_RANGE_CHECK(*c8_b_QueueRoute, 1U);
  _SFD_DATA_RANGE_CHECK(*c8_b_JobClass, 2U);
  chartInstance->c8_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 7U, chartInstance->c8_sfEvent);
  c8_hoistedGlobal = *c8_b_CustomerClass;
  c8_b_hoistedGlobal = *c8_b_JobClass;
  c8_CustomerClass = c8_hoistedGlobal;
  c8_JobClass = c8_b_hoistedGlobal;
  sf_debug_symbol_scope_push_eml(0U, 7U, 7U, c8_debug_family_names,
    c8_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c8_aVarTruthTableCondition_1, 0U,
    c8_b_sf_marshallOut, c8_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c8_aVarTruthTableCondition_2, 1U,
    c8_b_sf_marshallOut, c8_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c8_nargin, 2U, c8_sf_marshallOut,
    c8_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c8_nargout, 3U, c8_sf_marshallOut,
    c8_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(&c8_CustomerClass, 4U, c8_sf_marshallOut);
  sf_debug_symbol_scope_add_eml(&c8_JobClass, 5U, c8_sf_marshallOut);
  sf_debug_symbol_scope_add_eml_importable(&c8_QueueRoute, 6U, c8_sf_marshallOut,
    c8_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 3);
  c8_aVarTruthTableCondition_1 = FALSE;
  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 4);
  c8_aVarTruthTableCondition_2 = FALSE;
  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 9);
  c8_aVarTruthTableCondition_1 = (c8_CustomerClass == 1.0);
  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 13);
  c8_aVarTruthTableCondition_2 = (c8_JobClass == 1.0);
  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 15);
  guard1 = FALSE;
  if (CV_EML_COND(0, 1, 0, c8_aVarTruthTableCondition_1)) {
    if (CV_EML_COND(0, 1, 1, c8_aVarTruthTableCondition_2)) {
      CV_EML_MCDC(0, 1, 0, TRUE);
      CV_EML_IF(0, 1, 0, TRUE);
      _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 16);
      CV_EML_FCN(0, 1);
      _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 29);
      c8_QueueRoute = 1.0;
      _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, -29);
    } else {
      guard1 = TRUE;
    }
  } else {
    guard1 = TRUE;
  }

  if (guard1 == TRUE) {
    CV_EML_MCDC(0, 1, 0, FALSE);
    CV_EML_IF(0, 1, 0, FALSE);
    _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 17);
    guard2 = FALSE;
    if (CV_EML_COND(0, 1, 2, c8_aVarTruthTableCondition_1)) {
      if (!CV_EML_COND(0, 1, 3, c8_aVarTruthTableCondition_2)) {
        CV_EML_MCDC(0, 1, 1, TRUE);
        CV_EML_IF(0, 1, 1, TRUE);
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 18);
        CV_EML_FCN(0, 2);
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 35);
        c8_QueueRoute = 2.0;
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, -35);
      } else {
        guard2 = TRUE;
      }
    } else {
      guard2 = TRUE;
    }

    if (guard2 == TRUE) {
      CV_EML_MCDC(0, 1, 1, FALSE);
      CV_EML_IF(0, 1, 1, FALSE);
      _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 19);
      guard3 = FALSE;
      if (!CV_EML_COND(0, 1, 4, c8_aVarTruthTableCondition_1)) {
        if (CV_EML_COND(0, 1, 5, c8_aVarTruthTableCondition_2)) {
          CV_EML_MCDC(0, 1, 2, TRUE);
          CV_EML_IF(0, 1, 2, TRUE);
          _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 20);
          CV_EML_FCN(0, 3);
          _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 41);
          c8_QueueRoute = 3.0;
          _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, -41);
        } else {
          guard3 = TRUE;
        }
      } else {
        guard3 = TRUE;
      }

      if (guard3 == TRUE) {
        CV_EML_MCDC(0, 1, 2, FALSE);
        CV_EML_IF(0, 1, 2, FALSE);
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 22);
        CV_EML_FCN(0, 4);
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, 47);
        c8_QueueRoute = 4.0;
        _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, -47);
      }
    }
  }

  _SFD_EML_CALL(0U, chartInstance->c8_sfEvent, -22);
  sf_debug_symbol_scope_pop();
  *c8_b_QueueRoute = c8_QueueRoute;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 7U, chartInstance->c8_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc8_WorkstationModel
  (SFc8_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c8_machineNumber, uint32_T
  c8_chartNumber)
{
}

static const mxArray *c8_sf_marshallOut(void *chartInstanceVoid, void *c8_inData)
{
  const mxArray *c8_mxArrayOutData = NULL;
  real_T c8_u;
  const mxArray *c8_y = NULL;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_mxArrayOutData = NULL;
  c8_u = *(real_T *)c8_inData;
  c8_y = NULL;
  sf_mex_assign(&c8_y, sf_mex_create("y", &c8_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c8_mxArrayOutData, c8_y, FALSE);
  return c8_mxArrayOutData;
}

static real_T c8_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_QueueRoute, const char_T *c8_identifier)
{
  real_T c8_y;
  emlrtMsgIdentifier c8_thisId;
  c8_thisId.fIdentifier = c8_identifier;
  c8_thisId.fParent = NULL;
  c8_y = c8_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c8_QueueRoute),
    &c8_thisId);
  sf_mex_destroy(&c8_QueueRoute);
  return c8_y;
}

static real_T c8_b_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId)
{
  real_T c8_y;
  real_T c8_d0;
  sf_mex_import(c8_parentId, sf_mex_dup(c8_u), &c8_d0, 1, 0, 0U, 0, 0U, 0);
  c8_y = c8_d0;
  sf_mex_destroy(&c8_u);
  return c8_y;
}

static void c8_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData)
{
  const mxArray *c8_QueueRoute;
  const char_T *c8_identifier;
  emlrtMsgIdentifier c8_thisId;
  real_T c8_y;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_QueueRoute = sf_mex_dup(c8_mxArrayInData);
  c8_identifier = c8_varName;
  c8_thisId.fIdentifier = c8_identifier;
  c8_thisId.fParent = NULL;
  c8_y = c8_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c8_QueueRoute),
    &c8_thisId);
  sf_mex_destroy(&c8_QueueRoute);
  *(real_T *)c8_outData = c8_y;
  sf_mex_destroy(&c8_mxArrayInData);
}

static const mxArray *c8_b_sf_marshallOut(void *chartInstanceVoid, void
  *c8_inData)
{
  const mxArray *c8_mxArrayOutData = NULL;
  boolean_T c8_u;
  const mxArray *c8_y = NULL;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_mxArrayOutData = NULL;
  c8_u = *(boolean_T *)c8_inData;
  c8_y = NULL;
  sf_mex_assign(&c8_y, sf_mex_create("y", &c8_u, 11, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c8_mxArrayOutData, c8_y, FALSE);
  return c8_mxArrayOutData;
}

static boolean_T c8_c_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId)
{
  boolean_T c8_y;
  boolean_T c8_b0;
  sf_mex_import(c8_parentId, sf_mex_dup(c8_u), &c8_b0, 1, 11, 0U, 0, 0U, 0);
  c8_y = c8_b0;
  sf_mex_destroy(&c8_u);
  return c8_y;
}

static void c8_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData)
{
  const mxArray *c8_aVarTruthTableCondition_2;
  const char_T *c8_identifier;
  emlrtMsgIdentifier c8_thisId;
  boolean_T c8_y;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_aVarTruthTableCondition_2 = sf_mex_dup(c8_mxArrayInData);
  c8_identifier = c8_varName;
  c8_thisId.fIdentifier = c8_identifier;
  c8_thisId.fParent = NULL;
  c8_y = c8_c_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c8_aVarTruthTableCondition_2), &c8_thisId);
  sf_mex_destroy(&c8_aVarTruthTableCondition_2);
  *(boolean_T *)c8_outData = c8_y;
  sf_mex_destroy(&c8_mxArrayInData);
}

const mxArray *sf_c8_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c8_nameCaptureInfo = NULL;
  c8_nameCaptureInfo = NULL;
  sf_mex_assign(&c8_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c8_nameCaptureInfo;
}

static const mxArray *c8_c_sf_marshallOut(void *chartInstanceVoid, void
  *c8_inData)
{
  const mxArray *c8_mxArrayOutData = NULL;
  int32_T c8_u;
  const mxArray *c8_y = NULL;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_mxArrayOutData = NULL;
  c8_u = *(int32_T *)c8_inData;
  c8_y = NULL;
  sf_mex_assign(&c8_y, sf_mex_create("y", &c8_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c8_mxArrayOutData, c8_y, FALSE);
  return c8_mxArrayOutData;
}

static int32_T c8_d_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId)
{
  int32_T c8_y;
  int32_T c8_i0;
  sf_mex_import(c8_parentId, sf_mex_dup(c8_u), &c8_i0, 1, 6, 0U, 0, 0U, 0);
  c8_y = c8_i0;
  sf_mex_destroy(&c8_u);
  return c8_y;
}

static void c8_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c8_mxArrayInData, const char_T *c8_varName, void *c8_outData)
{
  const mxArray *c8_b_sfEvent;
  const char_T *c8_identifier;
  emlrtMsgIdentifier c8_thisId;
  int32_T c8_y;
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c8_b_sfEvent = sf_mex_dup(c8_mxArrayInData);
  c8_identifier = c8_varName;
  c8_thisId.fIdentifier = c8_identifier;
  c8_thisId.fParent = NULL;
  c8_y = c8_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c8_b_sfEvent),
    &c8_thisId);
  sf_mex_destroy(&c8_b_sfEvent);
  *(int32_T *)c8_outData = c8_y;
  sf_mex_destroy(&c8_mxArrayInData);
}

static uint8_T c8_e_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_b_is_active_c8_WorkstationModel, const
  char_T *c8_identifier)
{
  uint8_T c8_y;
  emlrtMsgIdentifier c8_thisId;
  c8_thisId.fIdentifier = c8_identifier;
  c8_thisId.fParent = NULL;
  c8_y = c8_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c8_b_is_active_c8_WorkstationModel), &c8_thisId);
  sf_mex_destroy(&c8_b_is_active_c8_WorkstationModel);
  return c8_y;
}

static uint8_T c8_f_emlrt_marshallIn(SFc8_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c8_u, const emlrtMsgIdentifier *c8_parentId)
{
  uint8_T c8_y;
  uint8_T c8_u0;
  sf_mex_import(c8_parentId, sf_mex_dup(c8_u), &c8_u0, 1, 3, 0U, 0, 0U, 0);
  c8_y = c8_u0;
  sf_mex_destroy(&c8_u);
  return c8_y;
}

static void init_dsm_address_info(SFc8_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c8_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3549911021U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1833586552U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3576882300U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(886202840U);
}

mxArray *sf_c8_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("oo47cGgFPDtsRTvscifTEE");
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

static const mxArray *sf_get_sim_state_info_c8_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"QueueRoute\",},{M[8],M[0],T\"is_active_c8_WorkstationModel\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c8_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc8_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc8_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           8,
           1,
           1,
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
          _SFD_SET_DATA_PROPS(0,1,1,0,"CustomerClass");
          _SFD_SET_DATA_PROPS(1,2,0,1,"QueueRoute");
          _SFD_SET_DATA_PROPS(2,1,1,0,"JobClass");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,5,3,0,0,0,0,6,3);
        _SFD_CV_INIT_EML_FCN(0,0,"tt_blk_kernel",0,-1,590);
        _SFD_CV_INIT_EML_FCN(0,1,"aFcnTruthTableAction_1",590,-1,650);
        _SFD_CV_INIT_EML_FCN(0,2,"aFcnTruthTableAction_2",650,-1,710);
        _SFD_CV_INIT_EML_FCN(0,3,"aFcnTruthTableAction_3",710,-1,770);
        _SFD_CV_INIT_EML_FCN(0,4,"aFcnTruthTableAction_4",770,-1,829);
        _SFD_CV_INIT_EML_IF(0,1,0,260,319,350,588);
        _SFD_CV_INIT_EML_IF(0,1,1,350,414,445,588);
        _SFD_CV_INIT_EML_IF(0,1,2,445,509,540,588);

        {
          static int condStart[] = { 264, 293 };

          static int condEnd[] = { 289, 318 };

          static int pfixExpr[] = { 0, 1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,0,264,318,2,0,&(condStart[0]),&(condEnd[0]),
                                3,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 358, 388 };

          static int condEnd[] = { 383, 413 };

          static int pfixExpr[] = { 0, 1, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,1,358,413,2,2,&(condStart[0]),&(condEnd[0]),
                                4,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 454, 483 };

          static int condEnd[] = { 479, 508 };

          static int pfixExpr[] = { 0, -1, 1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,2,453,508,2,4,&(condStart[0]),&(condEnd[0]),
                                4,&(pfixExpr[0]));
        }

        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c8_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c8_sf_marshallOut,(MexInFcnForType)c8_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c8_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c8_CustomerClass;
          real_T *c8_QueueRoute;
          real_T *c8_JobClass;
          c8_JobClass = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c8_QueueRoute = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c8_CustomerClass = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c8_CustomerClass);
          _SFD_SET_DATA_VALUE_PTR(1U, c8_QueueRoute);
          _SFD_SET_DATA_VALUE_PTR(2U, c8_JobClass);
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
  return "J6DoLRGizk8X0mWaMu7TiD";
}

static void sf_opaque_initialize_c8_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c8_WorkstationModel(void *chartInstanceVar)
{
  enable_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c8_WorkstationModel(void *chartInstanceVar)
{
  disable_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c8_WorkstationModel(void *chartInstanceVar)
{
  sf_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c8_WorkstationModel(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c8_WorkstationModel
    ((SFc8_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c8_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c8_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c8_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c8_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c8_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c8_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c8_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c8_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc8_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c8_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c8_WorkstationModel((SFc8_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c8_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      8);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,8,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,8,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,8,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,8,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,8);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(357763525U));
  ssSetChecksum1(S,(3399102434U));
  ssSetChecksum2(S,(2626699010U));
  ssSetChecksum3(S,(3249110271U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c8_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Truth Table");
  }
}

static void mdlStart_c8_WorkstationModel(SimStruct *S)
{
  SFc8_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc8_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc8_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc8_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c8_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c8_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c8_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c8_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c8_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c8_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c8_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c8_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c8_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c8_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c8_WorkstationModel;
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

void c8_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c8_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c8_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c8_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c8_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
