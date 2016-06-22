// ------------------------------------------------------------------------
//  Copyright (C)
//  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
//  July 2015
// ------------------------------------------------------------------------
// area = poly_area_mex(poly);
#include "mex.h"

#include <matlab/private/matlab_interface.hpp>
#include <cpp/poly_compare.hpp>

using namespace std;
using namespace PolyCont;


void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{
    /* Check number of input parameter */
    if (nrhs!=1)
        mexErrMsgTxt("There should be 1 input only");
        

    /* From Matlab pointers to contour containers */
    ContContainer poly = cont_from_matlab(prhs[0]);
    
    /*-------------------------------------------*/
    /*              Get the area                 */
    /*-------------------------------------------*/ 
    double area = poly_area(poly);
    
    
    /*-------------------------------------------*/
    /*                 Output                    */
    /*-------------------------------------------*/
    
    /* ---- Area ---- */
    plhs[0] = mxCreateDoubleScalar(area);
}
    
