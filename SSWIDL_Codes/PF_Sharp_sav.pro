; Created by Marianna Korsos 1st of November, 2020
; Adopted by Shreeyesh Biswal, Feb 01, 2021


pro PF_Sharp_sav, dir


  ;==input=====================

  t0=systime(/s)
  
  if n_elements(dir) eq 0 then dir='/home/shreeyeshbiswal/IDLWorkspace/Dataset_PF/AR_11158/2011.02.15_00:00:00_TAI/'
  cd, dir
  x = strmid(dir,55,23) + '.sav'
  
  files=file_search(dir+'*.Br.fits',count=nf)
  print, files
  for i=0,nf-1 do begin
    name_time=strmid(files[i],strlen(files[i])-50,39)
    brfile=findfile(dir+'/*.Br.fits')
    bpfile=findfile(dir+'/*.Bp.fits')
    btfile=findfile(dir+'/*.Bt.fits')
    read_sdo,brfile[i],indexf,dataf,/uncomp_delete
    read_sdo,bpfile[i],indexa,dataa,/uncomp_delete
    read_sdo,btfile[i],indexi,datai,/uncomp_delete

    help,dataf,datai,dataa
    print,max(dataf),min(dataf)
    print,max(datai),min(datai)
    print,max(dataa),min(dataa)

    bx=dataa
    by=datai
    bz=dataf
    
    print, 'size: ', size(bz, /dimensions)
    zdim = size(bz, /dimensions)            ; for ex. 733 x 382
    e1 = zdim[0]                            ; 733
    e2 = zdim[1]                            ; 382
    e3 = 10                                 ; znn runs from 0 to 9; so e3 = znn+1 (end of for loop -> znn = 9)
    Datacube_3vec = fltarr(3, e1, e2, e3)
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    bl=bz


    alph=0.

    for znn = 0.,9.,1. do begin
      
      poten_sheffield,znn,alph,bl,pbx,pby,pbz

      ;tvscl, congrid(pbz,ss(1)/2.,ss(2)/2.)>(-255)<255

      writefits,name_time+strcompress(string(alph))+strcompress(string(znn))+'_pbx.fits',pbx
      writefits,name_time+strcompress(string(alph))+strcompress(string(znn))+'_pby.fits',pby
      writefits,name_time+strcompress(string(alph))+strcompress(string(znn))+'_pbz.fits',pbz
      print,'output 3dfield data:',name_time+strcompress(string(alph))+strcompress(string(znn))+'*.fits','  saved!'
      Datacube_3vec[0,*,*,znn] = pbx
      Datacube_3vec[1,*,*,znn] = pby
      Datacube_3vec[2,*,*,znn] = pbz

    endfor
    
    ;Datacube = dblarr(bx, by, bz, znn)     ; original code
    ;Datacube_x = dblarr(bx, znn)
    ;Datacube_y = dblarr(by, znn)
    ;save, Datacube, filename = 'AR.sav'    ; original code
    ;save, Datacube_x, filename = 'AR_x.sav'
    ;save, Datacube_y, filename = 'AR_y.sav'
    
    
    
    save, Datacube_3vec, filename = x

  endfor
  t3=systime(/s)

  print, 'Total time (all)=', (t3-t0)/60 , '  (minutes)'


end

