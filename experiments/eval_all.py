#!/usr/bin/python

# ----- Parameters passed to the cluster -------
#$ -S /usr/bin/python
#$ -l h_rt=5:59:00
#$ -l h_vmem=5000M
#$ -o /scratch_net/neo/jpont/logs/
#$ -j y

# ----------------- Imports --------------------
import os
import numpy as np
import math
import sys


# ------------- Get the parameters -------------
if len(sys.argv)<3:
  print "Usage 'eval_all technique measures gt_set'"
  exit(1)

technique = sys.argv[1]
measures  = sys.argv[2]
gt_set    = sys.argv[3]

# ---------------- Check main folders -------------------

# Run the actual code
os.chdir('/srv/glusterfs/jpont/dev/davis-matlab')
command_to_run = "/usr/sepp/bin/matlab -nodesktop -nodisplay -nosplash -r \"startup;eval_result('"+technique+"',"+measures+",'"+gt_set+"');exit\""
os.system(command_to_run)



