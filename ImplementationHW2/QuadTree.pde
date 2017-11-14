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
    int xmin = v.getRegion().getXMin();
    int xmax = v.getRegion().getXMax();
    int ymin = v.getRegion().getYMin();
    int ymax = v.getRegion().getYMax();

    int width = xmax - xmin;
    int height = ymax - ymin;
    int xShift = xmin;
    int yShift = ymin;

    Rectangle northWestRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);
    yShift = ymin + ((ymax/2) - ymin);
    Rectangle southWestRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);
    xShift = xmin + ((xmax/2) - xmin);
    Rectangle northEastRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);
    yShift = ymin + ((ymax/2) - ymin);
    Rectangle southEastRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);

    v.getChildren().add(new Node(northWestRegion, SplitRegion.NORTH_WEST));
    v.getChildren().add(new Node(northEastRegion, SplitRegion.NORTH_EAST));
    v.getChildren().add(new Node(southWestRegion, SplitRegion.SOUTH_WEST));
    v.getChildren().add(new Node(southEastRegion, SplitRegion.SOUTH_EAST));

    for (Node u : v.getChildren()) {
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

  public void traverseTree() {
    traverseHelper(root);
  }

  public void traverseHelper(Node node) {
    if (!node.isLeaf()) {
      for (Node u : node.getChildren()) {
        traverseHelper(u);
      }
    }
    for (LineSegment lineSegment : node.getLineSegments()) {
      println(lineSegment);
    }
    return;
  }
}