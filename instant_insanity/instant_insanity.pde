import java.util.Map;
import java.util.ArrayList;
import java.util.HashSet;

class Edge
{
  public Vertex V;
  public int CubeNumber;
  
  Edge(Vertex v, int cubeNumber) {
    V = v;
    CubeNumber = cubeNumber;
  }
}

class Vertex
{
  public color Value;
  public ArrayList<Edge> Edges;
  
  Vertex(color value)
  {
    Value = value;
    Edges = new ArrayList<>();
  }
  
  void Print() {
    println(NumToText(Value));
    for (int i = 0; i < Edges.size(); i++)
    {
      print("    ");
      print(NumToText(Edges.get(i).V.Value));
      print("    ");
      println(Edges.get(i).CubeNumber + 1);
    }
  }
}


//Index pairs are: (0-1) left and right, (2-3) bottom and top, (4-5) front and back
class Cube
{
  public int X;
  public int Y;
  public int Z;
  public int Size;
  public color[] Colors; 
  
  
  Cube(int x, int y, int z, int size, color[] colors)
  {
    X = x;
    Y = y;
    Z = z;
    Size = size;
    Colors = colors;
  }
  
  void Draw() {
    
    pushMatrix();
    stroke(255);
    
    //Left side
    pushMatrix();
    translate(X - Size / 2, Y, Z);
    fill(Colors[0]);
    box(1, boxSize, boxSize);
    popMatrix();
    
    //Right side
    pushMatrix();
    translate(X + Size / 2, Y, Z);
    fill(Colors[1]);
    box(1, boxSize, boxSize);
    popMatrix();
    
    //Top side
    pushMatrix();
    translate(X, Y - Size / 2, Z);
    fill(Colors[2]);
    box(boxSize, 1, boxSize);
    popMatrix();
    
    //Bottom side
    pushMatrix();
    translate(X, Y + Size / 2, Z);
    fill(Colors[3]);
    box(boxSize, 1, boxSize);
    popMatrix();
    
    //Front side
    pushMatrix();
    translate(X, Y, Z - Size / 2);
    fill(Colors[4]);
    box(boxSize, boxSize, 1);
    popMatrix();
    
    //Back side
    pushMatrix();
    translate(X, Y, Z + Size / 2);
    fill(Colors[5]);
    box(boxSize, boxSize, 1);
    popMatrix();
    
    popMatrix();
    
  }
}

String NumToText(int number) { 
  if(number == -65536) return "Red";
  if(number == -16711936) return "Green";
  if(number == -16776961) return "Blue";
  if(number == -13312) return "Yellow";
  
  return "Something bad happened!";
}

HashSet<Character> keysPressed = new HashSet<Character>();
HashSet<Integer> keyCodesPressed = new HashSet<Integer>();

void setup() {

  size(400,400,P3D);

  camX = width / 2;
  camY = height / 2;
  
  color[] faceColors = new color[] { color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 204, 0) };
  
  cubes = new Cube[4];
  int spacing = 20;
  for(int i = 0; i < 4; i++) {
    cubes[i] = new Cube(0, i * (boxSize + spacing), 0, boxSize, GenerateRandomColorSet(faceColors));
  }
  
  //Debug:
  cubes[0].Colors = SetUpCube1();
  cubes[1].Colors = SetUpCube2();
  cubes[2].Colors = SetUpCube3();
  cubes[3].Colors = SetUpCube4();

  
  //Setup verticies
  Vertex[] verticies = new Vertex[faceColors.length]; //Every vertex represents a color
  HashMap<Integer, Vertex> colorToVertex = new HashMap<Integer, Vertex>();
  
  for(int i = 0; i < verticies.length; i++)
  {
    verticies[i] = new Vertex(faceColors[i]);
    colorToVertex.put(faceColors[i], verticies[i]);
  }
  
  //For every cube set up edges
  for (int i = 0; i < cubes.length; i++)
  {
      if(cubes[i] == null) continue;
    //Look at the pairs of colors and set up edges
    for(int j = 0; j < cubes[i].Colors.length; j += 2){
      //adjacent indexes are pairs
      
      
      color c1 = cubes[i].Colors[j];
      color c2 = cubes[i].Colors[j + 1];
      
      Vertex v1 = colorToVertex.get(c1);
      Vertex v2 = colorToVertex.get(c2);
      
      v1.Edges.add(new Edge(v2, i));
    }
  }
  
  //Debug:
  for(int i = 0; i < verticies.length; i++) {
      verticies[i].Print();
   }
}

color[] GenerateRandomColorSet(color[] faces)
{
  color[] colors = new color[6];
  for(int i = 0; i < 6; i++)
  {
    colors[i] = faces[int(random(0, faces.length))];
  }
  return colors;
}

int camX;
int camY; 

int boxSize = 100;

Cube[] cubes;

float rotationX = PI;
float rotationY = 0;
float rotationZ = 0;

void keyReleased(){
  keysPressed.remove(key);
  keyCodesPressed.remove(keyCode);
}

void keyPressed() {
  
  if(keysPressed.contains(key)) return;
  keysPressed.add(key);

  if(keyCodesPressed.contains(keyCode)) return;
  keyCodesPressed.add(keyCode);
}

void HandleNormalKeys() {
  
  for (Character cur : keysPressed) {
    
    if(cur == 'w') {
      camY += 5;
    }
    else if(cur == 's') {
      camY -= 5;
    }
    else if(cur == 'a') {
      camX += 5;
    }
    else if(cur == 'd') {
       camX -= 5;
    }
  
  }
}

void HandleSpecialKeys() {
  
  for (Integer cur : keyCodesPressed) {
    
    if(cur == LEFT) {
      rotationY += 0.1f;
    }
    else if(cur == RIGHT) {
      rotationY -= 0.1f;
    }
  
  }
}

void draw() {

  HandleNormalKeys();
  HandleSpecialKeys();
  
  background(0);
  camera(width / 2, height / 2, (height/2) / tan(PI/6), width / 2, height / 2, 0, 0, 1, 0);
  translate(camX, camY, -100);
  
  textSize(128);
  
  pushMatrix();
  rotateX(rotationX);
  rotateY(rotationY);
  rotateZ(rotationZ);
  
  for(int i = 0; i < cubes.length; i++) {
    if(cubes[i] == null) continue;
    cubes[i].Draw();
  }
  popMatrix();
  
  
}
