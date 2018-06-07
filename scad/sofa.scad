module pipe(length)
{
  difference(){
    thi=0.0015;
    cube([length,0.025,0.025], center=true);
    cube([length,0.025-thi,0.025-thi], center=true);
  }
}
for (i=[0:10]) {
  for (j=[0:10]) {
      translate([0,i,j]) {
      pipe(2);
    }
  }
}
