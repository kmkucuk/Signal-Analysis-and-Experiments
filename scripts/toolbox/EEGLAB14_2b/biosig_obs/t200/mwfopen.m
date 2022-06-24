function [HDR]=mwfopen(HDR,PERMISSION,arg3,arg4,arg5,arg6)
% MWFOPEN reads MFER files 
%
% HDR = mwfopen(Filename,PERMISSION);
%
% HDR contains the Headerinformation and internal data
%
% see also: SOPEN, SREAD, SSEEK, STELL, SCLOSE, SWRITE, SEOF


% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
        HDR.FILE.OPEN= 0; 

%	$Revision: 1.3 $
%	$Id: mwfopen.m,v 1.3 2004/05/02 11:00:02 schloegl Exp $
%	(C) 2004 by Alois Schloegl
%	a.schloegl@ieee.org	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


if nargin<1, PERMISSION='rb'; end;
if ischar(HDR)
        tmp=HDR;
        HDR=[];
        HDR.FileName=tmp;
end;

VER = version;

HDR.FILE.FID = fopen(HDR.FileName,PERMISSION,'ieee-be');
HDR.Endianity= 'ieee-be';

%%% Default values %%%
HDR.SampleRate = 1000;
HDR.GDFTYP = 3;        
HDR.AS.bps = 2;
HDR.SPR = NaN;
HDR.NS = 1; 
HDR.NRec = NaN; 
HDR.Off = 0; 
HDR.Cal = NaN; 

fprintf(2,'Warning MWFOPEN: support of MFER format not complete, but in testing state\n');
%% default values 
% standard 12 leads ECG codes 
ECG12LeadsCodes(1:9)={'I';'II';'V1';'V2';'V3';'V4';'V5';'V6';'V1'};
ECG12LeadsCodes(11:15)={'V3R';'V4R';'V5R';'V6R';'V7R'};
ECG12LeadsCodes(61:64)={'III';'aVR';'aVL';'aVF'};
ECG12LeadsCodes(66:69)={'V8';'V9';'V8R';'V9R'};

