/**
 * Maintains a pointer to the root, and has the responsibility
 * to add line segments to its children, and query itself.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class QuadTree {

  private int height = 0;
  private Node root = new Node();

  QuadTree() {
    root.setRegion(new Rectangle(0, 512, 0, 512));
    int numPixels = (int) java.lang.Math.pow(2, getHeight());
    root.setRegion(new Rectangle(0, numPixels, 0, numPixels));
  }

  public void insert(LineSegment lineSegment, Node v) {
    if (v == null) {
      System.err.println("QuadTree[ insert ] v is null. This shouldn't happen.");
      return;
    }
    if (v.getRegion().isDisjoint(lineSegment)) {
      return;
    } else if (!v.isLeaf()) {
      for (Node u : v.getChildren()) {
        insert(lineSegment, u);
      }
    } else {
      v.addLineSegment(lineSegment);
      if (v.shouldSplit()) {
        split(v);
      }
    }
  }

  public void split(Node v) {
    /* xmin                   xmax
     * ymin    
     *          
     *          ____________
     *         |      |     |
     *         |  NW  |  NE |
     *         |______|_____|
     *         |      |     |
     *         |  SW  | SE  |
     *          ____________
     * ymax
     */
    int xmin = v.getRegion().getXMin();
    int xmax = v.getRegion().getXMax();
    int ymin = v.getRegion().getYMin();
    int ymax = v.getRegion().getYMax();
    Node northWestNode = new Node(xmin, ymin, xmax/2, ymax/2);
    Node northEastNode = new Node(xmax/2, ymin, xmax, ymax/2);
    Node southWestNode = new Node(xmin, ymax/2, xmax/2, ymax);
    Node southEastNode = new Node(xmax/2, ymax/2, xmax, ymax);
    v.getChildren().add(northWestNode);
    v.getChildren().add(northEastNode);
    v.getChildren().add(southWestNode);
    v.getChildren().add(southEastNode);

    for (Node u : v.getChildren) {
      for (LineSegment lineSegment : v.getLineSegments()) {
        insert(lineSegment, u);
      }
    }
  }

  public Node getRoot() {
    return root;
  }

  public void setRoot(Node root) {
    this.root = root;
  }

  public int getHeight() {
    return height;
  }

  public void setHeight(int height) {
    this.height = height;
  }
}