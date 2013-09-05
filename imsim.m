%function ud = imsim(action, varargin)
%
%       Title: MRI Image Simulator
%
%   Purpose: Simulate MRI giving Signal and Image Parameters
%
%   Developed by: Eman Ghobrial Fall 2005
%   Last update Feb 5, 2006
%
%   Data Set from MNI
%   url: http://www.bic.mni.mcgill.ca/brainweb/
%   Under Guidelines of Dr. Richard Buxton
%   References:
%           Introduction to Functional Magnetic Resonance Imaging
%           Principles & Techniques, Richard B. Buxton
%           
% 	Stable version 2.0 checked into GIT
function ud = imsim(action, varargin)
%imsim 


if nargin<1,
   action='InitializeIMSIM';
end;

feval(action,varargin{:})
ud=1;
return


%%%
%%%  Sub-function - InitializeIMSIM
%%%

function InitializeIMSIM()

% If dctdemo is already running, bring it to the foreground.
h = findobj(allchild(0), 'tag', 'MRI Image Simulation Program (imsim v2.1)');
if ~isempty(h)
   figure(h(1));
   return
end

screenD = get(0, 'ScreenDepth');
if screenD>8
   grayres=256;
else
   grayres=128;
end
 
ImSimFig = figure( ...
   'Name','MRI Image Simulation Program (imsim v2.1)', ...
   'NumberTitle','off', 'HandleVisibility', 'on', ...
   'tag', 'MRI Image Simulation Program (imsim v2.1)', ...
   'Visible','off', 'Resize', 'off',...
   'BusyAction','Queue','Interruptible','off', ...
   'Color', [.8 .8 .8], 'Pointer', 'watch',...
   'DoubleBuffer', 'on', ...
   'IntegerHandle', 'off', ...
   'Colormap', gray(grayres));

figpos = get(ImSimFig, 'position');
% Adjust the size of the figure window
figpos(3:4) = [1160 700];
%figpos(3:4) = [1000 700];
horizDecorations = 10;  % resize controls, etc.
vertDecorations = 45;   % title bar, etc.
screenSize = get(0,'ScreenSize');
if (screenSize(3) <= 1)
    % No display connected (apparently)
    screenSize(3:4) = [100000 100000]; % don't use Inf because of vms
end
if (((figpos(3) + horizDecorations) > screenSize(3)) | ...
            ((figpos(4) + vertDecorations) > screenSize(4)))
    % Screen size is too small for this demo!
    delete(fig);
    error(['Screen resolution is too low ', ...
                '(or text fonts are too big) to run this demo']);
end
dx = screenSize(3) - figpos(1) - figpos(3) - horizDecorations;
dy = screenSize(4) - figpos(2) - figpos(4) - vertDecorations;
if (dx < 0)
    figpos(1) = max(5,figpos(1) + dx);
end
if (dy < 0)
    figpos(2) = max(5,figpos(2) + dy);
end
set(ImSimFig, 'position', figpos);
rows = figpos(4);
cols = figpos(3);


spac = 25;   % Spacing

ud.Computer = computer;

Std.Interruptible = 'off';
Std.BusyAction = 'queue';    

% Defaults for image axes
Ax = Std;
Ax.Units = 'Pixels';
Ax.Parent = ImSimFig;
Ax.ydir = 'reverse';
Ax.XLim = [.5 256.5];
Ax.YLim = [.5 256.5];
Ax.CLim = [0 1];
Ax.XTick = [];
Ax.YTick = [];

Img = Std;
Img.CData = [];
%Img.Xdata = [1 256];
%Img.Ydata = [1 256];
Img.CDataMapping = 'Scaled';
Img.Erasemode = 'none';

Ctl = Std;
Ctl.Units = 'Pixels';
Ctl.Parent = ImSimFig;

Btn = Ctl;
Btn.Parent = ImSimFig;
Btn.Style = 'pushbutton';
Btn.Enable = 'off';

btnHt = 26;
txtHt = 18;
menuHt = 26;
editHt = 21;
radioHt = 20;
radioWid = 140;
% Colors
bgcolor = [0.45 0.45 0.45];  % Background color for frames
wdcolor = [.8 .8 .8];  % Window color
fgcolor = [1 1 1];  % For text
radio_color = [.7 .7 .7];
%================================
% Control Frame
frsp = spac/3;  % Frame spacing
fleft = spac*2+256;
fbot = frsp*1.5;
fwid = cols - fleft - frsp*1.5;
fht = rows - 4*spac - 128;
%ud.hControlFrame = uicontrol(Std, ...
%   'Parent', ImSimFig, ...
%   'Style', 'Frame', ...
%   'Units', 'pixels', ...
%   'Position', [fleft fbot fwid fht], ...
%   'BackgroundColor', bgcolor);

%================================
% Operations Popup menu
opleft = fleft+frsp; 
opbot = fbot+fht-frsp/3-txtHt-btnHt;
opwid = fwid-2*frsp;
opht = menuHt;
%=================================
% Axes for Adjustment tool
atwid = 70;
atht = 128;
atleft = fleft+(fwid-atwid)/2;
atbot = fbot+fht+1.5*spac+txtHt;

% Operations Popup menu
opleft = fleft+frsp; 
opbot = fbot+fht-frsp/3-txtHt-btnHt;  
opwid = fwid-2*frsp;
opht = menuHt;
%btnWid = (opwid-frsp)/2;
btnWid = 75;
framewid=3*atwid+2*frsp;
%================================
% Original real Image 
ud.hOriginalAxes = axes(Ax, ...
    'Position', [spac rows-txtHt-2*spac-256 256 256], ...
    'XGrid','on', ...
    'YGrid','on');
title('Magnitude Image');
ud.hOriginalImage = image(Img, ...
      'Parent', ud.hOriginalAxes);
%================================
% Original phase Image 
ud.hOriginalPhaseAxes = axes(Ax, ...
    'Position', [spac fbot+spac 256 256], ...
    'XGrid','on', ...
    'YGrid','on');
title('Phase Image');
ud.hOriginalPhaseImage = image(Img, ...
      'Parent', ud.hOriginalPhaseAxes);
%================================
% distroted mag Image 
ud.hDistAxes = axes(Ax, ...
    'Position', [256+framewid+3*spac rows-txtHt-2*spac-256 256 256], ...
    'XGrid','on', ...
    'YGrid','on');
title('Acquired Mag Image');
ud.hDistImage = image(Img, ...
      'Parent', ud.hDistAxes);
%================================
% Images from memory 
ud.hDistPhaseAxes = axes(Ax, ...
    'Position', [256+framewid+3*spac fbot+spac 256 256], ...
    'XGrid','on', ...
    'YGrid','on');
title('Images stored in memory');
ud.hDistPhaseImage = image(Img, ...
      'Parent', ud.hDistPhaseAxes);
% Text label for Signal Parameters
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft-frsp opbot+5*(txtHt+frsp)-frsp+radioHt+editHt+4*frsp  128 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Signal Parameters');





% %================================
% %SE Sim Frame
% ud.hSEFrame = uicontrol(Std, ...
%    'Parent', ImSimFig, ...
%    'Style', 'Frame', ...
%    'Units', 'pixels', ...
%    'Position', [opleft+frsp+radioWid/4 opbot+5*(txtHt+frsp)-frsp 2*atwid+frsp radioHt+editHt+4*frsp], ...
%    'BackgroundColor', bgcolor);
% % GRE Sim Frame
% ud.hGREFrame = uicontrol(Std, ...
%    'Parent', ImSimFig, ...
%    'Style', 'Frame', ...
%    'Units', 'pixels', ...
%    'Position', [opleft+frsp+radioWid/4 opbot+2*(txtHt+frsp)-frsp 2*atwid+frsp radioHt+editHt+4*frsp], ...
%    'BackgroundColor', bgcolor);
% % IR Sim Frame
% ud.hIRFrame = uicontrol(Std, ...
%    'Parent', ImSimFig, ...
%    'Style', 'Frame', ...
%    'Units', 'pixels', ...
%    'Position', [opleft+frsp+radioWid/4 opbot-(txtHt+frsp)-frsp 2*atwid+frsp radioHt+editHt+4*frsp], ...
%    'BackgroundColor', bgcolor);


%SE Sim Frame
ud.hSEFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [opleft-frsp opbot+5*(txtHt+frsp)-frsp 3*atwid+2*frsp radioHt+editHt+4*frsp], ...
   'BackgroundColor', bgcolor);
