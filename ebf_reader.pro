pro read_halo,file1,halo
halo={no:0}
load_ebf_halo,file1,"/Pos3",halo,["px","py","pz"] ;Pos: x,y,z
load_ebf_halo,file1,"/Vel3",halo,["vx","vy","vz"] ;Vel: U,B,V heliocentric
load_ebf_halo,file1,"/Rad",halo,"rad"             ;metallicty FeH
load_ebf_halo,file1,"/Mag0",halo,"j"              ;App mag B
load_ebf_halo,file1,"/Mag1",halo,"i"              ;App mag V
load_ebf_halo,file1,"/Mag2",halo,"k"              ;App mag I
load_ebf_halo,file1,"/PopID",halo,"id"            ;Population ID 0-9
load_ebf_halo,file1,"/Smass",halo,"mass"          ;star mass
load_ebf_halo,file1,"/FeH",halo,"feh"             ;star age
load_ebf_halo,file1,"/Age",halo,"age"             ;metallicty FeH
; empty labels
load_ebf_halo,file1,"/Smass",halo,"r"   ; Abs mag
load_ebf_halo,file1,"/Smass",halo,"mi"   ; Abs mag
load_ebf_halo,file1,"/Smass",halo,"cjk"  ; Color
load_ebf_halo,file1,"/Smass",halo,"vr"   ; radial vel
; calculate value for empty labels
;halo.r=sqrt(halo.px^2+halo.py^2+halo.pz^2)
halo.mi=halo.i-5*alog10(halo.r*100.0)
halo.cjk=halo.j-halo.k
halo.id=halo.id+1                        ; add 1 to make same as Besancon
halo.vr=(halo.vx*halo.px+halo.vy*halo.py+halo.vz*halo.pz)/halo.r
end

file1='/home/azuri/daten/besancon/sanjib/Survey-0.3-beta/Examples/galaxy1.ebf'
read_halo,file1,halo

!p.multi=[0,2,2]
plot,halo.px,halo.pz,psym=3,xrange=[-10,10],yrange=[-10,10],xtitle='px',ytitle='pz'
plot,halo.px,halo.py,psym=3,xrange=[-10,10],yrange=[-10,10],xtitle='px',ytitle='py'
plot,halo.vx,halo.vz,psym=3,xrange=[-400,400],yrange=[-400,400],xtitle='vx',ytitle='vz'
plot,halo.vx,halo.vy,psym=3,xrange=[-400,400],yrange=[-400,400],xtitle='vx',ytitle='vy'


end
