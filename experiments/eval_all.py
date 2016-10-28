import os
import sys

techniques = ['mcg','sf-lab','sf-mot','nlc','cvos','trc','msg','key','sal','fst','tsp','sea','hvs','jmp','fcp','bvs'];
gt_set = sys.argv[1]
for ii in range(0,len(techniques)):
    os.system('qsub -N '+techniques[ii]+'-'+gt_set+' eval_one.py ' + techniques[ii] +' "{\'F\',\'J\',\'T\'}" ' + gt_set)

