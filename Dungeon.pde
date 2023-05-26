int speed = 2;
int size = 30;
int mazeSize = 25;
int end;
int slot = 0;
int floor = 1;
int coin = 0;
PFont font;
float health = 2;
PVector start;
char[][] maze;
Runner player;
PImage cS;
boolean initial = true;

// Items
ArrayList<Item> inventory = new ArrayList<>();
HashMap<PVector, Item> ground = new HashMap<>();
HashMap<String, ArrayList<Item>> items = new HashMap<>();

File folder;
String[] sprites;

void setup() {
  size(810, 930);
  noStroke();
  textSize(20);
  background(#EEEEEE);
  surface.setTitle("Dungeon - Floor " + floor);
  font = createFont("assets/Minecraft Regular.otf", 40);
  textFont(font);

  // Load sprites
  cS = loadImage("assets/coin.png");
  cS.resize(50, 50);

  folder = new java.io.File(sketchPath("sprites"));
  sprites = folder.list();
  for (String s : new String[]{"common", "uncommon", "rare", "epic", "legendary"}) items.put(s, new ArrayList<>());
  for (String s : sprites) items.get(s.substring(0, s.indexOf("-"))).add(new Item(s.substring(0, s.indexOf("-")) + " " + s.substring(s.indexOf("-") + 1, s.length() - 4), loadImage("sprites/" + s)));
  
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

  // Start + end values/squares
  maze[1][1] = 's';
  fill(#95E1D3);
  drawSquare(1, 1);
  maze[mazeSize][end] = 'p';
  fill(#F38181);
  drawSquare(end, mazeSize);
  
  if (initial) {
    initial = false;
    player = new Runner(1, 1);
    inventory.add(items.get("common").get(0));
  }
  
  hud();
}

Item chest() {
  int item = (int) (Math.random() * 100);
  String rarity = "";
  if (item < 50) rarity = "common";
  else if (item < 75) rarity = "uncommon";
  else if (item < 90) rarity = "rare";
  else if (item < 97) rarity = "epic";
  else if (item < 100) rarity = "legendary";
  return items.get(rarity).get((int) (Math.random() * items.get(rarity).size()));
}

void update() {
  fill(#424874);
  for (int i = 0; i < mazeSize; i++) drawSquare(i, 0);  
  hud();
}

void keyPressed(){
  switch (key) {
    case 'w':
    case 'a':
    case 's':
    case 'd':
      player.move(maze, key);
      break;
    case 'q':
      player.drop();
      break;
    case 'e':
      player.interact();
      break;
  }
  update();
}

void draw() {
}
