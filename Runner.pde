public class Runner {
  PVector runner;
  PVector dir;

  public Runner(float startX, float startY) {
    runner = new PVector(startX, startY);
    dir = new PVector(1, 0);
  }

  public void move(char[][] maze, char k) {
    if (k == 'a') dir = new PVector(-1, 0);
    else if (k == 'd') dir = new PVector(1, 0);
    else if (k == 'w') dir = new PVector(0, -1);
    else if (k == 's') dir = new PVector(0, 1);
    if (moveAvaliable(maze)) {
      maze[(int) runner.y][(int) runner.x] = 'c';
      fill(#F4EEFF);
      rect(runner.x * 30, runner.y * 30, 30, 30);
      
      runner = new PVector(runner.x + dir.x, runner.y + dir.y);
      if (maze[(int) runner.y][(int) runner.x] == 'o') coin += (int) (Math.random() * 100);
      maze[(int) runner.y][(int) runner.x] = 's';
      fill(#95E1D3);
      rect(runner.x * 30, runner.y * 30, 30, 30);
    }
  }

  public boolean moveAvaliable(char[][] maze) {
    switch (maze[int(runner.y + dir.y)][int(runner.x + dir.x)]) {
      case 'w':
      case 'p':
      case 'h':
        return false;
      default:
        return true;
    }
  }
  
  public PVector getDir() {
    return dir;
  }

  public String frontBlock() {
    String status = "";
    switch (maze[int(runner.y + dir.y)][int(runner.x + dir.x)]) {
      case 'c':
        status = "FLOOR";
        clearText();
        break;
      case 'w':
        status = "WALL";
        clearText();
        break;
      case 'p':
        status = "PORTAL";
        interactable("A glowing portal");
        break;
      case 'o':
        status = "COIN";
        clearText();
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
