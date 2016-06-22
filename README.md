
Disclaimer
--------------
Package containing the Matlab implementation of the code behind:
*A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation*
[DAVIS](https://graphics.ethz.ch/~perazzif/davis/index.html).


Code Installation
-----------------
1) Adapt the value of `db_root_dir.m` to point to the root dir where DAVIS
   is uncompressed in your system (contains folder `480p`)
2) Run the script `startup.m` to add the necessary paths and perform some checks.
3) [If necessary] Recompile using the script `build.m` in case the startup
   script detects some files missing.


Code Usage
-----------------
- The script `demo_sweep.m` contains a demo of how the dataset images and
  annotations are read (all functions in `db_util`).
- The script `measures/eval_result.m` runs the evaluation for the selected measures
  on a certain subset of the dataset.
- The three measures used in the evaluation are found in the folder `measures`.
- The folder `experiments` contains the scripts used to generate all plots 
  and tables in the paper. `global_table.m` might be the best point ot start.


Evaluate your technique
-----------------
- Add your results in the folder `results`, as the provided precomputed results,
  in a folder `my_method`
- Run `measures/eval_result.m` on your technique: `eval_result('my_method',{'J','F','T'})`.
  (You can select which measures to use - You can skip T for fast computation)
- Show your results as in `experiments\global_table.m`


Citation
--------------
Please cite `DAVIS` in your publications if it helps your research:

    @inproceedings{Perazzi_CVPR_2016,
      author    = {Federico Perazzi and
                   Jordi Pont-Tuset and
                   Brian McWilliams and
                   Luc Van Gool and
                   Markus Gross and
                   Alexander Sorkine-Hornung},
      title     = {A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation},
      booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
      year      = {2016}
    }


Contacts
------------------
- [Federico Perazzi](https://graphics.ethz.ch/~perazzif/)
- [Jordi Pont-Tuset](http://jponttuset.github.io/)
