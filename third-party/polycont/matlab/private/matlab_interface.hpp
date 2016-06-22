
#ifndef MATLAB_INTERFACE_HPP
#define MATLAB_INTERFACE_HPP

#include "mex.h"
#include <Eigen/Dense>
#include <cpp/containers.hpp>

namespace PolyCont
{
    ContContainer cont_from_matlab(const mxArray * mat_pointer)
    {
        /* Check sizes */
        std::size_t nfields = mxGetNumberOfFields(mat_pointer);
        assert(nfields==2);
        
        /* Get polygons */
        mxArray* paths = mxGetField(mat_pointer,0,"paths");
        std::size_t npieces = mxGetNumberOfElements(paths);

        /* Allocate */
        ContContainer all_cont(npieces);
        
        /* Get image size */
        mxArray* im_size = mxGetField(mat_pointer,0,"im_size");
        uint16_t* im_s_ptr = (uint16_t*)mxGetData(im_size);        
        all_cont.im_sx = im_s_ptr[0];
        all_cont.im_sy = im_s_ptr[1];

        /* Sweep each contour piece */
        for (std::size_t ii=0; ii<npieces; ++ii) 
        {
            /* Eigen map for ease of use */
            mxArray *c_coords = mxGetField(paths, ii, "contour_coords");
            Eigen::Map<Eigen::Array<uint16_t,Eigen::Dynamic,Eigen::Dynamic> >
                    curr_poly((uint16_t*)mxGetData(c_coords),mxGetM(c_coords),mxGetN(c_coords));

            /* Sanity check */
            if (curr_poly.cols()!=2)
                mexErrMsgTxt("Bad formed contours!");

            /* Allocate output */
            all_cont[ii].resize(curr_poly.rows());
            
            /* Fill it */
            for (std::size_t jj=0; jj<curr_poly.rows(); ++jj)
            {
                all_cont[ii][jj].X = (std::size_t)curr_poly(jj,0);
                all_cont[ii][jj].Y = (std::size_t)curr_poly(jj,1);
            }
        }

        return all_cont;
    }
    
    
    
    void cont_to_matlab(const ContContainer& conts, mxArray*& mat_pointer)
    {
        /* ---- Contour list ---- */
        /* Allocate */
        const char **fieldnames;
        fieldnames = (const char **)mxCalloc(2, sizeof(*fieldnames));
        fieldnames[0] = "paths";
        fieldnames[1] = "im_size";
        mat_pointer = mxCreateStructMatrix(1,1,2,fieldnames);

        /* Copy image size */
        mxArray* im_size = mxCreateNumericMatrix((mwSize)1, (mwSize)2, mxUINT16_CLASS, mxREAL);
        uint16_t* ptr = (uint16_t*)mxGetData(im_size);
        ptr[0] = conts.im_sx;
        ptr[1] = conts.im_sy;
        mxSetFieldByNumber(mat_pointer, 0, 1, im_size);

        /* Allocate paths */
        fieldnames[0] = "contour_coords";
        fieldnames[1] = "is_hole";
        mxArray* paths = mxCreateStructMatrix(1,conts.size(),2,fieldnames);
        mxFree((void *)fieldnames);
        
        for (std::size_t ii=0; ii<conts.size(); ++ii)
        {
            /* Copy contour coordinates */
            mxArray* curr_field = mxCreateNumericMatrix((mwSize)conts[ii].size(), (mwSize)2, mxUINT16_CLASS, mxREAL);
            
            /* Eigen map for ease of use */
            Eigen::Map<Eigen::Array<uint16_t,Eigen::Dynamic,Eigen::Dynamic> >
                    curr_poly((uint16_t*)mxGetData(curr_field),mxGetM(curr_field),mxGetN(curr_field));
            for (std::size_t jj=0; jj<conts[ii].size(); ++jj)
            {
                curr_poly(jj,0) = conts[ii][jj].X;
                curr_poly(jj,1) = conts[ii][jj].Y;
            }
            mxSetFieldByNumber(paths, (mwIndex)ii, 0, curr_field);
            
            /* Copy is_hole */
            if (conts.is_hole[ii])
                curr_field = mxCreateDoubleScalar(1);
            else
                curr_field = mxCreateDoubleScalar(0);
            mxSetFieldByNumber(paths, (mwIndex)ii, 1, curr_field);
        }
        mxSetFieldByNumber(mat_pointer, 0, 0, paths);
    }
}
#endif