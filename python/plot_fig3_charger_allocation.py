import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
from style import apply_style, NAVY, ORANGE, GRAY
from repo_io import read_csv, save_figure
apply_style()
rows=read_csv('data/published/charger_allocation.csv')
stations=[f'CS{i}' for i in range(1,9)]
bus_by_cs={r['CS']:r['Bus'] for r in rows if r['Algorithm']=='B&C'}
algos=['B&C','BIPSO-GR','Hybrid']; colors=[NAVY,ORANGE,GRAY]
lookup={(r['Algorithm'],r['CS']):(int(r['Chargers_11kW']),int(r['Chargers_60kW']),int(r['Chargers_150kW'])) for r in rows}
fig,ax=plt.subplots(figsize=(7.0,3.4)); x=np.arange(8); w=0.26
for offset,algo,base in zip([-w,0,w],algos,colors):
    data=[lookup[(algo,cs)] for cs in stations]
    n11=np.array([v[0] for v in data]); n60=np.array([v[1] for v in data]); n150=np.array([v[2] for v in data])
    if algo=='B&C': shades=['#8FAADC',NAVY,'#0F1E3F']
    elif algo=='BIPSO-GR': shades=['#F4B183',ORANGE,'#7A330A']
    else: shades=['#BFBFBF',GRAY,'#262626']
    ax.bar(x+offset,n11,w,color=shades[0],edgecolor='black',linewidth=.4)
    ax.bar(x+offset,n60,w,bottom=n11,color=shades[1],edgecolor='black',linewidth=.4)
    ax.bar(x+offset,n150,w,bottom=n11+n60,color=shades[2],edgecolor='black',linewidth=.4)
ax.set_xticks(x); ax.set_xticklabels([f'{cs}\n(Bus {bus_by_cs[cs]})' for cs in stations])
ax.set_ylabel('Number of chargers (units)'); ax.set_ylim(0,145); ax.grid(axis='y',linestyle=':',alpha=.45); ax.set_axisbelow(True)
leg1=ax.legend(handles=[Patch(facecolor=c,edgecolor='black',label=a) for a,c in zip(algos,colors)],loc='upper left',ncol=3,title='Algorithm',frameon=True)
ax.add_artist(leg1)
ax.legend(handles=[Patch(facecolor='white',edgecolor='black',label='11 kW = light shade'),Patch(facecolor='lightgray',edgecolor='black',label='60 kW = medium shade'),Patch(facecolor='dimgray',edgecolor='black',label='150 kW = dark shade')],loc='upper right',frameon=True,fontsize=8)
fig.tight_layout(); save_figure(fig,'paper_fig3_charger_allocation'); plt.close(fig)
