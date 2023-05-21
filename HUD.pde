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
  slot += (int) event.getCount();
  if (slot > 4 || slot < 0) slot = 5 - abs(slot);
  inventory();
}
