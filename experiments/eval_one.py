#!/usr/bin/python

# qsub -N OSVOS eval_one.py OSVOS "{'F','J'}" val-2016
# ----- Parameters passed to the cluster -------
#$ -S /usr/bin/python
#$ -l h_rt=23:59:00
#$ -l h_vmem=30000M
#$ -o /scratch_net/neo/jpont/logs/
#$ -j y

# ----------------- Imports --------------------
import os
import numpy as np
import math
import sys


# ------------- Get the parameters -------------
if len(sys.argv)<3:
  print "Usage 'eval_one technique measures gt_set'"
  exit(1)

technique = sys.argv[1]
measures  = sys.argv[2]
gt_set    = sys.argv[3]

# ---------------- Check main folders -------------------

# Run the actual code
os.chdir('/scratch_net/neo_second/jpont/dev/davis-matlab')
command_to_run = "/usr/sepp/bin/matlab -nodesktop -nodisplay -nosplash -r \"startup;db_set_properties(2017,1,'480p');eval_result('"+technique+"',"+measures+",'"+gt_set+"');exit\""
os.system(command_to_run)



