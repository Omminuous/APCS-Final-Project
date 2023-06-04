// Game variables
float health = 3;
boolean initial = true;
int floor = 1;
int coin = 0;
int slot = 0;
int slots = 0;
boolean menu = false;
boolean hudScreen = true;

// Maze Variables
int end;
int size = 30;
int mazeSize = 25;
Runner player;
char[][] maze;

// Items
HashMap<PVector, Item> ground = new HashMap<>();
HashMap<String, ArrayList<Item>> items = new HashMap<>();
HashMap<String, Integer> rarity;
Item[] inventory = new Item[5];

// Assets
PFont font;
PImage cS;
File folder;
String[] sprites;

void setup() {
  size(810, 930);
  noStroke();
  textSize(20);
  background(0);
  surface.setTitle("The Maze Game");
  font = createFont("assets/Minecraft Regular.otf", 40);
  textFont(font);
  
  //title screen
  image(loadImage("assets/menu.png"), 0, 0);
}

void generate() {
  size(810, 930);
  noStroke();
  textSize(20);
  background(#EEEEEE);
  surface.setTitle("Dungeon - Floor " + floor);
  font = createFont("assets/Minecraft Regular.otf", 40);
  textFont(font);

  rarity = new HashMap<>() {{
    put("common", #CBDBFC);
    put("uncommon", #C1D0B5);
    put("rare", #AFD3E2);
    put("epic", #5C469C);
    put("legendary", #FFB6B9);
  }};

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
        if (isDeadEnd(maze, new PVector(j, i)) && (int) (Math.random() * 5) == 1) {
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
  player = new Runner(1, 1);
  maze[1][1] = 's';
  maze[mazeSize][end] = 'p';

  fill(#95E1D3);
  drawSquare(1, 1);
  fill(#F38181);
  drawSquare(end, mazeSize);
  
  player = new Runner(1, 1);
  if (initial) {
    initial = false;
    inventory[slots++] = items.get("common").get(0);
  }
  ground = new HashMap<>();
  hud();
}

void draw() {}

Item chest() {
  int item = (int) (Math.random() * 100);
  String rarity = "";
  if (item < 40) rarity = "common";
  else if (item < 65) rarity = "uncommon";
  else if (item < 85) rarity = "rare";
  else if (item < 95) rarity = "epic";
  else if (item < 100) rarity = "legendary";
  return items.get(rarity).get((int) (Math.random() * items.get(rarity).size()));
}

void update() {
  fill(#424874);
  for (int i = 0; i < mazeSize; i++) drawSquare(i, 0);  
  hud();
}

void keyPressed () {
  // regular input
  if (!hudScreen) {
    if (Character.isDigit(key)) if (key > '0' && key < '6') slot = key - 49;
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
      case 'y':
      case 'n':
        player.options(key);
        return;
    }
    update();
  }
  // menu
  else {
    switch(key) {
      case 'p':
        hudScreen = false;
        coin = 0;
        floor = 1; 
        generate();
        draw();
    }
  }
}

void mouseClicked() {
  if (menu || hudScreen) return;
  if (mouseButton == LEFT) System.out.println("left");
  else if (mouseButton == RIGHT) player.interact();
  else player.drop();
  update();
}
