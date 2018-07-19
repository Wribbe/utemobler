// Units in cm.

dim_pillow = 60;
dim_pillow_height = 10;

dim_back_pillow = 30;
dim_back_pillow_height = 5;

dim_floor_to_pillow_top = 43;
dim_frame_part = 4.2;
dim_legs = dim_floor_to_pillow_top-dim_pillow_height-dim_frame_part;

color_back_pillows="Magenta";
color_pillows="CadetBlue";
color_frame="Silver";
color_armrest="Salmon";
color_surroundings="DarkSlateGray";

// Backrest-parameters.
angle_rest=90/10;
back_height=40;
back_straight_height=cos(angle_rest)*back_height+dim_frame_part;
back_straight_offset=sin(angle_rest)*back_height+dim_frame_part-4.5;

// Armrest parameters.
dim_diff_armrest_top_of_pillow = 10;
dim_armrest_height = dim_floor_to_pillow_top+dim_diff_armrest_top_of_pillow;
dim_armrest_width = 20;

// Corner dimensions.
dim_corner_cross_beam = dim_pillow+back_straight_offset-dim_frame_part;
dim_corner_main_beam = dim_pillow+back_straight_offset;
dim_corner_back_legs = back_straight_height+dim_legs+dim_frame_part;
dim_corner_leg_stab_height = dim_legs/2;
dim_corner_back_height = back_height+1;
offset_corner_back = back_straight_offset+2;

// Table dimensions.
//dim_table_width = 240;
dim_table_width = 165;
dim_table_depth = 110;
dim_table_height = 55;
dim_table_mosaic_depth = 0.6;
dim_oak_board_width = 9.5;
dim_oak_board_height = 1.5;
dim_table_top_indent = 1.5;
dim_board_height = 0.3;
dim_table_cut_depth = dim_oak_board_height-dim_board_height-dim_table_mosaic_depth;
dim_table_lath_width = 3.8;
dim_table_lath_height = 2.5;
dim_table_lath_length = dim_table_depth-2*dim_table_lath_height;
dim_table_furu_sides_width = 1.5;
dim_table_furu_sides_height = 0.8;
dim_table_leg_height = dim_table_height-dim_oak_board_height;
dim_table_leg_width = 4.5;
dim_table_leg_depth = 4.5;
dim_table_leg_offset = 3;
dim_table_offset = dim_pillow+back_straight_offset+dim_frame_part+15;
dim_table_bottom_part_height = 14;
dim_table_bottom_reduction = dim_table_leg_width+2*dim_table_leg_offset;
dim_table_bottom_part_width = dim_table_width-dim_table_bottom_reduction;
dim_table_bottom_part_depth = dim_table_depth-dim_table_bottom_reduction;
dim_table_depth_between_legs = dim_table_depth-2*dim_table_leg_depth-2*dim_table_leg_offset;
dim_table_width_between_legs = dim_table_width-2*dim_table_leg_width-2*dim_table_leg_offset;
dim_table_lath_offset = (dim_table_leg_width+dim_table_leg_offset)-dim_table_lath_width;
dim_table_lath_last_offset = dim_table_width_between_legs+dim_table_lath_width;
dim_table_bottom_lath_offset = 0;
dim_table_lath_cut_depth = dim_oak_board_height-dim_table_cut_depth-dim_board_height;


back_crossbar_lower = 1;

function pillow_area(w, d, h) =
  2 * w*d +
  2 * d*h +
  2 * w*h;

module frame_part(length)
{
//  difference(){
//    thi=0.155;
    color([0,1,0])
    cube([length,dim_frame_part,dim_frame_part]);
//    translate([0, thi/2, thi/2])
//    cube([length*1.3,dim_frame_part-thi,dim_frame_part-thi]);
//  }
  echo(str("frame -- ", length, "cm "));
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
//    // First main bar to correct length.
//    if(!skip_top_bar) {
//      translate([0,0,back_height])
//      frame_part(dim_pillow);
//    }

    // crossbars.
    translate([dim_frame_part,0,-back_crossbar_lower])
    rotate([0,-90,0])
    frame_part(back_height);
    translate([dim_pillow,0, -back_crossbar_lower])
    rotate([0,-90,0])
    frame_part(back_height);
  }

  color(color_frame)
  translate([0,-back_straight_offset,-dim_frame_part])
  {
   // Second main bar to correct length.
    if(!skip_top_bar) {
      translate([0,0,back_straight_height])
      frame_part(dim_pillow);
    }

    // Crossbars / back-legs.
    translate([dim_frame_part,0, -dim_legs])
    rotate([0,-90,0])
    frame_part(back_straight_height+dim_legs);

    translate([dim_pillow,0, -dim_legs])
    rotate([0,-90,0])
    frame_part(back_straight_height+dim_legs);
  }

}

