// ------------------------------------------------------------------------
//  Copyright (C)
//  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
//  July 2015
// ------------------------------------------------------------------------
// intersection = poly_intersection_mex(poly1, poly2);
#include "mex.h"

#include <matlab/private/matlab_interface.hpp>
#include <cpp/poly_compare.hpp>

using namespace std;
using namespace PolyCont;


void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{
    /* Check number of input parameter */
    if (nrhs!=2)
        mexErrMsgTxt("There should be 2 inputs");
        

    /* From Matlab pointers to contour containers */
    ContContainer poly1 = cont_from_matlab(prhs[0]);
    ContContainer poly2 = cont_from_matlab(prhs[1]);
    
    /*-------------------------------------------*/
    /*           Intersect polygons              */
    /*-------------------------------------------*/ 
    double intersection = poly_intersection(poly1, poly2);
    
    
    /*-------------------------------------------*/
    /*                 Output                    */
    /*-------------------------------------------*/
    
    /* ---- Intersection ---- */
    plhs[0] = mxCreateDoubleScalar(intersection);
}
    
