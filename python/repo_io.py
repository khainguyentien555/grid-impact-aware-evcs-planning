from pathlib import Path
import csv
ROOT = Path(__file__).resolve().parents[1]
def read_csv(relpath):
    with (ROOT/relpath).open(newline='',encoding='utf-8') as f:
        return list(csv.DictReader(f))
def outdir():
    p=ROOT/'results'/'figures'; p.mkdir(parents=True,exist_ok=True); return p
def save_figure(fig, stem):
    p=outdir()
    for ext in ('pdf','png','svg'):
        fig.savefig(p/f'{stem}.{ext}', dpi=600 if ext=='png' else None, bbox_inches='tight', pad_inches=0.05)