% GRE Sim Frame
ud.hGREFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [opleft-frsp opbot+2*(txtHt+frsp)-frsp 3*atwid+2*frsp radioHt+editHt+4*frsp], ...
   'BackgroundColor', bgcolor);
% IR Sim Frame
ud.hIRFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [opleft-frsp opbot-(txtHt+frsp)-frsp 3*atwid+2*frsp radioHt+editHt+4*frsp], ...
   'BackgroundColor', bgcolor);

%imaging matrix frame
ud.hIMFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [512+framewid+4*spac opbot+5*(txtHt+frsp)-frsp 3*atwid+2*frsp menuHt+txtHt+4*frsp], ...
   'BackgroundColor', bgcolor);
%imaging noise frame
ud.hNoFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [512+framewid+4*spac opbot+2*(txtHt+frsp)-frsp 3*atwid+2*frsp radioHt+editHt+4*frsp], ...
   'BackgroundColor', bgcolor);
%imaging EPI parameters frame 
ud.hNoFrame = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [512+framewid+4*spac opbot-7*(txtHt+frsp)-frsp 3*atwid+2*frsp 3*(radioHt+editHt+4.35*frsp)], ...
   'BackgroundColor', bgcolor);
% Text label for Imaging Parameters
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+4*spac opbot+5*(txtHt+frsp)-frsp/2+radioHt+editHt+4*frsp  128 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Imaging Parameters');
%================================
% Image matrix popup menu
ud.hImgPop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac opbot+4*(txtHt+frsp)+1.3*spac 128 menuHt], ...
   'Enable','on', ...
   'String','256x256|128x128|64x64', ...
   'Tag','ImageMatrixPop',...
   'Callback','imsim(''SetMat'')');
% Text label for Image Martix Menu Popup
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac opbot+5*(txtHt+frsp)+1.7*spac  128 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Image Matrix:');
%================================
% Add noise popup menu
ud.hNoisePop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac opbot+(txtHt+frsp)+1.3*spac 100 menuHt], ...
   'Enable','on', ...
   'String','1|2|3|4|5|20|100|1000', ...
   'Tag','ImageNoisePop',...
   'Callback','imsim(''SetNoise'')');
% Text label for Image Noise Menu Popup
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac opbot+2*(txtHt+frsp)+1.7*spac 100 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String',' NEX');
%================================
% Add tesla popup menu
ud.hTeslaPop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac+100+frsp opbot+(txtHt+frsp)+1.3*spac 60 menuHt], ...
   'Enable','on', ...
   'String','1.5T|3.0T|7.0T', ...
   'Tag','TeslaPop',...
   'Callback','imsim(''SetTesla'')');
% Text label for tesla Menu Popup
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac+100+frsp opbot+2*(txtHt+frsp)+1.7*spac 60 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String',' Tesla:');
%================================
% Add frequency encoding direction popup menu
ud.hFreqEncodePop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac opbot-2*(txtHt+frsp)+.8*spac-2*frsp 100 menuHt], ...
   'Enable','on', ...
   'String',' Right-Left | Ant-Post', ...
   'Tag','FreqEncodePop',...
   'Callback','imsim(''SetFreqEncode'')');
% Text label for Freq Encode Menu Popup
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac opbot-(txtHt+frsp)+1.1*spac-2*frsp  100 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Freq. Encoding Dir:');
%================================
% Add Band Width direction popup menu
ud.hBWPop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac+100+frsp opbot-2*(txtHt+frsp)+.8*spac-2*frsp 60 menuHt], ...
   'Enable','on', ...
   'String','31.25|62.5|125|250', ...
   'Tag','BWPop',...
   'Callback','imsim(''SetBW'')');
% Text label for BandWidth txt
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac+100+frsp opbot-(txtHt+frsp)+1.1*spac-2*frsp 60 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Bandwidth');

%================================
% Add Phase encoding direction popup menu
ud.hPhaseEncodePop = uicontrol(Ctl, ...
   'Style', 'Popupmenu',...
   'Position',[512+framewid+5*spac+100+frsp rows-txtHt-2.5*spac-256 90 menuHt], ...
   'Enable','on', ...
   'String','Top-Bottom|Bottom-Top', ...
   'Tag','PhaseEncodePop',...
   'Callback','imsim(''SetPhaseEncode'')');
% Text label for Phase Encode Menu Popup
uicontrol( Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac rows-txtHt-2.5*spac-256  100 menuHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Phase Encoding Dir:');

% %====================================
% % Radio Button Group
% 
% ud.hRG = uibuttongroup('Parent', ImSimFig, ...
%     'visible', 'off', ...
%     'Position', [opleft-frsp fbot+spac radioWid+2*frsp 256]);

%====================================
% Radio Buttons
%    'parent', ud.hRG, ...
%     'HandleVisibility', 'off', ...
% ud.hSE=uicontrol('Parent', ImSimFig, ...
%    'Style','radiobutton', ...
%    'Position',[opleft opbot+6*(radioHt+frsp) radioWid radioHt], ...
%     'String',' ** SE Simulation **', ...
%    'Callback','imsim(''UpdateApply'')');
% ud.hGRE=uicontrol('Parent', ImSimFig, ...
%    'Style','radiobutton', ...
%    'Position',[opleft opbot+3*(radioHt+frsp) radioWid radioHt], ...
%    'String',' ** GRE Simulation **', ...
%    'Callback','imsim(''UpdateApplyGRE'')');
% ud.hIR=uicontrol('Parent', ImSimFig, ...
%    'Style','radiobutton', ...
%    'Position',[opleft opbot+0.5*(radioHt+frsp) radioWid radioHt], ...
%    'String',' ** IR Simulation **', ...
%    'Callback','imsim(''UpdateApplyIR'')');
% 



ud.hEPI=uicontrol('Parent', ImSimFig, ...
   'Style','radiobutton', ...
  'Position',[512+framewid+5*spac opbot-(txtHt+frsp)+2*spac 175 txtHt-frsp/2], ...
'Foreground', [.8 0 0], ...   
 'Background',wdcolor, ...   
'String',' ** Click for EPI Sim **', ...
   'Callback','imsim(''ApplyEPI'')');
ud.hGRID=uicontrol('Parent', ImSimFig, ...
   'Style','radiobutton', ...
  'Position',[512+framewid+5*spac opbot-(txtHt+frsp)+1.3*spac 175 txtHt-frsp/2], ...
'Foreground', [.8 0 0], ...   
 'Background',wdcolor, ...   
'String',' ** Display Grid **', ...
   'Callback','imsim(''ApplyGRID'')');

ud.hgauss=uicontrol('Parent', ImSimFig, ...
   'Style','radiobutton', ...
   'Position',[512+framewid+5*spac rows-txtHt-3.5*spac-256  200 txtHt-frsp/2], ...
'Foreground', [.8 0 0], ...   
 'Background',wdcolor, ...   
'String',' ** Apply Gaussian Smoothing **', ...
   'Callback','imsim(''Applygauss'')');

%====================================
% Radio Button Group

% ud.hRG = uibuttongroup('visible', 'off', ...
%     'Position', [opleft-frsp fbot+spac radioWid/4 256]);

ud.hRG = uibuttongroup('visible', 'off', ...
    'Position', [0 0 .01 .01]);

ud.hSE=uicontrol('Parent', ud.hRG, ...
     'HandleVisibility', 'off', ...
   'Style','Radio', ...
   'Position',[opleft opbot+6*(radioHt+frsp) radioWid radioHt], ...
   'String','SpinEcho');
ud.hGRE=uicontrol('Parent', ud.hRG, ...
     'HandleVisibility', 'off', ...
   'Style','Radio', ...
   'Position',[opleft opbot+3*(radioHt+frsp) radioWid radioHt], ...
   'String','GRadientEcho');
ud.hIR=uicontrol('Parent', ud.hRG, ...
     'HandleVisibility', 'off', ...
   'Style','Radio', ...
   'Position',[opleft opbot+0.5*(radioHt+frsp) radioWid radioHt], ...
   'String','InversionRecovery');


set (ud.hRG, 'SelectionChangeFcn', @selcbk);
set (ud.hRG, 'SelectedObject', []);
set (ud.hRG, 'Visible', 'on');






%parameters for Spin Echo Simulation
%=================================
% Text label for TE
ud.hSETELabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft opbot+5*(txtHt+frsp) atwid/3 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TE: ');
% Edit box for TE
ud.hSETEEdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+atwid/2 opbot+5*(txtHt+frsp) atwid/2 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','17',...
   'Callback','imsim(''UpdateSETE'')');
