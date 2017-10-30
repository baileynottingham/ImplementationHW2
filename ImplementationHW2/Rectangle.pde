

class Rectangle {
   
  int xmin;
  int xmax;
  int ymin;
  int ymax;
  
  Rectangle(int xmin, int xmax, int ymin, int ymax) {
    this.xmin = xmin;
    this.xmax = xmax;
    this.ymin = ymin;
    this.ymax = ymax;
  }

  public boolean isDisjoint(LineSegment lineSegment) {
    return false;
  }

}