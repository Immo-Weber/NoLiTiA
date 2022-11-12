
#include "mex.h"
#include "stdlib.h"

/* The computational routine */
void neigh(double  inputMatrix[10], double subq[10], double mode, mwSize n_sub, mwSize dim, mwSize n, double res[10][10])
{
    
    
    
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
                  
    double *inputMatrix;               
    size_t dim;                   
    size_t n=0;
	size_t n_sub=0;                   
    double *outputMatrix;             
    mwSize i=0;
    mwSize j=0;
    mwSize q=0;
    double tges=0;
    mwSize  ind1=0;
    mwSize ind2=0;
    int k=0;
    double *subq;
    double mode;
            
    
    inputMatrix = mxGetPr(prhs[0]);
	subq = mxGetPr(prhs[1]);
    mode=mxGetScalar(prhs[2]);
   


     /* get dimensions of the input matrix */
    dim = mxGetN(prhs[0]);
    n = mxGetM(prhs[0]);
    n_sub=mxGetM(prhs[1]);
    
    
    /* create the output matrix */
    
    plhs[0] = mxCreateDoubleMatrix(n,n_sub,mxREAL);
    outputMatrix = mxGetPr(plhs[0]);
    
    if ( mode==1){
    
    for (i=0; i<n_sub;i++){
	for (j=0;  j<n;j++){		
		tges=0;
		for (q=0; q<dim; q++){
		ind1=q*n+subq[i]-1;
		ind2=q*n+j;
		tges=((inputMatrix[ind1]-inputMatrix[ind2])*(inputMatrix[ind1]-inputMatrix[ind2]))+tges;
		}
		outputMatrix[k]=sqrt(tges);
        k=k++;
	}
    }
    }else { 
        if ( mode==2){
        for (i=0; i<n_sub;i++){
        for (j=0;  j<n;j++){		
		tges=0;
		for (q=0; q<dim; q++){
		ind1=q*n+subq[i]-1;
		ind2=q*n+j;
		if (fabs(inputMatrix[ind1]-inputMatrix[ind2])>tges) {
        tges=fabs(inputMatrix[ind1]-inputMatrix[ind2]);
        }
		}
		outputMatrix[k]=tges;
        k=k++;
	}
    }
    }
    }
     /* call the computational routine */
    neigh(inputMatrix,subq,mode,(mwSize)n_sub,(mwSize)dim,(mwSize)n,outputMatrix);
    
}