%=================================
% Text label for TR
ud.hSETRLabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft+1.5*atwid opbot+5*(txtHt+frsp) atwid/3 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TR: ');
% Edit box for TR
ud.hSETREdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+2*atwid opbot+5*(txtHt+frsp) atwid/2 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','700',...
   'Callback','imsim(''UpdateSETR'')');
%default values for SE
ud.sete=17;
ud.setr=700;
%parameters for Gradient Echo Simulation
%=================================
% Text label for TE
ud.hGRETELabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft opbot+2*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TE: ');
% Edit box for TE
ud.hGRETEEdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+atwid/2 opbot+2*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','10',...
   'Callback','imsim(''UpdateGRETE'')');
%=================================
% Text label for TR
ud.hGRETRLabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft+1*atwid opbot+2*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TR: ');
% Edit box for TR
ud.hGRETREdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+1.5*atwid opbot+2*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','200',...
   'Callback','imsim(''UpdateGRETR'')');
%=================================
% Text label for FA
ud.hGREFALabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft+2*atwid opbot+2*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','FA: ');
% Edit box for FA
ud.hGREFAEdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+2.5*atwid opbot+2*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','90',...
   'Callback','imsim(''UpdateGREFA'')');
%default values for GRE
ud.grete=10;
ud.gretr=200;
ud.grefa=90;
%parameters for Inversion Recovery Simulation
%=================================
% Text label for TE
ud.hIRTELabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft opbot-.75*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TE: ');
% Edit box for TE
ud.hIRTEEdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+atwid/2 opbot-.75*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','10',...
   'Callback','imsim(''UpdateIRTE'')');
%=================================
% Text label for TR
ud.hIRTRLabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft+1*atwid opbot-.75*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TR: ');
% Edit box for TR
ud.hIRTREdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+1.5*atwid opbot-.75*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','3000',...
   'Callback','imsim(''UpdateIRTR'')');
%=================================
% Text label for TI
ud.hIRTILabel = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft+2*atwid opbot-.75*(txtHt+frsp) atwid/3.5 txtHt ], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'Foreground','black', ...
   'String','TI: ');
% Edit box for TI
ud.hIRTIEdit = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[opleft+2.5*atwid opbot-.75*(txtHt+frsp) atwid/2.5 editHt ], ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','800',...
   'Callback','imsim(''UpdateIRTI'')');
%default values for IR
ud.irte=10;
ud.irtr=3000;
ud.irti=800;

% Global Default values
ud.matrix=256;
ud.noise=1;
ud.r=1;
ud.tesla=1.5;
ud.freqen='rl';
ud.phaseen='tb';
ud.phasencode='ypm';
ud.BW=62.5;
ud.epi='off';
ud.gridopt='off';
ud.gaussopt='off';
ud.imc=1;
ud.mc=0;
ud.memimages=zeros(256,256,15);
% ud.memmag=zeros(256,256);
% ud.memcormag=zeros(256,256);
% ud.memphase=zeros(256,256);
% ud.origimg=zeros(256,256);
ud.magmin=0;
ud.magmax=1;
ud.mni=1;

if isequal(ud.Computer(1:2), 'MA')
   CtlEraseMode = 'normal';
else
   CtlEraseMode = 'xor';
end

%====================================
% Buttons for Intensity Adjustment for Mag image
ud.hBrighten=uicontrol(Btn, ...
   'Position',[opleft-3*frsp rows-txtHt-3*spac-256 btnWid/1.5 btnHt], ...
   'String','+Bright', ...
   'Callback','imsim(''IncreaseBrightness'')');

ud.hDarken = uicontrol(Btn, ...
   'Position',[opleft-2*frsp+btnWid/1.5  rows-txtHt-3*spac-256 btnWid/1.5 btnHt], ...
   'String','-Bright', ...
   'Callback','imsim(''DecreaseBrightness'')');

ud.hIncrContr=uicontrol(Btn, ...
   'Position',[opleft-3*frsp rows-txtHt-4.5*spac-256 btnWid/1.5 btnHt], ...
   'String','+Cntrst', ...
   'Callback','imsim(''IncreaseContrast'')');

ud.hDecrContr=uicontrol(Btn, ...
   'Position',[opleft-2*frsp+btnWid/1.5 rows-txtHt-4.5*spac-256 btnWid/1.5 btnHt], ...
   'String','-Cntrst', ...
   'Callback','imsim(''DecreaseContrast'')');
%====================================
% Buttons for Intensity Adjustment for corrected Mag Image
ud.hBrighten1=uicontrol(Btn, ...
   'Position',[opleft-3*frsp+3*(btnWid/1.5) rows-txtHt-3*spac-256 btnWid/1.5 btnHt], ...
   'String','+Bright', ...
   'Callback','imsim(''IncreaseBrightness1'')');

ud.hDarken1 = uicontrol(Btn, ...
   'Position',[opleft-2*frsp+4*(btnWid/1.5)  rows-txtHt-3*spac-256 btnWid/1.5 btnHt], ...
   'String','-Bright', ...
   'Callback','imsim(''DecreaseBrightness1'')');

ud.hIncrContr1 = uicontrol(Btn, ...
   'Position',[opleft-3*frsp+3*(btnWid/1.5) rows-txtHt-4.5*spac-256 btnWid/1.5 btnHt], ...
   'String','+Cntrst', ...
   'Callback','imsim(''IncreaseContrast1'')');

ud.hDecrContr1 = uicontrol(Btn, ...
   'Position',[opleft-2*frsp+4*(btnWid/1.5) rows-txtHt-4.5*spac-256 btnWid/1.5 btnHt], ...
   'String','-Cntrst', ...
   'Callback','imsim(''DecreaseContrast1'')');
%=======================================
%
ud.hSave=uicontrol(Btn, ...
   'Position',[spac rows-txtHt-3.5*spac-256 btnWid/1.2 btnHt], ...
   'String','Raw Im', ...
   'Callback','imsim(''SaveIm1'')');

ud.hSavem=uicontrol(Btn, ...
   'Position',[spac+btnWid/1.2+frsp rows-txtHt-3.5*spac-256 btnWid/1.2 btnHt], ...
   'String','MEM Save', ...
   'Callback','imsim(''Savem1'')');
%=======================================
%
ud.hSave2=uicontrol(Btn, ...
   'Position',[256+framewid+3*spac rows-txtHt-3.5*spac-256 btnWid/1.2 btnHt], ...
   'String','Raw Im', ...
   'Callback','imsim(''SaveIm2'')');
ud.hSavem2=uicontrol(Btn, ...
   'Position',[256+framewid+3*spac+spac+btnWid/1.2+frsp rows-txtHt-3.5*spac-256 btnWid/1.2 btnHt], ...
   'String','MEM Save', ...
   'Callback','imsim(''Savem2'')');
%=======================================
%
ud.hSave3=uicontrol(Btn, ...
   'Position',[spac 6 btnWid/1.2 btnHt], ...
   'String','Raw Im', ...
   'Callback','imsim(''SaveIm3'')');
ud.hSavem3=uicontrol(Btn, ...
   'Position',[spac+btnWid/1.2+frsp 6 btnWid/1.2 btnHt], ...
   'String','MEM Save', ...
   'Callback','imsim(''Savem3'')');
% %====================================
% % Buttons - Apply and Close
% ud.hApply=uicontrol(Btn, ...
%    'Position',[opleft fbot+frsp btnWid btnHt], ...
%    'String','Apply', ...
%    'Callback','imsim(''Apply'')');

%====================================
% Buttons - manual advance
% ud.hRev=uicontrol(Btn, ...
%    'Position',[512+framewid+4*spac fbot+4*(btnHt+frsp) btnWid/1.5 btnHt], ...
%    'String','<', ...
%    'Callback','imsim(''RevIm'')');
% ud.hFor=uicontrol(Btn, ...
%    'Position',[512+framewid+4*spac+btnWid/1.5+frsp fbot+4*(btnHt+frsp) btnWid/1.5 btnHt], ...
%    'String','>', ...
%    'Callback','imsim(''ForIm'')');
ud.hFor=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac fbot+4*(btnHt+frsp) btnWid*1.5 btnHt], ...
   'String','Browse Image Buffer', ...
   'Callback','imsim(''ForIm'')');
%====================================
% Buttons - clear memory
ud.hMemC=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac fbot+3*(btnHt+frsp) btnWid*1.5 btnHt], ...
   'String','Clear MEM Images', ...
   'Callback','imsim(''MemC'')');
