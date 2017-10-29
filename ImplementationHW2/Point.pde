/*--------------------------------------------------------------------------------------------
 * Author: Bailey Nottingham & Mario Hernandez
 *
 * Class: Point
 * 
 * Description: Contains the x, and y coordinate of a Point. This will help when drawing on our frame.
 *-------------------------------------------------------------------------------------------*/

class Point {
  int x;
  int y;

  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  /**
   * @returns the Point's x coordinate. 
   */
  int getX() {
    return x;
  }

  /**
   * @returns the Point's y coordinate 
   */
  int getY() {
    return y;
  } 

  /**
   * Sets the x.
   */
  void setX(int x) {
    this.x = x;
  }
  /**
   * Sets the y.
   */
  void setY(int y) {
    this.y = y;
  }

  /**
   * @returns a deep copy of the data.
   */
  Point clone() {
    return new Point(this.x, this.y);
  }

  /**
   * @returns are this, and p2 equal.
   */
  boolean isEqual(Point pt) {
    if (pt == null) {
      return false;
    }

    if (this.x == pt.getX() && this.y == pt.getY()) {
      return true;
    }
    return false;
  }

  String toString() {
    return "(" + x +", " + y + ")";
  }
}