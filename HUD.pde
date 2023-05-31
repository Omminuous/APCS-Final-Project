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

void itemText(String s) {
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text(s, 400, 845);
  textAlign(BASELINE);
}

void interactable(String s, String option) {
  clearText();
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text(s + " - Press E to " + option, 400, 845);
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
  stroke(#FF2E63);
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
  textSize(50);
  text(coin, 455, 908);
}

void items() {
  fill(#F4EEFF);
  for (PVector p : ground.keySet()) image(ground.get(p).getImage(), int(p.x) * 30 - 1, int(p.y) * 30 - 1);
}

void mouseWheel(MouseEvent event) {
  slot += (int) event.getCount();
  if (slot > 4 || slot < 0) slot = 5 - abs(slot);
  inventory();
}