ud.hAMemC=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac fbot+2*(btnHt+frsp) btnWid*1.5 btnHt], ...
   'String','Clear All Memory', ...
   'Callback','imsim(''AMemC'')');

%====================================
% Buttons - Apply for imaging
ud.hApplyIm=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac fbot+frsp btnWid btnHt], ...
   'String','Scan', ...
   'Callback','imsim(''ApplyIm'')');
ud.hClose=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac+btnWid+frsp fbot+frsp btnWid btnHt], ...
   'String','Close', ...
   'Callback','close(gcbf)');
ud.hCredit=uicontrol(Btn, ...
   'Position',[512+framewid+4*spac+2*btnWid+2*frsp fbot+frsp btnWid btnHt], ...
   'String','About', ...
   'Callback','imsim(''helpfunc'')');
ud.hSEhelp=uicontrol(Btn, ...
 'Position',[opleft+radioWid+frsp opbot+6*(radioHt+frsp)  btnWid/2 radioHt], ...
 'String','info', ...
 'Callback','imsim(''SEhelpfunc'')');
ud.hGREhelp=uicontrol(Btn, ...
 'Position',[opleft+radioWid+frsp opbot+3*(radioHt+frsp)  btnWid/2 radioHt], ...
 'String','info', ...
 'Callback','imsim(''GREhelpfunc'')');
ud.hIRhelp=uicontrol(Btn, ...
 'Position',[opleft+radioWid+frsp opbot+0.5*(radioHt+frsp)  btnWid/2 radioHt], ...
 'String','info', ...
 'Callback','imsim(''IRhelpfunc'')');
%====================================
% Status bar
ud.hStatus = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[spac+256 6 512 txtHt], ...
   'Foreground', [.8 0 0], ...
   'Background',wdcolor, ...
   'Horiz','center', ...
   'Tag', 'Status', ...
   'String','Initializing imsim...');
%====================================
% Imaging Time
ud.hImTime = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac rows-txtHt-5.5*spac-256  200 txtHt], ...
   'Foreground', [.8 0 0], ...
   'Background',wdcolor, ...
   'Horiz','left', ...
   'Tag', 'ImTime', ...
   'String','Imaging Time ');
%====================================
% SNR
ud.hSNR = uicontrol(Std, ...
   'Parent', ImSimFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[512+framewid+5*spac rows-txtHt-4.5*spac-256  200 txtHt], ...
   'Foreground', [.8 0 0], ...
   'Background',wdcolor, ...
   'Horiz','left', ...
   'Tag', 'SNR', ...
   'String','Gray Matter SNR ');
set(ImSimFig, 'UserData', ud,'Visible','on');
LoadNewImage(ImSimFig);
UpdateOperations(ImSimFig);
drawnow;
set(ImSimFig,'Pointer','arrow','HandleVisibility', 'Callback');
set([ ud.hClose ud.hSE] , 'enable', 'on');
set([ ud.hCredit] , 'enable', 'on');
set([ ud.hSEhelp ud.hGREhelp ud.hIRhelp] , 'enable', 'on');
set([ ud.hSave] , 'enable', 'on');
set([ ud.hSavem] , 'enable', 'on');
%set ([ud.hRev ud.hFor ud.hMemC ud.hAMemC], 'enable', 'on'); 
set ([ ud.hFor ud.hMemC ud.hAMemC], 'enable', 'on'); 
return
%%% 
%%%  Sub-Function - helpfunc
%%%
function helpfunc
% Credit String
str = sprintf(['Purpose:      MRI Simulation - An Educational Tool\n\n',...
   'Developed by: Eman Ghobrial Fall 2005\n\n',...
   'Under Guidelines of Dr. Richard Buxton\n\n',...
   'Data Set:     MNI\n\n',...
   '              url: http://www.bic.mni.mcgill.ca/brainweb/\n\n',...
   'EPI Distrotion Function: Created by Yansong Zhao, VUIIS. 09/15/2003\n\n',...
   'References:\n\n',...
   'Book:\n\n',...
   '  Introduction to Functional Magnetic Resonance Imaging\n\n',...
   '  Principles & Techniques, Richard B. Buxton\n\n',...
   'Papers:\n\n',...
   '  MRI Simulation-based Evaluation of Image-Processing and Classification Methods\n\n',...
   '  Remi K.-S. Kwan, Alan C. Evans, and G. Bruce Pike, IEEE Transcation on Medical Imaging, Nov 1999\n\n',...
   'Courses:\n\n',...
   '  SOMI276A, fMRI Foundation, Winter 2006, Dr. David Dubowitz\n',...
   '  BE280A, Principles of Biomedical Imaging, Fall 2005, Dr. Thomas Liu\n',]);
msgbox(str,'About MRI Simulator (imsim)','modal');
return
%%% 
%%%  Sub-Function - SEhelpfunc
%%%
function SEhelpfunc
% SE String
sehelpstr = sprintf (['    The Spin-Echo Sequence\n\n',...
   'One of the commonly used pulse squence.\n\n ',...
   'Here a 90 degree pulse is first applied to the spin system\n',...
   'The 90 degree pulse rotates the magnetization down into the X''Y'' plane.\n',...
   'The transverse magnetization begins to dephase.\n',...
   'At some point in time after the 90 degree pulse, a 180 degree pulse is applied.\n',...
   'This pulse rotates the magnetization by 180o about the X'' axis.\n',...
   'The 180 degree pulse causes the magnetization to at least partially\n',...
   'rephase and to produce a signal called an echo.\n',...
   '  \n',...
   'The signal equation for a repeated spin echo sequence \n',...
   'as a function of the repetition time TR, and the echo time (TE) defined as\n',...
   'the time between the 90 degree pulse and the maximum amplitude in the echo is\n',...
   '  \n',...
   'S se = M0 exp(-TE/T2) ( 1 - exp(-TR/T1) )  \n',...
   ' ']);
 msgbox(sehelpstr,'Spin Echo Pulse Sequence','modal');
return
%%% 
%%%  Sub-Function - GREhelpfunc
%%%
function GREhelpfunc
% GRE String
grehelpstr = sprintf (['           The Gradient-Echo Sequence\n\n',...
   '(alpha) - wait TE - measure - wait TR - TE \n ',...
   '  \n',...
   'The signal equation: \n',...
   'S gre = M0 exp(-TE/T2*) sin (alpha) 1-exp(-TR/T1)\1-cos (alpha) exp(-TR/T1)\n',...
   ' \n',...
   'Note that the transverse decay now depends on T2*, rather than T2\n',...
   'because there is no spin echo to refocus the effects of magnetic field inhomogenity\n',...
      ' ']);
msgbox(grehelpstr,'Gradient Echo Pulse Sequence','modal');
return
%%% 
%%%  Sub-Function - IRhelpfunc
%%%
function IRhelpfunc
% IR String
irhelpstr = sprintf (['           The Inversion Recovery Sequence\n\n',...
   '180 - wait TI-90 - wait TE/2 - 180 - wait TE/2 - measure - wait TR TI TE \n ',...
   '  \n',...
   'The initial 180 pulse acts as a preparation pulse modifying the longitudinal magnetization, and the   \n',...
   'transverse magnetization is not created until the 90 pulse is applied after the inversion time TI. \n',...
   'The second 180 pulse creates a spinecho of this transverse magnetization.  \n',...
   '  \n',...
   'The signal equation: \n',...
   'S ir = M0 exp(-TE/T2)  (1-2*exp(-TR/T1)+2*exp-(TR-TE/2)/T1 - exp(-TR/T1)\n',...
   ' \n',...
   'IR differs from SE in two ways:\n',...
   '1. More T1 weighted because the longitudinal magnetization has twice the range (-M0->M0)\n',...
   '2. There is a null point when the longitudinal magnetization relaxing from negative value, passes through Mz=0  \n',...
      ' ']);
