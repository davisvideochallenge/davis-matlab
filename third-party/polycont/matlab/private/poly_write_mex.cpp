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
    if (nrhs!=2)
        mexErrMsgTxt("There should be 2 input parameter");
    

    /* From Matlab pointers to contour containers */
    ContContainer poly = cont_from_matlab(prhs[0]);

    /* Filename */
    std::string filename = mxArrayToString(prhs[1]);

    /* Call write code */
    write_polycont(filename, poly);

}
    
