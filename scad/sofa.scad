// Units in cm.

dim_pillow = 60;
dim_pillow_height = 10;

dim_back_pillow = 30;
dim_back_pillow_height = 5;

dim_floor_to_pillow_top = 43;
dim_pipe = 2.5;
dim_legs = dim_floor_to_pillow_top-dim_pillow_height-dim_pipe;

color_back_pillows="Magenta";
color_pillows="CadetBlue";
color_frame="Silver";
color_armrest="Salmon";

// Backrest-parameters.
angle_rest=90/10;
back_height=40;
back_straight_height=cos(angle_rest)*back_height+dim_pipe;
back_straight_offset=sin(angle_rest)*back_height+dim_pipe;

// Armrest parameters.
dim_diff_armrest_top_of_pillow = 10;
dim_armrest_height = dim_floor_to_pillow_top+dim_diff_armrest_top_of_pillow;
dim_armrest_width = 15;

function pillow_area(w, d, h) =
  2 * w*d +
  2 * d*h +
  2 * w*h;

module pipe(length)
{
  difference(){
    thi=0.155;
    color([0,1,0])
    cube([length,dim_pipe,dim_pipe]);
    translate([0, thi/2, thi/2])
    cube([length*1.3,dim_pipe-thi,dim_pipe-thi]);
  }
  echo(str("pipe -- ", length, "cm "));
}

module pillow()
{
  color(color_pillows)
  cube([dim_pillow,dim_pillow,dim_pillow_height]);
  echo(str("pillow -- ", pillow_area(dim_pillow, dim_pillow, dim_pillow_height), "cm^2"));
}

module back_pillow()
{
  color(color_back_pillows)
  cube([dim_pillow,dim_back_pillow,dim_back_pillow_height]);
  echo(str("pillow_back -- ", pillow_area(dim_pillow, dim_back_pillow, dim_back_pillow_height), "cm^2"));
}

module back_pillow_corner()
{
  dim_back_pillow_corner=dim_pillow-dim_back_pillow_height;
  color(color_back_pillows)
  cube([dim_back_pillow_corner,dim_back_pillow,dim_back_pillow_height]);
  echo(str("pillow_back_corner -- ", pillow_area(dim_pillow, dim_back_pillow_corner, dim_back_pillow_height), "cm^2"));
}

module frame_back(skip_top_bar)
{

  color(color_frame)
  rotate([angle_rest,0,0])
  {
    // First main bar to correct length.
    if(!skip_top_bar) {
      translate([0,0,back_height])
      pipe(dim_pillow);
    }

    // crossbars.
    translate([dim_pipe,0, 0])
    rotate([0,-90,0])
    pipe(back_height);
    translate([dim_pillow,0, 0])
    rotate([0,-90,0])
    pipe(back_height);
  }

  color(color_frame)
  translate([0,-back_straight_offset,-dim_pipe])
  {
    // Second main bar to correct length.
    if(!skip_top_bar) {
      translate([0,0,back_straight_height])
      pipe(dim_pillow);
    }

    // Crossbars / back-legs.
    translate([dim_pipe,0, -dim_legs])
    rotate([0,-90,0])
    pipe(back_straight_height+dim_legs);

    translate([dim_pillow,0, -dim_legs])
    rotate([0,-90,0])
    pipe(back_straight_height+dim_legs);
  }
}

module frame(skip_top_bar)
{

  dim_bottom_bar=back_straight_offset+dim_pillow;

  frame_back(skip_top_bar);

  color(color_frame)
  translate([0,-back_straight_offset,-dim_pipe])
  {
    // Second main bar to correct length.
    if (!skip_top_bar) {
      translate([0,0,back_straight_height])
      pipe(dim_pillow);
    }

    // Crossbars / back-legs.
    translate([dim_pipe,0, -dim_legs])
    rotate([0,-90,0])
    pipe(back_straight_height+dim_legs);

    translate([dim_pillow,0, -dim_legs])
    rotate([0,-90,0])
    pipe(back_straight_height+dim_legs);
  }


  color(color_frame)
  translate([0,-back_straight_offset,-dim_pipe])
  {
    // Create bottom side pipes.
    translate([dim_pipe, dim_pipe, 0])
    rotate([0,0,90])
    pipe(dim_bottom_bar);

    translate([dim_pillow, dim_pipe, 0])
    rotate([0,0,90])
    pipe(dim_bottom_bar);

    // Create bottom front and back pipe.
    dim_bottom_cross_pipe = dim_pillow-2*dim_pipe;
    translate([dim_pipe, 0, 0])
    pipe(dim_bottom_cross_pipe);

    translate([dim_pipe, dim_pillow+back_straight_offset, 0])
    pipe(dim_bottom_cross_pipe);

    // Create front legs.
    translate([0, dim_pillow+back_straight_offset, 0])
    rotate([0,90,0])
    pipe(dim_legs);

    translate([dim_pillow-dim_pipe, dim_pillow+back_straight_offset, 0])
    rotate([0,90,0])
    pipe(dim_legs);
  }
}

