// implementation of Prim's maze algorithm
Object[] generateMaze(int size) {
  char[][] maze = new char[size + 2][size + 2];
  for (int i = 0; i < size + 2; i++) {
    for (int j = 0; j < size + 2; j++) {
      maze[i][j] = 'd';
    }
  }

  ArrayList<PVector> wallList = neighborCells(new PVector(1, 1), size, 2);
  for (PVector w : wallList) maze[(int) w.x][(int) w.y] = 's';
  maze[1][1] = 'c';

  while (wallList.size() > 0) {
    int item = (int) (Math.random() * wallList.size());
    PVector tentative = wallList.get(item);
    boolean notEdge = tentative.x != size + 1 && tentative.y != size + 1;

    ArrayList<PVector> nearbyCells = neighborCells(tentative, size, 2);

    for (int i = 0; i < nearbyCells.size(); ) {
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
  for (int i = 1; i < size + 1; i++) if (maze[size][i] == 'c' && isDeadEnd(maze, new PVector(i, size))) ends.add(i);

  return new Object[]{maze, ends.get((int) (Math.random() * ends.size()))};
}

ArrayList<PVector> neighborCells(PVector p, int size, int dist) {
  ArrayList<PVector> neighbors = new ArrayList<>();
  int x = (int) p.x;
  int y = (int) p.y;

  for (int value : new int[]{-1 * dist, dist}) {
    if (x + value > 0 && x + value < size + 2) neighbors.add(new PVector(x + value, y));
    if (y + value > 0 && y + value < size + 2) neighbors.add(new PVector(x, y + value));
  }

  return neighbors;
}

boolean isDeadEnd(char[][] maze, PVector p) {
  int count = 0;
  ArrayList<PVector> nearby = neighborCells(p, mazeSize, 1);
  for (PVector n : nearby) count += maze[int(n.y)][int(n.x)] == 'w' ? 1 : 0;
  return count == 3;
}

void drawSquare(int x, int y) {
  rect(x * size, y * size, size, size);
}
