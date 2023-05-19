public class Runner{
  PVector runner;
  PVector dir;
  
  public Runner(float startX, float startY){
    runner = new PVector(startX, startY);
    dir = new PVector(0, 0);
  }
  
  public char[][] move(char[][] maze, char k){
    char[][] tempMaze = maze;
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
  
  public PVector getDir() {
    return dir; 
  }
  
  public String frontBlock(){
    String status = "";
    if(maze[int(runner.x + dir.x)][int(runner.y + dir.y)] == 'c') status = "OPEN SPACE";
    else if(maze[int(runner.x + dir.x)][int(runner.y + dir.y)] == 'w') status = "WALL";
    else if(maze[int(runner.x + dir.x)][int(runner.y + dir.y)] == 'e') status = "TREASURE";
    return status;
  }
}