module section()
{
  translate([0,dim_pipe, 0])
  pillow();
  translate([0,dim_back_pillow_height+1,dim_pillow_height])
  rotate([90+angle_rest, 0, 0])
  back_pillow();
  frame();
}

module corner()
{
  translate([0,dim_pipe, 0])
  pillow();
  translate([0,dim_back_pillow_height+1,dim_pillow_height])
  rotate([90+angle_rest, 0, 0])
  back_pillow();
  translate([-1.5, dim_back_pillow_height+1.5,dim_pillow_height-1])
  rotate([90-angle_rest, 0, 90])
  back_pillow_corner();
  frame(true);
  translate([-dim_pipe,dim_pillow, 0])
  color(color_frame)
  rotate([0,0,-90]) {
    translate([-dim_pipe,-back_straight_offset,-dim_pipe])
    pipe(dim_pillow);
    translate([-dim_pipe,-back_straight_offset,-dim_pipe])
    pipe(dim_pillow);
    translate([-dim_pipe,0,-dim_pipe])
    pipe(dim_pillow);
    translate([-dim_pipe,0,0])
    frame_back(true);
  }
  color(color_frame) {
    translate([-back_straight_offset,dim_pipe,-dim_pipe])
    pipe(back_straight_offset-dim_pipe);

    translate([-back_straight_offset,dim_pillow,-dim_pipe])
    pipe(back_straight_offset-dim_pipe);

    translate([-back_straight_offset-dim_pipe,-back_straight_offset,-dim_pipe])
    pipe(back_straight_offset+dim_pipe);

    translate([-back_straight_offset-dim_pipe,-back_straight_offset,-dim_pipe])
    pipe(back_straight_offset+dim_pipe);

    translate([-back_straight_offset,-back_straight_offset+dim_pipe,-dim_pipe])
    rotate([0,0,90])
    pipe(back_straight_offset);

    rotate([angle_rest, 0,0])
    translate([-back_straight_offset,0,back_height])
    pipe(dim_pillow+back_straight_offset);

    translate([-back_straight_offset,-back_straight_offset,back_straight_height-dim_pipe])
    pipe(dim_pillow+back_straight_offset);

    translate([-back_straight_offset,-back_straight_offset,back_straight_height-dim_pipe])
    rotate([0,0,90])
    pipe(dim_pillow+back_straight_offset+dim_pipe);

    addition_corner=0.5;
    rotate([-angle_rest, 0,90])
    translate([-back_straight_offset+2*dim_pipe-addition_corner,0,back_height+0.4])
    pipe(dim_pillow+back_straight_offset-dim_pipe+addition_corner);
  }
}

module armrest()
{
  module base_frame()
  {
    pipe(dim_pillow+back_straight_offset+dim_pipe);
    translate([0, -dim_armrest_width,0])
    pipe(dim_pillow+back_straight_offset+dim_pipe);
    rotate([0,0,90])
    translate([-dim_armrest_width+dim_pipe,-dim_pipe,0])
    pipe(dim_armrest_width-dim_pipe);
    rotate([0,0,90])
    translate([-dim_armrest_width+dim_pipe,-dim_pipe-dim_pillow-back_straight_offset,0])
    pipe(dim_armrest_width-dim_pipe);
  }

  module crossbeams()
  {
    rotate([0,-90,0]) {
      translate([dim_pipe,0,-dim_pipe])
      pipe(dim_armrest_height-2*dim_pipe);
      translate([dim_pipe,0,-dim_pipe-dim_pillow-back_straight_offset])
      pipe(dim_armrest_height-2*dim_pipe);
    }
  }

  color(color_armrest) {
    base_frame();
    crossbeams();
    translate([0,-dim_armrest_width,0])
    crossbeams();
    translate([0,0,dim_armrest_height-dim_pipe])
    base_frame();
  }
}

module stefan()
{
  cube([60, 25, 180]);
}

module amanda()
{
  cube([40, 25, 156]);
}

sections_window=3;
sections_other=4;

translate([back_straight_offset,back_straight_offset,dim_legs+dim_pipe]) {
  for (i=[0:sections_window-1]) {
    translate([dim_pillow*(i+1), 0, 0])
    section();
  }
  corner();
  for (i=[0:sections_other-1]) {
    translate([-dim_pipe, dim_pillow*(i+2)+dim_pipe, 0])
    rotate([0,0,-90])
    section();
  }
}

rotate([0,0,90])
translate([0, -((sections_window+1)*dim_pillow+back_straight_offset+dim_pipe),0])
armrest();
translate([0, (sections_other+1)*dim_pillow+back_straight_offset+dim_armrest_width+dim_pipe,0])
armrest();


translate([280,0,0])
stefan();
translate([0,350,0])
amanda();
