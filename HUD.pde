void hud() {
  purse();
  health();
  inventory();
  status();
  items();
}

void status() {
  fill(#F9F7F7);
  text(player.frontBlock(), 8, 21);
}

void writeText(String s) {
  clearText();
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text(s, 400, 845);
  textAlign(BASELINE);
}

void mobText(String s) {
  writeText(s + " - click to attack");
}

void itemText(String s) {
  writeText(s);
}

void interactable(String s, String option) {
  writeText(s + " - Press E to " + option);
}

void clearText() {
  fill(#EEEEEE);
  rect(0, 810, 810, 50);
}

void health() {
  strokeWeight(2);
  stroke(#212A3E);
  
  fill(#ACB1D6);
  for (int i = 0; i < 3; i++) rect(720 - 70 * i, 865, 50, 50);
  
  fill(#FC4F00);
  for (int i = 0; i < floor(health); i++) rect(580 + 70 * i, 865, 50, 50);
  if (floor(health) != health) rect(580 + floor(health) * 70, 865, 25, 50);
  
  noStroke();
}

void inventory() {
  fill(#EEEEEE);
  rect(0, 860, 390, 70);
  strokeWeight(2);
  stroke(#212A3E);
  
  fill(#EEE3CB);
  
  for (int i = 0; i < 5; i++) {
    rect(50 + i * 70, 865, 50, 50);
    if (inventory[i] != null) image(inventory[i].getImage(), 50 + i * 70, 865, 50, 50);
  }
  
  strokeWeight(4);
  stroke(inventory[slot] != null ? rarity.get(inventory[slot].getName().split(" ")[0]) : #FF2E63);
  noFill();
  rect(49 + slot * 70, 864, 52, 52);
  noStroke();
  clearText();
  if (inventory[slot] != null) itemText(inventory[slot].getName());
}

void purse() {
  fill(#EEEEEE);
  rect(350, 860, 250, 70);
  image(cS, 400, 866);
  fill(#222831);
  textSize(max(10, 50 - max(0, String.valueOf(coin).length() - 4) * 10));
  text(coin, 455, 908);
}

void items() {
  for (PVector p : ground.keySet()) {
    if (p.equals(player.coords())) fill(#95E1D3);
    else {
      fill(#F9F7F7);
      drawSquare(p);
      fill(#393E46, 180);
    }
    
    drawSquare(p);
    image(ground.get(p).getImage(), int(p.x) * 30 - 1, int(p.y) * 30 - 1);
  }
}

void mouseWheel(MouseEvent event) {
  if (!hudScreen) {
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