if ~isempty(findstr(PERMISSION,'r')),		%%%%% READ 
        HDR.FILE.OPEN = 1;
        HDR.FRAME.N = 0; 
        count = 1;
        %while count>0, %~feof(HDR.FILE.FID)
        while ~feof(HDR.FILE.FID)
                tag = fread(HDR.FILE.FID,1,'uchar');
                len = fread(HDR.FILE.FID,1,'char');
                %fprintf(1,'[%i] Tag %i: (%i)\n',ftell(HDR.FILE.FID),tag,len);

                if (len < 0) | (len > 127),
                        l   = mod(len,128);
                        len = fread(HDR.FILE.FID,[l,1],'uchar');
                        %len = 256.^[0:l-1]*len;        
                        len = 256.^[l-1:-1:0]*len;
                end;
                % tmp = fread(HDR.FILE.FID,[1,len],'char');
                % fprintf(1,'[%i] Tag %i: (%i)\n',ftell(HDR.FILE.FID),tag,len);
                
                if 0,
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        
                elseif tag==0; 
                        [tmp,count] = fread(HDR.FILE.FID,[1,1],'char');
                        
                elseif tag==1;
                        [tmp,count] = fread(HDR.FILE.FID,[1,1],'char');
                        if 0, 
                        elseif (tmp==0) & strcmp(HDR.Endianity,'ieee-le'),
                                tmp = ftell(HDR.FILE.FID);
                                HDR.Endianity='ieee-be';
                                fclose(HDR.FILE.FID);
                                HDR.FILE.FID = fopen(HDR.FileName,PERMISSION,HDR.Endianity);
                                fseek(HDR.FILE.FID,tmp,'bof');
                        elseif (tmp==1) & strcmp(HDR.Endianity,'ieee-be'),
                                tmp = ftell(HDR.FILE.FID);
                                HDR.Endianity='ieee-le';
                                fclose(HDR.FILE.FID);
                                HDR.FILE.FID = fopen(HDR.FileName,PERMISSION,HDR.Endianity);
                                fseek(HDR.FILE.FID,tmp,'bof');
                        else
                        end;
                        
                elseif tag==2;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.Version = tmp;
                        
                elseif tag==3;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.tag03 = tmp;
                        
                elseif tag==4;          % channel number
                        if len == 0;
                                tmp = NaN;
                        elseif len == 1;
                                [tmp,count] = fread(HDR.FILE.FID,1,'uint8');
                        elseif len == 2;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        elseif len == 3;
                                [tmp,count] = fread(HDR.FILE.FID,1,'bit24');
                                %[tmp,count] = fread(HDR.FILE.FID,3,'uint8');
                                %tmp = (2.^[16,8,0])*tmp;
                        elseif len == 4;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                        else
                                fprintf(2,'Error MWFOPEN: len=%i exceeds max length (4) in tag 04h\n',len);
                        end;
                        %[HDR.SPR,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.SPR = tmp;
                        
                elseif tag==5;
%                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        if len == 0;
                                tmp = 1;
                        elseif len == 1;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int8');
                        elseif len == 2;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        elseif len == 3;
                                [tmp,count] = fread(HDR.FILE.FID,1,'bit24');
                                %tmp = (2.^[16,8,0])*tmp;
                                %tmp = (2.^[0:8:16])*tmp;
                        elseif len == 4;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                        else
                                fprintf(2,'Error MWFOPEN: max length exceeded in tag 05h\n');
                        end;
                        HDR.NS = tmp; %*256.^[len-1:-1:0]';

                elseif tag==6;
                        if len == 0;
                                tmp = NaN;
                        elseif len == 1;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int8');
                        elseif len == 2;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        elseif len == 3;
                                [tmp,count] = fread(HDR.FILE.FID,1,'bit24')
                                %tmp = (2.^[16,8,0])*tmp;
                        elseif len == 4;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                        else
                                fprintf(2,'Error MWFOPEN: max length exceeded in tag 06h\n');
                        end;
                        HDR.NRec = tmp;
                                
                elseif tag==7;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar')
                        HDR.Pointer = tmp*256.^[0:len-1]';
                        
                elseif tag==8;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        if tmp==0,
                                HDR.MFER.WaveFormType = 'undefined';
                        elseif tmp==1,
                                HDR.MFER.WaveFormType = 'ECG_STD12';
                        elseif tmp==2,
                                HDR.MFER.WaveFormType = 'ECG_LTERM';
                        elseif tmp==3,
                                HDR.MFER.WaveFormType = 'Vectorcardiogram';
                        elseif tmp==4,
                                HDR.MFER.WaveFormType = 'Stress_ECG';
                        elseif tmp==5,
                                HDR.MFER.WaveFormType = 'ECG_LTERM';
                        else
                                HDR.MFER.WaveFormType = tmp;
			end
                        
                elseif tag==9; 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.Label=char(tmp);
                        
                elseif tag==10;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        if tmp==0;	% int16, default
                                HDR.GDFTYP = 3;
                                HDR.AS.bps = 2;
                        elseif tmp==1;	% uint16
                                HDR.GDFTYP = 4;
                                HDR.AS.bps = 2;
                        elseif tmp==2;	% int32
                                HDR.GDFTYP = 5;
                                HDR.AS.bps = 4;
                        elseif tmp==3;	% uint8
                                HDR.GDFTYP = 3;
                                HDR.AS.bps = 1;
                        elseif tmp==4;	% 16bit status
                                HDR.GDFTYP = 4;
                                HDR.AS.bps = 2;
                        elseif tmp==5;	% int8
                                HDR.GDFTYP = 1;
                                HDR.AS.bps = 1;
                        elseif tmp==6;	% uint32
                                HDR.GDFTYP = 6;
                                HDR.AS.bps = 4;
                        elseif tmp==7;	% float32
                                HDR.GDFTYP = 16;
                                HDR.AS.bps = 4;
                        elseif tmp==8;	% float64
                                HDR.GDFTYP = 17;
                                HDR.AS.bps = 8;
                        elseif tmp==9;	% 8 bit AHA compression 
                                HDR.GDFTYP = 4;
                                HDR.AS.bps = NaN;
                                fprintf(2,'Error MWFOPEN: compression not supported, yet.\n');
                        end;
                        
                elseif tag==11;       
                        [tmp1,count] = fread(HDR.FILE.FID,2,'int8');
                        len = len - 2;
                        if len == 1;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int8');
                        elseif len == 2;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        elseif len == 3;
                                [tmp,count] = fread(HDR.FILE.FID,1,'bit24');
                        elseif len == 4;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                        end;
                        e = 10^tmp1(2);
                        if     tmp1(1)==0, 
                                HDR.Xphysdim = 'Hz';
                                HDR.SampleRate=tmp*e;
                        elseif tmp1(1)==1, 
                                HDR.Xphysdim = 's';
                                HDR.SampleRate= 1/(tmp*e);
                        elseif tmp1(1)==2, 
                                HDR.Xphysdim = 'm';
                                HDR.SampleRate=tmp*e;
                        end;
                        
                elseif tag==12;          % sensitivity, resolution, gain, calibration, 
                        [tmp,count] = fread(HDR.FILE.FID,2,'int8');
                        if     tmp(1)==0, HDR.PhysDim = 'V';
                        elseif tmp(1)==1, HDR.PhysDim = 'mmHg';
                   	elseif tmp(1)==2, HDR.PhysDim = 'Pa';
                        elseif tmp(1)==3, HDR.PhysDim = 'cmH2O';
                        elseif tmp(1)==4, HDR.PhysDim = 'mmHg';
                        elseif tmp(1)==5, HDR.PhysDim = 'dyne';
                        elseif tmp(1)==6, HDR.PhysDim = 'N';
                        elseif tmp(1)==7, HDR.PhysDim = '%';
                        elseif tmp(1)==8, HDR.PhysDim = '�C';
                        elseif tmp(1)==9, HDR.PhysDim = '/m';
                        elseif tmp(1)==10, HDR.PhysDim = '/s';
                        elseif tmp(1)==11, HDR.PhysDim = 'Ohm';
                        elseif tmp(1)==12, HDR.PhysDim = 'A';
                        elseif tmp(1)==13, HDR.PhysDim = 'r.p.m.';
                        elseif tmp(1)==14, HDR.PhysDim = 'W';
                        elseif tmp(1)==15, HDR.PhysDim = 'dB';
                        elseif tmp(1)==16, HDR.PhysDim = 'kg';
                        elseif tmp(1)==17, HDR.PhysDim = 'J';
                        elseif tmp(1)==18, HDR.PhysDim = 'dyne s m-2 cm-5';
                        elseif tmp(1)==19, HDR.PhysDim = 'L';
                        elseif tmp(1)==20, HDR.PhysDim = 'L/s';
                        elseif tmp(1)==21, HDR.PhysDim = 'L/m';
                        elseif tmp(1)==22, HDR.PhysDim = 'cd';
                        elseif tmp(1)==23, HDR.PhysDim = '';
                        elseif tmp(1)==24, HDR.PhysDim = '';
                        elseif tmp(1)==25, HDR.PhysDim = '';
                        end;
                        e = 10^tmp(2);
                        len = len - 2;
                        if len == 1;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int8');
                        elseif len == 2;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        elseif len == 3;
                                [tmp,count] = fread(HDR.FILE.FID,1,'bit24');
                        elseif len == 4;
                                [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                        end;
                        HDR.Cal = tmp*e;
                        
                elseif tag==13;          % offset
                        [tmp,count] = fread(HDR.FILE.FID,1,gdfdatatype(HDR.GDFTYP));
                        HDR.Off=tmp;
                        
                elseif tag==14;          % compression
                        %[tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar')
                        [HDR.MFER.CompressionCode,count] = fread(HDR.FILE.FID,1,'uint16');
                        [HDR.MFER.DataLength1,count] = fread(HDR.FILE.FID,1,'uint32');
                        [HDR.MFER.DataLength2,count] = fread(HDR.FILE.FID,1,'uint32');
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.tag14=char(tmp);
                        HDR.FLAG.Compresssion=tmp;
                        
                elseif tag==17;
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.tag17 = tmp;
                        
                elseif tag==18;       % null value
                        [tmp,count] = fread(HDR.FILE.FID,1,gdfdatatype(HDR.GDFTYP));
                        HDR.MFER.NullValue = tmp;
                        
                elseif tag==21;          % 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.tag21=char(tmp);
                        
                elseif tag==22;          % 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.comment=char(tmp);
                        
                elseif tag==23;          % 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                        HDR.tag23 = char(tmp);
                        
                elseif tag==30;          % 
			if isfield(HDR,'MFER');
				if isfield(HDR.MFER,'SPR');
	                                HDR.AS.spb = sum(HDR.MFER.SPR);
				else
	                                HDR.AS.spb = HDR.SPR*HDR.NS;
        	                        HDR.MFER.SPR = HDR.SPR(ones(1,HDR.NS));
				end;
			end;					
        
                        HDR.SPR = HDR.MFER.SPR(1);
                        for k=2:HDR.NS,
                                HDR.SPR = lcm(HDR.SPR,HDR.MFER.SPR(k));
                        end;

                        HDR.FRAME.N = HDR.FRAME.N + 1; 
                        HDR.FRAME.POS(HDR.FRAME.N) = ftell(HDR.FILE.FID);
                        HDR.FRAME.TYP(HDR.FRAME.N) = HDR.GDFTYP;
                        nos = len/(HDR.AS.bps*HDR.AS.spb);
                        HDR.FRAME.sz(HDR.FRAME.N,1:5) = [HDR.AS.spb,nos,HDR.NRec,HDR.NS,len];
                        HDR.FRAME.Fs(HDR.FRAME.N) = HDR.SampleRate;
                        
                        fseek(HDR.FILE.FID,len,'cof');
			
                        
                elseif tag==63;     
                        chansel = mod(len,128)+1;
                        k = 1;
                        while len > 127,
                                [len, count] = fread(HDR.FILE.FID,1,'uchar');
                                k = k + 1;
                                chansel(k)  = mod(len,128)+1;
                        end   
                        
                        [len, count] = fread(HDR.FILE.FID,1,'uchar');
                        if 0, 
                        elseif len<128,
                                while len,
                                        tag2 = fread(HDR.FILE.FID,1,'uchar');
                                        len2 = fread(HDR.FILE.FID,1,'char');
                                        len = len - 2 - len2; 
                                        if 0, 
                                        elseif (tag2 == 4), 
                                                if len == 0;
                                                        tmp = NaN;
                                                elseif len == 1;
                                                        [tmp,count] = fread(HDR.FILE.FID,1,'int8');
                                                elseif len == 2;
                                                        [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                                                elseif len == 3;
                                                        [tmp,count] = fread(HDR.FILE.FID,1,'bit24');
                                                elseif len == 4;
                                                        [tmp,count] = fread(HDR.FILE.FID,1,'int32');
                                                else
                                                        fprintf(2,'Error MWFOPEN: len=%i exceeds max length (4) in tag 04h\n',len);
                                                end;
                                                %[HDR.SPR,count] = fread(HDR.FILE.FID,[1,len],'uchar');
                                                HDR.MFER.SPR(chansel) = tmp;
                                                HDR.SPR = lcm(tmp,HDR.SPR);
                                                
                                        elseif (tag2 == 12), 
                                                [tmp, count] = fread(HDR.FILE.FID,1,gdfdatatype(HDR.GDFTYP));
                                                HDR.Cal(chansel) = tmp;
                                        elseif (tag2 == 13), 
                                                [tmp, count] = fread(HDR.FILE.FID,1,gdfdatatype(HDR.GDFTYP));
                                                HDR.Off(chansel) = tmp;
                                        elseif (tag2 == 9), 
                                                [tmp, count] = fread(HDR.FILE.FID,[1,len2],'uchar');
                                                if ~isfield(HDR,'Label')
                                                        HDR.Label(chansel,:) = ECG12LeadsCodes{tmp};
                                                else
                                                        HDR.Label(chansel,1:length(ECG12LeadsCodes{tmp})) = ECG12LeadsCodes{tmp};
                                                end;
                                        else  % if (tag2 == 10), 
                                                fprintf(2,'Error MWFOPEN: Tag %i in channel-specific section not supported \n',tag2);
                                                fclose(HDR.FILE.FID);
                                                HDR.FILE.OPEN=0;
                                                return;
                                        end;
                                        %fprintf(1,'\t%i',chansel);
                                        %fprintf(1,'> [%i] Tag %i = %i: (%i) \n',ftell(HDR.FILE.FID),tag2,tmp,len2);
                                end;
                        else
                                tag2 = 1; len2=1;
                                while (tag2 | len2),
                                        tag2 = fread(HDR.FILE.FID,1,'uchar');
                                        len2 = fread(HDR.FILE.FID,1,'char');
                                        %% this part is not tested yet
                                        fprintf(1,'\t%i',chansel);
                                        fprintf(1,'> [%i] Tag %i: (%i)\n',ftell(HDR.FILE.FID),tag2,len2);
                                        
                                        if (len2 < 0) | (len2 > 127),
                                                l   = mod(len2,128);
                                                len2 = fread(HDR.FILE.FID,[l,1],'uchar');
                                                %len = 256.^[0:l-1]*len;        
                                                len2 = 256.^[l-1:-1:0]*len2;
                                        end;
                                        [tmp, count] = fread(HDR.FILE.FID,[1,len],'uchar');
                                end;
                        end;
                        if isfield(HDR,'Label')
                                HDR.Label = char(HDR.Label);
                        end;
                        
                elseif tag==64;     % Preamble
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.TYPE='MFER';
                        
                elseif tag==65;     % Events
                        N = HDR.EVENT.N + 1;
                        HDR.EVENT.N = N;
                        [HDR.EVENT.TYP(N),count] = fread(HDR.FILE.FID,1,'uint16');
                        if len>5,
                                [HDR.EVENT.POS(N),count] = fread(HDR.FILE.FID,1,'uint32');
                        end;
                        if len>9,
                                [HDR.EVENT.DUR(N),count] = fread(HDR.FILE.FID,1,'uint32');
                        end;
                        if len>10,
                                [HDR.EVENT.Desc{N},count] = fread(HDR.FILE.FID,len-10,'char');
                        end;
                        
                elseif tag==67;     % Sample Skew
                        [tmp,count] = fread(HDR.FILE.FID,1,'int16');
                        HDR.SampleSkew = tmp;
                        
                elseif tag==129;     % Patient Name 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.Patient.Name = char(tmp);
                        
                elseif tag==130;     % Patient Id 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.PID = char(tmp);
                        
                elseif tag==131;     % Patient Age 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.Patient.Age = char(tmp);
                        
                elseif tag==132;     % Patient Age 
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        HDR.Patient.Sex = char(tmp);
                        
                elseif tag==133;     % recording time 
                        [HDR.T0(1),count] = fread(HDR.FILE.FID,1,'int16');
                        [HDR.T0(2:6),count] = fread(HDR.FILE.FID,[1,5],'uint8');
                        [tmp,count] = fread(HDR.FILE.FID,[1,2],'int16');
                        HDR.T0(6) = HDR.T0(6) + tmp(1)*1e-3 + tmp(2)+1e-6;
                        
                else
                        [tmp,count] = fread(HDR.FILE.FID,[1,len],'char');
                        %fprintf(1,'[%i %i] Tag %i: (%i) %s\n',ftell(HDR.FILE.FID),count,tag,len,char(tmp));
                end;
                % fprintf(1,'[%i %i] Tag %i: (%i)\n',ftell(HDR.FILE.FID),count,tag,len);
                %                        count = 1;
                %                        pause
        end;

        HDR.HeadLen = ftell(HDR.FILE.FID);
        HDR.FILE.POS  = 0; 
        HDR.Calib = sparse([HDR.Off(ones(1,HDR.NS/length(HDR.Off)));eye(HDR.NS)]);
        HDR.Calib = HDR.Calib * sparse(1:HDR.NS,1:HDR.NS,HDR.Cal);
end;        

