"""Validate internal consistency of frozen publication datasets."""
from pathlib import Path
import csv, math
ROOT=Path(__file__).resolve().parents[1]
def read(name):
    with (ROOT/'data'/'published'/name).open(newline='',encoding='utf-8') as f:
        return list(csv.DictReader(f))
def close(a,b,tol=1e-9):
    return abs(a-b) <= tol
errors=[]
# Installed capacities from integer charger counts vs Table VI.
alloc=read('charger_allocation.csv'); tab6=read('planning_to_grid_s2_table_vi.csv')
for algo in ['B&C','BIPSO-GR','Hybrid']:
    cap=sum(float(r['InstalledCapacity_MW']) for r in alloc if r['Algorithm']==algo)
    ref=float(next(r['InstalledCapacity_MW'] for r in tab6 if r['Algorithm']==algo))
    if not close(cap,ref,1e-9): errors.append(f'{algo}: charger capacity {cap} != Table VI {ref}')
# Table VII totals.
bus=read('bus_evcs_injections_table_vii.csv'); expected={'B&C':2.443,'BIPSO-GR':5.561,'Hybrid':2.215}
col={'B&C':'B&C_P_EVCS_MW','BIPSO-GR':'BIPSO-GR_P_EVCS_MW','Hybrid':'Hybrid_P_EVCS_MW'}
for algo in expected:
    total=sum(float(r[col[algo]]) for r in bus)
    if not close(total,expected[algo],0.0011): errors.append(f'{algo}: Table VII row sum {total} != published total {expected[algo]} within rounding tolerance')
# HCM/CSI definitions.
grid=read('grid_impact_summary_table_ix.csv')
for r in grid:
    L=float(r['Lmax_percent']); h=float(r['HCM_percent']); c=float(r['CSI_percent'])
    if not close(h,100-L,0.11): errors.append(f"{r['Scenario']} {r['Algorithm']}: HCM mismatch")
    if not close(c,max(0,L-100),0.11): errors.append(f"{r['Scenario']} {r['Algorithm']}: CSI mismatch")
# Voltage minima against Table IX rounded values.
vp=read('voltage_profiles_fig5.csv')
for sc in ['S1','S2','S3']:
    for algo in ['B&C','BIPSO-GR','Hybrid']:
        v=[float(r['Voltage_pu']) for r in vp if r['Scenario']==sc and r['Algorithm']==algo and r['Voltage_pu']]
        ref=float(next(r['Vmin_pu'] for r in grid if r['Scenario']==sc and r['Algorithm']==algo))
        if round(min(v),4)!=round(ref,4): errors.append(f'{sc} {algo}: voltage profile min {min(v)} != Table IX {ref}')
# Heatmap maxima against S2/S3 Table IX.
hm=read('branch_loading_fig7.csv')
for sc in ['S2','S3']:
    for algo,field in [('B&C','B&C_Loading_percent'),('BIPSO-GR','BIPSO-GR_Loading_percent'),('Hybrid','Hybrid_Loading_percent')]:
        mx=max(float(r[field]) for r in hm if r['Scenario']==sc)
        ref=float(next(r['Lmax_percent'] for r in grid if r['Scenario']==sc and r['Algorithm']==algo))
        if not close(mx,ref,0.01): errors.append(f'{sc} {algo}: heatmap max {mx} != Table IX {ref}')

# PowerWorld binary case hashes and case count.
import hashlib
case_index_path=ROOT/'powerworld'/'CASE_INDEX.csv'
with case_index_path.open(newline='',encoding='utf-8') as f:
    case_rows=list(csv.DictReader(f))
if len(case_rows)!=15: errors.append(f'PowerWorld case count {len(case_rows)} != 15')
for r in case_rows:
    fp=ROOT/r['CanonicalPath']
    if not fp.exists():
        errors.append(f"Missing PowerWorld case: {r['CanonicalPath']}")
        continue
    h=hashlib.sha256(fp.read_bytes()).hexdigest()
    if h!=r['SHA256']: errors.append(f"Hash mismatch: {r['CanonicalPath']}")

if errors:
    print('VALIDATION FAILED')
    for e in errors: print(' -',e)
    raise SystemExit(1)
print('VALIDATION PASSED')
print(' - integer charger capacities match Table VI')
print(' - Table VII bus values sum to published totals within display-rounding tolerance')
print(' - HCM and CSI are consistent with Lmax')
print(' - supplied voltage-profile minima round to Table IX')
print(' - S2/S3 heatmap maxima match Table IX')
print(' - 15 PowerWorld case files match the original archive hashes')
