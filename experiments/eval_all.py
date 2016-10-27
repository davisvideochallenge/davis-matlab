import os
techniques = ['mcg','sf-lab','sf-mot','nlc','cvos','trc','msg','key','sal','fst','tsp','sea','hvs','jmp','fcp','bvs'];
for ii in range(0,len(techniques)):
    os.system('qsub -N davis-'+techniques[ii]+' eval_all.py ' + techniques[ii] +' "{\'F\',\'J\',\'T\'}" val')

