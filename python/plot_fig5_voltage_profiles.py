import numpy as np
import matplotlib.pyplot as plt
from style import apply_style, ALGO_COLORS
from repo_io import read_csv, save_figure
apply_style(); rows=read_csv('data/published/voltage_profiles_fig5.csv')
algos=['B&C','BIPSO-GR','Hybrid']; markers={'B&C':'o','BIPSO-GR':'s','Hybrid':'^'}
fig,axes=plt.subplots(3,1,figsize=(7.0,8.1),sharex=True)
for ax,sc in zip(axes,['S1','S2','S3']):
    for algo in algos:
        vals=[]
        for r in rows:
            if r['Scenario']==sc and r['Algorithm']==algo:
                vals.append((int(r['Bus']), np.nan if not r['Voltage_pu'] else float(r['Voltage_pu'])))
        vals=sorted(vals); b=[v[0] for v in vals]; y=[v[1] for v in vals]
        ax.plot(b,y,marker=markers[algo],markersize=4,color=ALGO_COLORS[algo],label=algo)
    if sc=='S2': ax.axvspan(.65,1.35,color='lightgray',alpha=.35); ax.text(1,1.0008,'Outaged\nbus',ha='center',va='top',fontsize=8)
    if sc=='S3': ax.axvspan(6.65,7.35,color='lightgray',alpha=.35); ax.text(7,1.0008,'Outaged\nbus',ha='center',va='top',fontsize=8)
    ax.set_ylabel('Bus voltage (p.u.)'); ax.grid(linestyle=':',alpha=.45); ax.set_axisbelow(True)
    ax.set_ylim((0.9990,1.0005) if sc=='S1' else (0.9970,1.0010)); xlab=.02 if sc=='S1' else .98; ax.text(xlab,.92,sc,transform=ax.transAxes,ha='left' if sc=='S1' else 'right',fontweight='bold')
axes[-1].set_xlabel('Bus number'); axes[-1].set_xticks(range(1,17)); axes[0].legend(loc='upper right',ncol=3,frameon=True)
fig.tight_layout(); save_figure(fig,'paper_fig5_voltage_profiles'); plt.close(fig)
