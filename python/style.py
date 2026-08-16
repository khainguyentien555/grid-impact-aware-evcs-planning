"""Shared publication plotting style."""
import matplotlib.pyplot as plt
NAVY='#1F3864'; ORANGE='#C65911'; GRAY='#595959'; RED='#A52A2A'
ALGO_COLORS={'B&C':NAVY,'BIPSO-GR':ORANGE,'Hybrid':GRAY}
def apply_style():
    plt.rcParams.update({
        'font.family':'serif','font.serif':['Times New Roman','DejaVu Serif'],
        'font.size':11,'axes.labelsize':11,'xtick.labelsize':10,'ytick.labelsize':10,
        'legend.fontsize':10,'axes.linewidth':0.9,'lines.linewidth':1.3,
        'pdf.fonttype':42,'ps.fonttype':42
    })
