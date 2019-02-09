/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c11_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c11_debug_family_names[7] = { "aVarTruthTableCondition_1",
  "aVarTruthTableCondition_2", "nargin", "nargout", "Processing", "QueueLength",
  "Available" };

/* Function Declarations */
static void initialize_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance);
static void enable_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance);
static void c11_update_debugger_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance, const mxArray *c11_st);
static void finalize_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c11_machineNumber, uint32_T
  c11_chartNumber);
static const mxArray *c11_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData);
static real_T c11_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_Available, const char_T *c11_identifier);
static real_T c11_b_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId);
static void c11_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData);
static const mxArray *c11_b_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData);
static boolean_T c11_c_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId);
static void c11_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData);
static const mxArray *c11_c_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData);
static int32_T c11_d_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId);
static void c11_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData);
static uint8_T c11_e_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_b_is_active_c11_WorkstationModel, const
  char_T *c11_identifier);
static uint8_T c11_f_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId);
static void init_dsm_address_info(SFc11_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
  chartInstance->c11_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c11_is_active_c11_WorkstationModel = 0U;
}

static void initialize_params_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c11_update_debugger_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c11_st;
  const mxArray *c11_y = NULL;
  real_T c11_hoistedGlobal;
  real_T c11_u;
  const mxArray *c11_b_y = NULL;
  uint8_T c11_b_hoistedGlobal;
  uint8_T c11_b_u;
  const mxArray *c11_c_y = NULL;
  real_T *c11_Available;
  c11_Available = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c11_st = NULL;
  c11_st = NULL;
  c11_y = NULL;
  sf_mex_assign(&c11_y, sf_mex_createcellarray(2), FALSE);
  c11_hoistedGlobal = *c11_Available;
  c11_u = c11_hoistedGlobal;
  c11_b_y = NULL;
  sf_mex_assign(&c11_b_y, sf_mex_create("y", &c11_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c11_y, 0, c11_b_y);
  c11_b_hoistedGlobal = chartInstance->c11_is_active_c11_WorkstationModel;
  c11_b_u = c11_b_hoistedGlobal;
  c11_c_y = NULL;
  sf_mex_assign(&c11_c_y, sf_mex_create("y", &c11_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c11_y, 1, c11_c_y);
  sf_mex_assign(&c11_st, c11_y, FALSE);
  return c11_st;
}

static void set_sim_state_c11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance, const mxArray *c11_st)
{
  const mxArray *c11_u;
  real_T *c11_Available;
  c11_Available = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c11_doneDoubleBufferReInit = TRUE;
  c11_u = sf_mex_dup(c11_st);
  *c11_Available = c11_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c11_u, 0)), "Available");
  chartInstance->c11_is_active_c11_WorkstationModel = c11_e_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c11_u, 1)),
     "is_active_c11_WorkstationModel");
  sf_mex_destroy(&c11_u);
  c11_update_debugger_state_c11_WorkstationModel(chartInstance);
  sf_mex_destroy(&c11_st);
}

static void finalize_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
}

