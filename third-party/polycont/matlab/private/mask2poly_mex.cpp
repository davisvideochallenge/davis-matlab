// ------------------------------------------------------------------------
//  Copyright (C)
//  Disney Research, Zurich
//
//  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
//  June 2014
// ------------------------------------------------------------------------
// mask2poly_mex(mask, border, simplify_tol)
#include "mex.h"
#include <Eigen/Dense>
#include <matlab/private/matlab_interface.hpp>
#include <cpp/mask2polycont.hpp>

using namespace std;
using namespace PolyCont;

void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{
    /* Check number of input parameter */
    if (nrhs==0)
        mexErrMsgTxt("There should be at least 1 input parameter");
    else if (nrhs>3)
        mexErrMsgTxt("Maximum 3 input parameters");
    
    /* Parameter controling the amount of simplifiction of the contour points */
    double simplify_tol;
    if(nrhs<2)
        simplify_tol = 0;
    else
        simplify_tol = mxGetScalar(prhs[1]);
    
    /* Input Mask - Matrix of booleans */
    Eigen::Map<Eigen::Array<bool,Eigen::Dynamic,Eigen::Dynamic> >
            mask((bool*)mxGetData(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    
    /* Output contours */
    ContContainer all_conts;
            
    
    /*-------------------------------------------*/
    /*         Call the actual function          */
    /*-------------------------------------------*/
    mask2polycont(mask, all_conts, simplify_tol);
 
    
    /*-------------------------------------------*/
    /*                 Output                    */
    /*-------------------------------------------*/
    cont_to_matlab(all_conts, plhs[0]);

}
    
