public class Item {
  String name;
  PImage image;
  
  public Item(String n, PImage i) {
    name = n;
    image = i;
  } 
  
  String getName() {
    return name;
  }
  
  PImage getImage() {
    return image;
  }
}
