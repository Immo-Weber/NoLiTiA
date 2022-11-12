/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nolitia_var_initialize.c
 *
 * Code generation for function 'nolitia_var_initialize'
 *
 */

/* Include files */
#include "nolitia_var_initialize.h"
#include "_coder_nolitia_var_mex.h"
#include "nolitia_var.h"
#include "nolitia_var_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void nolitia_var_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (nolitia_var_initialize.c) */
