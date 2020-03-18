import processing.sound.*;
import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

SoundFile launch;
SoundFile pop;
SoundFile pad1;
SoundFile pad2;
SoundFile pad3;
SoundFile pad4;
SoundFile pad5;
SoundFile pad6;
SoundFile st;
SoundFile beep;

Box2DProcessing world;
PImage bg, city, mountains, title, button, comeback, exitbutton, instruction, mute, nomute;
ArrayList <Cohete> cohetes;
ArrayList <GParticulas> lights;
color cp = color(random(255), random(255), random(255));
Vec2 pe;
boolean instr = true;
int screen = 0;
float alp;
boolean muteSong = false;

void setup()
{ 
  size(1024,600);
  
  world = new Box2DProcessing(this);
  world.createWorld();
  
  cohetes = new ArrayList <Cohete>();
  lights = new ArrayList<GParticulas>();
  
  launch = new SoundFile(this, "launch.wav");
  pop = new SoundFile(this, "pop.wav");
  pad1 = new SoundFile(this, "pad1.wav");
  pad2 = new SoundFile(this, "pad2.wav");
  pad3 = new SoundFile(this, "pad3.wav");
  pad4 = new SoundFile(this, "pad4.wav");
  pad5 = new SoundFile(this, "pad5.wav");
  pad6 = new SoundFile(this, "pad6.wav");
  st = new SoundFile(this, "the_sea.wav");
  beep = new SoundFile(this, "beep.wav");
  
  bg = loadImage("bg.jpg");
  bg.resize(1024, 600);
  
  city = loadImage("city.png");
  city.resize(1024, 600);
  
  mountains = loadImage("mountains.png");
  mountains.resize(1024, 600);
  
  title = loadImage("title.png");
  title.resize(1024, 0);
  
  button = loadImage("button.png");
  button.resize(180,0);
  
  comeback = loadImage("comeback.png");
  comeback.resize(70, 0);
  
  exitbutton = loadImage("exitbutton.png");
  exitbutton.resize(70, 0);
  
  instruction = loadImage("instruction.png");
  instruction.resize(1024, 0);
  
  mute = loadImage("mute.png");
  mute.resize(70, 0);
  
  nomute = loadImage("nomute1.png");
  nomute.resize(70, 0);
  
  st.loop();
}

void draw()
{ 
  imageMode(CENTER);
  image(bg, 512, 300);
  image(mountains, 512, 300);
  
  world.step();

  switch(screen)
  {
    case 0:
    float dbm1 = dist(mouseX, mouseY, 512, 380);
    float dbm2 = dist(mouseX, mouseY, 964, 60);

    image(title, 512, 200);
    
    if(dbm1 <= 95)
    image(button, 512, 380, 190, 190);
    else
    image(button, 512, 380, 180, 180);
    
    if(dbm2 <= 35)
    image(exitbutton, 964, 60, 75, 75);
    else
    image(exitbutton, 964, 60, 70, 70);
    
    for (int i = cohetes.size()-1; i >= 0; i--) 
    {
      cohetes.remove(i);
    }
    for (int i = lights.size()-1; i >= 0; i--)
    {
      lights.remove(i);
    }
    
    break;
    
    case 1:
    
    float dbm3 = dist(mouseX, mouseY, 60, 60);
    float dbm4 = dist(mouseX, mouseY, 964, 60);
    
    if(dbm3 <= 35)
    image(comeback, 60, 60, 75, 75);
    else
    image(comeback, 60, 60, 70, 70);
    
    if(dbm4 <= 35 && mousePressed == false || mouseButton == RIGHT)
    {
      if(muteSong)
      image(nomute, 964, 60, 75, 75);
      else
      image(mute, 964, 60, 75, 75);
    }
    else
    {
      if(muteSong)
      image(nomute, 964, 60, 70, 70);
      else
      image(mute, 964, 60, 70, 70);
    }
    
    
    for(Cohete c: cohetes)
    {
      c.display();
      pe = c.pExplosion();
    }
    
    for (int i = cohetes.size()-1; i >= 0; i--) 
    {
      Cohete c = cohetes.get(i);
      c.display();
    
      if (c.borrarCohete()) 
      {
        lights.add(new GParticulas(c.pExplosion()));
        cohetes.remove(i);
      }
    }
  
    for (GParticulas x: lights) 
    {
      x.iniciar();
    }
  
    for (int i = lights.size()-1; i >= 0; i--) 
    {
      GParticulas gp = lights.get(i);
    
      if (gp.borrarGrupo()) 
      {
        lights.remove(i);
      }
    }
    break;
  }
  
  image(city, 512, 300);
  
  if(instr == true && screen == 1)
  image(instruction, 512, 580);
}

void mousePressed()
{
  float dbm1 = dist(mouseX, mouseY, 512, 380);
  float dbm2 = dist(mouseX, mouseY, 964, 60);
  float dbm3 = dist(mouseX, mouseY, 60, 60);
  
  if(mouseY >= 560 && mouseButton == LEFT && screen == 1)
  {
    cohetes.add(new Cohete(mouseX, 585, 2, 10));
  }
  
  if(screen == 0 && dbm1 < 95 && mouseButton == LEFT)
  {
    beep.play();
    screen = 1;
  }
  
  if(screen == 0 && dbm2 < 35 && mouseButton == LEFT)
  {
    exit();
    beep.play();
  }
  
  if(screen == 1 && dbm3 < 35 && mouseButton == LEFT)
  {
    screen = 0;
    instr = true;
    beep.play();
    
    if(muteSong)
    {
      muteSong = false;
      st.loop();
    }    
  }
  
  if(screen == 1 && mouseButton == LEFT && dbm2 < 35 && muteSong == false)
  {
    muteSong = true;
    st.stop();
    beep.play();
  }
  else if(screen == 1 && mouseButton == LEFT && dbm2 < 35 && muteSong)
  {
    muteSong = false;
    st.loop();
    beep.play();
  }
  if(screen == 1 && instr == true && mouseY >= 560 && mouseButton == LEFT)
  {
    instr = false;
  }
  
}

