function phase=create_phase(matrix,te,r,tesla);
load simfmap1
newfmap1 = newfmap1*r;
coff = 0.24*tesla*te;
phase=newfmap1.*coff;
phase=mod(phase,2*pi);
%phase=mod(phase,pi);
%phase = phase';
%phase = phase/100;

%phasemax = max(max(phase))