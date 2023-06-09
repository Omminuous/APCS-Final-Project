public class Monster {
  int health = 20;
  String type;

  public Monster(String name, int floor) {
    type = name;
    health = 25 + (floor - 1) % 5 * 10;
  }

  public String getType() {
    return type;
  }

  public void decreaseHealth(int amount, PVector pos) {
    this.health -= amount;
    if (this.health <= 0) {
      coin += (int) (Math.random() * 10);
      maze[(int) pos.y][(int) pos.x] = 'c';
      monsters.remove(pos);
      fill(#F4EEFF);
      
      // random item drop
      int drop = (int) (Math.random() * 10);
      if (drop < 2) {
        maze[(int) pos.y][(int) pos.x] = 'h';
        fill(#AD8B73);
      } else if (drop < 5) {
        maze[(int) pos.y][(int) pos.x] = 'o';
        fill(#FFD3B6);
      }
      drawSquare(pos);
    }
  }

  public int getHealth() {
    return this.health;
  }
}
