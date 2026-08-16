import numpy as np
import matplotlib.pyplot as plt
from style import apply_style, NAVY, ORANGE, GRAY, RED
from repo_io import read_csv, save_figure
apply_style(); rows=read_csv('data/published/grid_impact_summary_table_ix.csv')
scs=['S1','S2','S3','S4','S5']; labels=['S1\n(Base)','S2\n(N-1, SS1 lost)','S3\n(N-1, SS2 lost)','S4\n(×1.2 Seasonal)','S5\n(×1.5 Event)']
algos=['B&C','BIPSO-GR','Hybrid']; colors=[NAVY,ORANGE,GRAY]
vals={a:[float(next(r['Lmax_percent'] for r in rows if r['Scenario']==s and r['Algorithm']==a)) for s in scs] for a in algos}
fig,ax=plt.subplots(figsize=(7.0,4.3)); x=np.arange(5); w=.27
for off,a,c in zip([-w,0,w],algos,colors):
    bars=ax.bar(x+off,vals[a],w,color=c,edgecolor='black',linewidth=.5,label=a)
    for bar,v in zip(bars,vals[a]): ax.text(bar.get_x()+bar.get_width()/2,v+2,f'{v:.1f}',ha='center',va='bottom',fontsize=8)
ax.axhline(100,color=RED,ls='--',lw=1.1,label='Thermal limit (100%)'); ax.set_xticks(x); ax.set_xticklabels(labels)
ax.set_ylabel('Maximum branch loading (% of MVA rating)'); ax.set_ylim(0,185); ax.grid(axis='y',ls=':',alpha=.45); ax.set_axisbelow(True); ax.legend(loc='upper right')
fig.tight_layout(); save_figure(fig,'paper_fig6_scenario_loading'); plt.close(fig)
