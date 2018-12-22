/* Inspired by the speedrun clocks used in recent Games Done Quick marathons.
   I wanted to make my own little speedrun timer with a cool animated background.
   Going to use this for an upcoming Christmas party where a couple of
   my friends are doing a speedrun race.
 */

import java.util.Date;
Date date = new Date();
void setup() {
  size(1000, 200, P3D);
  ortho(-500, 500, 100, -100);
  colorMode(RGB, 1f);
  pixelDensity(2);
  resetMatrix();
  println(System.currentTimeMillis());
  hint(DISABLE_OPTIMIZED_STROKE);
}

long startTime = 0;
long currTime = 0;
long elapsedTime = 0;
boolean timerFinished = false;
float[][] pos = new float[][]{
  {4, 0.75}, 
  {4, 0.25}, 
  {4, -0.25}, 
  {4, -0.75}, 

  {-4, 0.75}, 
  {-4, 0.25}, 
  {-4, -0.25}, 
  {-4, -0.75}, 

  {-2, 0.75}, 
  {-2, 0.25}, 
  {-2, -0.25}, 
  {-2, -0.75}, 

  {0, 0.75}, 
  {0, 0.25}, 
  {0, -0.25}, 
  {0, -0.75}, 

  {2, 0.75}, 
  {2, 0.25}, 
  {2, -0.25}, 
  {2, -0.75}, 
};

void draw() {
  clear();
  scale(100, 100);
  if (!timerFinished)
    setTime();
  fill(1);
  String secondsFill = intToString(elapsedTime/1000, 16, 16);
  String millsFill = intToString(((elapsedTime%1000) /125)+1, 4, 4);

  if (timerFinished)
    drawVictoryArray();
  else
    drawArray(secondsFill, millsFill);

  if (timerFinished && victoryT < 120)
    fill(1 - ((float)(victoryT% 120))/120, 0.5);
  else
    fill(0, 0.5);
  rectMode(CENTER);
  rect(0, 0, 20, 20);
  resetMatrix();
  scale(1, -1);
  textSize(100);

  fill(1);
  translate(-270, 40);
  if (startTime != 0)
    text(millSecToString(elapsedTime), 0, 0);

  //println(millSecToString(elapsedTime));


  //ellipse(0, 0, 0.1, 0.1);
  //print(secondsFill);
  //println("\t", millsFill);
}

void drawBar() {
  beginShape(QUAD);
  vertex(-4, 1);
  vertex(-4, -1);
  vertex(4, -1);
  vertex(4, 1);
  endShape();
}

void drawArray(String secondsFill, String millsFill) {
  for (int i = 0; i < pos.length; i ++) {
    pushMatrix();
    translate(pos[i][0], pos[i][1]);
    scale(0.245, 0.24);
    fill(0.3);
    drawBar();
    fill(1);
    if (i < 4) {
      if (millsFill.charAt(i) == '1')
        drawBar();
    } else {
      if (secondsFill.charAt(i-4) == '1')
        drawBar();
    }
    popMatrix();
  }
}

int victoryT = 0;
int randomNum = 0;
void drawVictoryArray() {  
  if (victoryT % 120 == 0) 
    randomNum = (int)random(10485755);

  String randomNumBinary = intToString(randomNum, 20, 20);
  for (int i = 0; i < pos.length; i ++) {
    pushMatrix();
    translate(pos[i][0], pos[i][1]);
    scale(0.245, 0.24);
    if (randomNumBinary.charAt(i) == '1')
      fill(0.3);
    else
      fill(1);
    drawBar();
    popMatrix();
  }

  victoryT ++;
}


String intToString(long number, int groupSize, int len) {
  StringBuilder result = new StringBuilder();

  for (int i = len-1; i >= 0; i--) {
    int mask = 1 << i;
    result.append((number & mask) != 0 ? "1" : "0");

    if (i % groupSize == 0)
      result.append(" ");
  }
  result.replace(result.length() - 1, result.length(), "");

  return result.toString();
}

void setTime() {
  currTime = System.currentTimeMillis();
  elapsedTime = currTime - startTime;
}

void keyPressed() {
  if (startTime != 0 && key == ' ') {
    timerFinished = true;
  }
  if (startTime == 0 && key == ' ') {
    startTime = System.currentTimeMillis();
  }

  if (key == '.' || key == '>')
    startTime -= 300000;
}

String millSecToString(long currTime) {
  String result = "";

  long milliseconds = (currTime % 1000);
  currTime = currTime / 1000;

  // currTime is now how many seconds there are.
  long seconds = (currTime % 60);
  currTime = currTime / 60;

  // currTime is now how many minutes
  long minutes = (currTime % 60);
  currTime = currTime / 60;

  // currTime is now how many hours
  long hours = (currTime % 24);

  result = String.format("%02d:%02d:%02d.%d", hours, minutes, seconds, milliseconds/100);
  return result;
}
