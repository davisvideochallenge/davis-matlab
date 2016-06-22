// ------------------------------------------------------------------------
//  Copyright (C)
//  Disney Research, Zurich
//
//  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
//  June 2014
// ------------------------------------------------------------------------
// mask2poly_mex(mask, border, simplify_tol)
#include "mex.h"
#include <matlab/private/matlab_interface.hpp>
#include <cpp/io.hpp>

using namespace std;
using namespace PolyCont;

void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{
    /* Check number of input parameter */
    if (nrhs!=1)
        mexErrMsgTxt("There should be 1 input parameter");
    
    /* Filename */
    std::string filename = mxArrayToString(prhs[0]);

    /* Call write code */
    ContContainer poly;
    read_polycont(filename, poly);

    /* From Matlab pointers to contour containers */
    cont_to_matlab(poly, plhs[0]);
}
    
