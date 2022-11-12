/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_nolitia_var_mex.c
 *
 * Code generation for function '_coder_nolitia_var_mex'
 *
 */

/* Include files */
#include "_coder_nolitia_var_mex.h"
#include "_coder_nolitia_var_api.h"
#include "nolitia_var.h"
#include "nolitia_var_data.h"
#include "nolitia_var_initialize.h"
#include "nolitia_var_terminate.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void nolitia_var_mexFunction(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[2]);

/* Function Definitions */
void nolitia_var_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const
  mxArray *prhs[2])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        11, "nolitia_var");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 11,
                        "nolitia_var");
  }

  /* Call the function. */
  nolitia_var_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&nolitia_var_atexit);

  /* Module initialization. */
  nolitia_var_initialize();

  /* Dispatch the entry-point. */
  nolitia_var_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  nolitia_var_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_nolitia_var_mex.c) */