static void sf_c11_WorkstationModel(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T c11_hoistedGlobal;
  real_T c11_b_hoistedGlobal;
  real_T c11_Processing;
  real_T c11_QueueLength;
  uint32_T c11_debug_family_var_map[7];
  boolean_T c11_aVarTruthTableCondition_1;
  boolean_T c11_aVarTruthTableCondition_2;
  real_T c11_nargin = 2.0;
  real_T c11_nargout = 1.0;
  real_T c11_Available;
  real_T *c11_b_Processing;
  real_T *c11_b_Available;
  real_T *c11_b_QueueLength;
  boolean_T guard1 = FALSE;
  boolean_T guard2 = FALSE;
  boolean_T guard3 = FALSE;
  c11_b_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c11_b_Available = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c11_b_Processing = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 10U, chartInstance->c11_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c11_b_Processing, 0U);
  _SFD_DATA_RANGE_CHECK(*c11_b_Available, 1U);
  _SFD_DATA_RANGE_CHECK(*c11_b_QueueLength, 2U);
  chartInstance->c11_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 10U, chartInstance->c11_sfEvent);
  c11_hoistedGlobal = *c11_b_Processing;
  c11_b_hoistedGlobal = *c11_b_QueueLength;
  c11_Processing = c11_hoistedGlobal;
  c11_QueueLength = c11_b_hoistedGlobal;
  sf_debug_symbol_scope_push_eml(0U, 7U, 7U, c11_debug_family_names,
    c11_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c11_aVarTruthTableCondition_1, 0U,
    c11_b_sf_marshallOut, c11_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c11_aVarTruthTableCondition_2, 1U,
    c11_b_sf_marshallOut, c11_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c11_nargin, 2U, c11_sf_marshallOut,
    c11_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c11_nargout, 3U, c11_sf_marshallOut,
    c11_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(&c11_Processing, 4U, c11_sf_marshallOut);
  sf_debug_symbol_scope_add_eml(&c11_QueueLength, 5U, c11_sf_marshallOut);
  sf_debug_symbol_scope_add_eml_importable(&c11_Available, 6U,
    c11_sf_marshallOut, c11_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 3);
  c11_aVarTruthTableCondition_1 = FALSE;
  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 4);
  c11_aVarTruthTableCondition_2 = FALSE;
  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 9);
  c11_aVarTruthTableCondition_1 = (c11_Processing > 0.0);
  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 13);
  c11_aVarTruthTableCondition_2 = (c11_QueueLength > 0.0);
  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 15);
  guard1 = FALSE;
  if (CV_EML_COND(0, 1, 0, c11_aVarTruthTableCondition_1)) {
    if (CV_EML_COND(0, 1, 1, c11_aVarTruthTableCondition_2)) {
      CV_EML_MCDC(0, 1, 0, TRUE);
      CV_EML_IF(0, 1, 0, TRUE);
      _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 16);
      CV_EML_FCN(0, 1);
      _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 29);
      c11_Available = 0.0;
      _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, -29);
    } else {
      guard1 = TRUE;
    }
  } else {
    guard1 = TRUE;
  }

  if (guard1 == TRUE) {
    CV_EML_MCDC(0, 1, 0, FALSE);
    CV_EML_IF(0, 1, 0, FALSE);
    _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 17);
    guard2 = FALSE;
    if (CV_EML_COND(0, 1, 2, c11_aVarTruthTableCondition_1)) {
      if (!CV_EML_COND(0, 1, 3, c11_aVarTruthTableCondition_2)) {
        CV_EML_MCDC(0, 1, 1, TRUE);
        CV_EML_IF(0, 1, 1, TRUE);
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 18);
        CV_EML_FCN(0, 1);
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 29);
        c11_Available = 0.0;
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, -29);
      } else {
        guard2 = TRUE;
      }
    } else {
      guard2 = TRUE;
    }

    if (guard2 == TRUE) {
      CV_EML_MCDC(0, 1, 1, FALSE);
      CV_EML_IF(0, 1, 1, FALSE);
      _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 19);
      guard3 = FALSE;
      if (!CV_EML_COND(0, 1, 4, c11_aVarTruthTableCondition_1)) {
        if (CV_EML_COND(0, 1, 5, c11_aVarTruthTableCondition_2)) {
          CV_EML_MCDC(0, 1, 2, TRUE);
          CV_EML_IF(0, 1, 2, TRUE);
          _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 20);
          CV_EML_FCN(0, 1);
          _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 29);
          c11_Available = 0.0;
          _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, -29);
        } else {
          guard3 = TRUE;
        }
      } else {
        guard3 = TRUE;
      }

      if (guard3 == TRUE) {
        CV_EML_MCDC(0, 1, 2, FALSE);
        CV_EML_IF(0, 1, 2, FALSE);
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 22);
        CV_EML_FCN(0, 2);
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, 35);
        c11_Available = 1.0;
        _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, -35);
      }
    }
  }

  _SFD_EML_CALL(0U, chartInstance->c11_sfEvent, -22);
  sf_debug_symbol_scope_pop();
  *c11_b_Available = c11_Available;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 10U, chartInstance->c11_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc11_WorkstationModel
  (SFc11_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c11_machineNumber, uint32_T
  c11_chartNumber)
{
}

static const mxArray *c11_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData)
{
  const mxArray *c11_mxArrayOutData = NULL;
  real_T c11_u;
  const mxArray *c11_y = NULL;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_mxArrayOutData = NULL;
  c11_u = *(real_T *)c11_inData;
  c11_y = NULL;
  sf_mex_assign(&c11_y, sf_mex_create("y", &c11_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c11_mxArrayOutData, c11_y, FALSE);
  return c11_mxArrayOutData;
}

static real_T c11_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_Available, const char_T *c11_identifier)
{
  real_T c11_y;
  emlrtMsgIdentifier c11_thisId;
  c11_thisId.fIdentifier = c11_identifier;
  c11_thisId.fParent = NULL;
  c11_y = c11_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c11_Available),
    &c11_thisId);
  sf_mex_destroy(&c11_Available);
  return c11_y;
}

