int speed = 2;
int size = 30;
int mazeSize = 25;
char[][] maze;
int end;
int slot = 0;
int floor = 1;
int coin = 0;
PFont font;
float health = 3;
PVector start;
PVector treasure;
ArrayList<String> inventory;
Runner player;
PImage cS;
boolean menu = false;
boolean gameOver = false;

void setup() {
  size(810, 930);
  noStroke();
  textSize(20);
  background(#EEEEEE);
  surface.setTitle("Dungeon - Floor " + floor);
  
  // Load assets
  font = createFont("Minecraft Regular.otf", 40);
  textFont(font);
  cS = loadImage("sprites/coin.png");
  cS.resize(40, 40);
  
  // Maze setup + Destructuring
  Object[] m = generateMaze(mazeSize);
  maze = (char[][]) m[0];
  end = (int) m[1];
  for (int i = 0; i < mazeSize + 2; i++) {
    for (int j = 0; j < mazeSize + 2; j++) {
      if (maze[i][j] == 'c') {
        fill(#F4EEFF);
        if (isDeadEnd(maze, new PVector(j, i)) && (int) (Math.random() * 8) == 1) {
          if ((int) (Math.random() * 5) == 1) {
            maze[i][j] = 'h';
            fill(#AD8B73);
          } else {
            maze[i][j] = 'o';
            fill(#FFD3B6);
          }  
        }
      } else fill(#424874);
      drawSquare(j, i);
    }
  }

  // Start + end values
  maze[1][1] = 's';
  fill(#95E1D3);
  drawSquare(1, 1);
  maze[mazeSize][end] = 'p';
  fill(#F38181);
  drawSquare(end, mazeSize);
  
  player = new Runner(1, 1);
  status();
  purse();
  health();
  inventory();
}

void draw() {
}

void update() {
  fill(#424874);
  for (int i = 0; i < mazeSize; i++) drawSquare(i, 0);  
  purse();
  health();
  status();
  inventory();  
}

void keyPressed(){
  if(!gameOver){
    switch (key) {
      case 'w':
      case 'a':
      case 's':
      case 'd':
        player.move(maze, key);
        break;
      case 'e':
        player.portal();
        break;
      case 'y':
      case 'n':
        player.options(key);
        return;
    }
    update();
  }
  else{
    switch(key){
      case 'p':
        gameOver = false;
        coin = 0;
        floor = 1; 
        setup();
        draw();
    }
  }
}
