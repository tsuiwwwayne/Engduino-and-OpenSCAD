/* This is an openSCAD Engduino design by Wayne Tsui.
     Multi-part design: case and case cover
     Colours of the base, walls, USB bracket, hook, and text can be customised.
     Case can also function as a stand (cover removed) by rotating 90 degrees in X-axis.
*/    

// Import a package for drawing characters
use <Spiff.scad>;

// Default dimensions of the case
BASE_LENGTH = 110;
BASE_WIDTH = 86;
BASE_HEIGHT = 3;

WALL_WIDTH = 5;
WALL_HEIGHT = 17;

COVER_HEIGHT = 17;
COVER_WALL_HEIGHT = 14;

USB_BRACKET_WIDTH = 3;
USB_BRACKET_HEIGHT = 13;

HOOK_HEIGHT = 13;

// Default height of the characters in the text for the case
TEXT_HEIGHT = 1;

// Default dimensions for cover
COVER_BASE_LENGTH = BASE_LENGTH - WALL_WIDTH + 1;
COVER_BASE_WIDTH = BASE_WIDTH - (2*(WALL_WIDTH-1));
COVER_BASE_HEIGHT = 1;


module base(colorName) {
    color(colorName, 1)
        cube([BASE_LENGTH, BASE_WIDTH, BASE_HEIGHT]);    
}

// Create USB bracket by difference of two cubes
module USBBracket(colorName, height = USB_BRACKET_HEIGHT, width = USB_BRACKET_WIDTH) {
    difference() {
        translate([22,WALL_WIDTH+0.1,BASE_HEIGHT])
            rotate(a=[0,0,45])
                color(colorName, 1) 
                    cube([19, 21, height]);
        translate([22,WALL_WIDTH+width+1,BASE_HEIGHT-1])
            rotate(a=[0,0,45])
                cube([18, 15, height+2]);
    }   
}    

// Create hook to attach to Engduino keychain ring
module hook(colorName, height = HOOK_HEIGHT) {
    translate([98,74,BASE_HEIGHT])
        color(colorName, 1)
            cylinder(r=1, h=height);
}

// Create walls with ridges for cover to slide in
module wallsWithRidges(colorName, width = WALL_WIDTH, height = WALL_HEIGHT) {    
    difference() {
        translate([0,0,BASE_HEIGHT])
            color(colorName, 1)
                cube([BASE_LENGTH, width, height]);
        translate([-1,4,COVER_HEIGHT])
            cube([BASE_LENGTH-width+2, 2, 1]);
    }    
    difference() {
        translate([0,BASE_WIDTH-width,BASE_HEIGHT])
            color(colorName, 1)
                cube([BASE_LENGTH, width, height]);
        translate([-1,BASE_WIDTH-width-1,COVER_HEIGHT])
            cube([BASE_LENGTH-width+2, 2, 1]);
    }   
     difference() {
        translate([BASE_LENGTH-width,width,BASE_HEIGHT])
            color(colorName, 1)
                cube([width, (BASE_WIDTH-(2*width)), height]);  
        translate([BASE_LENGTH-width-1,width-1,COVER_HEIGHT])
            cube([2, (BASE_WIDTH-(2*width))+2, 1]);
    }           
}

// Create a cover wall to fully enclose the case when used with the cover
module coverWall(colorName, height=COVER_WALL_HEIGHT) {
    translate([0,WALL_WIDTH,BASE_HEIGHT])
        color(colorName, 1)
            cube([WALL_WIDTH, (BASE_WIDTH-(2*WALL_WIDTH)), height]);
}

// Custom name/brand label to the base
// Characters are extruded to give it height
module addTextHere(textHeight, position, colorName, text) {
  translate(position)
      color(colorName, 1)
      linear_extrude(height = textHeight)
      write(text);   
}

// Assembly of all the components except cover
// Colours and text can be customised
module customColorCase() {
base("White");
USBBracket("DodgerBlue");
hook("Crimson");
wallsWithRidges("White");
coverWall("Crimson");
addTextHere(TEXT_HEIGHT, [50,12,BASE_HEIGHT], "Gold", "Wayne");
}

// Create cover with handle to slide in and out
module cover(colorNameBase, colorNameHandle) {
    translate([0,100,0])
        color(colorNameBase, 1)
            cube([COVER_BASE_LENGTH, COVER_BASE_WIDTH, COVER_BASE_HEIGHT]);
    translate([0,101,COVER_BASE_HEIGHT])
        rotate(a=[0,0,0])
            color(colorNameHandle, 1)
                cube([WALL_WIDTH, COVER_BASE_WIDTH - 2, 2]);
}

// Assembly of cover
// Colours and text can be customised
module customColorCaseCover() {
    cover("White", "Crimson");
    addTextHere(TEXT_HEIGHT, [30,135,COVER_BASE_HEIGHT], "Gold", "Engduino");
}

customColorCase();
customColorCaseCover();