static real_T c11_b_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId)
{
  real_T c11_y;
  real_T c11_d0;
  sf_mex_import(c11_parentId, sf_mex_dup(c11_u), &c11_d0, 1, 0, 0U, 0, 0U, 0);
  c11_y = c11_d0;
  sf_mex_destroy(&c11_u);
  return c11_y;
}

static void c11_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData)
{
  const mxArray *c11_Available;
  const char_T *c11_identifier;
  emlrtMsgIdentifier c11_thisId;
  real_T c11_y;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_Available = sf_mex_dup(c11_mxArrayInData);
  c11_identifier = c11_varName;
  c11_thisId.fIdentifier = c11_identifier;
  c11_thisId.fParent = NULL;
  c11_y = c11_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c11_Available),
    &c11_thisId);
  sf_mex_destroy(&c11_Available);
  *(real_T *)c11_outData = c11_y;
  sf_mex_destroy(&c11_mxArrayInData);
}

static const mxArray *c11_b_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData)
{
  const mxArray *c11_mxArrayOutData = NULL;
  boolean_T c11_u;
  const mxArray *c11_y = NULL;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_mxArrayOutData = NULL;
  c11_u = *(boolean_T *)c11_inData;
  c11_y = NULL;
  sf_mex_assign(&c11_y, sf_mex_create("y", &c11_u, 11, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c11_mxArrayOutData, c11_y, FALSE);
  return c11_mxArrayOutData;
}

static boolean_T c11_c_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId)
{
  boolean_T c11_y;
  boolean_T c11_b0;
  sf_mex_import(c11_parentId, sf_mex_dup(c11_u), &c11_b0, 1, 11, 0U, 0, 0U, 0);
  c11_y = c11_b0;
  sf_mex_destroy(&c11_u);
  return c11_y;
}

static void c11_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData)
{
  const mxArray *c11_aVarTruthTableCondition_2;
  const char_T *c11_identifier;
  emlrtMsgIdentifier c11_thisId;
  boolean_T c11_y;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_aVarTruthTableCondition_2 = sf_mex_dup(c11_mxArrayInData);
  c11_identifier = c11_varName;
  c11_thisId.fIdentifier = c11_identifier;
  c11_thisId.fParent = NULL;
  c11_y = c11_c_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c11_aVarTruthTableCondition_2), &c11_thisId);
  sf_mex_destroy(&c11_aVarTruthTableCondition_2);
  *(boolean_T *)c11_outData = c11_y;
  sf_mex_destroy(&c11_mxArrayInData);
}

const mxArray *sf_c11_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c11_nameCaptureInfo = NULL;
  c11_nameCaptureInfo = NULL;
  sf_mex_assign(&c11_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c11_nameCaptureInfo;
}

static const mxArray *c11_c_sf_marshallOut(void *chartInstanceVoid, void
  *c11_inData)
{
  const mxArray *c11_mxArrayOutData = NULL;
  int32_T c11_u;
  const mxArray *c11_y = NULL;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_mxArrayOutData = NULL;
  c11_u = *(int32_T *)c11_inData;
  c11_y = NULL;
  sf_mex_assign(&c11_y, sf_mex_create("y", &c11_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c11_mxArrayOutData, c11_y, FALSE);
  return c11_mxArrayOutData;
}

static int32_T c11_d_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId)
{
  int32_T c11_y;
  int32_T c11_i0;
  sf_mex_import(c11_parentId, sf_mex_dup(c11_u), &c11_i0, 1, 6, 0U, 0, 0U, 0);
  c11_y = c11_i0;
  sf_mex_destroy(&c11_u);
  return c11_y;
}

static void c11_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c11_mxArrayInData, const char_T *c11_varName, void *c11_outData)
{
  const mxArray *c11_b_sfEvent;
  const char_T *c11_identifier;
  emlrtMsgIdentifier c11_thisId;
  int32_T c11_y;
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c11_b_sfEvent = sf_mex_dup(c11_mxArrayInData);
  c11_identifier = c11_varName;
  c11_thisId.fIdentifier = c11_identifier;
  c11_thisId.fParent = NULL;
  c11_y = c11_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c11_b_sfEvent),
    &c11_thisId);
  sf_mex_destroy(&c11_b_sfEvent);
  *(int32_T *)c11_outData = c11_y;
  sf_mex_destroy(&c11_mxArrayInData);
}

