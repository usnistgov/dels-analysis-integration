/* Include files */

#include "blascompat32.h"
#include "WorkstationModel_sfun.h"
#include "c6_WorkstationModel.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "WorkstationModel_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c6_debug_family_names[4] = { "aVarTruthTableCondition_1",
  "nargin", "nargout", "CompletedJobCount" };

/* Function Declarations */
static void initialize_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance);
static void initialize_params_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance);
static void enable_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance);
static void disable_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance);
static void c6_update_debugger_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance);
static void set_sim_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance, const mxArray *c6_st);
static void finalize_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance);
static void sf_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance);
static void initSimStructsc6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c6_machineNumber, uint32_T
  c6_chartNumber);
static const mxArray *c6_sf_marshallOut(void *chartInstanceVoid, void *c6_inData);
static real_T c6_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void c6_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData);
static const mxArray *c6_b_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData);
static boolean_T c6_b_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void c6_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData);
static const mxArray *c6_c_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData);
static int32_T c6_c_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void c6_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData);
static uint8_T c6_d_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_b_is_active_c6_WorkstationModel, const
  char_T *c6_identifier);
static uint8_T c6_e_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void init_dsm_address_info(SFc6_WorkstationModelInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
  chartInstance->c6_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c6_is_active_c6_WorkstationModel = 0U;
}

static void initialize_params_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance)
{
}

static void enable_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_enable(chartInstance->S, 0, "fcn", 0);
}

static void disable_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  sf_call_output_fcn_disable(chartInstance->S, 0, "fcn", 0);
}

static void c6_update_debugger_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance)
{
  const mxArray *c6_st;
  const mxArray *c6_y = NULL;
  uint8_T c6_hoistedGlobal;
  uint8_T c6_u;
  const mxArray *c6_b_y = NULL;
  c6_st = NULL;
  c6_st = NULL;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_createcellarray(1), FALSE);
  c6_hoistedGlobal = chartInstance->c6_is_active_c6_WorkstationModel;
  c6_u = c6_hoistedGlobal;
  c6_b_y = NULL;
  sf_mex_assign(&c6_b_y, sf_mex_create("y", &c6_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c6_y, 0, c6_b_y);
  sf_mex_assign(&c6_st, c6_y, FALSE);
  return c6_st;
}

static void set_sim_state_c6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance, const mxArray *c6_st)
{
  const mxArray *c6_u;
  chartInstance->c6_doneDoubleBufferReInit = TRUE;
  c6_u = sf_mex_dup(c6_st);
  chartInstance->c6_is_active_c6_WorkstationModel = c6_d_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c6_u, 0)),
     "is_active_c6_WorkstationModel");
  sf_mex_destroy(&c6_u);
  c6_update_debugger_state_c6_WorkstationModel(chartInstance);
  sf_mex_destroy(&c6_st);
}

static void finalize_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
}