//Objeto Cohete.______________________________________________________________________

class Cohete
{
  float w;
  float h;
  float inclinacion = random(-5, 5);
  
  Body b;  

  Cohete(float x_, float y_, float w_, float h_)
  {
    w = w_;
    h = h_;
    BodyDef bd = new BodyDef();
    
    launch.play();
    
    Vec2 posicionInicial = new Vec2(x_,y_);
    Vec2 posicionEnEscalaBox2d = world.coordPixelsToWorld(posicionInicial);
    bd.position.set(posicionEnEscalaBox2d);

    bd.type = BodyType.DYNAMIC;
    
    b = world.createBody(bd);
    
    b.setLinearVelocity(new Vec2(inclinacion,30));
    b.setAngularVelocity(inclinacion*-0.06);
    
    PolygonShape ps = new PolygonShape();
    float ancho = world.scalarPixelsToWorld(w_);
    float alto = world.scalarPixelsToWorld(h_);
    ps.setAsBox(ancho/2,alto/2);

  }
  
  Vec2 pExplosion()
  {
    Vec2 pos = world.getBodyPixelCoord(b);
    
    return pos;
  }
  
  void destruir() 
  {
    Vec2 pos = world.getBodyPixelCoord(b);
     
    noStroke();
    fill(255, 10);
    rect(width/2, height/2, width, height);
    fill(255);
    ellipse(pos.x, pos.y, random(30, 40), random(30, 40));
    
    world.destroyBody(b);
  }
  
  boolean borrarCohete() 
  {
    Vec2 pos = world.getBodyPixelCoord(b);
    
    if (pos.y < 170) 
    {
      destruir();
      return true;
    }
    return false;
  }
  
  void display()
  {
    Vec2 pos = world.getBodyPixelCoord(b);
    float a = b.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    rectMode(CENTER);
    strokeWeight(4);
    stroke(255,192, 128, 50);
    fill(255,192, 128);    
    rect(0,0,w,h,50);
    popMatrix();
  }
}

//Grupo de objetos Partícula._________________________________________________________

class GParticulas
{
  Particula [] particulas = new Particula [100];
  Vec2 posExp;
  float r = random(100, 255), g = random(100, 255), b = random(100, 255);
  float ss = random(0, 6);

  GParticulas(Vec2 posExp_)
  {
    posExp = posExp_;
    pop.play();
    
    for(int i = 0; i < particulas.length; i++)
    {
      particulas [i] = new Particula(posExp.x, posExp.y, random(1, 2), r, g, b);
    }
    
    switch((int) ss)
    {
      case 0:
      pad1.play();
      break;
      
      case 1:
      pad2.play();
      break;
      
      case 2:
      pad3.play();
      break;
      
      case 3:
      pad4.play();
      break;
      
      case 4:
      pad5.play();
      break;
      
      case 5:
      pad6.play();
      break;
      
      case 6:
      pad6.play();
      break;
    }
    
  }
  
  void iniciar()
  {
    for(int i = 0; i < particulas.length; i++)
    {
      particulas [i].display();
    }
  }
  
  
  boolean borrarGrupo() 
  {
    for(int i = 0; i < particulas.length; i++)
    {
      if(particulas[i].borrarParticula())
      {
        return true;
      }
    }
    return false;
  }
}

//Objeto Partícula.___________________________________________________________________

class Particula
{
  float x, y;
  float r;
  float at = 255;
  float cr, cg, cb;
  boolean delete = false;
  
  Body b;
  
  Particula(float x_, float y_, float r_, float cr_, float cg_, float cb_)
  {
    r = r_;
    cr = cr_;
    cg = cg_;
    cb = cb_;

    BodyDef bd = new BodyDef();
    
    Vec2 posicionInicial = new Vec2(x_,y_);
    Vec2 posicionEnEscalaBox2d = world.coordPixelsToWorld(posicionInicial);
    bd.position.set(posicionEnEscalaBox2d);

    bd.type = BodyType.DYNAMIC;
    
    b = world.createBody(bd);
    
    b.setLinearVelocity(new Vec2(random(-15, 15),random(-15, 15)));
    
    CircleShape cs = new CircleShape();
    cs.m_radius = world.scalarPixelsToWorld(r);
  }
  
  void destruir() 
  {
    world.destroyBody(b);
  }

  boolean borrarParticula() 
  {
    if (at <= 0) 
    {
      destruir();
      return true;
    }
    return false;
  }
    
  void display()
  {
    Vec2 pos = world.getBodyPixelCoord(b);
   
    if(at > 0)
    at -= 2;
    
    pushMatrix();
    strokeWeight(2);
    stroke(cr, cg, cb, at);
    fill(255, at);
    ellipse(pos.x, pos.y, r*2, r*2);
    popMatrix();
  }
}
