// ------------------------------------------------------------------------
//  Copyright (C)
//  Disney Research, Zurich
//
//  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
//  June 2014
// ------------------------------------------------------------------------
// mask = poly2mask_mex(poly)
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
    
    /* From Matlab pointers to contour containers */
    ContContainer poly = cont_from_matlab(prhs[0]);

    /* Call actual code */
    MaskType mask;
    polycont2mask(poly, mask);

    /* Output Mask - Matrix of booleans */
    plhs[0] = mxCreateLogicalMatrix(mask.rows(), mask.cols());
    Eigen::Map<Eigen::Array<bool,Eigen::Dynamic,Eigen::Dynamic> >
            mask_map((bool*)mxGetData(plhs[0]),mask.rows(),mask.cols());
    for(std::size_t ii=0; ii<mask.rows(); ++ii)
        for(std::size_t jj=0; jj<mask.cols(); ++jj)
            mask_map(ii,jj) = mask(ii,jj);
}   
    