module mod_frame(skip_top_bar)
{

  dim_bottom_bar=back_straight_offset+dim_pillow;

  frame_back(skip_top_bar);

//  color(color_frame)
//  translate([0,-back_straight_offset,-dim_frame_part])
//  {
//    // Second main bar to correct length.
//    if (!skip_top_bar) {
//      translate([0,0,back_straight_height])
//      frame_part(dim_pillow);
//    }
//  }


  color(color_frame)
  translate([0,-back_straight_offset,-dim_frame_part])
  {
    // Create bottom side frame_parts.
    translate([dim_frame_part, dim_frame_part, 0])
    rotate([0,0,90])
    frame_part(dim_bottom_bar);

    translate([dim_pillow, dim_frame_part, 0])
    rotate([0,0,90])
    frame_part(dim_bottom_bar);

    // Stablize legs.
    translate([dim_pillow, dim_frame_part, -dim_legs/2])
    rotate([0,0,90])
    frame_part(dim_bottom_bar-dim_frame_part);

    translate([dim_frame_part, 0, -dim_legs/2])
    frame_part(dim_bottom_cross_frame_part);

    translate([dim_frame_part, dim_pillow+back_straight_offset, -dim_legs/2])
    frame_part(dim_bottom_cross_frame_part);

    translate([dim_frame_part, dim_frame_part, -dim_legs/2])
    rotate([0,0,90])
    frame_part(dim_bottom_bar-dim_frame_part);

    // Create bottom front and back frame_part.
    dim_bottom_cross_frame_part = dim_pillow-2*dim_frame_part;
    translate([dim_frame_part, 0, 0])
    frame_part(dim_bottom_cross_frame_part);

    translate([dim_frame_part, dim_pillow+back_straight_offset, 0])
    frame_part(dim_bottom_cross_frame_part);

    // "Fill in bottom.
    for (a = [dim_frame_part*2:dim_frame_part*2:dim_pillow+back_straight_offset] ) {
      translate([dim_frame_part,a,0])
      frame_part(dim_bottom_cross_frame_part);
    }

    // "Fill in" back-rest.
    rotate([angle_rest, 0, 0]) {
      for (a = [dim_frame_part:dim_frame_part*2:back_height] ) {
        translate([dim_frame_part,back_straight_offset+back_crossbar_lower,a])
        frame_part(dim_bottom_cross_frame_part);
      }
    }

    // Create front legs.
    translate([0, dim_pillow+back_straight_offset, 0])
    rotate([0,90,0])
    frame_part(dim_legs);

    translate([dim_pillow-dim_frame_part, dim_pillow+back_straight_offset, 0])
    rotate([0,90,0])
    frame_part(dim_legs);
  }
}

module section()
{
//  translate([0,dim_frame_part, 0])
//  pillow();
//  translate([0,dim_back_pillow_height+2.9,dim_pillow_height])
//  rotate([90+angle_rest, 0, 0])
//  back_pillow();
  mod_frame();
}

module corner()
{

  // *** Add frame parts adjusted for extra back piece.
  // -- Top part.
  translate([-back_straight_offset,-back_straight_offset,back_straight_height-dim_frame_part])
  frame_part(dim_corner_cross_beam);

  translate([-back_straight_offset,-back_straight_offset+dim_frame_part,back_straight_height-dim_frame_part])
  rotate([0,0,90])
  frame_part(dim_corner_main_beam-dim_frame_part);

  // -- Bottom part.
  translate([-back_straight_offset,-back_straight_offset+dim_corner_main_beam,-dim_frame_part])
  frame_part(dim_corner_cross_beam);

  translate([-back_straight_offset,-back_straight_offset,-dim_frame_part])
  frame_part(dim_corner_cross_beam);

  translate([-back_straight_offset,-back_straight_offset+dim_frame_part,-dim_frame_part])
  rotate([0,0,90])
  frame_part(dim_corner_main_beam-dim_frame_part);

  translate([-back_straight_offset+dim_corner_cross_beam+dim_frame_part,-back_straight_offset+dim_frame_part,-dim_frame_part])
  rotate([0,0,90])
  frame_part(dim_corner_main_beam);

