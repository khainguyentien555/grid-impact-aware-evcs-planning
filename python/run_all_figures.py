"""Regenerate all figures for which source arrays were supplied."""
import subprocess, sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
scripts=['plot_fig3_charger_allocation.py','plot_fig5_voltage_profiles.py','plot_fig6_scenario_loading.py','plot_fig7_n1_heatmaps.py']
for s in scripts:
    print(f'Running {s}...')
    subprocess.run([sys.executable,str(HERE/s)],check=True)
print('Done. See results/figures/.')
