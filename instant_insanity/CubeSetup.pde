color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color green = color(0, 255, 0);
color yellow = color(255, 204, 0);

//Index pairs are: (0-1) left and right, (2-3) bottom and top, (4-5) front and back

color[] SetUpCube1()
{   
   return new color[] { red, red, yellow, blue, red, green };
}

color[] SetUpCube2()
{
  return new color[] { red, yellow, yellow, green, red, blue };
}

color[] SetUpCube3()
{
  return new color[] { green, green, blue, yellow, blue, red };
}

color[] SetUpCube4()
{
  return new color[] { blue, yellow, yellow, green, green, red };
}