  // *** Add vertical back-frame/leg pieces.
  translate([-back_straight_offset,-back_straight_offset,-dim_legs-dim_frame_part])
  rotate([0,-90,0])
  frame_part(dim_corner_back_legs);

  translate([-back_straight_offset+dim_corner_cross_beam+dim_frame_part,-back_straight_offset,-dim_legs-dim_frame_part])
  rotate([0,-90,0])
  frame_part(dim_corner_back_legs);

  translate([-back_straight_offset,-back_straight_offset+dim_corner_main_beam,-dim_legs-dim_frame_part])
  rotate([0,-90,0])
  frame_part(dim_corner_back_legs);

  // *** Add single leg.
  translate([-back_straight_offset+dim_corner_cross_beam+dim_frame_part,-back_straight_offset+dim_corner_main_beam,-dim_legs-dim_frame_part])
  rotate([0,-90,0])
  frame_part(dim_legs);

  // *** Add lower beams between legs.
  translate([0,0,-dim_corner_leg_stab_height])
  {
    translate([-back_straight_offset,-back_straight_offset+dim_corner_main_beam,-dim_frame_part])
    frame_part(dim_corner_cross_beam);

    translate([-back_straight_offset,-back_straight_offset,-dim_frame_part])
    frame_part(dim_corner_cross_beam);

    translate([-back_straight_offset,-back_straight_offset+dim_frame_part,-dim_frame_part])
    rotate([0,0,90])
    frame_part(dim_corner_main_beam-dim_frame_part);

    translate([-back_straight_offset+dim_corner_cross_beam+dim_frame_part,-back_straight_offset+dim_frame_part,-dim_frame_part])
    rotate([0,0,90])
    frame_part(dim_corner_main_beam);
  }

  // *** Fill in seat.
  for (a = [-back_straight_offset+dim_frame_part*2:dim_frame_part*2:dim_corner_main_beam-2*dim_frame_part] ) {
    translate([-back_straight_offset,a,-dim_frame_part])
    frame_part(dim_corner_cross_beam);
  }

  // *** Add extra beam in order to fixate backrest.
  translate([-back_straight_offset,-back_straight_offset+dim_frame_part,-dim_frame_part])
  frame_part(dim_corner_cross_beam);

  // *** Construct sloped back.
  translate([back_straight_offset+dim_frame_part,0.3,-0.7])
  rotate([angle_rest,0,0]) {
    // --- Right part.
    translate([-back_straight_offset+(dim_corner_main_beam-back_straight_offset-dim_frame_part),0,0])
    rotate([0,-90,0])
    frame_part(dim_corner_back_height);

    // --- Left part.
    translate([-back_straight_offset,0,0])
    rotate([0,-90,0])
    frame_part(dim_corner_back_height);

    // --- Fill in back between.
    for (a = [dim_frame_part:dim_frame_part*2:back_height-dim_frame_part]) {
      translate([-back_straight_offset,0,a])
      frame_part(dim_corner_main_beam-back_straight_offset-2*dim_frame_part);
    }
  }
  // *** Construct second sloped back.
  translate([-dim_frame_part,dim_corner_main_beam-2*back_straight_offset,-0.7])
  rotate([angle_rest,0,-90])
  {
    // --- Right part.
    translate([-back_straight_offset+dim_corner_back_cross+dim_frame_part,0,0])
    rotate([0,-90,0])
    frame_part(dim_corner_back_height);


    // --- Left part.
    translate([-back_straight_offset,0,0])
    rotate([0,-90,0])
    frame_part(dim_corner_back_height);

    dim_corner_back_cross = dim_corner_main_beam-back_straight_offset-1.6*dim_frame_part;

    // --- Fill in back between.
    for (a = [dim_frame_part:dim_frame_part*2:back_height-dim_frame_part]) {
      translate([-back_straight_offset,0,a])
      frame_part(dim_corner_back_cross);
    }
  }
}

module armrest()
{
  module base_mod_frame()
  {
    frame_part(dim_pillow+back_straight_offset+dim_frame_part);

    translate([0, -dim_armrest_width,0])
    frame_part(dim_pillow+back_straight_offset+dim_frame_part);

    rotate([0,0,90])
    translate([-dim_armrest_width+dim_frame_part,-dim_frame_part,0])
    frame_part(dim_armrest_width-dim_frame_part);

