void status() {
  fill(#F9F7F7);
  text(player.frontBlock(), 8, 21);
}

void interactable(String s) {
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text(s + " - Press E to interact", 400, 855);
  textAlign(BASELINE);
}

void clearText() {
  fill(#EEEEEE);
  rect(0, 810, 810, 50);
}

void health() {
  strokeWeight(2);
  stroke(#212A3E);
  
  fill(#ACB1D6);
  for (int i = 0; i < 3; i++) rect(720 - 60 * i, 875, 40, 40);
  
  fill(#FC4F00);
  for (int i = 0; i < floor(health); i++) rect(600 + 60 * i, 875, 40, 40);
  if (floor(health) != health) rect(600 + floor(health) * 60, 875, 20, 40);
  
  noStroke();
}

void inventory() {
  fill(#EEEEEE);
  rect(0, 860, 350, 70);
  strokeWeight(2);
  stroke(#212A3E);
  
  fill(#EEE3CB);
  for (int i = 0; i < 5; i++) rect(50 + i * 60, 875, 40, 40);
  
  strokeWeight(4);
  stroke(#FF2E63);
  rect(49 + slot * 60, 874, 42, 42);
  noStroke();
}

void purse() {
  fill(#EEEEEE);
  rect(350, 860, 250, 70);
  image(cS, 373, 875);
  fill(#222831);
  textSize(40);
  text(coin, 425, 908);
}

void mouseWheel(MouseEvent event) {
  if(!hudScreen) {
    slot += (int) event.getCount();
     if (slot > 4 || slot < 0) slot = 5 - abs(slot);
    inventory();
  }
}

void optionsOpen() {
   menu = true;
   fill(#43A6C6);
   rect(155, 220, 500, 350);
   fill(#ADD8E6);
   rect(185, 250, 440, 290);
   fill(#98FB98);
   rect(185, 360, 440, 90);
   fill(#FAA0A0);
   rect(185, 450, 440, 90);
   fill(#000000);
   textSize(45);
   text("DO YOU WISH TO", 235, 300);
   text("ENTER OR STOP?", 230, 340);
   fill(#0BDA51);
   text("PRESS Y TO ENTER", 205, 420);
   fill(#FF0000);
   text("PRESS N TO STOP", 220, 510);
}

void endScreen() {
  fill(#000000);
  rect(0, 0, 810, 930);
  textSize(200);
  fill(#FFFFFF);
  text("GAME", 175, 200);
  text("OVER", 175, 350);
  textSize(85);
  text("YOU'VE COLLECTED ", 20, 500);
  cS.resize(75, 75);
  image(cS, 300, 525);
  text(coin, 400, 595);
  fill(#FFFFFF);
  rect(55, 650, 700, 230);
  fill(#E8B923);
  text("PRESS P TO", 170, 745);
  text("PLAY AGAIN", 170, 825);
}
