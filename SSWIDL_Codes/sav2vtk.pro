; $Id$
;+
; NAME:
;	WRITE_VTK
;
; PURPOSE:
;	This procedure converts the NLFFF magnetic field data into legacy VTK
;	format.
;
;
; MODIFICATION HISTORY:
;       Written by: Chao-Chin Yang, February 12, 2013.
;       Adopted by: Marianna Korsos, May 21, 2018
;       Adopted by: Shreeyesh Biswal, May 15, 2024
;-

pro sav2vtk, dir,x=x,y=y,z=z,dx=dx,dy=dy,dz=dz,pot=pot,center=center,current=current, alpha = alpha, magz=magz
	
	dir = '/home/shreeyeshbiswal/IDLWorkspace/Dataset_PF/AR_11158/2011.02.15_00:00:00_TAI/'
	x = strmid(dir,55,23) + '.sav'
	cd, dir
	
	file=file_search(dir+'/*.sav')
	if keyword_set(pot) then file=file_search(dir+x)
	if n_elements(file) gt 1 then file=file[0]
	restore,file
	if ~keyword_set(dx) then dx=0.36 
	if ~keyword_set(dy) then dy=0.36
	if ~keyword_set(dz) then dz=0.36
	spacing=[dx,dy,dz]
	data_type=strlowcase(size(DATACUBE_3VEC,/tname)) 

	siz=size(DATACUBE_3VEC) 
	siz=siz[1:6]
	print, 'size of datacube_3vec is: '
	print, siz
	
	nx=siz[1]*1L & ny=siz[2]*1L & nz=siz[3]*1L
	if ~keyword_set(center) then center=[nx/2.*dx,ny/2.*dy,0.]
	ntot=(nx*ny*nz)*1L
	x=findgen(nx)*dx-center[0] & y=findgen(ny)*dy-center[1] & z=findgen(nz)*dz-center[2]
	dimensions=[nx,ny,nz]
	origin=center
	ndim=3

	name=strmid(file,strpos(file,'/',/reverse_search)+1)
	name=dir+'/'+strmid(name,0,strpos(name,'.sav'))+'.vtk'
	print,'Writing ',strtrim(name), '. . .'
	openw,lun,name,/get_lun,/swap_if_little_endian
	
  ; Write the header information
	printf, lun, '# vtk DataFile Version 2.0'
	printf, lun, 'Non-Linear Force Free Field Data'
	printf, lun, 'BINARY'
	printf, lun, 'DATASET RECTILINEAR_GRID'
  printf, lun, 'DIMENSIONS ', dimensions
  printf, lun, 'X_COORDINATES ', nx, ' ', data_type
  writeu, lun, x
  printf, lun, 'Y_COORDINATES ', ny, ' ', data_type
  writeu, lun, y
  printf, lun, 'Z_COORDINATES ', nz, ' ', data_type
  writeu, lun, z
	printf, lun, 'POINT_DATA ',ntot
      
	data = fltarr(3,nx,ny,nz)
	szdt = size(data, /dimensions)
	print, 'data size is: '
	print, szdt
	data = DATACUBE_3VEC
	sz3v = size(datacube_3vec, /dimensions)
	print, 'datacube_3vec size is: '
	print, sz3v
  print, 'VECTORS ', strlowcase('Bfield'), ' ', data_type
  printf, lun, 'VECTORS ', strlowcase('Bfield'), ' ', data_type
  writeu, lun, swap_endian(data, /swap_if_big_endian)
  close, lun
  free_lun, lun

end

