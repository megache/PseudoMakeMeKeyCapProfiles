use <scad-utils/morphology.scad> //for cheaper minwoski 
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <sweep.scad>
use <skin.scad>  

//DP (Distored Pyramidal) [Double Penetration] Profile for neuron sets

//TODO add shift 
//#square([22.5, 19.05], center = true);
translate([0, 0, 0])keycap(keyID = 4, cutLen = 0, Stem =true,  Dish = true, visualizeDish = true, crossSection = false, homeDot = false, Legends = false);
////fullsetee
//RowHome = [0,0,5,2.5,0,0];
//rotate([0,0,0])
//for(Col = [0:0]){ 
//  for(Row = [1:3]){
//    translate([19*Col, 19*Row +RowHome[Col], 0]){
//      keycap(keyID = Col*4+Row, cutLen = 0, Stem = true,  Dish = true, visualizeDish = true, crossSection = true);
//      #translate([0, 0, StemBrimDep])cylinder(d=3,7);
//    }
//  }
//}

////// thumb
//  translate([-15, -4, 0])rotate([0,0,30])keycap(keyID = 0, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([10, 0, 0])rotate([0,0,15])keycap(keyID = 4, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([31, 2.2, 0])rotate([0,0,0])keycap(keyID = 8, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);

//Parameters
wallthickness = 1.25;
topthickness = 2.5;
stepsize = 50;  //resolution of Trajectory
step = 6;       //resolution of ellipes 
fn = 32;          //resolution of Rounded Rectangles: 60 for output
layers = 50;    //resolution of vertical Sweep: 50 for output

