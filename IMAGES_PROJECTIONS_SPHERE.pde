import peasy.*;
import processing.pdf.*;
// the vector out
ArrayList<PVector>U= new ArrayList<PVector>();
// the unit normal vector
ArrayList<PVector>N= new ArrayList<PVector>();
// the vector in 
ArrayList<PVector>V= new ArrayList<PVector>();

float Radius=500;

// the size of the box 
float boxSize=1000;
// this array holds the coordinates of the interscecion of the plane and 
// the vector U that is obtained directly after applying the laws of reflection
// IN short, the array holds the coordinates of the final vector
ArrayList<PVector>IMAGEXYZ= new ArrayList<PVector>();
// this value is the T of the parametrique equation of a line
ArrayList<Float> T= new ArrayList<Float>();
// this array list holds the pixel (rgb) information of the image
ArrayList<PVector> image_pixel= new ArrayList<PVector>();

// this array list holds the coordinate of where the image lies on the surface of the sphere
ArrayList<PVector>lie_Sphere= new ArrayList<PVector>();

PeasyCam cam;
//PImage frog= loadImage("frog.png");

// Image size
// this is not most efficient way of scaling an image. but hey it's definetily 
// a short cut 
float imageX=00;
float imageY=200;
// these values hold the postion of the eye 
float X=0;
float Y=-2000;
float Z=0;
IMAGES_COORDINATES co;
PVector eye= new PVector(X,Y,Z);
 //LOVE l;
PVector[][]globe;
PVector[][]gLove;
int total=50;
void setup(){
  size(2000,2000, P3D);
  //frog= loadImage("frog.jpg");
  
  //beginRecord(PDF,"everything.pdf");
  cam= new PeasyCam(this, 2000);
  co= new IMAGES_COORDINATES();
  // get the data pixels of the image
  image_pixel=co.Pixels();
  
  // this method finds the intersection of the sphere and the image relative to the viewer(eye)
  Intersection_Sphere_Image();
  
  globe= new PVector[total][total];
  computeSphere();
//gLove= new PVector[l.data().size()][l.data().size()];

//compute the normal vector 
// this method is in set up because I do no want to continuously compute the value  of the normal and U vectors (directional vector)
FindN_U();


// compute theh coordianate of where the letters LOVE will land on the plane 
IMAGEXYZ();
}

void draw(){
   background(0);

stroke(255);
//frameRate(5);
noFill();

 box(boxSize);
 EYE();

 drawSphere();
 //Intersection_Sphere_Image();

co.LetDraw();
//DrawSurface();


   
 Display_Image();
  
}

void computeSphere(){
 for (int i=0; i<total; i++){
    float lat= map(i, 0, total, -HALF_PI, HALF_PI);
   
    for(int j=0; j<total; j++){
    float lon = map(j, 0, total, -PI, PI);
      
      float x = Radius*sin(lon)*cos(lat);
      float y= Radius*sin(lon)*sin(lat);
      float z= Radius*cos(lon);
      globe[i][j]=new PVector(x,y,z);
     
    }
  }
}

void drawSphere(){
  for (int i=0; i<total; i++){ 
    for(int j=0; j<total; j++){
   
     PVector v=globe[i][j];
      stroke(255);
      strokeWeight(4);
      point(v.x,v.y,v.z);
    }
  }
  
}



// this method finds the final coordinate of where the letter of the image lands on the plane
void IMAGEXYZ(){
//IMAGES_COORDINATES im= new IMAGES_COORDINATES();
  // this value hold the position of the plane 
  float zPlane=boxSize/2;
// These are where the points of the image lands on the surface of the sphere
  //ArrayList<PVector> data= im.Sphere_Image_Coordinates();
  for(int i=0; i<lie_Sphere.size(); i++){
    T.add((zPlane-lie_Sphere.get(i).z)/U.get(i).z);
    //System.out.println((zPlane-lie_Sphere.get(i).z)/U.get(i).z);
  }
  
  // find the find coordinate of LOVE and where it lands on the plane
  for(int i=0; i<lie_Sphere.size();i++){
    float x=lie_Sphere.get(i).x+(T.get(i)*U.get(i).x);
    float y=lie_Sphere.get(i).y+(T.get(i)*U.get(i).y);
    float z=lie_Sphere.get(i).z+(T.get(i)*U.get(i).z);
    IMAGEXYZ.add(new PVector(x,y,z));
     if(i==7000){
        stroke(0);
        strokeWeight(20);
      point(x,y,z);
      strokeWeight(5);
      
      }
  }
  
  
  
  
}