static void sf_c6_WorkstationModel(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
  real_T c6_hoistedGlobal;
  real_T c6_CompletedJobCount;
  uint32_T c6_debug_family_var_map[4];
  boolean_T c6_aVarTruthTableCondition_1;
  real_T c6_nargin = 1.0;
  real_T c6_nargout = 0.0;
  real_T *c6_b_CompletedJobCount;
  c6_b_CompletedJobCount = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c6_b_CompletedJobCount, 0U);
  chartInstance->c6_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  c6_hoistedGlobal = *c6_b_CompletedJobCount;
  c6_CompletedJobCount = c6_hoistedGlobal;
  sf_debug_symbol_scope_push_eml(0U, 4U, 4U, c6_debug_family_names,
    c6_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c6_aVarTruthTableCondition_1, 0U,
    c6_b_sf_marshallOut, c6_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c6_nargin, 1U, c6_sf_marshallOut,
    c6_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c6_nargout, 2U, c6_sf_marshallOut,
    c6_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(&c6_CompletedJobCount, 3U, c6_sf_marshallOut);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 3);
  c6_aVarTruthTableCondition_1 = FALSE;
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 8);
  c6_aVarTruthTableCondition_1 = (c6_CompletedJobCount == 10.0);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 10);
  if (CV_EML_IF(0, 1, 0, c6_aVarTruthTableCondition_1)) {
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 11);
    CV_EML_FCN(0, 1);
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 20);
    sf_call_output_fcn_call(chartInstance->S, 0, "fcn", 0);
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, -20);
  } else {
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 13);
    CV_EML_FCN(0, 2);
  }

  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, -13);
  sf_debug_symbol_scope_pop();
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  sf_debug_check_for_state_inconsistency(_WorkstationModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc6_WorkstationModel
  (SFc6_WorkstationModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c6_machineNumber, uint32_T
  c6_chartNumber)
{
}

static const mxArray *c6_sf_marshallOut(void *chartInstanceVoid, void *c6_inData)
{
  const mxArray *c6_mxArrayOutData = NULL;
  real_T c6_u;
  const mxArray *c6_y = NULL;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_mxArrayOutData = NULL;
  c6_u = *(real_T *)c6_inData;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_create("y", &c6_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c6_mxArrayOutData, c6_y, FALSE);
  return c6_mxArrayOutData;
}

static real_T c6_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  real_T c6_y;
  real_T c6_d0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_d0, 1, 0, 0U, 0, 0U, 0);
  c6_y = c6_d0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void c6_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData)
{
  const mxArray *c6_nargout;
  const char_T *c6_identifier;
  emlrtMsgIdentifier c6_thisId;
  real_T c6_y;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_nargout = sf_mex_dup(c6_mxArrayInData);
  c6_identifier = c6_varName;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_emlrt_marshallIn(chartInstance, sf_mex_dup(c6_nargout), &c6_thisId);
  sf_mex_destroy(&c6_nargout);
  *(real_T *)c6_outData = c6_y;
  sf_mex_destroy(&c6_mxArrayInData);
}

static const mxArray *c6_b_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData)
{
  const mxArray *c6_mxArrayOutData = NULL;
  boolean_T c6_u;
  const mxArray *c6_y = NULL;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_mxArrayOutData = NULL;
  c6_u = *(boolean_T *)c6_inData;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_create("y", &c6_u, 11, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c6_mxArrayOutData, c6_y, FALSE);
  return c6_mxArrayOutData;
}

static boolean_T c6_b_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  boolean_T c6_y;
  boolean_T c6_b0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_b0, 1, 11, 0U, 0, 0U, 0);
  c6_y = c6_b0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void c6_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData)
{
  const mxArray *c6_aVarTruthTableCondition_1;
  const char_T *c6_identifier;
  emlrtMsgIdentifier c6_thisId;
  boolean_T c6_y;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_aVarTruthTableCondition_1 = sf_mex_dup(c6_mxArrayInData);
  c6_identifier = c6_varName;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_b_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c6_aVarTruthTableCondition_1), &c6_thisId);
  sf_mex_destroy(&c6_aVarTruthTableCondition_1);
  *(boolean_T *)c6_outData = c6_y;
  sf_mex_destroy(&c6_mxArrayInData);
}

const mxArray *sf_c6_WorkstationModel_get_eml_resolved_functions_info(void)
{
  const mxArray *c6_nameCaptureInfo = NULL;
  c6_nameCaptureInfo = NULL;
  sf_mex_assign(&c6_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c6_nameCaptureInfo;
}

static const mxArray *c6_c_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData)
{
  const mxArray *c6_mxArrayOutData = NULL;
  int32_T c6_u;
  const mxArray *c6_y = NULL;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_mxArrayOutData = NULL;
  c6_u = *(int32_T *)c6_inData;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_create("y", &c6_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c6_mxArrayOutData, c6_y, FALSE);
  return c6_mxArrayOutData;
}

static int32_T c6_c_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  int32_T c6_y;
  int32_T c6_i0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_i0, 1, 6, 0U, 0, 0U, 0);
  c6_y = c6_i0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void c6_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData)
{
  const mxArray *c6_b_sfEvent;
  const char_T *c6_identifier;
  emlrtMsgIdentifier c6_thisId;
  int32_T c6_y;
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)chartInstanceVoid;
  c6_b_sfEvent = sf_mex_dup(c6_mxArrayInData);
  c6_identifier = c6_varName;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c6_b_sfEvent),
    &c6_thisId);
  sf_mex_destroy(&c6_b_sfEvent);
  *(int32_T *)c6_outData = c6_y;
  sf_mex_destroy(&c6_mxArrayInData);
}