//---Stem param
slop    = 0.4;
stemRot = 0;
stemWid = 7.2;
stemLen = 5.5;
stemCrossHeight = 7;
extra_vertical = 0.6;
StemBrimDep    = 0.75; 
stemLayers     = 20; //resolution of stem to cap top transition
proHeight      = 3.5;
dishLayers     = 30;

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//3  heavy sculpt rows setup
    [17.16,  17.16,   8.0, 	 8.0, 8.5+proHeight,    0,    0,    -5,     0,    -0,   2,   2,      1,  3.999,      1,      5,     2,       2], //R5
    [17.96,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,    0,    10,     0,    -0,   2,   2,     .1,  3.999,     .1,  3.399,     2,       2], //R4 
    [17.96,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3
    [17.96,  17.96,   8.0, 	 8.0,10.8+proHeight,    0,    0,   -16,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R2 
    [17.96,  17.96,   8.0, 	 8.0, 8.0+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3 home 
//mods neuron
    [22.26,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3 1.25
    [31.06,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3 1.75

    [22.26,  17.96,   8.4, 	 8.4, 7.8+proHeight,    0,    0,    10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R4 1.25
    [32.06,  17.96,   8.4, 	 8.4, 7.8+proHeight,    0,    0,    10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R4 1.75
//mods van
    [32.06,  17.96,   8.4, 	 8.4,10.8+proHeight,    0,    0,   -16,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R2 1.75
    
    [22.26,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3 1.25
    [26.66,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,   .5,   -10,     0,    -0,   2,   2,     .1,  3.399,     .1,  3.399,     2,       2], //R3 1.5 
    
    [32.06,  17.96,   8.0, 	 8.0, 7.8+proHeight,    0,    0,    10,     0,    -0,   2,   2,     .1,  3.999,     .1,  3.399,     2,       2], //R4 1.75

];

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  // 
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4];  //
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function StemExponent(keyID) = keyParameters[keyID][17];

dishParameters = //dishParameter[keyID][ParameterID]
[ 
// EdOf    fn   LEx   WEx  DshDep     Ch0i, ch1i, Ch0f, Ch1f, DishExp
  //3rows 
  [1.00,  .005,   2, 2,    2.2,  3.399,3.399, .001, .001, 2.0], //R5
  [1.00,  .005,   2, 2,    2.2,  3.399,3.399, .001, .001, 2.0], //R4
  [1.00,  .005,   2, 2,    2.2,  3.399,3.399, .001, .001, 2.0], //R3
  [1.00,  .005,   2, 2,    2.2,  3.399,3.399, .001, .001, 2.0], //R2
  [1.00,  .005,   2, 2,    2.5,  3.399,3.399, .001, .001, 2.5], //R3 homet
  
  //Mods
  [1.00,  .005,   1.5, 1.5,    2.5,  3.399,3.399, .001, .001, 2.5], //R3
  [1.00,  .005,   1.5, 1.5,    2.5,  3.399,3.399, .001, .001, 2.5], //R3

  [1.00,  .005,   1.5, 1.5,    2.5,  3.399,3.399, .001, .001, 2.5], //R2
  [1.00,  .005,   1.5, 1.5,    2.5,  3.399,3.399, .001, .001, 2.5], //R2
  // Van
  [1.00,  .005,   2, 2,    2.5,  3.399,3.399, .001, .001, 2.5], //R2

  [1.00,  .005,   2, 2,    2.5,  3.399,3.399, .001, .001, 2.5], //R3
  [1.00,  .005,   2, 2,    2.5,  3.399,3.399, .001, .001, 2.5], //R3

  [1.00,  .005,   2, 2,    2.5,  3.399,3.399, .001, .001, 2.5], //R4 
];

function EdgeOffset(keyID) = dishParameters[keyID][0];  //
function LenFinal(keyID)   = dishParameters[keyID][1];  // 
function LenExpo(keyID)    = dishParameters[keyID][2];  //
function WidExpo(keyID)    = dishParameters[keyID][3];  //
function DishDepth(keyID)  = dishParameters[keyID][4];  //
function DishCham0i(keyID) = dishParameters[keyID][5];  //
function DishCham1i(keyID) = dishParameters[keyID][6];  //
function DishCham0f(keyID) = dishParameters[keyID][7];  //
function DishCham1f(keyID) = dishParameters[keyID][8];  //
function DishExpo(keyID)   = dishParameters[keyID][9];


//function FrontTrajectory(keyID) = 
//  [
//    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)), //more param available: yaw, roll, scale
//    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish 
//  ];
//
//function BackTrajectory (keyID) = 
//  [
//    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID)),
//    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID)),
//  ];

//------- function defining Dish Shapes

function ellipse(a, b, d = 0, rot1 = 0, rot2 = 360) = [for (t = [rot1:step:rot2]) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]]; //Centered at a apex to avoid inverted face

function DishShape (a,b,c,d) = 
  concat(
//   [[c+a,b]],
    ellipse(a, b, d = 0,rot1 = 90, rot2 = 270)
//   [[c+a,-b]]
  );

function oval_path(theta, phi, a, b, c, deform = 0) = [
 a*cos(theta)*cos(phi), //x
 c*sin(theta)*(1+deform*cos(theta)) , // 
 b*sin(phi),
]; 
  
path_trans2 = [for (t=[0:step:180])   translation(oval_path(t,0,10,15,2,0))*rotation([0,90,0])];


//--------------Function definng Cap 
function CapTranslation(t, keyID) = 
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*ZAngleSkew(keyID))    //Z shift
  ];

function CapTransform(t, keyID) = 
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID) ,
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];
function CapRoundness(t, keyID) = 
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];
  
function InnerTransform(t, keyID) = 
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];
  
function StemTranslation(t, keyID) =
  [
    ((1-t)/stemLayers*TopWidShift(keyID)),   //X shift
    ((1-t)/stemLayers*TopLenShift(keyID)),   //Y shift
    stemCrossHeight+.1+StemBrimDep + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1 -StemBrimDep))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];
  
function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;

//----- Distorted Pyramidal Dish

function DishTranslation(t, keyID) =
  [
    ((t)/dishLayers*TopWidShift(keyID)),   //X shift
    (-TopLenShift(keyID)),   //Y shift
    KeyHeight(keyID)-(t)/dishLayers*(DishDepth(keyID))    //Z shift
  ];

