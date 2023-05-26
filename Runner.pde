public class Runner {
  PVector runner;
  PVector dir;

  public Runner(float startX, float startY) {
    runner = new PVector(startX, startY);
    dir = new PVector(1, 0);
  }

  public void move(char[][] maze, char k) {
    // movement logic
    switch (k) {
      case 'a':
        dir = new PVector(-1, 0);
        break;
      case 'd':
        dir = new PVector(1, 0);
        break;
      case 'w':
        dir = new PVector(0, -1);
        break;
      case 's':
        dir = new PVector(0, 1);
        break;
    }

    // movement interactions
    if (moveAvaliable()) {
      maze[(int) runner.y][(int) runner.x] = ground.containsKey(runner) ? 'i' : 'c';
      fill(#F4EEFF);
      rect(runner.x * 30, runner.y * 30, 30, 30);
      
      runner = new PVector(runner.x + dir.x, runner.y + dir.y);
      if (maze[(int) runner.y][(int) runner.x] == 'o') coin += (int) (Math.random() * 100);
      maze[(int) runner.y][(int) runner.x] = 's';
      fill(#95E1D3);
      rect(runner.x * 30, runner.y * 30, 30, 30);
    }
  }

  public char front() {
    return maze[int(runner.y + dir.y)][int(runner.x + dir.x)];
  }

  public boolean moveAvaliable() {
    switch (front()) {
      case 'w':
      case 'p':
      case 'h':
        return false;
      default:
        return true;
    }
  }
  
  public PVector frontVector() {
    return new PVector(runner.x + dir.x, runner.y + dir.y);
  }

  public String frontBlock() {
    String status = "";
    clearText();
    switch (front()) {
      case 'c':
        status = "FLOOR";
        break;
      case 'w':
        status = "WALL";
        break;
      case 'p':
        status = "PORTAL";
        interactable("A glowing portal");
        break;
      case 'o':
        status = "COIN";
        break;
      case 'i':
        status = "ITEM";
        interactable(ground.get(frontVector()).getName());
        interactable("ASD");
        break;
      case 'h':
        status = "CHEST";
        interactable("A treasure chest");
        break;
      default:
        status = "UNKNOWN";
    }
    fill(#F9F7F7);
    textSize(20);
    return status;
  }
  
  public void interact() {
    switch (front()) {
      case 'h':
        maze[int(runner.y + dir.y)][int(runner.x + dir.x)] = 'i';
        fill(#F4EEFF);
        drawSquare(int(runner.x + dir.x), int(runner.y + dir.y));
        ground.put(new PVector(runner.x + dir.x, runner.y + dir.y), chest());
        return;
      case 'i':
        if (inventory.size() == 5) {
          Item swap = inventory.remove(slot);
          inventory.add(slot, ground.get(player.frontVector()));
          ground.remove(player.frontVector());
          ground.put(player.frontVector(), swap);
          
          fill(#F4EEFF);
          drawSquare(int(frontVector().x), int(frontVector().y));
          break;
        }
        
        inventory.add(ground.get(player.frontVector()));
        ground.remove(player.frontVector());
        maze[int(runner.y + dir.y)][int(runner.x + dir.x)] = 'c';
        fill(#F4EEFF);
        drawSquare(int(runner.x + dir.x), int(runner.y + dir.y));
        return;
      case 'p':
        portal();
    }
    if (inventory.size() > slot && inventory.get(slot).getName().equals("uncommon potion")) {
      health = min(3, health + 1);
      inventory.remove(slot);
    }
  }
  
  public void drop() {
    if (inventory.size() == 0 || ground.containsKey(frontVector())) return;
    fill(#F4EEFF);
    drawSquare(int(runner.x + dir.x), int(runner.y + dir.y));
    ground.put(frontVector(), inventory.remove(slot));
    maze[int(frontVector().y)][int(frontVector().x)] = 'i';
    return;
  }
  
  public void portal(){
     if(frontBlock() == "PORTAL"){
       optionsOpen();
     }
     else if(frontBlock() == "CHEST"){
       coin += (int) (Math.random() * 1000);
       fill(#EEEEEE);
       maze[int(runner.y + dir.y)][int(runner.x + dir.x)] = 'c';
       fill(#F4EEFF);
       drawSquare(int(runner.x + dir.x), int(runner.y + dir.y));
     }
  }
  
  public void options(char k){
    if(menu){
      if(k == 'y'){
        floor++;
        generate();
        draw();
      }
      else if(k == 'n'){
        endScreen();
        hudScreen = true;
        surface.setTitle("Game Over");
      }
      menu = false;
    }
  }
}
