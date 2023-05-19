int speed = 20;
int size = 30;
int mazeSize = 25;
char[][] maze;
PVector start;
PVector treasure;
int end;
Runner player;

void setup() {
  size(810, 810);
  strokeWeight(0);
 
  // Maze setup + Destructuring
  Object[] m = generateMaze(mazeSize);
  maze = (char[][]) m[0];
  end = (int) m[1];

  for (int i = 0; i < mazeSize + 2; i++) {
  for (int j = 0; j < mazeSize + 2; j++) {
    fill(maze[i][j] == 'c' ? #F4EEFF : #424874);
    rect(i * 30, j * 30, 30, 30);
  }
  }
 
  // Start + end values
  start = new PVector(1, 1);
  maze[int(start.x)][int(start.y)] = 's';
  fill(#95E1D3);
  rect(start.x*30, start.y*30, 30, 30);
  treasure = new PVector(end, mazeSize);
  maze[int(treasure.x)][int(treasure.y)] = 'e';
  fill(#F38181);
  rect(end * 30, mazeSize * 30, 30, 30);
  
  player = new Runner(start.x, start.y);
}

void draw() {
  if(frameCount % speed == 0) {
  update();  
  }
}

void update() {
  for (char[] r : maze) {
  for (char c : r) System.out.print(c + " ");
  System.out.println();  
  }

  for (int i = 0; i < mazeSize + 2; i++) {
    for (int j = 0; j < mazeSize + 2; j++) {
      if(maze[i][j] == 'c') fill(#F4EEFF);
      else if(maze[i][j] == 'w') fill(#424874);
      else if(maze[i][j] == 's') fill(#95E1D3);
      else if(maze[i][j] == 'e') fill(#F38181);
      rect(i * 30, j * 30, 30, 30);
    }
  }
}

// Maze Generation:
ArrayList<PVector> neighborCells(PVector p, int size) {
  ArrayList<PVector> neighbors = new ArrayList<>();
  int x = (int) p.x;
  int y = (int) p.y;
 
  for (int value : new int[]{-2, 2}) {
  if (x + value > 0 && x + value < size + 2) neighbors.add(new PVector(x + value, y));
  if (y + value > 0 && y + value < size + 2) neighbors.add(new PVector(x, y + value));
  }
 
  return neighbors;
}

Object[] generateMaze(int size) {
  char[][] maze = new char[size + 2][size + 2];
  for (int i = 0; i < size + 2; i++) {
  for (int j = 0; j < size + 2; j++) {
      maze[i][j] = 'd';
  }
  }
 
  ArrayList<PVector> wallList = neighborCells(new PVector(1, 1), size);
  for (PVector w : wallList) maze[(int) w.x][(int) w.y] = 's';
  maze[1][1] = 'c';
 
  while (wallList.size() > 0) {
  int item = (int) (Math.random() * wallList.size());
  PVector tentative = wallList.get(item);
  boolean notEdge = tentative.x != size + 1 && tentative.y != size + 1;

  ArrayList<PVector> nearbyCells = neighborCells(tentative, size);
    
  for (int i = 0; i < nearbyCells.size();) {
    PVector p = nearbyCells.get(i);
    char value = maze[(int) p.x][(int) p.y];
    
    if (value == 'c') {
      i++;
      continue;
    }
    if (value == 'd') {
      maze[(int) p.x][(int) p.y] = 's';
      if (notEdge) wallList.add(p);
    }
    nearbyCells.remove(i);
  }
    
  PVector chosenCell = nearbyCells.get((int) (Math.random() * nearbyCells.size()));
  maze[(int) (tentative.x + chosenCell.x) / 2][(int) (tentative.y + chosenCell.y) / 2] = 'c';
  if (notEdge) maze[int(tentative.x)][int(tentative.y)] = 'c';

  wallList.remove(item);
  System.out.println(wallList);
  }
 
  for (int i = 1; i < size + 1; i++) {
  if (maze[size + 1][i] == 's') maze[size][i] = 'c';
  if (maze[i][size + 1] == 's') maze[i][size] = 'c';
  }
 
  for (int i = 0; i < size + 2; i++) {
  for (int j = 0; j < size + 2; j++) {
    if (maze[i][j] != 'c') maze[i][j] = 'w';
    else maze[i][j] = 'c';
  }
  }
 
  ArrayList<Integer> ends = new ArrayList<>();
  for (int i = 1; i < size + 1; i++) if (maze[size][i] == 'c') ends.add(i);
 
  return new Object[]{maze, ends.get((int) (Math.random() * ends.size()))};
}

void keyPressed(){
  if(key == 'a' || key == 'A') maze = player.move(maze, key);
  if(key == 'd' || key == 'D') maze = player.move(maze, key);
  if(key == 'w' || key == 'W') maze = player.move(maze, key);
  if(key == 's' || key == 'S') maze = player.move(maze, key);
  update();
}
