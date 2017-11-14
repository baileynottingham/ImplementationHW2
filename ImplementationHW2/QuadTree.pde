/**
 * Maintains a pointer to the root, and has the responsibility
 * to add line segments to its children, and query itself.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class QuadTree {

  private int height = 0;
  private Node root = new Node();
  // width & height
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

    Rectangle northWestRegion = new Rectangle(xmin, xmax/2, ymin, ymax/2);
    Rectangle northEastRegion = new Rectangle(xmax/2, xmax, ymin, ymax/2);
    Rectangle southWestRegion = new Rectangle(xmin, xmax/2, ymax/2, ymax);
    Rectangle southEastRegion = new Rectangle(xmax/2, xmax, ymax/2, ymax);

    Node northWestNode = new Node(northWestRegion);
    Node northEastNode = new Node(northEastRegion);
    Node southWestNode = new Node(southWestRegion);
    Node southEastNode = new Node(southEastRegion);

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

  public void traverseTree() {
    traverseHelper(root);
  }

  public void traverseHelper(Node node) {
    if (!node.isLeaf()) {
      for (Node u : node.getChildre()) {
        traverseHelper(u);
      }
    }
    for (LineSegment lineSegment : node.getLineSegments()) {
      println(lineSegment);
    }
    return;
  }
}