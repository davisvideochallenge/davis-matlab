
Introduction
--------------
Package containing the **Matlab** implementation of the code behind:
[The 2017 DAVIS Video Object Segmentation Challenge](http://davischallenge.org).
You can find the **Python** implementation [here](https://github.com/fperazzi/davis).


Code Installation
-----------------
1. Adapt the value of `db_root_dir.m` to point to the root dir where DAVIS
   is uncompressed in your system (contains folders `Annotations` and `JPEGImages`)
2. Run the script `startup.m` to add the necessary paths and perform some checks.
3. [If necessary] Recompile using the script `build.m` in case the startup
   script detects some files missing.


Code Usage
-----------------
- The script `demo/demo_eval_multiple.m` contains a demo of how annotations and 
  results are stored in the case of multiple objects.
- The script `demo/demo_sweep.m` contains a demo of how the dataset images and
  annotations are read (all functions in `db_util`).
- The script `measures/eval_result.m` runs the evaluation for the selected measures
  on a certain subset of the dataset.
- The three measures used in the evaluation are found in the folder `measures`.
- The folder `experiments` contains the scripts used to generate all plots 
  and tables in the paper. `global_table.m` might be the best point ot start.


Evaluate your technique
-----------------
- The script `demo/demo_eval_your_method.m` contains a demo of how to
  evaluate your method (call `measures/eval_result.m`).
- Add your results in the folder `$root_DAVIS\Results\Segmentations\480p`,
  as the provided precomputed results, in a folder `my_method`
- Run `measures/eval_result.m` on your technique: `eval_result('my_method',{'J','F','T'})`.
  (You can select which measures to use - You can skip T for fast computation)
- Show your results as in `experiments\global_table.m`


Citation
--------------
Please cite `DAVIS 2017` and `DAVIS 2016` in your publications if it helps your research:

    @article{Pont-Tuset_arXiv_2017,
      author    = {Jordi Pont-Tuset and Federico Perazzi and Sergi Caelles and
                   Pablo Arbel\'aez and Alexander Sorkine-Hornung and Luc {Van Gool}},
      title     = {The 2017 DAVIS Challenge on Video Object Segmentation},
      journal   = {arXiv:1704.00675},
      year      = {2017}
    }

    @inproceedings{Perazzi_CVPR_2016,
      author    = {Federico Perazzi and
                   Jordi Pont-Tuset and
                   Brian McWilliams and
                   Luc {Van Gool} and
                   Markus Gross and
                   Alexander Sorkine-Hornung},
      title     = {A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation},
      booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
      year      = {2016}
    }


Contacts
------------------
- [Jordi Pont-Tuset](http://jponttuset.cat/) - Matlab code
- [Federico Perazzi](https://graphics.ethz.ch/~perazzif/) - Python code

