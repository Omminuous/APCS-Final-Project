public class Runner {
  PVector runner;
  PVector dir;

  public Runner(float startX, float startY) {
    runner = new PVector(startX, startY);
    dir = new PVector(1, 0);
  }

  public void move(char[][] maze, char k) {
    // movement logic
    PImage img = down;
    switch (k) {
      case 'a':
        dir = new PVector(-1, 0);
        img = left;
        break;
      case 'd':
        dir = new PVector(1, 0);
        img = right;
        break;
      case 'w':
        dir = new PVector(0, -1);
        img = up;
        break;
      case 's':
        dir = new PVector(0, 1);
        break;
    }

    // movement interactions
    if (moveAvaliable()) {
      if (front() == 'm') {
        health -= 0.5;
        if (health <= 0) {
          endScreen();
          hudScreen = true;
          surface.setTitle("Game Over");
        }
        return;
      }
      maze[(int) runner.y][(int) runner.x] = ground.containsKey(runner) ? 'i' : 'c';
      
      fill(#F4EEFF);
      rect(runner.x * 30, runner.y * 30, 30, 30);
      
      runner = new PVector(runner.x + dir.x, runner.y + dir.y);
      if (maze[(int) runner.y][(int) runner.x] == 'o') {
        int multiplier = 1;
        if (inventory[slot] != null && inventory[slot] != null && inventory[slot].getName().split(" ")[1].equals("amulet")) multiplier += rarityOrder.indexOf(inventory[slot].getName().split(" ")[0]) + 1;
        coin += (int) (Math.random() * 100 * multiplier);
      }
      maze[(int) runner.y][(int) runner.x] = 's';
    }

    fill(#F4EEFF);
    rect(runner.x * 30, runner.y * 30, 30, 30);
    image(img, runner.x * 30, runner.y * 30);
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
    if (ground.containsKey(runner)) {
      interactable(ground.get(runner).getName(), "pickup");
      status = "ITEM";
    }
    switch (front()) {
      case 'c':
        status = "FLOOR";
        break;
      case 'w':
        status = "WALL";
        break;
      case 'p':
        status = "PORTAL";
        interactable("A glowing portal", "enter");
        break;
      case 'o':
        status = "COINS";
        break;
      case 'i':
        status = "ITEM";
        interactable(ground.get(frontVector()).getName(), "pickup");
        break;
      case 'h':
        status = "CHEST";
        interactable("A treasure chest", "open");
        break;
      case 'm':
        String name = monsters.get(frontVector()).getType();
        status = name.toUpperCase();
        mobText(name);
        break;
      default:
        status = "UNKNOWN";
    }
    fill(#F9F7F7);
    textSize(20);
    return status;
  }
  
  public void interact() {
    if (ground.containsKey(runner)) {
      pickup(runner);
      return;
    }
    
    switch (front()) {
      case 'h':
        maze[int(runner.y + dir.y)][int(runner.x + dir.x)] = 'i';
        fill(#F4EEFF);
        drawSquare(frontVector());
        ground.put(new PVector(runner.x + dir.x, runner.y + dir.y), chest());
        return;
      case 'i':
        pickup(frontVector());
        return;
      case 'p':
        optionsOpen();
        break;
    }
    
    if (inventory[slot] != null) {
      switch (inventory[slot].getName()) {
        case "legendary chest":
          coin += (int) (Math.random() * 10000);
          inventory[slot] = null;
          slots--;
          break;
        case "uncommon potion":
          health = min(3, health + 1);
          inventory[slot] = null;
          slots--;
          break;
      }
    }
  }
  
  private void pickup(PVector p) {
    fill(p.equals(runner) ? #95E1D3 : #F4EEFF); 
    if (slots == 5) {
      Item swap = inventory[slot];
      inventory[slot] = ground.remove(p);
      ground.put(p, swap);
      
      drawSquare(frontVector());
      return;
    }
    
    if (inventory[slot] != null) {
      int i = 0;
      while (inventory[i] != null) i++;
      slot = i;
    }

    inventory[slot] = ground.remove(p);
    slots++;
    maze[int(p.y)][int(p.x)] = 'c';
    drawSquare(p);
  }
  
  public void attack() {
    if (front() != 'm') return;
    int damage = 1;
    if (inventory[slot] != null && inventory[slot].getName().split(" ")[1].equals("dagger")) damage += rarityOrder.indexOf(inventory[slot].getName().split(" ")[0]) + 1;
    monsters.get(frontVector()).decreaseHealth(damage * 5, frontVector());
  }
  
  public void drop() {
    if (inventory[slot] == null) return;
    if (!ground.containsKey(runner)) {
      ground.put(runner, inventory[slot]);
      inventory[slot] = null;
      slots--;
      maze[int(runner.y)][int(runner.x)] = 'i';
    } else if (front() == 'c') {
      fill(#F4EEFF);
      drawSquare(frontVector());
      ground.put(frontVector(), inventory[slot]);
      inventory[slot] = null;
      slots--;
      maze[int(frontVector().y)][int(frontVector().x)] = 'i'; 
    }
  }
  
  public PVector coords() {
    return runner;
  }
  
  public void options(char k) {
    if (menu) {
      if (k == 'y') {
        floor++;
        health = min(health + 1, 3);
        generate();
        draw();
      }
      else if (k == 'n') {
        endScreen();
        hudScreen = true;
        surface.setTitle("Game Over");
      }
      menu = false;
    }
  }
}
