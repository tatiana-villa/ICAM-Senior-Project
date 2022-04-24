// import the fingertracker library
// and the SimpleOpenNI library for Kinect access
import fingertracker.*;
import SimpleOpenNI.*;
import fullscreen.*; 
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
Kinect kinect1;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

// declare FignerTracker and SimpleOpenNI objects
FingerTracker fingers;
SimpleOpenNI kinect;
// set a default threshold distance:
// 625 corresponds to about 2-3 feet from the Kinect
int threshold = 625;

void setup() {
  
  //initialize your SimpleOpenNI object
  // and set it up to access the depth image
  kinect = new SimpleOpenNI(this);
  frameRate(5);
  kinect.enableDepth();
  // mirror the depth image so that it is more natural
  kinect.setMirror(true);
  oscP5 = new OscP5(this,12003);
  myRemoteLocation = new NetAddress("127.0.0.1",12003);
  // initialize the FingerTracker object
  // with the height and width of the Kinect
  // depth image
  fingers = new FingerTracker(this, 640, 480);
  // the "melt factor" smooths out the contour
  // making the finger tracking more robust
  // especially at short distances
  // farther away you may want a lower number
  fingers.setMeltFactor(100);
}

void draw() {
  // get new depth data from the kinect
  kinect.update();
  
  // get a depth image and display it
 // PImage depthImage = kinect.depthImage();
 // image(depthImage, 0, 0, width, height);
  // we'll look for fingers
  fingers.setThreshold(threshold);
  
  // access the "depth map" from the Kinect
  // this is an array of ints with the full-resolution
  // depth data (i.e. 500-2047 instead of 0-255)
  // pass that data to our FingerTracker
  int[] depthMap = kinect.depthMap();
  fingers.update(depthMap);
 
    //for (int k = 0; k < fingers.getNumFingers(); k++) {
    // PVector position = fingers.getFinger(k);
    // if(position != null){
    //   sendOSC(position.x, position.y, position.x + 1/2, position.y + 1/2, position.x + 5/6, position.y + 5/6);
    // }
    //}
    
    PVector position = fingers.getFinger(0); 
     
    if(position != null){
       sendOSC(position.x, position.y);
     }
    
}

void sendOSC(float ff1x, float ff1y){
  OscMessage myMessage = new OscMessage("/fingers");
  
  myMessage.add(ff1x); /* add a float to the osc message */
  myMessage.add(ff1y);
  
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}  
