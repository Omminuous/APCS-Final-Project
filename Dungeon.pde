// Game variables
float health;
boolean initial;
int floor;
int coin;
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
ArrayList<String> rarityOrder;
Item[] inventory;

// Assets
PFont font;
PImage cS;
File folder;
String[] sprites;

PImage up;
PImage down;
PImage left;
PImage right;

HashMap<String, PImage[]> mobSprites;

// Monsters
HashMap<PVector, Monster> monsters;
HashMap<String, Integer> monColors;
String[] monsterList = {"demon", "skeleton", "zombie"};

void setup() {
  // window setup
  size(810, 930);
  noStroke();
  textSize(20);
  background(0);
  surface.setTitle("The Maze Game");
  font = createFont("assets/Minecraft Regular.otf", 40);
  textFont(font);
  
  //title screen
  image(loadImage("assets/menu.png"), 0, 0);
  
  // declare constants
  rarityOrder = new ArrayList<>() {{
    add("common");
    add("uncommon");
    add("rare");
    add("epic");
    add("legendary");
  }};
  
  rarity = new HashMap<>() {{
    put("common", #CBDBFC);
    put("uncommon", #C1D0B5);
    put("rare", #AFD3E2);
    put("epic", #5C469C);
    put("legendary", #FFB6B9);
  }};
  
  monColors = new HashMap<>() {{
    put("demon", #FF0000);
    put("skeleton", #BABABA);
    put("zombie", #28FC03);
  }};

  // Load sprites
  cS = loadImage("assets/coin.png");
  cS.resize(50, 50);

  folder = new java.io.File(sketchPath("sprites"));
  sprites = folder.list();
  
  for (String s : new String[]{"common", "uncommon", "rare", "epic", "legendary"}) items.put(s, new ArrayList<>());
  for (String s : sprites) items.get(s.substring(0, s.indexOf("-"))).add(new Item(s.substring(0, s.indexOf("-")) + " " + s.substring(s.indexOf("-") + 1, s.length() - 4), loadImage("sprites/" + s)));

  up = loadImage("assets/rogue_up.png");
  down = loadImage("assets/rogue_down.png");
  left = loadImage("assets/rogue_left.png");
  right = loadImage("assets/rogue_right.png");
  
  PImage sl = loadImage("assets/skeleton_left.png");
  sl.resize(30, 30);
  PImage sr = loadImage("assets/skeleton_right.png");
  sr.resize(30, 30);
  
  PImage dl = loadImage("assets/demon_left.png");
  dl.resize(30, 30);
  PImage dr = loadImage("assets/demon_right.png");
  dr.resize(30, 30);
  
  PImage zl = loadImage("assets/zombie_left.png");
  zl.resize(30, 30);

  PImage zr = loadImage("assets/zombie_right.png");
  zr.resize(30, 30);
  
  mobSprites = new HashMap<>() {{
    put("skeleton", new PImage[]{sl, sr});
    put("demon", new PImage[]{dl, dr});
    put("zombie", new PImage[]{zl, zr});
  }};
}

void generate() {
  background(#F4EEFF);
  surface.setTitle("Dungeon - Floor " + floor);
  
  // set stats
  health = 3;
  initial = true;
  slot = 0;
  slots = 0;
  cS = loadImage("assets/coin.png");
  cS.resize(50, 50);

  // Maze setup + Destructuring
  Object[] m = generateMaze(mazeSize);
  maze = (char[][]) m[0];
  end = (int) m[1];
  inventory = new Item[5];

  monsters = new HashMap<>();
  ground = new HashMap<>();

  for (int i = 0; i < mazeSize + 2; i++) {
    for (int j = 0; j < mazeSize + 2; j++) {
      if (maze[i][j] == 'c') {
        fill(#F4EEFF);
        if (!isDeadEnd(maze, new PVector(j, i))) continue;
        if ((int) (Math.random() * 5) == 0) {
          if ((int) (Math.random() * 5) == 0) {
            maze[i][j] = 'h';
            fill(#AD8B73);
          } else {
            maze[i][j] = 'o';
            fill(#FFD3B6);
          }
        } else {
          if ((int) (Math.random() * 2) == 0) {
            maze[i][j] = 'm';
            PVector pos = new PVector(j, i);
            monsters.put(pos, new Monster(monsterList[(int) (Math.random() * monsterList.length)], floor));
          }
        }
      } else fill(#424874);
      drawSquare(j, i);
    }
  }

  // curb monster if on portal
  monsters.remove(new PVector(end, mazeSize));

  // Start + end values/squares
  player = new Runner(1, 1);
  maze[1][1] = 's';
  maze[mazeSize][end] = 'p';

  image(down, 30, 30);
  fill(#F38181);
  drawSquare(end, mazeSize);
  
  player = new Runner(1, 1);
  if (initial) {
    initial = false;
    inventory[slots++] = items.get("common").get(0);
  }
  
  for (PVector pos : monsters.keySet()) image(mobSprites.get(monsters.get(pos).getType())[(int) (Math.random() * 2)], pos.x * 30, pos.y * 30);
  
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
  if (hudScreen) return;
  fill(#424874);
  for (int i = 0; i < mazeSize; i++) drawSquare(i, 0);  
  
  moveMonsters();
  hud();
}

void moveMonsters() {
  if (menu) return;
  // update monster positions in maze
  HashMap<PVector, Monster> next = new HashMap<>();
  for (PVector pos : monsters.keySet()) {
    if ((int) (Math.random() * 5) != 1) {
      next.put(pos, monsters.get(pos));
      continue;
    }
    
    ArrayList<PVector> cells = neighborCells(pos, mazeSize, 1);
    cells.removeIf(p -> maze[(int) p.y][(int) p.x] != 'c');    
    if (cells.size() == 0) {
      next.put(pos, monsters.get(pos));
      continue;
    }

    Monster m = monsters.get(pos);

    maze[(int) pos.y][(int) pos.x] = 'c';
    fill(#F4EEFF);
    drawSquare(pos);
    
    PVector newPos = cells.get((int) (Math.random() * cells.size()));
    next.put(newPos, m);
    maze[(int) newPos.y][(int) newPos.x] = 'm';

    image(mobSprites.get(m.getType())[pos.x < newPos.x ? 1 : 0], newPos.x * 30, newPos.y * 30);    
  }
  monsters = next;
}

void keyPressed() {
  // regular input
  if (!hudScreen) {
    if (Character.isDigit(key)) if (key > '0' && key < '6') slot = key - 49;
    switch (key) {
      case 'w':
      case 'a':
      case 's':
      case 'd':
        if (menu) return;
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
      default:
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
  if (mouseButton == LEFT) player.attack();
  else if (mouseButton == RIGHT) player.interact();
  else player.drop();
  update();
}
