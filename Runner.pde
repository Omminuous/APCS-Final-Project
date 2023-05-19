public class Runner{
  PVector runner;
  
  public Runner(float startX, float startY){
    runner = new PVector(startX, startY);
  }
  
  public char[][] move(char[][] maze, char k){
    char[][] tempMaze = maze;
    PVector dir = new PVector(0, 0);
    if(k == 'a') dir = new PVector(-1, 0);
    else if(k == 'd') dir = new PVector(1, 0);
    else if(k == 'w') dir = new PVector(0, -1);
    else if(k == 's') dir = new PVector(0, 1);
    if(moveAvaliable(maze, dir)){
      tempMaze[int(runner.x)][int(runner.y)] = 'c';
      runner.x += dir.x;
      runner.y += dir.y;
      tempMaze[int(runner.x)][int(runner.y)] = 's';
    }
    return tempMaze;
  }
  
  public boolean moveAvaliable(char[][] maze, PVector dir){
    if(dir.x == 0 && dir.y == 0) return false;
    else if(maze[int(runner.x + dir.x)][int(runner.y + dir.y)] == 'w') return false;
    else return true;
  }
}
