%% ispc grand average scripts 

itpc = computeISPCGA(wholeData,'itpc','chaninfo',20,0);
itpc_lap = computeISPCGA(wholeData,'itpc_lap','chaninfo',20,0);

phasediff_s = computeISPCGA(wholeData,'avg_phase_diff','chaninfo',20,0);
phasediff_pli = computeISPCGA(wholeData,'avg_phase_diff_pli','chaninfo',20,0);

phasediff_s_lap = computeISPCGA(wholeData,'avg_phase_diff_lap','chaninfo',20,0);
phasediff_pli_lap= computeISPCGA(wholeData,'avg_phase_diff_pli_lap','chaninfo',20,0);


