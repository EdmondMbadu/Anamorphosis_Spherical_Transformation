 class IMAGES_COORDINATES{
  PImage frog= loadImage("saphir1.jpg");
   //PImage intermediary;
   ArrayList<PVector> Points= new ArrayList<PVector>();
     ArrayList<PVector> sphere_coordinates= new ArrayList<PVector>();
   ArrayList<PVector>IColors= new ArrayList<PVector>();
 int incrementX=100;
 int incrementY=100;
 
 
 // the constructor that initializes the shapes and coordinates of theh sphere 
IMAGES_COORDINATES(){
  
 // get all the data of the of the frog image and save it to the img array
 // make the with half its size, and in order to scale it pass the argument 0
 // for the height
 
 frog.resize(frog.width/5,0);
 
 for(int i=0; i<frog.width; i++){
   for(int j=0; j< frog.height; j++){
     // translate and rotate the image , and move it a little left 
     // these value are completely aribitrary 
       Points.add(new PVector(i-200,-0,j+50));
   }
 }
 
 frog.loadPixels();
 
  for(int i=0; i<frog.width; i++){
   for(int j=0; j< frog.height; j++){
      
     int location=i+j*(frog.width);
     float r=red(frog.pixels[location]);
     float g=green(frog.pixels[location]);
     float b=blue(frog.pixels[location]);
     IColors.add(new PVector(r,g,b));
   }
 }
 

 
 //Calculate();
 
 
 }
 
 
   
   // this methods retuns the poins in the arraylist of vectos that will be used later
   
ArrayList<PVector> Sphere_Image_Coordinates(){
     return sphere_coordinates;
}
// this method returns the coordinates of the image within the sphere 
ArrayList<PVector> Image_Within_Sphere(){
     return Points;
}
// this method returns the pixel information of the image 
ArrayList<PVector> Pixels(){
     return IColors;
}
   
 
 

// This method calculatest the coordinates of the points 
// that corresponds the the position of the image coordinates
//on the surface of the sphere 
 void Calculate(){
  
   int total=60;
   for(int i=0; i<Points.size(); i++){
     PVector v =Points.get(i);
     //stroke(255);
     
     
     // to be honest, this is a piece of a code that I have yet to understant 
     // myself. It arrose out of an error. 
    float lat= map(v.x, width, total, -PI/3, PI/3);

    float lon = map(v.y, 100, height, -2, 0);
      
     float theta=lon;
     float fi=acos(lat);
      float x = Radius*sin(theta)*cos(fi);
      float y= Radius*sin(theta)*sin(fi);
      float z= Radius*cos(theta);
     // save the coordinate inside the arraylist of vector 
    sphere_coordinates.add(new PVector(x,y,z));
 
  } 
 }
 
 // This method display the image at the center of the screen
 void LetDraw(){
   for(int i=0; i<Points.size(); i++){
      stroke(IColors.get(i).x,IColors.get(i).y,IColors.get(i).z);
      //strokeWeight(8);
      //point(sphere_coordinates.get(i).x, sphere_coordinates.get(i).y,
      //sphere_coordinates.get(i).z);
       point(Points.get(i).x, Points.get(i).y,
      Points.get(i).z);
   }
 
 }
 
 
 }
