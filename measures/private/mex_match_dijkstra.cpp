// ------------------------------------------------------------------------ 
// Jordi Pont-Tuset - http://jponttuset.github.io/
// April 2016
// ------------------------------------------------------------------------ 
// This file is part of the DAVIS package presented in:
//   Federico Perazzi, Jordi Pont-Tuset, Brian McWilliams,
//   Luc Van Gool, Markus Gross, Alexander Sorkine-Hornung
//   A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
//   CVPR 2016
// Please consider citing the paper if you use this code.
// ------------------------------------------------------------------------
#include "mex.h"
#include <Eigen/Dense>

#include <boost/config.hpp>
#include <iostream>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/dijkstra_shortest_paths.hpp>
#include <boost/property_map/property_map.hpp>

using namespace boost;
using namespace std;

/* Typedefs from Boost */
typedef adjacency_list < listS, vecS, directedS,
        no_property, property < edge_weight_t, double > > graph_t;
typedef graph_traits < graph_t >::vertex_descriptor vertex_descriptor;
typedef std::pair<int, int> Edge;

std::vector<vertex_descriptor> run_one_dijkstra(std::list<Edge>& edge_list, std::list<double>& edge_costs, const int num_nodes, int orig)
{
    /* Define the graph and the containers for the distances and parent nodes */
    graph_t g(edge_list.begin(), edge_list.end(), edge_costs.begin(), num_nodes);
    property_map<graph_t, edge_weight_t>::type weightmap = get(edge_weight, g);
    std::vector<vertex_descriptor> parents(num_vertices(g));
    std::vector<double>              dists(num_vertices(g));

    /* Run Dijkstra to all nodes */
    vertex_descriptor orig_vertex = vertex(orig, g);
    dijkstra_shortest_paths(g, orig_vertex,
            predecessor_map(boost::make_iterator_property_map(parents.begin(), get(vertex_index, g))).
            distance_map(boost::make_iterator_property_map(dists.begin(), get(vertex_index, g))));
    
    return parents;
}
    