void Display_Image(){
  loadPixels();
  // this byte array will be used to write to a file so that the coordinates will be access later 
  String[] Xcoordinates=new String[IMAGEXYZ.size()];
  String[] Ycoordinates=new String[IMAGEXYZ.size()];
  String[]red= new String[IMAGEXYZ.size()];
  String[]green= new String[IMAGEXYZ.size()];
  String[]blue= new String[IMAGEXYZ.size()];
  for(int i=0; i<IMAGEXYZ.size(); i++){
     stroke(image_pixel.get(i).x,image_pixel.get(i).y,image_pixel.get(i).z); 
     
     stroke(image_pixel.get(i).x,image_pixel.get(i).y,image_pixel.get(i).z); 
     point(IMAGEXYZ.get(i).x,IMAGEXYZ.get(i).y,IMAGEXYZ.get(i).z);
     
     //int px= (int) IMAGEXYZ.get(i).x;
     // int py= (int) IMAGEXYZ.get(i).y;
     //int pz= (int) IMAGEXYZ.get(i).x;
     //float r=red(frog.pixels[location]);
     //float g=green(frog.pixels[location]);
     //float b=blue(frog.pixels[location]);
     //while(
     
     // this is a interesting piece of code. It checks the pixel of the element next to it. If it black, 
     // it replaces with the same pixel then its neigbor
     
     
     // this a beautiful way to convert a float to a string. This is done by converting first the float to an object, 
     //then convert it to a string value since every object has a to string method
     // with that we can store everything infomration into a file, and then we will extract it 
     Float r= new Float(image_pixel.get(i).x);
     Float g= new Float(image_pixel.get(i).y);
     Float b= new Float(image_pixel.get(i).z); 
     Float fx= new Float(IMAGEXYZ.get(i).x);   
     Float fy= new Float(IMAGEXYZ.get(i).y);   
     Xcoordinates[i]=fx.toString();
     Ycoordinates[i]=fy.toString();
     red[i]=r.toString();
     green[i]=g.toString();
     blue[i]=b.toString();
  }
  saveStrings("Xcoordinates.txt",Xcoordinates);
  saveStrings("Ycoordinates.txt",Ycoordinates);
  saveStrings("RedData.txt", red);
  saveStrings("GreenData.txt", green);
  saveStrings("BlueData.txt",blue);
}

// this method finds the vector U and the vector N (normal vector)
void FindN_U(){
 
  // the values in the arraylist data represents the postions of the the letters LOVE on the surface of the sphere 
  //ArrayList<PVector>data= ic.Sphere_Image_Coordinates();
  // fill the arraylist that contains the vector V
  for(int i=0; i<lie_Sphere.size(); i++){
    V.add(new PVector(eye.x-lie_Sphere.get(i).x,eye.y-lie_Sphere.get(i).y,eye.z-lie_Sphere.get(i).z));
     if(i==7000){
        stroke(255);
        strokeWeight(3);
      line(lie_Sphere.get(i).x, lie_Sphere.get(i).y,lie_Sphere.get(i).z,eye.x,eye.y,eye.z);
      
      }
  }
  
  // populate the normal vector 
  for (int i=0; i<lie_Sphere.size(); i++){
    // we are looking for the normal vector 
    // since it is a sphere the partial derivative is 2x,2y,2x
    
   float Nx=2*lie_Sphere.get(i).x;
   float Ny=2*lie_Sphere.get(i).y;
   float Nz=2*lie_Sphere.get(i).z;
   
   // now normalize those values 
   //Nx=Nx/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   //Ny=Ny/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   //Nz=Nz/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   // add these values in the arraylist of PVector
   N.add(new PVector(Nx,Ny,Nz));
    if(i==7000){
        stroke(0,0,255);
        strokeWeight(3);
      line(lie_Sphere.get(i).x,lie_Sphere.get(i).y,lie_Sphere.get(i).z,2*Nx,2*Ny,2*Nz);
      
      }
  }
  
  // find the reflection vector 
  
  // We are going to do it step by step
  
   for(int i=0 ; i<lie_Sphere.size(); i++){
       // the variable A will hold the value of the numerator of the the multiplication of
   // V.N the dot product of V and N
   
     float A= (V.get(i).x*N.get(i).x)+(V.get(i).y*N.get(i).y)+(V.get(i).z*N.get(i).z);
     // the variable B will hold the value of the dot product of N.N
    float B= (N.get(i).x*N.get(i).x)+(N.get(i).y*N.get(i).y)+(N.get(i).z*N.get(i).z);
    // C will hold the quotient of A over B
    float C=A/B;
    //the variable D will hole -V+2Cn
    //float D= (V.get(i).x*-1)+2*(C*N.get(i).x);
    
    // let now find the vector U searched 
    
    U.add(new PVector((V.get(i).x*-1)+2*(C*N.get(i).x),
    (V.get(i).y*-1)+2*(C*N.get(i).y),(V.get(i).z*-1)+2*(C*N.get(i).z)));
    if(i==7000){
        stroke(255,0,0);
        strokeWeight(3);
      line(lie_Sphere.get(i).x, lie_Sphere.get(i).y,lie_Sphere.get(i).z,lie_Sphere.get(i).x+U.get(i).x,lie_Sphere.get(i).y+U.get(i).y,lie_Sphere.get(i).z+U.get(i).z);
      
      }
   }
}