static uint8_T c6_d_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_b_is_active_c6_WorkstationModel, const
  char_T *c6_identifier)
{
  uint8_T c6_y;
  emlrtMsgIdentifier c6_thisId;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c6_b_is_active_c6_WorkstationModel), &c6_thisId);
  sf_mex_destroy(&c6_b_is_active_c6_WorkstationModel);
  return c6_y;
}

static uint8_T c6_e_emlrt_marshallIn(SFc6_WorkstationModelInstanceStruct
  *chartInstance, const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  uint8_T c6_y;
  uint8_T c6_u0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_u0, 1, 3, 0U, 0, 0U, 0);
  c6_y = c6_u0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void init_dsm_address_info(SFc6_WorkstationModelInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c6_WorkstationModel_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(62884893U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(167215013U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3102388624U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2340473334U);
}

mxArray *sf_c6_WorkstationModel_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("cPED91qOP5chirnW9PjzU");
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
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c6_WorkstationModel(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S'type','srcId','name','auxInfo'{{M[8],M[0],T\"is_active_c6_WorkstationModel\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 1, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c6_WorkstationModel_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc6_WorkstationModelInstanceStruct *chartInstance;
    chartInstance = (SFc6_WorkstationModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_WorkstationModelMachineNumber_,
           6,
           1,
           1,
           1,
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
          _SFD_SET_DATA_PROPS(0,1,1,0,"CompletedJobCount");
          _SFD_EVENT_SCOPE(0,2);
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
        _SFD_CV_INIT_EML(0,1,3,1,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"tt_blk_kernel",0,-1,273);
        _SFD_CV_INIT_EML_FCN(0,1,"aFcnTruthTableAction_1",273,-1,340);
        _SFD_CV_INIT_EML_FCN(0,2,"aFcnTruthTableAction_2",340,-1,388);
        _SFD_CV_INIT_EML_IF(0,1,0,162,192,223,271);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c6_CompletedJobCount;
          c6_CompletedJobCount = (real_T *)ssGetInputPortSignal(chartInstance->S,
            0);
          _SFD_SET_DATA_VALUE_PTR(0U, c6_CompletedJobCount);
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
  return "0FiPnXxXglYg712k7MfEqE";
}

static void sf_opaque_initialize_c6_WorkstationModel(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar);
  initialize_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c6_WorkstationModel(void *chartInstanceVar)
{
  enable_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c6_WorkstationModel(void *chartInstanceVar)
{
  disable_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c6_WorkstationModel(void *chartInstanceVar)
{
  sf_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c6_WorkstationModel(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c6_WorkstationModel
    ((SFc6_WorkstationModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c6_WorkstationModel();/* state var info */
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

extern void sf_internal_set_sim_state_c6_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c6_WorkstationModel();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c6_WorkstationModel(SimStruct* S)
{
  return sf_internal_get_sim_state_c6_WorkstationModel(S);
}

static void sf_opaque_set_sim_state_c6_WorkstationModel(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c6_WorkstationModel(S, st);
}

static void sf_opaque_terminate_c6_WorkstationModel(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc6_WorkstationModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_WorkstationModel_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c6_WorkstationModel(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c6_WorkstationModel((SFc6_WorkstationModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c6_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_WorkstationModel_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      6);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,6,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,6,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_mark_output_events_with_multiple_callers(S,sf_get_instance_specialization
      (),infoStruct,6,1);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,6,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,6);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(865843733U));
  ssSetChecksum1(S,(4043823609U));
  ssSetChecksum2(S,(3020082877U));
  ssSetChecksum3(S,(4017662375U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c6_WorkstationModel(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Truth Table");
  }
}

static void mdlStart_c6_WorkstationModel(SimStruct *S)
{
  SFc6_WorkstationModelInstanceStruct *chartInstance;
  chartInstance = (SFc6_WorkstationModelInstanceStruct *)malloc(sizeof
    (SFc6_WorkstationModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc6_WorkstationModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c6_WorkstationModel;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c6_WorkstationModel;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c6_WorkstationModel;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c6_WorkstationModel;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c6_WorkstationModel;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c6_WorkstationModel;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c6_WorkstationModel;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c6_WorkstationModel;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c6_WorkstationModel;
  chartInstance->chartInfo.mdlStart = mdlStart_c6_WorkstationModel;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c6_WorkstationModel;
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

void c6_WorkstationModel_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c6_WorkstationModel(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c6_WorkstationModel(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c6_WorkstationModel(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c6_WorkstationModel_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