function DishRotation(t, keyID) =
  [
    (-XAngleSkew(keyID)),   //X shift
    (-YAngleSkew(keyID)),   //Y shift
    (-ZAngleSkew(keyID))    //Z shift
  ];

function DishTransform(t, keyID) =
  [
    (1-pow(t/dishLayers, WidExpo(keyID)))*(BottomWidth(keyID) -TopWidthDiff(keyID)+EdgeOffset(keyID)) + (pow(t/dishLayers, WidExpo(keyID)))*(LenFinal(keyID)),
    (1-pow(t/dishLayers, LenExpo(keyID)))*(BottomLength(keyID)-TopLenDiff(keyID)+EdgeOffset(keyID)) + (pow(t/dishLayers, LenExpo(keyID)))*(LenFinal(keyID))
  ];

function DishRoundness(t, keyID) = 
  [
    pow(t/dishLayers, DishExpo(keyID))*(DishCham0f(keyID)) + (1-pow(t/dishLayers, DishExpo(keyID)))*DishCham0i(keyID),
    pow(t/dishLayers, DishExpo(keyID))*(DishCham1f(keyID)) + (1-pow(t/dishLayers, DishExpo(keyID)))*DishCham1i(keyID)
  ];

///----- KEY Builder Module
module keycap(keyID = 0, cutLen = 0, visualizeDish = false, rossSection = false, Dish = true, Stem = false, homeDot = false, Stab = false, Stab = 0) {
  
//  //Set Parameters for dish shape
//  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
//  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);
//  
//  //Scaling initial and final dim tranformation by exponents
//  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID); 
//  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID); 
//
//  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShape(DishDepth(keyID), FrontDishArc(i), 1, d = 0)) ];  
//  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShape(DishDepth(keyID),  BackDishArc(i), 1, d = 0)) ];
  
  //builds
  difference(){
    union(){
      difference(){
        skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell
        
        //Cut inner shell
        if(Stem == true){ 
          translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
        }
      }
      if(Stem == true){
        translate([0,0,StemBrimDep])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID)-StemBrimDep-1, slop); // 
        if (Stab != 0){
          translate([Stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
          translate([-Stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
          //TODO add binding support?
        }
        translate([0,0,-.001])skin([for (i=[0:stemLayers-1]) transform(translation(StemTranslation(i,keyID))*rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID),fn=fn,r=StemRadius(i, keyID)))]); //Transition Support for taller profile
      }
    //cut for fonts and extra pattern for light?
    }
    
    //Cuts
    
    //Fonts
    if(Legends ==  true){
      //    #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,4,KeyHeight(keyID)-2.5])linear_extrude(height = 0.5)text( text = "Why?", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      //  #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }
      
   //Dish Shape 
    if(Dish == true){
     if(visualizeDish == false){
        skin([for (i=[0:dishLayers]) transform(translation(DishTranslation(i, keyID)) * rotation(DishRotation(i, keyID)), 
          elliptical_rectangle(DishTransform(i, keyID), b = DishRoundness(i,keyID),fn=fn)
        )]);
     } else {
        #skin([for (i=[0:dishLayers]) transform(translation(DishTranslation(i, keyID)) * rotation(DishRotation(i, keyID)),           
          elliptical_rectangle(DishTransform(i, keyID), b = DishRoundness(i,keyID),fn=fn)
        )]);
     } 
   }
     if(crossSection == true) {
       translate([0,-15,-.1])cube([15,30,15]); 
     }
  }
  //Homing dot
  if(homeDot == true)translate([0,0,KeyHeight(keyID)-DishDepth(keyID)-.1])sphere(d = 1);
}

//------------------stems 
$fn = fn;

function outer_cherry_stem(slop) = [ stemWid - slop * 2, stemLen - slop * 2];
function outer_cherry_stabilizer_stem(slop) = [4.85 - slop * 2, 6.05 - slop * 2];
function outer_box_cherry_stem(slop) = [6 - slop, 6 - slop];