void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{
    /* Cost matrix (doubles) */
    Eigen::Map<Eigen::Array<double,Eigen::Dynamic,Eigen::Dynamic> >
            costs_matrix((double *)mxGetData(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    Eigen::Array<double,Eigen::Dynamic,Eigen::Dynamic> costs(costs_matrix);
    
    /* Sizes of the graph */
    const int n1 = costs.rows();
    const int n2 = costs.cols();
    const int num_nodes = n1*n2;
    
    /* Create a look-up table for node indices */
    Eigen::Array<std::size_t,Eigen::Dynamic,Eigen::Dynamic> sub2ind(n1,n2);
    size_t curr_id = 0;
    for (size_t xx=0; xx<n1; ++xx)
        for (size_t yy=0; yy<n2; ++yy)
            sub2ind(xx,yy) = curr_id++;

    /* Inverted LUT */
    vector<pair<size_t,size_t>> ind2sub(num_nodes);
    for (size_t xx=0; xx<n1; ++xx)
        for (size_t yy=0; yy<n2; ++yy)
            ind2sub[sub2ind(xx,yy)] = make_pair(xx,yy);

    /* Define the edges of the graph */
    std::list<Edge> edge_list;
    std::list<double> edge_costs;
    for (std::size_t xx=0; xx<n1; ++xx)
    {
        for (std::size_t yy=0; yy<n2; ++yy)
        {
            /* Down */
            if (yy>0)
            {
                edge_list.emplace_back(sub2ind(xx,yy-1),sub2ind(xx,yy));
                edge_costs.emplace_back(costs(xx,yy));
            }
//             else 
//             {
//                 /* Last with first */
//                 edge_list.emplace_back(sub2ind(xx,n2-1),sub2ind(xx,yy));
//                 edge_costs.emplace_back(costs(xx,yy));
//                 
//                 if (xx>0)
//                 {
//                     /* Add diagonal also in these cases */
//                     edge_list.emplace_back(sub2ind(xx-1,n2-1),sub2ind(xx,yy));
//                     edge_costs.emplace_back(costs(xx,yy));
//                 }
//             }

            /* Left */
            if (xx>0)
            {
                edge_list.emplace_back(sub2ind(xx-1,yy),sub2ind(xx,yy));
                edge_costs.emplace_back(costs(xx,yy));
            }
            
            /* Down-left */
            if ((yy>0) && (xx>0))
            {
                edge_list.emplace_back(sub2ind(xx-1,yy-1),sub2ind(xx,yy));
                edge_costs.emplace_back(costs(xx,yy));
            }
        }
    }


    /* Origin and destination nodes - First we assume the 0-0 matching */
    int orig = 0;
    int dest = num_nodes-1;
    std::vector<vertex_descriptor> parents = run_one_dijkstra(edge_list,edge_costs,num_nodes,orig);

    /* Get path to destination by scanning predecessors
     * We also get the minimum-cost node */
    std::vector<size_t> opt_path;
    size_t curr_predecessor = dest;
    double min_cost = numeric_limits<double>::max();
    size_t min_id = curr_predecessor;
    while(curr_predecessor!=orig)
    {
        double curr_cost = costs(ind2sub[curr_predecessor].first,ind2sub[curr_predecessor].second);
        if (curr_cost<min_cost)
        {
            min_cost = curr_cost;
            min_id = curr_predecessor;
        }
        opt_path.emplace_back(curr_predecessor);
        curr_predecessor = parents[curr_predecessor];
    }
    opt_path.emplace_back(curr_predecessor);
    int min_xx = ind2sub[min_id].first;
    int min_yy = ind2sub[min_id].second;
    
//     int dest_xx = min_xx-1; if (dest_xx<0) dest_xx += n1;
//     int dest_yy = min_yy-1; if (dest_yy<0) dest_yy += n2;
//     orig = min_id;
//     dest = sub2ind(dest_xx,dest_yy);
    
// mexPrintf("orig = %d (%d,%d)",orig+1, min_xx+1, min_yy+1);    
// mexPrintf("dest = %d (%d,%d)",dest+1,dest_xx+1,dest_yy+1);    
//     
//     parents = run_one_dijkstra(edge_list,edge_costs,num_nodes,orig);
// 
//     /* Get path to destination by scanning predecessors */
//     opt_path.clear();
//     curr_predecessor = dest;
//     while(curr_predecessor!=orig)
//     {
//         opt_path.emplace_back(curr_predecessor);
//         curr_predecessor = parents[curr_predecessor];
//     }
//     opt_path.emplace_back(curr_predecessor);
    
    
    
    
    
// mexPrintf("distances and parents:\n");
// graph_traits < graph_t >::vertex_iterator vi, vend;
// for (boost::tie(vi, vend) = vertices(g); vi != vend; ++vi) {
//     mexPrintf("V%d (%d,%d) - %0.2f - P(V%d) = V%d\n", *vi, ind2sub[*vi].first, ind2sub[*vi].second, dists[*vi],*vi,parents[*vi]);
// }
//     
// mexPrintf("\nMatching:\n");
// for(size_t match:opt_path)
//     mexPrintf("(%d,%d) - ", ind2sub[match].first, ind2sub[match].second);
// mexPrintf("\n");

    
    
    
    /* Output pairs - +1 for Matlab */
    plhs[0] = mxCreateDoubleMatrix(opt_path.size(),2,mxREAL);
    double* outputMatrix = (double*)mxGetData(plhs[0]);
    for (size_t i=0; i<opt_path.size(); i++)
    {
        outputMatrix[i                ] = ind2sub[opt_path[i]].first  +1;
        outputMatrix[i+opt_path.size()] = ind2sub[opt_path[i]].second +1;
    }
    
    plhs[1] = mxCreateDoubleScalar(min_xx+1);
    plhs[2] = mxCreateDoubleScalar(min_yy+1);
}


