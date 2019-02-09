/* Include files */

#include "WorkstationModel_sfun.h"
#include "c1_WorkstationModel.h"
#include "c2_WorkstationModel.h"
#include "c3_WorkstationModel.h"
#include "c4_WorkstationModel.h"
#include "c5_WorkstationModel.h"
#include "c6_WorkstationModel.h"
#include "c7_WorkstationModel.h"
#include "c8_WorkstationModel.h"
#include "c9_WorkstationModel.h"
#include "c10_WorkstationModel.h"
#include "c11_WorkstationModel.h"
#include "c12_WorkstationModel.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _WorkstationModelMachineNumber_;
real_T _sfTime_;

/* Function Declarations */

/* Function Definitions */
void WorkstationModel_initializer(void)
{
}

void WorkstationModel_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_WorkstationModel_method_dispatcher(SimStruct *simstructPtr,
  unsigned int chartFileNumber, const char* specsCksum, int_T method, void *data)
{
  if (chartFileNumber==1) {
    c1_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==2) {
    c2_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==3) {
    c3_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==4) {
    c4_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==5) {
    c5_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==6) {
    c6_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==7) {
    c7_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==8) {
    c8_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==9) {
    c9_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==10) {
    c10_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==11) {
    c11_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==12) {
    c12_WorkstationModel_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

unsigned int sf_WorkstationModel_process_check_sum_call( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(439204582U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(406143278U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(448391652U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2712745605U);
    } else if (!strcmp(commandName,"exportedFcn")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0U);
    } else if (!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(791197459U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3651277872U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1769759129U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2376360547U);
    } else if (nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch (chartFileNumber) {
       case 1:
        {
          extern void sf_c1_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c1_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 2:
        {
          extern void sf_c2_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c2_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 3:
        {
          extern void sf_c3_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c3_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 4:
        {
          extern void sf_c4_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c4_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 5:
        {
          extern void sf_c5_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c5_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 6:
        {
          extern void sf_c6_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c6_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 7:
        {
          extern void sf_c7_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c7_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 8:
        {
          extern void sf_c8_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c8_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 9:
        {
          extern void sf_c9_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c9_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 10:
        {
          extern void sf_c10_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c10_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 11:
        {
          extern void sf_c11_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c11_WorkstationModel_get_check_sum(plhs);
          break;
        }

       case 12:
        {
          extern void sf_c12_WorkstationModel_get_check_sum(mxArray *plhs[]);
          sf_c12_WorkstationModel_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    } else if (!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3564696471U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(678668628U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1090454852U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3896867807U);
    } else {
      return 0;
    }
  } else {
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(402935763U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1355349944U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2950393957U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3901582584U);
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_WorkstationModel_autoinheritance_info( int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "glDp5R2FxtRsJTpCHyoISD") == 0) {
          extern mxArray *sf_c1_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c1_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 2:
      {
        if (strcmp(aiChksum, "DgljjvvgNPBpuaNJTzEhPE") == 0) {
          extern mxArray *sf_c2_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c2_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 3:
      {
        if (strcmp(aiChksum, "cPED91qOP5chirnW9PjzU") == 0) {
          extern mxArray *sf_c3_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c3_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 4:
      {
        if (strcmp(aiChksum, "DgljjvvgNPBpuaNJTzEhPE") == 0) {
          extern mxArray *sf_c4_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c4_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 5:
      {
        if (strcmp(aiChksum, "eBEEm4ul1tmU4emgHfbkp") == 0) {
          extern mxArray *sf_c5_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c5_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 6:
      {
        if (strcmp(aiChksum, "cPED91qOP5chirnW9PjzU") == 0) {
          extern mxArray *sf_c6_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c6_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 7:
      {
        if (strcmp(aiChksum, "kGUUkVIQiGCGPnG4pb89kG") == 0) {
          extern mxArray *sf_c7_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c7_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 8:
      {
        if (strcmp(aiChksum, "oo47cGgFPDtsRTvscifTEE") == 0) {
          extern mxArray *sf_c8_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c8_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 9:
      {
        if (strcmp(aiChksum, "dIZlRsBSCDAPtjtTjYZJlD") == 0) {
          extern mxArray *sf_c9_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c9_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 10:
      {
        if (strcmp(aiChksum, "kNjEqAbRKaKQe7wEWEEgiH") == 0) {
          extern mxArray *sf_c10_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c10_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 11:
      {
        if (strcmp(aiChksum, "n469iLnUaBRzneorQ7smjH") == 0) {
          extern mxArray *sf_c11_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c11_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 12:
      {
        if (strcmp(aiChksum, "uk3UGQXkBHQiQXaol9MWoH") == 0) {
          extern mxArray *sf_c12_WorkstationModel_get_autoinheritance_info(void);
          plhs[0] = sf_c12_WorkstationModel_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_WorkstationModel_get_eml_resolved_functions_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray
          *sf_c1_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 2:
      {
        extern const mxArray
          *sf_c2_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c2_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 3:
      {
        extern const mxArray
          *sf_c3_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c3_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 4:
      {
        extern const mxArray
          *sf_c4_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c4_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 5:
      {
        extern const mxArray
          *sf_c5_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c5_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 6:
      {
        extern const mxArray
          *sf_c6_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c6_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 7:
      {
        extern const mxArray
          *sf_c7_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c7_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 8:
      {
        extern const mxArray
          *sf_c8_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c8_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 9:
      {
        extern const mxArray
          *sf_c9_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c9_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 10:
      {
        extern const mxArray
          *sf_c10_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c10_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 11:
      {
        extern const mxArray
          *sf_c11_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c11_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 12:
      {
        extern const mxArray
          *sf_c12_WorkstationModel_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c12_WorkstationModel_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

void WorkstationModel_debug_initialize(void)
{
  _WorkstationModelMachineNumber_ = sf_debug_initialize_machine(
    "WorkstationModel","sfun",0,12,0,0,0);
  sf_debug_set_machine_event_thresholds(_WorkstationModelMachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(_WorkstationModelMachineNumber_,0);
}

void WorkstationModel_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_WorkstationModel_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info(
      "WorkstationModel", "WorkstationModel");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_WorkstationModel_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
