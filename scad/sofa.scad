// Units in cm.

dim_pillow = 60;
dim_pipe = 2.5;

module pipe(length)
{
  difference(){
    thi=0.155;
    cube([length,dim_pipe,dim_pipe]);
    translate([0, thi/2, thi/2])
    cube([length,dim_pipe-thi,dim_pipe-thi]);
  }
}

module pillow()
{
  color([0,0,1])
  cube([dim_pillow,dim_pillow,10]);
}

// Pillows window side.
for (i=[0:3]) {
  translate([dim_pillow*1.003*i, 0, 0]) {
    pillow();
  }
}
// Pillows other side.
for (i=[0:4]) {
  translate([0, dim_pillow*1.003*(i+1), 0]) {
    pillow();
  }
}

// Pipe frame.
translate([0,0,-dim_pipe])
pipe(dim_pillow*4);

translate([0,dim_pillow-dim_pipe,-dim_pipe])
pipe(dim_pillow*4);

translate([dim_pipe,dim_pillow,-dim_pipe])
rotate(90)
pipe(dim_pillow*5);

translate([dim_pillow,dim_pillow,-dim_pipe])
rotate(90)
pipe(dim_pillow*5);

translate([dim_pipe,dim_pillow*6-dim_pipe,-dim_pipe])
pipe(dim_pillow-2*dim_pipe);

translate([dim_pipe,dim_pipe,-dim_pipe])
rotate(90)
pipe(dim_pillow-2*dim_pipe);

translate([dim_pillow*4,dim_pipe,-dim_pipe])
rotate(90)
pipe(dim_pillow-2*dim_pipe);
