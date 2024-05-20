pro poten_sheffield,nz,aa,bz,pbx,pby,pbz
;
;+
; NAME:
;	FFF
;
; PURPOSE:
;	Extropolate  the 3-D field  above the photosphere by means of the 
;       constant alpha field model. The observed longitudinal magnetic field 
;       is taken as boundary conditions.
;               
; CATEGORY:
;	numerical caculation.
;
; CALLING SEQUENCE:
;	TFIELD, NZ,AA
;
; INPUTS:
;
; The observed longitudinal magnetic field 
; KEYWORD INPUT PARAMETERS:
;	NZ:	The height above the photosphere.  
;
;	AA:	The force free factor
;
;
; OUTPUTS:
;	The extropolated 3-D magnetic field.
;
; COMMON BLOCKS:
;	None.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	Straightforward.  Unrecognized keywords are passed to the PLOT
;	procedure.  
; NOTE: The value of nz should be small (1-10).
;
; MODIFICATION HISTORY:
;	Marianna
;-
;

s=size(bz)
sx=s(1)
sy=s(2)
i=complex(0,1)
sub=lindgen(sx,sy)
n=sub/sx
m=sub-n*sx

fct=aa
;_____________________calculating free field

zx=1.
zy=1.

bfft=fft(bz,1)
k1=2.0*!pi/float(sx)
k2=2.0*!pi/float(sy)

kk=(sin(k1*m)/zx)^2+(sin(k2*n)/zy)^2-fct*fct/4

ssign=((kk gt 0)-0.5)*2
kk=ssign*kk
ssi=(ssign eq 1)+i*(ssign eq -1)
k=i*ssi*sqrt(kk)


zk=-exp(i*k*nz)
fm=(sin(k1*m)/zx)^2+(sin(k2*n)/zy)^2+0.00000001
bxfft=zk*(-bfft*k*sin(k1*m)/zx+i*bfft*fct*sin(k2*n))/fm
byfft=zk*(-bfft*k*sin(k2*n)/zy-i*bfft*fct*sin(k1*m)/(2*zx))/fm
bzfft=-zk*bfft

bbx=fft(bxfft,-1)
bby=fft(byfft,-1)
bbz=fft(bzfft,-1)

pbx=long(bbx)
pby=(-1)*long(bby)
pbz=long(bbz)


;bxy=sqrt(bx^2+by^2)
;bxymax=max(bxy)
;bco=pbx*bx+pby*by
;ssign=((bco gt 0.0)-0.5)*2
;bx=ssign*bx
;by=ssign*by
;bx=pbx
;by=pby

end