// .005 purely for aesthetics, to get rid of that ugly crosshatch
function cherry_cross(slop, extra_vertical = 0) = [
  // horizontal tine
  [4.03 + slop, 1.15 + slop / 3],
  // vertical tine
  [1.25 + slop / 3, 4.23 + extra_vertical + slop / 3 + .005],
];
module inside_cherry_cross(slop) {
  // inside cross
  // translation purely for aesthetic purposes, to get rid of that awful lattice
  translate([0,0,-0.005]) {
    linear_extrude(height = 4) {
      square(cherry_cross(slop, extra_vertical)[0], center=true);
      square(cherry_cross(slop, extra_vertical)[1], center=true);
    }
  }

  // Guides to assist insertion and mitigate first layer squishing
  {
    for (i = cherry_cross(slop, extra_vertical)) hull() {
      linear_extrude(height = 0.01, center = false) offset(delta = 0.4) square(i, center=true);
      translate([0, 0, 0.5]) linear_extrude(height = 0.01, center = false)  square(i, center=true);
    }
  }
}

module cherry_stem(depth, slop) {
  D1=.15;
  D2=.05;
  H1=3.5;
  CrossDist = 1.75;
  difference(){
    // outside shape
    linear_extrude(height = depth) {
      offset(r=1){
        square(outer_cherry_stem(slop) - [2,2], center=true);
      }
    }
    #inside_cherry_cross(slop);
    hull(){
      translate([CrossDist,CrossDist-.1,0])cylinder(d1=D1, d2=D2, H1);
      translate([-CrossDist,-CrossDist+.1,0])cylinder(d1=D1, d2=D2, H1);
    }
    hull(){
      translate([-CrossDist,CrossDist-.1])cylinder(d1=D1, d2=D2, H1);
      translate([CrossDist,-CrossDist+.1])cylinder(d1=D1, d2=D2, H1);
    }
  }
}


/// ----- helper functions 
function rounded_rectangle_profile(size=[1,1],r=1,fn=32) = [
	for (index = [0:fn-1])
		let(a = index/fn*360) 
			r * [cos(a), sin(a)] 
			+ sign_x(index, fn) * [size[0]/2-r,0]
			+ sign_y(index, fn) * [0,size[1]/2-r]
];

function elliptical_rectangle(a = [1,1], b =[1,1], fn=32) = [
    for (index = [0:fn-1]) // section right
     let(theta1 = -atan(a[1]/b[1])+ 2*atan(a[1]/b[1])*index/fn) 
      [b[1]*cos(theta1), a[1]*sin(theta1)]
    + [a[0]*cos(atan(b[0]/a[0])), 0]
    - [b[1]*cos(atan(a[1]/b[1])), 0],
    
    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + (180 -2*atan(b[0]/a[0]))*index/fn) 
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    - [0, b[0]*sin(atan(b[0]/a[0]))]
    + [0, a[1]*sin(atan(a[1]/b[1]))],

    for(index = [0:fn-1]) // section left
     let(theta3 = -atan(a[1]/b[1])+180+ 2*atan(a[1]/b[1])*index/fn) 
      [b[1]*cos(theta3), a[1]*sin(theta3)]
    - [a[0]*cos(atan(b[0]/a[0])), 0]
    + [b[1]*cos(atan(a[1]/b[1])), 0],
    
    for(index = [0:fn-1]) // section Top
     let(theta4 = atan(b[0]/a[0]) + 180 + (180 -2*atan(b[0]/a[0]))*index/fn) 
      [a[0]*cos(theta4), b[0]*sin(theta4)]
    + [0, b[0]*sin(atan(b[0]/a[0]))]
    - [0, a[1]*sin(atan(a[1]/b[1]))]
]/2;
    
function sign_x(i,n) = 
	i < n/4 || i > n-n/4  ?  1 :
	i > n/4 && i < n-n/4  ? -1 :
	0;

function sign_y(i,n) = 
	i > 0 && i < n/2  ?  1 :
	i > n/2 ? -1 :
	0;
