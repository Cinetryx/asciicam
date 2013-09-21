/**
 * ASCII cam
 * 
 * Converts the video feed from the webcam to a ascii video version.
 * The brightness is done with a custom ramp function where letters match the brightness of the pixel.
 * 
 * Denis Foo Kune, December 2007, revised December 2012.
 *
 * Note:  I could also use a "noloop()" and respond to events.  It might be more efficient, but this way is cleaner.
 *
 */
 
import processing.video.*;

PFont fontA; // Stores the appropriate fiexed-width font, that works for the hard-coded ramp function
Capture cam; // The camera object
char ramp[]; // Stores the characters to be mapped to the brightness
int text_width  = 80; 
int text_height = 60;
int cam_width  = 80; // Reduced camera size.  Aspect ratio has to match a resolution supported by the camera!
int cam_height = 60; // Reduced camera size.  Aspect ratio has to match a resolution supported by the camera!

// Big enough for an 80x60 character matrix, with 20 pixel margins (and -10 for an extra character)
int window_width = 830;
int window_height = 630;

void setup() 
{
  size(window_width, window_height); 
  background(255); // White background
  
  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. A font must first be created
  // using the 'Create Font...' option in the Tools menu.
  fontA = loadFont("Courier-12.vlw");
  textFont(fontA, 12);
  textAlign(CENTER);
  
  // Cleans out the array, just in case.
  ramp = new char[40];  
  for (int i=0; i<40; i++){
    ramp[i] = ' ';
  }
  
  ramp[0] = 'M'; // black
  ramp[1] = '@';
  ramp[2] = 'W';
  ramp[3] = 'B';
  ramp[4] = '0';
  ramp[5] = '8';
  ramp[6] = 'Z';
  ramp[7] = 'a';
  ramp[8] = '2';
  ramp[9] = 'S';
  ramp[10] = 'X';
  ramp[11] = '7';
  ramp[12] = 'r';
  ramp[13] = ';';
  ramp[14] = 'i';
  ramp[15] = ':';
  ramp[16] = ',';
  ramp[17] = '.';
  ramp[18] = ' ';
  ramp[19] = ' '; // white
  
  // Get a list of cameras and grab the first one available
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // Selects the default camera, and asks for a reduced resolution.
    cam = new Capture(this, cam_width, cam_height);
    cam.start();     
  }      
} 

void draw() 
{
  // Clears the screen, wiping out the previous frame
  fill(255);
  rect(0,0, width, height);
  
  // Set the margins and the inter-character gaps
  translate(20, 20);
  int gap = 10;
  
  // Reads an image from the camera
  if (cam.available() == true) {
    cam.read();
  }
  
  // DEBUG:  Displays what the camera sees on the top left corner.
  //image(cam, 0, 0);

  fill(0); // Sets the color of the font
  // picks out selected pixels and maps the corresponding character.
  for(int i = 0;i<text_height;i++)
  {
    for(int j = 0;j<text_width;j++)
    {
      color c = cam.get(j, i);// Calculates the brighness from 0 to 255.
      char dot = ramp[int(brightness(c)/8)]; // Maps the brightness to the corresponding character on the ramp.  
                                             // The division by 8 causes the brightness to saturate early.  It looks better that way.  
                                             // The actual 20 level ramp requires a division by 6.4.
      text(dot, j*gap, i*gap); // Draw the letter to the screen
    }
  }  
}