static uint8_T c11_e_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_b_is_active_c11_WorkstationModel, const
  char_T *c11_identifier)
{
  uint8_T c11_y;
  emlrtMsgIdentifier c11_thisId;
  c11_thisId.fIdentifier = c11_identifier;
  c11_thisId.fParent = NULL;
  c11_y = c11_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c11_b_is_active_c11_WorkstationModel), &c11_thisId);
  sf_mex_destroy(&c11_b_is_active_c11_WorkstationModel);
  return c11_y;
}

static uint8_T c11_f_emlrt_marshallIn(SFc11_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c11_u, const emlrtMsgIdentifier *c11_parentId)
{
  uint8_T c11_y;
  uint8_T c11_u0;
  sf_mex_import(c11_parentId, sf_mex_dup(c11_u), &c11_u0, 1, 3, 0U, 0, 0U, 0);
  c11_y = c11_u0;
  sf_mex_destroy(&c11_u);
  return c11_y;
}

static void init_dsm_address_info(SFc11_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c11_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2047874258U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(651435754U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3185152236U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(4147884340U);
}

mxArray *sf_c11_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("n469iLnUaBRzneorQ7smjH");
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

static const mxArray *sf_get_sim_state_info_c11_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"Available\",},{M[8],M[0],T\"is_active_c11_WorkstationModel\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c11_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc11_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc11_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           11,
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
          _SFD_SET_DATA_PROPS(0,1,1,0,"Processing");
          _SFD_SET_DATA_PROPS(1,2,0,1,"Available");
          _SFD_SET_DATA_PROPS(2,1,1,0,"QueueLength");
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
        _SFD_CV_INIT_EML(0,1,3,3,0,0,0,0,6,3);
        _SFD_CV_INIT_EML_FCN(0,0,"tt_blk_kernel",0,-1,603);
        _SFD_CV_INIT_EML_FCN(0,1,"aFcnTruthTableAction_1",603,-1,680);
        _SFD_CV_INIT_EML_FCN(0,2,"aFcnTruthTableAction_2",680,-1,752);
        _SFD_CV_INIT_EML_IF(0,1,0,273,332,363,601);
        _SFD_CV_INIT_EML_IF(0,1,1,363,427,458,601);
        _SFD_CV_INIT_EML_IF(0,1,2,458,522,553,601);

        {
          static int condStart[] = { 277, 306 };

          static int condEnd[] = { 302, 331 };

          static int pfixExpr[] = { 0, 1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,0,277,331,2,0,&(condStart[0]),&(condEnd[0]),
                                3,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 371, 401 };

          static int condEnd[] = { 396, 426 };

          static int pfixExpr[] = { 0, 1, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,1,371,426,2,2,&(condStart[0]),&(condEnd[0]),
                                4,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 467, 496 };

          static int condEnd[] = { 492, 521 };

          static int pfixExpr[] = { 0, -1, 1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,2,466,521,2,4,&(condStart[0]),&(condEnd[0]),
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
          (MexFcnForType)c11_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c11_sf_marshallOut,(MexInFcnForType)c11_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c11_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c11_Processing;
          real_T *c11_Available;
          real_T *c11_QueueLength;
          c11_QueueLength = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c11_Available = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c11_Processing = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c11_Processing);
          _SFD_SET_DATA_VALUE_PTR(1U, c11_Available);
          _SFD_SET_DATA_VALUE_PTR(2U, c11_QueueLength);
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
  return "W9rUf9C2E6alurTwIkhBaC";
}

static void sf_opaque_initialize_c11_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c11_WorkstationModel(void *chartInstanceVar)
{
  enable_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c11_WorkstationModel(void *chartInstanceVar)
{
  disable_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c11_WorkstationModel(void *chartInstanceVar)
{
  sf_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c11_WorkstationModel(SimStruct*
  S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c11_WorkstationModel
    ((SFc11_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c11_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c11_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c11_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c11_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c11_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c11_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c11_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c11_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc11_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c11_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c11_WorkstationModel((SFc11_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c11_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      11);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,11,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,11,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,11,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,11,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,11);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(2862169109U));
  ssSetChecksum1(S,(3897306883U));
  ssSetChecksum2(S,(462331046U));
  ssSetChecksum3(S,(37895506U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c11_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Truth Table");
  }
}

static void mdlStart_c11_WorkstationModel(SimStruct *S)
{
  SFc11_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc11_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc11_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc11_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c11_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c11_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c11_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c11_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c11_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c11_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c11_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c11_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c11_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c11_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c11_WorkstationModel;
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

void c11_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c11_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c11_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c11_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c11_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
