function layouts = define_fixed_layouts_mpce(cfg)
%DEFINE_FIXED_LAYOUTS_MPCE User-approved fixed charger allocation tables.
% Counts are in the station order defined in config_fixed_layout_mpce.m:
%   1 CC-TM2, 2 CC-TLC, 3 CC-HH2, 4 CC-TT1,
%   5 CC-TM1, 6 CC-HH1, 7 CC-BDX, 8 CC-TM3.
%
% IMPORTANT: The row-wise Hybrid counts in the user's latest table sum to
% [99, 79, 3]. If the printed TOTAL row in the spreadsheet says [98,77,3],
% that TOTAL row is inconsistent with the station rows. This code follows
% the station rows, because those are the actual allocation values.

layouts = struct([]);

% --- B&C benchmark ---
layouts(1).name = 'B&C';
layouts(1).shortName = 'BC';
layouts(1).counts3_CS = [ ...
    20  6 0;  ... % CC-TM2, Bus 2
    15  8 0;  ... % CC-TLC, Bus 4
    12 21 0;  ... % CC-HH2, Bus 6
    12  6 0;  ... % CC-TT1, Bus 8
    16  9 0;  ... % CC-TM1, Bus 10
    10  6 0;  ... % CC-HH1, Bus 13
    10 14 6;  ... % CC-BDX, Bus 14
    10  7 0];     % CC-TM3, Bus 15
layouts(1).status_CS = sum(layouts(1).counts3_CS,2) > 0;

% --- BIPSO-GR heuristic ---
layouts(2).name = 'BIPSO-GR';
layouts(2).shortName = 'BIPSO';
layouts(2).counts3_CS = [ ...
    25 37 0;  ... % CC-TM2, Bus 2
     0 25 0;  ... % CC-TLC, Bus 4
    25 75 0;  ... % CC-HH2, Bus 6
     0  0 0;  ... % CC-TT1, Bus 8 closed
    25 80 0;  ... % CC-TM1, Bus 10
     3  2 0;  ... % CC-HH1, Bus 13
    13 21 2;  ... % CC-BDX, Bus 14
     0  0 0];     % CC-TM3, Bus 15 closed
layouts(2).status_CS = sum(layouts(2).counts3_CS,2) > 0;

% --- Hybrid method, latest table supplied by user ---
layouts(3).name = 'Hybrid';
layouts(3).shortName = 'Hybrid';
layouts(3).counts3_CS = [ ...
    17  6 0;  ... % CC-TM2, Bus 2
    15  8 0;  ... % CC-TLC, Bus 4
    12 33 0;  ... % CC-HH2, Bus 6
    12  6 0;  ... % CC-TT1, Bus 8
    16  9 0;  ... % CC-TM1, Bus 10
    10  6 0;  ... % CC-HH1, Bus 13
     7  4 3;  ... % CC-BDX, Bus 14
    10  7 0];     % CC-TM3, Bus 15
layouts(3).status_CS = sum(layouts(3).counts3_CS,2) > 0;

% Validate row sums. These values are calculated from the rows above.
expectedTotals = [105 77 6; 91 240 2; 99 79 3];
for a = 1:numel(layouts)
    got = sum(layouts(a).counts3_CS, 1);
    if any(got ~= expectedTotals(a,:))
        error('Layout %s total mismatch. Expected [%s], got [%s].', ...
            layouts(a).name, num2str(expectedTotals(a,:)), num2str(got));
    end
end
end
