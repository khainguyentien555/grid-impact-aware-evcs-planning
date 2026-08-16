import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap, BoundaryNorm
from matplotlib.patches import Rectangle
from style import apply_style, RED
from repo_io import read_csv, save_figure
apply_style(); rows=read_csv('data/published/branch_loading_fig7.csv')
algos=['B&C','BIPSO-GR','Hybrid']; colors=['#1A5128','#5C8A3A','#C9D04F','#FDB813','#E66B0A','#A52A2A','#5C0E0E']
cmap=LinearSegmentedColormap.from_list('thermal',colors,N=256); bounds=[0,25,50,75,100,130,160,200]; norm=BoundaryNorm(bounds,cmap.N)
fig,axes=plt.subplots(2,1,figsize=(7.0,8.6))
for ax,sc in zip(axes,['S2','S3']):
    rr=[r for r in rows if r['Scenario']==sc]; branches=[r['Branch'] for r in rr]
    data=np.array([[float(r[f'{a}_Loading_percent']) for a in algos] for r in rr])
    im=ax.imshow(data,cmap=cmap,norm=norm,aspect='auto')
    for i in range(len(branches)):
        for j in range(3):
            v=data[i,j]; ax.text(j,i,f'{v:.1f}',ha='center',va='center',color='white',fontsize=8,fontweight='bold' if v>100 else 'normal')
            if v>100: ax.add_patch(Rectangle((j-.5,i-.5),1,1,fill=False,edgecolor=RED,linewidth=1.5))
    ax.set_xticks(range(3)); ax.set_xticklabels(algos); ax.set_yticks(range(len(branches))); ax.set_yticklabels(branches,fontsize=8); ax.set_ylabel('22 kV branch'); ax.set_title(f'{sc} contingency')
axes[-1].set_xlabel('Algorithm'); cbar=fig.colorbar(im,ax=axes,fraction=.025,pad=.02,boundaries=bounds,ticks=bounds); cbar.set_label('Loading (%)')
fig.subplots_adjust(left=.19,right=.89,hspace=.25); save_figure(fig,'paper_fig7_n1_heatmaps'); plt.close(fig)