    rotate([0,0,90])
    translate([-dim_armrest_width+dim_frame_part,-dim_frame_part-dim_pillow-back_straight_offset,0])
    frame_part(dim_armrest_width-dim_frame_part);
  }

  module crossbeams()
  {
    dim_height = dim_armrest_height-dim_legs-dim_frame_part;
    rotate([0,-90,0]) {
      translate([dim_legs-dim_frame_part,0,0]) {
        translate([dim_frame_part,0,-dim_frame_part])
        frame_part(dim_height);
        translate([dim_frame_part,0,-dim_frame_part-dim_pillow-back_straight_offset])
        frame_part(dim_height);
      }
    }
  }

  color(color_armrest) {
    //base_mod_frame();
    crossbeams();
    //translate([0,-dim_armrest_width,0])
    //crossbeams();
    translate([0,0,dim_armrest_height-dim_frame_part])
    base_mod_frame();
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

module surroundings()
{
  dim_window_width = 52.5;
  dim_window_height = 115;
  dim_window_sep = 9.5;
  dim_window_buf_right = 8;
  dim_window_buf_left = 19;

  dim_wall_right=132;
  dim_wall_lower=138.8;
  dim_wall_lower_height=90;

  dim_wall_height=241;
  dim_door=93;
  dim_door_height=202;

  dim_plank=325;

  color(color_surroundings) {

    // Plank.
    rotate([0,0,90])
    cube([dim_plank,9.2,180]);

    // Höger vägg.
    translate([0,-9.2,0])
    cube([dim_wall_right,9.2,dim_wall_height]);

    // Under fönster.
    translate([dim_wall_right,-9.2,0])
    cube([dim_wall_lower,9.2,dim_wall_lower_height]);

    // Fönsterkarm.
    translate([dim_wall_right,0,dim_wall_lower_height])
    rotate([0,90,0])
    cube([9.5,3,dim_wall_lower]);

    translate([dim_door+dim_wall_right+dim_wall_lower,0,0]) {
      // Dörr.
      rotate([0,0,150])
      cube([dim_door,3,dim_door_height]);
      translate([0,-3,0]) {
        // Dörr-padd.
        cube([5,3,dim_wall_height]);
        // Dörr-vägg.
        translate([5+102.2,3,0])
        rotate([0,0,90])
        cube([106,102.2,dim_wall_height]);
      }
    }
    // Staket.
    translate([0,dim_plank,0])
    cube([117.8,9.2,93.2]);

    // Roof.
    translate([0,0,dim_wall_height])
    cube([dim_wall_right+dim_wall_lower+dim_door+5,243,40]);

    //Above window.
    translate([dim_wall_right,-10,dim_door_height])
    cube([dim_door+dim_wall_lower,10,dim_wall_height-dim_door_height]);

    //Pillar.
    translate([343,230,0])
    cylinder(h=dim_wall_height,r=10/2);

    translate([5+5,230,0])
    cylinder(h=dim_wall_height,r=10/2);
  }
}

module oak(length)
{
  cube([dim_oak_board_width,length,dim_oak_board_height]);
}

module board(width, depth, height=dim_board_height)
{
  cube([width, depth, height]);
}

module lath(length)
{
  cube([dim_table_lath_width, length, dim_table_lath_height]);
}

module furu_sides(length)
{
  cube([dim_table_furu_sides_width, length, dim_table_furu_sides_height]);
}

module oak_leg(height)
{
  cube([dim_table_leg_width, dim_table_leg_depth, height]);
}

module table()
{

  module table_mod_top_frame(width, depth)
  {
    // *** Two planks for depth.
    oak(depth);
    translate([width-dim_oak_board_width, 0, 0])
    oak(depth);

    // *** Two plans for width.
    rotate([0,0,-90])
    {
      translate([-dim_oak_board_width,0,0])
      oak(width);
      translate([-depth,0,0])
      oak(width);
    }
  }

  module table_mod_bottom_board(width, depth, height=dim_board_height) {
    translate([
      dim_oak_board_width-dim_table_top_indent/2,
      dim_oak_board_width-dim_table_top_indent/2,
      dim_table_cut_depth
    ])
    board(
      width-2*dim_oak_board_width+dim_table_top_indent,
      depth-2*dim_oak_board_width+dim_table_top_indent,
      height
    );
  }

  module table_mod_cut_top_frame(width, depth)
  {
    difference()
    {
      table_mod_top_frame(width, depth);
      table_mod_bottom_board(width, depth, dim_oak_board_height);
    }
  }

  module table_mod_legs()
  translate([0,0,-dim_table_leg_height])
  {
    for (i=[
        [dim_table_leg_offset,dim_table_leg_offset],
        [dim_table_width-dim_table_leg_offset-dim_table_leg_width,dim_table_leg_offset],
        [dim_table_leg_offset,-dim_table_leg_offset+dim_table_depth-dim_table_leg_depth],
        [dim_table_width-dim_table_leg_offset-dim_table_leg_depth,-dim_table_leg_offset+dim_table_depth-dim_table_leg_depth],
    ]) {
      translate([i[0], i[1], 0])
      oak_leg(dim_table_leg_height);
    }
  }

  module table_mod_border()
  rotate([0,-90,0])
  {
    furu_sides(dim_table_lath_length);
  }

  module table_mod_underworks(width, depth, lath_depth, lath_first_offset,
  lath_last_offset)
  {
    reduction = depth-lath_depth;
    translate([lath_first_offset,
    reduction/2,-dim_table_lath_height])
    {
      // *** Create cross-beams depth-wise.
      for(i=[0:lath_last_offset/3:lath_last_offset]) {
        first_or_last = (i==0 || i==lath_last_offset);
        z = first_or_last ? 0 : dim_table_lath_cut_depth;
        final_depth = first_or_last ? dim_table_depth_between_legs : depth-reduction;
        y = (first_or_last && (lath_depth != dim_table_depth_between_legs)) ?
        (dim_table_depth_between_legs-lath_depth)/2 : 0;
        translate([i,-y,z])
        lath(final_depth);
      }
    }
    // *** Create support-beams width-wise.
    for(i=[0,lath_depth+dim_table_lath_width]) {
      y = lath_depth != dim_table_depth_between_legs ? (dim_table_depth_between_legs-lath_depth)/2 : 0;
      translate([(width-dim_table_width_between_legs)/2,(depth-dim_table_depth_between_legs)/2+y+i,-dim_table_lath_height])
      rotate([0,0,-90])
      lath(dim_table_width_between_legs);
    }
  }

  module table_mod_top_complete(width=dim_table_width, depth=dim_table_depth,
  lath_first_offset=dim_table_lath_offset,
  lath_last_offset=dim_table_lath_last_offset,
  lath_depth=dim_table_depth_between_legs)
  {

    table_mod_cut_top_frame(width, depth);
    table_mod_bottom_board(width, depth);
    table_mod_underworks(width, depth, lath_depth,
    lath_first_offset, lath_last_offset);
    //table_mod_border(width, depth);
  }

  // *** Construct table at correct height.
  translate([0,0,dim_table_height-dim_oak_board_height]) {
    // --- Top part.
    table_mod_top_complete();
    // --- Bottom part.
    translate([dim_table_bottom_reduction/2,dim_table_bottom_reduction/2,
      -dim_table_height+dim_oak_board_height+dim_table_bottom_part_height])
    table_mod_top_complete(
      dim_table_bottom_part_width,
      dim_table_bottom_part_depth,
      dim_table_bottom_lath_offset,
      dim_table_bottom_part_width-dim_table_lath_width,
      dim_table_bottom_part_depth-2*dim_table_lath_width
    );
    // --- Add legs.
    table_mod_legs();
  }
}

//sections_window=2;
sections_window=3;
sections_other=2;

translate([back_straight_offset+dim_frame_part,back_straight_offset,dim_legs+dim_frame_part]) {
  for (i=[0:sections_window-1]) {
    translate([dim_pillow*(i+1), 0, 0])
    section();
  }
  color(color_frame)
  corner();
  for (i=[0:sections_other-1]) {
    translate([-dim_frame_part, dim_pillow*(i+2)+dim_frame_part, 0])
    rotate([0,0,-90])
    section();
  }
}

//rotate([0,0,90])
//translate([0, -((sections_window+1)*dim_pillow+back_straight_offset+dim_frame_part*2),0])
//armrest();
//translate([dim_pillow+back_straight_offset+dim_frame_part, (sections_other+1)*dim_pillow+back_straight_offset+dim_frame_part*2,0])
//rotate([0,0,180])
//armrest();


//translate([280,100,0])
//stefan();
//translate([100,200,0])
//amanda();



translate([dim_table_offset,dim_table_offset,0])
table();

//surroundings();
