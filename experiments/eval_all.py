#!/usr/bin/python

# ----- Parameters passed to the cluster -------
#$ -S /usr/bin/python
#$ -l h_rt=5:59:00
#$ -l h_vmem=15000M
#$ -o /scratch_net/neo/jpont/logs/
#$ -j y

# ----------------- Imports --------------------
import os
import numpy as np
import math
import sys


# ---------------- Functions -------------------
def subfolders(parent_dir):
    return [name for name in os.listdir(parent_dir)
            if os.path.isdir(os.path.join(parent_dir, name))]


# ------------- Get the parameters -------------
if len(sys.argv)<3:
  print "Usage 'davis_segment im_root_folder results_root_folder'"
  exit(1)

database_folder = sys.argv[1]
results_folder  = sys.argv[2]

# Get subfolders
folders = subfolders(database_folder);

# Which subfolder we process?
task_id = int(os.getenv("SGE_TASK_ID", "0"))
if task_id>len(folders):
  print "Number of workers should be less than " + str(len(folders))
  exit(1)
if task_id==0:
  print "SGE_TASK_ID not set"
  exit(1)

# ---------------- Check main folders -------------------
ucm_folder = results_folder+"/ucm"
prop_folder = results_folder+"/proposals"

if not os.path.exists(results_folder):
  if task_id==1:
    os.makedirs(results_folder)
if not os.path.exists(ucm_folder):
  if task_id==1:
    os.makedirs(ucm_folder)
if not os.path.exists(prop_folder):
  if task_id==1:
    os.makedirs(prop_folder)


# ---------------- Check current folders -------------------
im_folder  = database_folder+"/"+folders[task_id-1];
curr_ucm_folder = ucm_folder+"/"+folders[task_id-1];
curr_prop_folder = prop_folder+"/"+folders[task_id-1];

if not os.path.exists(curr_ucm_folder):
    os.makedirs(curr_ucm_folder)
if not os.path.exists(curr_prop_folder):
    os.makedirs(curr_prop_folder)


print "Processing: " + im_folder

# Run the actual code
os.chdir('/srv/glusterfs/jpont/dev/scripts')
command_to_run = "/usr/sepp/bin/matlab -nodesktop -nodisplay -nosplash -r \"mcg_folder('"+im_folder+"','accurate','"+curr_prop_folder+"','"+curr_ucm_folder+"');exit\""
os.system(command_to_run)



