
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
    for (int i = 0; i < 4; ++i) {
      // TODO: Let the children know what area they cover.
      v.getChildren().add(new Node());
    }
    for (Node child : v.getChildren()) {
      for (LineSegment ls : child.getLineSegments()){
        insert(ls, child);
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