// this method finds the intersection of the image (inside the sphere) and theh eye and and the surface of the sphere 
// to do that, draw line connecting the image and the eye, and mark the intersection of the line and surface of the sphere as the point we are looking for 
void Intersection_Sphere_Image(){
 
  // this vector contains the point- poisition of the image
  ArrayList<PVector>Points= co.Image_Within_Sphere();
  // First find the direction vector that will help in parametrizing the line of intersection of the spere and the line.
  // since we are looking the projection of 
  ArrayList<PVector>Directions= new ArrayList<PVector>();
  for(int i=0; i<Points.size(); i++){
    // find the directions for evevery vector and add it to the arraylist 
      Directions.add(new PVector(Points.get(i).x-eye.x,Points.get(i).y-eye.y,Points.get(i).z-eye.z));
      if(i==30000){
        stroke(255);
        strokeWeight(3);
      line(Points.get(i).x, Points.get(i).y,Points.get(i).z,eye.x,eye.y,eye.z);
      
      }
      
  }
  
  // this array list will contain the coordinates of the parameter T
  ArrayList<Float>T1= new ArrayList<Float>();
  
  for(int i=0; i<Directions.size(); i++){
    
    // these equations are to find the intersection of the image and the sphere 
    // I already computed them on a piece of paper, and broke them to simplify the computation
    float C1=pow(Points.get(i).x,2)+pow(Points.get(i).y,2)+pow(Points.get(i).z,2);
    float C2=pow(Directions.get(i).x,2)+pow(Directions.get(i).y,2)+pow(Directions.get(i).z,2);
    float C3=2*((Points.get(i).x*Directions.get(i).x)+(Points.get(i).y*Directions.get(i).y)+(Points.get(i).z*Directions.get(i).z));
    float C= pow(Radius,2);
    float C4=C1-C;
    // this is the solving a quadratic equation to find T
    float A=sqrt((pow(C3,2)-4*C2*C4));
    float solution=(-1*C3-A)/(2*C2);
    T1.add(solution);
   
  }
  
  
  for (int i=0; i<Directions.size(); i++){
    // get the coordinates of the x value where the image lies on the surface of the sphere 
    float xc=Points.get(i).x+T1.get(i)*Directions.get(i).x;
    float yc=Points.get(i).y+T1.get(i)*Directions.get(i).y;
    float zc=Points.get(i).z+T1.get(i)*Directions.get(i).z;
    
    lie_Sphere.add(new PVector(xc,yc,zc));
    // attempting to find the intersection of the image inside the sphere and the eye
     //if(test.x==Points.get(i).x&&test.y==Points.get(i).y&&test.x==Points.get(i).z){
        //stroke(255,0,0);
        //strokeWeight(3);
        //point(xc,yc,zc); 
      //}
    
  }
}


// this method draws the image on the surface of the sphere 
void DrawSurface(){
  for(int i=0; i<lie_Sphere.size();i++){
   stroke(image_pixel.get(i).x,image_pixel.get(i).y,image_pixel.get(i).z); 
    point(lie_Sphere.get(i).x,lie_Sphere.get(i).y,lie_Sphere.get(i).z);
  }
}
// this method draws the eye that sees everything 
  void EYE(){
    PVector eye= new PVector(X,Y,Z);
    // the actual 3D coordinate of the eye 
  
  // PushMatrix and PopMatrix are used to contain the transformation within this scope 
  pushMatrix();
  translate(X,Y,Z);
  // rotate the ellipse to emphasize the position of the eye 
  rotateX(PI/2); 
  stroke(0,255,255);
  // draw the ellipse with a radius iof 5
  ellipse(0,0, 20,20);
  //fill(0);
  popMatrix();
  // draw a point at the position of the eye 
  // to emphasize the position of the eye
  point(eye.x,eye.y,eye.z);
}


// draw a quadrilateral 
void Quad(){
   pushMatrix();
  translate(-600,-900,400);
  fill(255);
  quad (0, 0, 800, 0, 800, 800,0, 800);
   popMatrix();
}
