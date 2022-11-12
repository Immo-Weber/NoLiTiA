/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nolitia_var.c
 *
 * Code generation for function 'nolitia_var'
 *
 */

/* Include files */
#include "nolitia_var.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "nolitia_var_data.h"
#include "nolitia_var_emxutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 5,     /* lineNo */
  "nolitia_var",                       /* fcnName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 20,  /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 99,  /* lineNo */
  "sumprod",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 125, /* lineNo */
  "combineVectorElements",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 152, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 164, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 169, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 185, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 187, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 21,  /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 18,  /* lineNo */
  "abs",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\abs.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 75,  /* lineNo */
  "applyScalarFunction",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyScalarFunction.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 70,  /* lineNo */
  "power",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\power.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 79,  /* lineNo */
  "fltpower",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\power.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 66,  /* lineNo */
  "applyBinaryScalarFunction",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 188, /* lineNo */
  "flatIter",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 4,   /* lineNo */
  7,                                   /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  5,                                   /* lineNo */
  22,                                  /* colNo */
  "data",                              /* aName */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { 3,     /* nDims */
  5,                                   /* lineNo */
  17,                                  /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { 3,   /* nDims */
  5,                                   /* lineNo */
  8,                                   /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 3, /* lineNo */
  1,                                   /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo d_emlrtRTEI = { 7, /* lineNo */
  1,                                   /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 20,/* lineNo */
  1,                                   /* colNo */
  "sum",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 5, /* lineNo */
  31,                                  /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo g_emlrtRTEI = { 125,/* lineNo */
  13,                                  /* colNo */
  "combineVectorElements",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 5, /* lineNo */
  17,                                  /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo i_emlrtRTEI = { 18,/* lineNo */
  5,                                   /* colNo */
  "abs",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\abs.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 79,/* lineNo */
  5,                                   /* colNo */
  "power",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\power.m"/* pName */
};

static emlrtRTEInfo k_emlrtRTEI = { 5, /* lineNo */
  1,                                   /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

static emlrtRTEInfo l_emlrtRTEI = { 1, /* lineNo */
  16,                                  /* colNo */
  "nolitia_var",                       /* fName */
  "\\\\dfs.hrz.uni-marburg.de\\projekte\\FB20\\NEUROLOGIE_FORSCHUNG\\AG Clinical Systems Neuroscience\\PIs\\Immo und Carina\\Immo\\Studien\\No"
  "liTiA\\Toolbox\\NoliTiA_v1.1.1\\statistics\\core\\test\\nolitia_var.m"/* pName */
};

/* Function Definitions */
void nolitia_var(const emlrtStack *sp, const emxArray_real_T *data, real_T nobs,
                 emxArray_real_T *v)
{
  int32_T i;
  int32_T xpageoffset;
  emxArray_real_T *y;
  int32_T vlen;
  emxArray_real_T *z1;
  int32_T loop_ub;
  emxArray_real_T *b_data;
  int32_T i1;
  int32_T b_i;
  int32_T b_loop_ub;
  int32_T c_loop_ub;
  int32_T c_i;
  int32_T i2;
  int32_T d_loop_ub;
  uint32_T sz_idx_1;
  uint32_T sz_idx_2;
  int32_T npages;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  i = v->size[0] * v->size[1] * v->size[2];
  v->size[0] = 1;
  v->size[1] = data->size[1];
  v->size[2] = data->size[2];
  emxEnsureCapacity_real_T(sp, v, i, &c_emlrtRTEI);
  xpageoffset = data->size[1] * data->size[2];
  for (i = 0; i < xpageoffset; i++) {
    v->data[i] = 0.0;
  }

  i = (int32_T)nobs;
  emlrtForLoopVectorCheckR2012b(1.0, 1.0, nobs, mxDOUBLE_CLASS, (int32_T)nobs,
    &emlrtRTEI, sp);
  emxInit_real_T(sp, &y, 3, &f_emlrtRTEI, true);
  if (0 <= i - 1) {
    vlen = data->size[0];
    loop_ub = data->size[1];
    i1 = data->size[2];
    b_loop_ub = data->size[2];
    c_loop_ub = data->size[1];
    i2 = data->size[2];
    d_loop_ub = data->size[2];
  }

  emxInit_real_T(sp, &z1, 3, &l_emlrtRTEI, true);
  emxInit_real_T(sp, &b_data, 3, &h_emlrtRTEI, true);
  for (b_i = 0; b_i < i; b_i++) {
    c_i = b_i + 1;
    if ((c_i < 1) || (c_i > data->size[0])) {
      emlrtDynamicBoundsCheckR2012b(c_i, 1, data->size[0], &emlrtBCI, sp);
    }

    st.site = &emlrtRSI;
    b_st.site = &b_emlrtRSI;
    c_st.site = &c_emlrtRSI;
    if ((data->size[0] == 0) || (data->size[1] == 0) || (data->size[2] == 0)) {
      sz_idx_1 = (uint32_T)data->size[1];
      sz_idx_2 = (uint32_T)data->size[2];
      c_i = y->size[0] * y->size[1] * y->size[2];
      y->size[0] = 1;
      y->size[1] = (int32_T)sz_idx_1;
      y->size[2] = (int32_T)sz_idx_2;
      emxEnsureCapacity_real_T(&c_st, y, c_i, &e_emlrtRTEI);
      xpageoffset = (int32_T)sz_idx_1 * (int32_T)sz_idx_2;
      for (c_i = 0; c_i < xpageoffset; c_i++) {
        y->data[c_i] = 0.0;
      }
    } else {
      d_st.site = &d_emlrtRSI;
      e_st.site = &e_emlrtRSI;
      npages = 1;
      k = 3;
      if (data->size[2] == 1) {
        k = 2;
      }

      for (xpageoffset = 2; xpageoffset <= k; xpageoffset++) {
        npages *= data->size[xpageoffset - 1];
      }

      c_i = y->size[0] * y->size[1] * y->size[2];
      y->size[0] = 1;
      y->size[1] = data->size[1];
      y->size[2] = data->size[2];
      emxEnsureCapacity_real_T(&d_st, y, c_i, &g_emlrtRTEI);
      e_st.site = &f_emlrtRSI;
      if ((1 <= npages) && (npages > 2147483646)) {
        f_st.site = &k_emlrtRSI;
        check_forloop_overflow_error(&f_st);
      }

      for (c_i = 0; c_i < npages; c_i++) {
        xpageoffset = c_i * data->size[0];
        e_st.site = &g_emlrtRSI;
        y->data[c_i] = data->data[xpageoffset];
        e_st.site = &h_emlrtRSI;
        if ((2 <= vlen) && (vlen > 2147483646)) {
          f_st.site = &k_emlrtRSI;
          check_forloop_overflow_error(&f_st);
        }

        for (k = 2; k <= vlen; k++) {
          e_st.site = &i_emlrtRSI;
          y->data[c_i] += data->data[(xpageoffset + k) - 1];
        }
      }
    }

    xpageoffset = y->size[0] * y->size[1] * y->size[2];
    c_i = y->size[0] * y->size[1] * y->size[2];
    y->size[0] = 1;
    emxEnsureCapacity_real_T(sp, y, c_i, &f_emlrtRTEI);
    for (c_i = 0; c_i < xpageoffset; c_i++) {
      y->data[c_i] /= nobs;
    }

    c_i = b_data->size[0] * b_data->size[1] * b_data->size[2];
    b_data->size[0] = 1;
    b_data->size[1] = loop_ub;
    b_data->size[2] = i1;
    emxEnsureCapacity_real_T(sp, b_data, c_i, &h_emlrtRTEI);
    for (c_i = 0; c_i < b_loop_ub; c_i++) {
      for (xpageoffset = 0; xpageoffset < loop_ub; xpageoffset++) {
        b_data->data[xpageoffset + b_data->size[1] * c_i] = data->data[(b_i +
          data->size[0] * xpageoffset) + data->size[0] * data->size[1] * c_i];
      }
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[3])b_data->size, *(int32_T (*)[3])
      y->size, &emlrtECI, sp);
    st.site = &emlrtRSI;
    c_i = y->size[0] * y->size[1] * y->size[2];
    y->size[0] = 1;
    y->size[1] = c_loop_ub;
    y->size[2] = i2;
    emxEnsureCapacity_real_T(&st, y, c_i, &h_emlrtRTEI);
    for (c_i = 0; c_i < d_loop_ub; c_i++) {
      for (xpageoffset = 0; xpageoffset < c_loop_ub; xpageoffset++) {
        y->data[xpageoffset + y->size[1] * c_i] = data->data[(b_i + data->size[0]
          * xpageoffset) + data->size[0] * data->size[1] * c_i] - y->
          data[xpageoffset + y->size[1] * c_i];
      }
    }

    b_st.site = &l_emlrtRSI;
    xpageoffset = y->size[1] * y->size[2];
    c_i = b_data->size[0] * b_data->size[1] * b_data->size[2];
    b_data->size[0] = 1;
    b_data->size[1] = y->size[1];
    b_data->size[2] = y->size[2];
    emxEnsureCapacity_real_T(&b_st, b_data, c_i, &i_emlrtRTEI);
    c_st.site = &m_emlrtRSI;
    if ((1 <= xpageoffset) && (xpageoffset > 2147483646)) {
      d_st.site = &k_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < xpageoffset; k++) {
      b_data->data[k] = muDoubleScalarAbs(y->data[k]);
    }

    st.site = &emlrtRSI;
    b_st.site = &n_emlrtRSI;
    c_st.site = &o_emlrtRSI;
    sz_idx_1 = (uint32_T)b_data->size[1];
    sz_idx_2 = (uint32_T)b_data->size[2];
    c_i = z1->size[0] * z1->size[1] * z1->size[2];
    z1->size[0] = 1;
    z1->size[1] = (int32_T)sz_idx_1;
    z1->size[2] = (int32_T)sz_idx_2;
    emxEnsureCapacity_real_T(&c_st, z1, c_i, &j_emlrtRTEI);
    d_st.site = &p_emlrtRSI;
    xpageoffset = (int32_T)sz_idx_1 * (int32_T)sz_idx_2;
    e_st.site = &q_emlrtRSI;
    if ((1 <= xpageoffset) && (xpageoffset > 2147483646)) {
      f_st.site = &k_emlrtRSI;
      check_forloop_overflow_error(&f_st);
    }

    for (k = 0; k < xpageoffset; k++) {
      z1->data[k] = b_data->data[k] * b_data->data[k];
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[3])v->size, *(int32_T (*)[3])z1->size,
      &b_emlrtECI, sp);
    xpageoffset = v->size[0] * v->size[1] * v->size[2];
    c_i = v->size[0] * v->size[1] * v->size[2];
    v->size[0] = 1;
    emxEnsureCapacity_real_T(sp, v, c_i, &k_emlrtRTEI);
    for (c_i = 0; c_i < xpageoffset; c_i++) {
      v->data[c_i] += z1->data[c_i];
    }

    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxFree_real_T(&b_data);
  emxFree_real_T(&z1);
  emxFree_real_T(&y);
  xpageoffset = v->size[0] * v->size[1] * v->size[2];
  i = v->size[0] * v->size[1] * v->size[2];
  v->size[0] = 1;
  emxEnsureCapacity_real_T(sp, v, i, &d_emlrtRTEI);
  for (i = 0; i < xpageoffset; i++) {
    v->data[i] /= nobs - 1.0;
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (nolitia_var.c) */
