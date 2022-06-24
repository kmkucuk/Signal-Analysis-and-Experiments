
% DEMO2 demonstrates the use of the data set III from the BCI competition 2003 for 
%   The demo shows the offline analysis for obtaining a classifier and 
%   uses a jack-knife method (leave-one-trial out) for validation. 
%
%
% References: 
% [1} A. Schl�gl, C. Keinrath, R. Scherer, G. Pfurtscheller,
%       Information transfer of an EEG-based Bran-computer interface.
%       Proceedings of the 1st International IEEE EMBS Conference on Neural Engineering, Capri, Italy, Mar 20-22, 2003. 
% [2} Schl�gl A., Neuper C. Pfurtscheller G.
%       Estimating the mutual information of an EEG-based Brain-Computer-Interface
%       Biomedizinische Technik 47(1-2): 3-8, 2002
% [3] Alois Schl�gl (2000)
%       The electroencephalogram and the adaptive autoregressive model: theory and applications
%       Shaker Verlag, Aachen, Germany, (ISBN3-8265-7640-3). 
% [4] A. Schl�gl, J. Kronegg, J.E. Huggins, S. G. Mason.
%       Evaluation criteria in BCI research.
%       (Eds.) G. Dornhege, J.R. Millan, T. Hinterberger, D.J. McFarland, K.-R.M�ller,
%       Towards Brain-Computer Interfacing. MIT press (accepted)


%	$Revision: 1.5 $
%	$Id: demo2.m,v 1.5 2006/04/25 10:03:15 schloegl Exp $
%	Copyright (C) 1999-2003,2006 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the  License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

M0  = 7;
MOP = 3;
uc  = 30:5:80;

% load EEG-data S and classlabels cl 
% here, the data set III of the BCI competition 2003 is used. The data is available from  
%     http://hci.tugraz.at/schloegl/bci/competition2003/ (untriggered, raw data) 

fn = 'dataset_BCIcomp1raw.mat'; 
if ~exist(fn,'file')
        system('wget http://hci.tugraz.at/schloegl/bci/competition2003/dataset_BCIcomp1raw.mat');
end;        
load(fn);
cl = c1;
Fs = 128;
trigchan = 4;
eegchan  = [1,3];

TRIG = gettrigger(S(:,trigchan))-2*Fs;
if length(TRIG)~=length(cl);
        fprintf(2,'number of Triggers (%i) does not fit size of class information (%i)',length(TRIG),length(cl));
	return;        
end;

if ~any(size(eegchan)==1)
	S = S(:,1:size(eegchan,1))*eegchan;
	eegchan=1:size(eegchan,2); 
end;

%randn('state',0);
[a0,A0] = getar0(S(:,1:2),1:M0,1000,Fs/2);

T  = reshape((1:1152),16,1152/16)';
t0 = zeros(1152/16,1);
t0(25:72) = 1;
t0 = logical(t0);

p  = 3;
k  = 7;
UC0= 2^(-uc(k)/8);

% feature extraction for each chaannel
for ch = 1:length(eegchan),
        [ar{ch},e,REV(ch)] = aar(S(:,eegchan(ch)), [2,3], p, UC0, a0{p},A0{p});
end;

% get classifier 
[cc] = findclassifier([cat(2,ar{:})],TRIG, cl,T,t0);
cc.TSD.T = cc.TSD.T/Fs;
plota(cc.TSD);