msgbox(irhelpstr,'Gradient Echo Pulse Sequence','modal');
return
%%%
%%%  Sub-function - UpdateOperations
%%%
function UpdateOperations(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
%op = get(ud.hOpPop, 'Value');
 % Intensity Adjustment
   % Turn off histeq part
 %%% set(ud.hT, 'Visible', 'off');
   % Turn on imadjust part
   set([ud.hBrighten ud.hDarken ud.hIncrContr ud.hDecrContr], 'Enable', 'on');
   %set([ud.hAdjLineCtl ud.hAdjTopCtl ud.hAdjGammaCtl ud.hAdjBotCtl], 'Visible', 'on');
   % Set labels correctly
   %set(get(ud.hAdjustToolAxes, 'Title'), 'String', 'Output vs. Input Intensity');
   %set(get(ud.hAdjustedAxes, 'Title'), 'String', 'Adjusted Image');
  set(DemoFig,'Userdata',ud);
  InitializeAdjustmentTool(DemoFig);
 %  DoAdjust(DemoFig);
return
%%%
%%%  Sub-function - InitializeAdjustmentTool
%%%
function InitializeAdjustmentTool(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
img = get(ud.hOriginalImage, 'Cdata');
img = abs(img);
high = max(img(:)); 
low = min(img(:));
ud.LowHiBotTop = [low high 0 1];  % Actual Low,high,bot,top
ud.origimg=img;
set(DemoFig, 'UserData', ud);
return

function selcbk(source,eventdata)

oldval = get(eventdata.OldValue,'String')
newval =  get(eventdata.NewValue,'String')

% if nargin<1
%    callb = 1;    % We're in a callback
%    DemoFig = gcbf;
% else 
%    callb = 0;    % We're in the initialization
% end
  DemoFig = gcbf;
ud=get(DemoFig,'Userdata');
switch newval
    case 'SpinEcho'
        ud.signaleq='se';
    case 'GRadientEcho'
        ud.signaleq='ge';
    case 'InversionRecovery'
        ud.signaleq='ir';
end        
set([ ud.hApplyIm] , 'enable', 'on');
set(DemoFig,'Userdata',ud);
return

%%%
%%%  Sub-Function - LoadNewImage
%%%
function LoadNewImage(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
name='Proton density ';
%set(DemoFig,'Pointer','watch');
ud=get(DemoFig,'Userdata');
setstatus(DemoFig, [ name ' image...']);
drawnow;
%%%% get a density image
img=image_sim_se(17,3000,ud.gridopt,ud.epi);
img=img';
% filename='den_img.jpg';
% den_img=imread(filename,'JPEG');
% img=den_img;
 cmin = min(img(:));
cmax = max(img(:));
 set (ud.hOriginalAxes,'CLim', [cmin cmax]);
set(ud.hOriginalImage, 'Cdata', img);
%set(DemoFig,'Pointer','fullcrosshair');
drawnow;
if callb
   setstatus(DemoFig, '');
end
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - ApplyEPI
%%%

function ApplyEPI(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
if (get(ud.hEPI,'Value')==get(ud.hEPI,'Max'))
    ud.epi='onn';
else
    ud.epi='off';
end    
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - ApplyEPI
%%%

function ApplyGRID(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
if (get(ud.hGRID,'Value')==get(ud.hGRID,'Max'))
    ud.gridopt='onn';
else
    ud.gridopt='off';
end    
set(DemoFig,'Userdata',ud);
return


function Applygauss(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
if (get(ud.hgauss,'Value')==get(ud.hgauss,'Max'))
    ud.gaussopt='onn';
else
    ud.gaussopt='off';
end    
set(DemoFig,'Userdata',ud);
return

% %%% 
% %%%  Sub-Function - UpdateApply
% %%%
% 
% function UpdateApply(DemoFig)
% 
% if nargin<1
%    callb = 1;    % We're in a callback
%    DemoFig = gcbf;
% else 
%    callb = 0;    % We're in the initialization
% end
% ud=get(DemoFig,'Userdata');
% ud.signaleq='se';
% set([ ud.hApplyIm] , 'enable', 'on');
% %setstatus(DemoFig, ['Adjust TE and TR and press apply...']);
% set(DemoFig,'Userdata',ud);
% return



%%% 
%%%  Sub-Function - SaveIm
%%%

function SaveIm1

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
fname='magim';
ext='raw';
signal=ud.signaleq;
if (signal == 'ge')
    te = ud.grete;
    tr = ud.gretr;
    fa = ud.grefa;
    sg = sprintf('GREfa%d',fa);
elseif (signal == 'se')
    te = ud.sete;
    tr = ud.setr;
    sg = 'SE';
    else 
    te = ud.irte;
    tr = ud.irtr;
    ti = ud.irti;
    sg = sprintf('IRti%d',ti);
    end    
filename=sprintf('%s%ste%dtr%d_%02d.%s',fname,sg,te,tr,ud.imc,ext)
        img = get(ud.hOriginalImage, 'Cdata');
%         signal=ud.signaleq;
%         if (signal == 'ge')
%           img=img*10;
%         end  
%         means=mean(mean(img));
%         if (means > 1.0)
%             img = img/10;
%         end    
%           maxi=max(max(img));
%         img = (img/maxi)*255;
 %       imwrite(img,filename,'JPEG');
 fid=fopen(filename,'wb');
fwrite(fid,img','float32');
fclose(fid);
ud.imc = ud.imc+1;
set(DemoFig,'Userdata',ud);
return


%%% 
%%%  Sub-Function - SaveIm2
%%%

function SaveIm2

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
fname='corim';
ext='raw';
signal=ud.signaleq;
if (signal == 'ge')
    te = ud.grete;
    tr = ud.gretr;
    fa = ud.grefa;
    sg = sprintf('GREfa%d',fa);
elseif (signal == 'se')
    te = ud.sete;
    tr = ud.setr;
    sg = 'SE';
    else 
    te = ud.irte;
    tr = ud.irtr;
    ti = ud.irti;
    sg = sprintf('IRti%d',ti);
    end    
filename=sprintf('%s%ste%dtr%d_%02d.%s',fname,sg,te,tr,ud.imc,ext)
        img = get(ud.hDistImage, 'Cdata');
        signal=ud.signaleq;
%         maxi=max(max(img));
%         img = floor((img/maxi)*255);
% %         if (signal == 'ge')
% %          img=img*10;
% %         end 
% %          if (means > 1.0)
% %             img = img/10;
% %         end  
      % imwrite(img,filename,'JPEG','Mode','lossless','Bitdepth',16);
     
fid=fopen(filename,'wb');
fwrite(fid,img','float32');
fclose(fid);
ud.imc = ud.imc+1;
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - SaveIm3
%%%

function SaveIm3

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
fname='phaseimage';
ext='raw';
filename=sprintf('%s%02d.%s',fname,ud.imc,ext)
        img = get(ud.hOriginalPhaseImage, 'Cdata');
   %     img=img*10;
%          if (means > 1.0)
%             img = img/10;
%         end  
  %      imwrite(img,filename,'JPEG');
  fid=fopen(filename,'wb');
fwrite(fid,img','float32');
fclose(fid);
ud.imc = ud.imc+1;
set(DemoFig,'Userdata',ud);
return

% %%% 
% %%%  Sub-Function - UpdateApplyGRE
% %%%
% 
% function UpdateApplyGRE(DemoFig)
% 
% if nargin<1
%    callb = 1;    % We're in a callback
%    DemoFig = gcbf;
% else 
%    callb = 0;    % We're in the initialization
% end
% ud=get(DemoFig,'Userdata');
% ud.signaleq='ge'; 
% %setstatus(DemoFig, ['Adjust TE, TR and FA and press apply...']);
% set([ ud.hApplyIm] , 'enable', 'on');
% set(DemoFig,'Userdata',ud);
% return


% %%% 
% %%%  Sub-Function - UpdateApplyIR
% %%%
% 
% function UpdateApplyIR(DemoFig)
% 
% if nargin<1
%    callb = 1;    % We're in a callback
%    DemoFig = gcbf;
% else 
%    callb = 0;    % We're in the initialization
% end
% ud=get(DemoFig,'Userdata');
% ud.signaleq='ir'; 
% %setstatus(DemoFig, ['Adjust TE, TR and TI and press apply...']);
% set([ ud.hApplyIm] , 'enable', 'on');
% set(DemoFig,'Userdata',ud);
% return

%%%
%%%  Sub-Function - UpdateSETE
%%%

function UpdateSETE(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end

ud = get(DemoFig, 'UserData');
setestr = get(ud.hSETEEdit, 'String');
sete = str2double(setestr);

if isempty(sete) | sete(1)<0 
   errordlg('TE must be a number greater than 0.');
else   
   ud.sete=sete(1);
   set(DemoFig, 'UserData', ud);
%   BtnMotion(5);  % Redraw
   %DoAdjust(DemoFig);
end
set(ud.hSETEEdit, 'String', ud.sete);
return

%%%
%%%  Sub-Function - UpdateSETR
%%%
function UpdateSETR(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
setrstr = get(ud.hSETREdit, 'String');
setr = str2double(setrstr);
if isempty(setr) | setr(1)<0 
   errordlg('TR must be a number greater than 0.0');
elseif setr<ud.sete
     errordlg('TR must be a number greater than TE');   
else   
   ud.setr=setr(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hSETREdit, 'String', ud.setr);
return

%%%
%%%  Sub-Function - UpdateGRETE
%%%
function UpdateGRETE(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
gretestr = get(ud.hGRETEEdit, 'String');
grete = str2double(gretestr);
if isempty(grete) | grete(1)<0 
   errordlg('TE must be a number greater than 0.');
else   
   ud.grete=grete(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hGRETEEdit, 'String', ud.grete);
return

%%%
%%%  Sub-Function - UpdateGRETR
%%%
function UpdateGRETR(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
gretrstr = get(ud.hGRETREdit, 'String');
gretr = str2double(gretrstr);
if isempty(gretr) | gretr(1)<0 
   errordlg('TR must be a number greater than 0.0');
elseif gretr<ud.grete
     errordlg('TR must be a number greater than TE');   
else   
   ud.gretr=gretr(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hGRETREdit, 'String', ud.gretr);
return

%%%
%%%  Sub-Function - UpdateGREFA
%%%
function UpdateGREFA(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
grefastr = get(ud.hGREFAEdit, 'String');
grefa = str2double(grefastr);
if isempty(grefa) | grefa(1)<0 
   errordlg('FA must be a number greater than 0.');
else   
   ud.grefa=grefa(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hGREFAEdit, 'String', ud.grefa);
return

%%%
%%%  Sub-Function - UpdateIRTE
%%%
function UpdateIRTE(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
irtestr = get(ud.hIRTEEdit, 'String');
irte = str2double(irtestr);
if isempty(irte) | irte(1)<0 
   errordlg('TE must be a number greater than 0.');
else   
   ud.irte=irte(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hIRTEEdit, 'String', ud.irte);
return

%%%
%%%  Sub-Function - UpdateIRTR
%%%
function UpdateIRTR(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
irtrstr = get(ud.hIRTREdit, 'String');
irtr = str2double(irtrstr);
if isempty(irtr) | irtr(1)<0 
   errordlg('TR must be a number greater than 0.');
elseif irtr<ud.irte
     errordlg('TR must be a number greater than TE');   
else   
   ud.irtr=irtr(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hIRTREdit, 'String', ud.irtr);
return

%%%
%%%  Sub-Function - UpdateIRTI
%%%
function UpdateIRTI(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
irtistr = get(ud.hIRTIEdit, 'String');
irti = str2double(irtistr);
if isempty(irti) | irti(1)<0 
   errordlg('FA must be a number greater than 0.');
else   
   ud.irti=irti(1);
   set(DemoFig, 'UserData', ud);
end
set(ud.hIRTIEdit, 'String', ud.irti);
return

%%%
%%%  Sub-Function - DoAdjust
%%%
function DoAdjust(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
setptr(DemoFig, 'watch');
setstatus(DemoFig, 'Adjusting image ...');
ud = get(DemoFig, 'UserData');
low = max(0.0,ud.LowHiBotTop(1));
high = min(1.0,ud.LowHiBotTop(2));
bot = max(0.0,ud.LowHiBotTop(3));
top = min(1.0,ud.LowHiBotTop(4));
if( abs(high-low)<eps )  % Protect imadjust against divide by 0
   high = low+.0001;
end
img = ud.origimg;
imgAd = imadjust(img, [low;high],[bot;top],1);
cmin = min(imgAd(:));
cmax = max(imgAd(:));
%set (ud.hOriginalAxes,'CLim', [cmin cmax]);
set(ud.hOriginalImage, 'Cdata', imgAd);
setstatus(DemoFig, '');
setptr(DemoFig, 'arrow');
drawnow;
return

%%% 
%%%  Sub-Function - IncreaseBrightness
%%%
function IncreaseBrightness
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
% img = get(ud.hOriginalImage, 'Cdata');
%  img = abs(img);
%  high = max(img(:)); low = min(img(:));
%ud.LowHiBotTop = [low high 0 1];  % Actual Low,high,bot,top
low = ud.LowHiBotTop(1);
high = ud.LowHiBotTop(2);
bot = ud.LowHiBotTop(3);
top = ud.LowHiBotTop(4);
bot=0;
top=1;
change = .1;
% Don't shift the whole line out of the axes range:
if top>=bot
   if (bot+change > 1)
      return     % Don't make it any brighter
   end
else
   if (top+change > 1)
      return     % Don't make it any brighter
   end
end   
top = top + change;
bot = bot + change;
ud.LowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust(DemoFig);
return

%%% 
%%%  Sub-Function - DecreaseBrightness
%%%
function DecreaseBrightness
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
low = ud.LowHiBotTop(1);
high = ud.LowHiBotTop(2);
bot = ud.LowHiBotTop(3);
top = ud.LowHiBotTop(4);
change = .1;
% Don't shift the whole line out of the axes range:
if top>=bot
   if (top-change < 0)   
      return  % Don't make it any darker
   end
else
   if (bot-change < 0)
      return  % Don't make it any darker
   end
end
top = top - change;
bot = bot - change;
ud.LowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust(DemoFig);
return

%%% 
%%%  Sub-Function - IncreaseContrast
%%%
function IncreaseContrast
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
low = ud.LowHiBotTop(1);
high = ud.LowHiBotTop(2);
bot = ud.LowHiBotTop(3);
top = ud.LowHiBotTop(4);
change = .1*(high-low);
low = low + change;
high = high - change;
ud.LowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust(DemoFig);
return

%%% 
%%%  Sub-Function - DecreaseContrast
%%%
function DecreaseContrast
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
low = ud.LowHiBotTop(1);
high = ud.LowHiBotTop(2);
bot = ud.LowHiBotTop(3);
top = ud.LowHiBotTop(4);
change = .1*(high-low);
low = max(low - change,0);
high = min(high + change,1);
ud.LowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust(DemoFig);
return

%%%
%%%  Sub-function - Initialimaging
%%%
function Initialimaging(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
imgc = get(ud.hDistImage, 'Cdata');
imgc = abs(imgc);
high = max(imgc(:)); low = min(imgc(:));
ud.LowHiBotTop1 = [low high 0 1];  % Actual Low,high,bot,top
ud.corimg=imgc;
set(DemoFig, 'UserData', ud);
set([ud.hBrighten1 ud.hDarken1 ud.hIncrContr1 ud.hDecrContr1], 'Enable', 'on');
set([ ud.hSave2] , 'enable', 'on');
set([ ud.hSavem2] , 'enable', 'on');
return

%%%
%%%  Sub-Function - DoAdjust1
%%%
function DoAdjust1(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
setptr(DemoFig, 'watch');
setstatus(DemoFig, 'Adjusting image ...');
ud = get(DemoFig, 'UserData');
low = max(0.0,ud.LowHiBotTop1(1));
high = min(1.0,ud.LowHiBotTop1(2));
bot = max(0.0,ud.LowHiBotTop1(3));
top = min(1.0,ud.LowHiBotTop1(4));
if( abs(high-low)<eps )  % Protect imadjust against divide by 0
   high = low+.0001;
end
%img = get(ud.hDistImage, 'Cdata');
imgc=ud.corimg;
imgAd = imadjust(imgc, [low;high],[bot;top],1);
cmin = min(imgAd(:));
cmax = max(imgAd(:));
%set (ud.hDistAxes,'CLim', [cmin cmax]);
set(ud.hDistImage, 'Cdata', imgAd);
setstatus(DemoFig, '');
setptr(DemoFig, 'arrow');
return


%%% 
%%%  Sub-Function - IncreaseBrightness1
%%%
function IncreaseBrightness1
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
% img = get(ud.hDistImage, 'Cdata');
% img = abs(img);
% high = max(img(:)); low = min(img(:));
% ud.LowHiBotTop1 = [low high 0 1]  % Actual Low,high,bot,top
ud = get(DemoFig, 'UserData');
img = get(ud.hDistImage, 'Cdata');
img = abs(img);
high = max(img(:)); low = min(img(:));
ud.LowHiBotTop1 = [low high 0 1];  % Actual Low,high,bot,top
low = ud.LowHiBotTop1(1);
high = ud.LowHiBotTop1(2);
bot = ud.LowHiBotTop1(3);
top = ud.LowHiBotTop1(4);
change = .1;
% Don't shift the whole line out of the axes range:
if top>=bot
   if (bot+change > 1)
      return     % Don't make it any brighter
   end
else
   if (top+change > 1)
      return     % Don't make it any brighter
   end
end   
top = top + change;
bot = bot + change;
ud.LowHiBotTop1 = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust1(DemoFig);
return


%%% 
%%%  Sub-Function - DecreaseBrightness1
%%%
function DecreaseBrightness1

DemoFig = gcbf;
% img = get(ud.hDistImage, 'Cdata');
% img = abs(img);
% high = max(img(:)); low = min(img(:));
% ud.LowHiBotTop1 = [low high 0 1]  % Actual Low,high,bot,top
ud = get(DemoFig, 'UserData');
img = get(ud.hDistImage, 'Cdata');
img = abs(img);
high = max(img(:)); low = min(img(:));
ud.LowHiBotTop1 = [low high 0 1];  % Actual Low,high,bot,top
low = ud.LowHiBotTop1(1);
high = ud.LowHiBotTop1(2);
bot = ud.LowHiBotTop1(3);
top = ud.LowHiBotTop1(4);
change = .1;
% Don't shift the whole line out of the axes range:
if top>=bot
   if (top-change < 0)   
      return  % Don't make it any darker
   end
else
   if (bot-change < 0)
      return  % Don't make it any darker
   end
end
top = top - change;
bot = bot - change;
ud.LowHiBotTop1 = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust1(DemoFig);
return

%%% 
%%%  Sub-Function - IncreaseContrast1
%%%
function IncreaseContrast1
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
img = get(ud.hDistImage, 'Cdata');
img = abs(img);
high = max(img(:)); low = min(img(:));
ud.LowHiBotTop1 = [low high 0 1];  % Actual Low,high,bot,top
low = ud.LowHiBotTop1(1);
high = ud.LowHiBotTop1(2);
bot = ud.LowHiBotTop1(3);
top = ud.LowHiBotTop1(4);
change = .1*(high-low);
low = low + change;
high = high - change;
ud.LowHiBotTop1 = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust1(DemoFig);
return

%%% 
%%%  Sub-Function - DecreaseContrast1
%%%
function DecreaseContrast1
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
img = get(ud.hDistImage, 'Cdata');
img = abs(img);
high = max(img(:)); low = min(img(:));
ud.LowHiBotTop1 = [low high 0 1];  % Actual Low,high,bot,top
low = ud.LowHiBotTop1(1);
high = ud.LowHiBotTop1(2);
bot = ud.LowHiBotTop1(3);
top = ud.LowHiBotTop1(4);
change = .1*(high-low);
low = max(low - change,0);
high = min(high + change,1);
ud.LowHiBotTop1 = [low high bot top];
set(DemoFig, 'UserData', ud);
DoAdjust1(DemoFig);
return

%%% 
%%%  Sub-Function - SetMat
%%%
function SetMat
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
mat = get(ud.hImgPop, 'Value');
switch mat
    case 1
      ud.matrix=256; 
    case 2
      ud.matrix=128;  
    case 3
      ud.matrix=64;
end
set(DemoFig,'UserData',ud);
return

%%% 
%%%  Sub-Function - SetNoise
%%%
function SetNoise
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
noise = get(ud.hNoisePop, 'Value');
switch noise 
    case 1
      ud.noise=1;  
    case 2
      ud.noise=2;  
    case 3
      ud.noise=3;
    case 4
      ud.noise=4;  
    case 5
      ud.noise=5; 
    case 6
        ud.noise=20;
    case 7
        ud.noise=100;
    case 8
        ud.noise=1000;    
end
set(DemoFig,'UserData',ud);
return

%%% 
%%%  Sub-Function - SetTesla
%%%
function SetTesla
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
t = get(ud.hTeslaPop, 'Value');
switch t
    case 1
      ud.tesla=1.5;  
    case 2
      ud.tesla=3.0;  
    case 3
      ud.tesla=7.0;
 end
set(DemoFig,'UserData',ud);
return

%%% 
%%%  Sub-Function - SetBW
%%%
function SetBW
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
b = get(ud.hBWPop, 'Value');
switch b
    case 1
       ud.BW=31.25;
    case 2
      ud.BW=62.5;  
    case 3
      ud.BW=125.0;  
    case 4
      ud.BW=250.0;
 end
set(DemoFig,'UserData',ud);
return
%%% 
%%%  Sub-Function - SetFreqEncode
%%%
function SetFreqEncode
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
freq = get(ud.hFreqEncodePop, 'Value');
switch freq
    case 1
      ud.freqen='rl'; 
    case 2
      ud.freqen='ap'; 
    end
set(DemoFig,'UserData',ud);
SetPhaseFinal(DemoFig);
return
%%% 
%%%  Sub-Function - SetPhaseEncode
%%%
function SetPhaseEncode
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
phase = get(ud.hPhaseEncodePop, 'Value');
switch phase
    case 1
      ud.phaseen='tb'; 
    case 2
      ud.phaseen='bt'; 
    end
set(DemoFig,'UserData',ud);
SetPhaseFinal(DemoFig);
return


%%% 
%%%  Sub-Function - SetPhaseFinal
%%%
function SetPhaseFinal(DemoFig)
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud = get(DemoFig, 'UserData');
freqen = ud.freqen;
phaseen = ud.phaseen;
switch freqen
    case 'rl'
        switch phaseen
            case 'tb'
                ud.phasencode='ypm'; 
            case 'bt'    
                ud.phasencode='ymp'; 
        end       
    case 'ap'
      switch phaseen
        case 'tb'
          ud.phasencode='xmp';
        case 'bt'
          ud.phasencode='xpm';  
      end    
end
set(DemoFig,'UserData',ud);
return

%%% 
%%%  Sub-Function - ApplyIm
%%%
function ApplyIm(DemoFig)
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
mat=ud.matrix;
switch mat
    case 256
        ud.matrix=256;
        ud.magicn=1;
        ud.iscale=1;
    case 128
        ud.matrix=128;
        ud.magicn=64;
        ud.iscale=2;
    case 64
        ud.matrix=64;
        ud.magicn=96;
         ud.iscale=4;
end
set(DemoFig, 'UserData', ud);
UpdateImaging(DemoFig);
return

%%% 
%%%  Sub-Function - UpdateImaging
%%%
function UpdateImaging(DemoFig)
DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
magicn=ud.magicn;
noise=ud.noise;
matrix=ud.matrix;
bw=ud.BW;
phasencode=ud.phasencode;
b0=ud.tesla;
switch ud.signaleq
    case 'se' 
        [img gray_pix]=image_sim_se(ud.sete,ud.setr,ud.gridopt,ud.epi);
        img=abs(img');
        cmin = min(img(:));
		cmax = max(img(:));
        ud.magmin=cmin;
        ud.magmax=cmax;
		set (ud.hOriginalAxes,'CLim', [cmin cmax]);
        set(ud.hOriginalImage, 'Cdata', img);
         
        %ud.origimg=img;
        phase=zeros(256,256);
        set(ud.hOriginalPhaseImage,'Cdata',phase);
        %set(DemoFig,'Pointer','fullcrosshair');
        drawnow;
    %    set([ud.hSE],'value',0);
       % set([ ud.hApply] , 'enable', 'off');
 text1=sprintf('Sim for SE TE: %2d TR: %4d ',ud.sete,ud.setr);
       setstatus(DemoFig, [text1]);
       mag=get(ud.hOriginalImage, 'Cdata');
phase=get(ud.hOriginalPhaseImage, 'Cdata');
set([ ud.hSave3] , 'enable', 'on');
set([ ud.hSavem3] , 'enable', 'on');
[imga imgb imsnr] = get_dist_se(mag,phase,magicn,noise,matrix,bw,b0,phasencode,ud.epi,gray_pix,ud.gaussopt);
   if  (ud.epi=='off')
       imtime=ud.setr*matrix*noise;
       text2=sprintf('Imaging Time: %4.4f sec',imtime/1000);
   else
       imtime=ud.setr*matrix*128;
       text2=sprintf('Imaging Time: very short');
   end
      text3=sprintf('Gray Matter SNR: %4.4f % of max signal',imsnr);
    set([ud.hImTime],'String', [text2]);
    set([ud.hSNR],'String', [text3]);
    

    case 'ge'
        [img gray_pix]=image_sim_gre(ud.grete,ud.gretr,ud.grefa,ud.gridopt,ud.epi);
        img=abs(img');
        %ud.memmag=img;
        cmin = min(img(:));
		cmax = max(img(:));
        ud.magmin=cmin;
        ud.magmax=cmax;
		set (ud.hOriginalAxes,'CLim', [cmin cmax]);
        set(ud.hOriginalImage, 'Cdata', img);
       % ud.origimg=img;
        %matrix=ud.matrix;
        phase=create_phase(256,ud.grete,ud.r,ud.tesla);
        ud.memphase=phase;
        %set(DemoFig,'Pointer','fullcrosshair');
        cmin = min(phase(:));
		cmax = max(phase(:));
		set (ud.hOriginalPhaseAxes,'CLim', [cmin cmax]);
        set(ud.hOriginalPhaseImage,'Cdata',phase);
       drawnow;
     %    set([ud.hGRE],'value',0);
        text1=sprintf('Sim for GRE TE: %2d TR: %4d FA: %2d',ud.grete,ud.gretr,ud.grefa);
        setstatus(DemoFig, [text1]);
        mag=img;
%         mag=get(ud.hOriginalImage, 'Cdata');
%         phase=get(ud.hOriginalPhaseImage, 'Cdata');
set([ ud.hSave3] , 'enable', 'on');
set([ ud.hSavem3] , 'enable', 'on');
[imga imgb imsnr] = get_dist_gre(mag,phase,magicn,noise,matrix,bw,b0,phasencode,ud.epi,gray_pix,ud.gaussopt); 
ud.memcormag=imga;
   if  (ud.epi=='off')
       imtime=ud.gretr*matrix*noise;
       text2=sprintf('Imaging Time: %4.4f sec',imtime/1000);
   else
     %  imtime=ud.gretr*matrix*128;
       text2=sprintf('Imaging Time: very short');
   end
   text3=sprintf('Gray Matter SNR: %4.4f % of max signal',imsnr);
    set([ud.hImTime],'String', [text2]);
    set([ud.hSNR],'String', [text3]);
    case  'ir'
        [img gray_pix]=image_sim_ir(ud.irte,ud.irtr,ud.irti,ud.gridopt,ud.epi);
        img=abs(img');
        cmin = min(img(:));
		cmax = max(img(:));
        ud.magmin=cmin;
        ud.magmax=cmax;
        set (ud.hOriginalAxes,'CLim', [cmin cmax]);
        set(ud.hOriginalImage, 'CData', img);
        %set(DemoFig,'Pointer','fullcrosshair');
        phase=zeros(256,256);
        set(ud.hOriginalPhaseImage,'Cdata',phase);
        drawnow;
      %   set([ud.hIR],'value',0);
         text1=sprintf('Sim for IR TE: %2d TR: %4d TI: %2d',ud.irte,ud.irtr,ud.irti);
        setstatus(DemoFig, [text1]);
        mag=get(ud.hOriginalImage, 'Cdata');
        phase=get(ud.hOriginalPhaseImage, 'Cdata');
        set([ ud.hSave3] , 'enable', 'on');
set([ ud.hSavem3] , 'enable', 'on');
       [imga imgb imsnr] = get_dist_ir(mag,phase,magicn,noise,matrix,bw,b0,phasencode,ud.epi,gray_pix,ud.gaussopt);   
       if  (ud.epi=='off')
       imtime=ud.irtr*matrix*noise;
       text2=sprintf('Imaging Time: %4.4f sec',imtime/1000);
   else
      % imtime=ud.setr*matrix*128;
         text2=sprintf('Imaging Time: very short');
       %text2=sprintf('Imaging Time: %4.4f sec',imtime/1000);
   end
   text3=sprintf('Gray Matter SNR: %4d % of max signal',imsnr);
    set([ud.hImTime],'String', [text2]);
    set([ud.hSNR],'String', [text3]);
%     case 'epise' 
%        [imga imgb] = get_dist_se_epi(mag,phase,magicn,noise,matrix,bw,b0,phasencode);
%     case 'epigre'
%        [imga imgb] = get_dist_gre_epi(mag,phase,magicn,noise,matrix,bw,b0,phasencode);    
end       
%imga=imresize(imga,ud.iscale);
% cmin = min(imga(:));
% cmax = max(imga(:));
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistAxes,'CLim', [cmin cmax]);
set(ud.hDistImage, 'Cdata', imga);

%imgb=imresize(imgb,ud.iscale);
cmin = min(imgb(:));
cmax = max(imgb(:));
%set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
%set(ud.hDistPhaseImage, 'Cdata', imgb);
set(DemoFig, 'UserData', ud);
InitializeAdjustmentTool(DemoFig);
Initialimaging(DemoFig);
   drawnow;
return
        
%%% 
%%%  Sub-Function - Savem1
%%%
function Savem1
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
counter=ud.mni;
if (counter > 15)
   errordlg(' Cannot save more than 15 images in memory');
else    
    img = get(ud.hOriginalImage, 'Cdata');
    ud.memimages(:,:,counter)=img;
  %  ud.memimages(:,:,counter)=ud.memmag;
    size(ud.memimages);
    ud.mni = ud.mni+1;
    ud.mc=ud.mc+1;
end 
imga(:,:)=ud.memimages(:,:,ud.mni-1);
% cmin = min(imga(:));
% cmax = max(imga(:));
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
set(ud.hDistPhaseImage,'Cdata',imga);
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - Savem2
%%%
function Savem2
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
counter=ud.mni;
if (counter > 15)
   errordlg(' Cannot save more than 15 images in memory');
else    
    img = get(ud.hDistImage, 'Cdata');
    ud.memimages(:,:,counter)=img;
   %ud.memimages(:,:,counter)=ud.memcormag;
    ud.mni = ud.mni+1;
    ud.mc=ud.mc+1;
end 
imga(:,:)=ud.memimages(:,:,ud.mni-1);
% cmin = min(imga(:));
% cmax = max(imga(:));
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
set(ud.hDistPhaseImage,'Cdata',imga);
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - Savem3
%%%
function Savem3
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
counter=ud.mni;
if (counter > 15)
   errordlg(' Cannot save more than 15 images in memory');
else    
    img = get(ud.hOriginalPhaseImage, 'Cdata');
    ud.memimages(:,:,counter)=img;
%    ud.memimages(:,:,counter)=ud.memphase;
    ud.mni = ud.mni+1;
      ud.mc=ud.mc+1;
end 
imga(:,:)=ud.memimages(:,:,ud.mni-1);
% cmin = min(imga(:));
% cmax = max(imga(:));
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
set(ud.hDistPhaseImage,'Cdata',imga);
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - RevIm
%%%
function RevIm
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
mni=ud.mni;
counter=ud.mc;
if (counter < 1) 
    ud.mc=mni;
    counter=mni;
   imga(:,:) = ud.memimages(:,:,counter);
%errordlg(' last image in memory');
else 
      imga(:,:) = ud.memimages(:,:,counter);
      ud.mc = ud.mc-1;
end
% cmin = min(imga(:))
% cmax = max(imga(:))
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
set(ud.hDistPhaseImage,'Cdata',imga);
set(DemoFig,'Userdata',ud);

% if (counter > 15)
%    errordlg(' Cannot save more than 15 images in memory');
% else    
%     img = get(ud.hOriginalPhaseImage, 'Cdata');
%     ud.memimages(:,:,counter)=img;
%     ud.mc = ud.mc+1;
%     set(DemoFig,'Userdata',ud);
% end 
return

%%% 
%%%  Sub-Function - ForIm
%%%
function ForIm
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
counter=ud.mc+1;
mni=ud.mni;
if (counter == 15) 
   imga(:,:) = ud.memimages(:,:,counter);
errordlg(' last image in memory');
elseif (counter == mni)
        ud.mc=1;
        counter = 1;
         imga(:,:) = ud.memimages(:,:,counter);
else        
      imga(:,:) = ud.memimages(:,:,counter);
        ud.mc = ud.mc+1;
end
% cmin = min(imga(:))
% cmax = max(imga(:))
cmin=ud.magmin;
cmax=ud.magmax;
set (ud.hDistPhaseAxes,'CLim', [cmin cmax]);
set(ud.hDistPhaseImage,'Cdata',imga);
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - Image Memory Clear
%%%
function MemC
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
ud.mc=0;
ud.mni=1;
ud.memimages=zeros(256,256,15);
set(DemoFig,'Userdata',ud);
return

%%% 
%%%  Sub-Function - Image Memory Clear
%%%
function AMemC
if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end
ud=get(DemoFig,'Userdata');
clear b0 bw cmax cmin gray_pix img imga imgb imsnr imtime mag magicn matrix noise phase phasencode;
set(DemoFig,'Userdata',ud);
return