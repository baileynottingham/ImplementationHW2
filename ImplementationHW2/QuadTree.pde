/** //<>// //<>//
 * Maintains a pointer to the root, and has the responsibility
 * to add line segments to its children, and query itself.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class QuadTree {

  private int height = 0;
  private Node root = new Node();
  private int numberOfNodes = 0;
  private int numberOfSegments = 0;

  QuadTree(int height) {
    this.height = height;
    root.setRegion(new Rectangle(0, 512, 0, 512));
    int numPixels = (int) java.lang.Math.pow(2, height);
    root.setRegion(new Rectangle(0, numPixels, 0, numPixels));
    root.setSplitRegion(SplitRegion.WHOLE_GRAPH);
    root.setHeight(0);
    // Regardless of the data, the QuadTree always has four leaf nodes to begin with.
    split(root);
  }

  public void insert(LineSegment lineSegment) {
    insert(lineSegment, root);
    traverseTree();
    println("--------------------------------------------");
  }

  public void insert(LineSegment lineSegment, Node v) {
    if (v == null) {
      System.err.println("QuadTree[ insert ] v is null. This shouldn't happen.");
      return;
    }
    if ((v.getRegion().isDisjoint(lineSegment))) {
      return;
    } 
    if (!v.isLeaf()) {
      for (Node u : v.getChildren()) {
        insert(lineSegment, u);
      }
    } else {
      v.addLineSegment(lineSegment);
      if (v.shouldSplit()) {
        System.err.println("QuadTree[ insert ]: we are going to split.");
        split(v);
      }
    }
  }

  public void split(Node v) {
    if (v.getHeight() >= this.height) {
      System.err.println("Can not split anymore becuase we have reached the max height");
      // delete the line segment that we just added because we have reached the maximum split level.
      v.getLineSegments().remove(v.getLineSegments().size() - 1);
      return;
    }
    int xmin = v.getRegion().getXMin();
    int ymin = v.getRegion().getYMin();

    int width = v.getRegion().getWidth();
    int height = v.getRegion().getHeight();

    int newHeight = v.getHeight() + 1;

    Rectangle northWestRegion = new Rectangle(xmin, xmin +(width / 2), ymin, ymin + (height / 2));
    Rectangle southWestRegion = new Rectangle(xmin, xmin + (width / 2), ymin + (height / 2), ymin + height);
    Rectangle northEastRegion = new Rectangle(xmin + (width / 2), xmin + width, ymin, ymin + (height / 2));
    Rectangle southEastRegion = new Rectangle(xmin + (width / 2), xmin + width, ymin + (height / 2), ymin + height);

    v.children.add(new Node(northWestRegion, SplitRegion.NORTH_WEST, newHeight));
    v.children.add(new Node(northEastRegion, SplitRegion.NORTH_EAST, newHeight));
    v.children.add(new Node(southWestRegion, SplitRegion.SOUTH_WEST, newHeight));
    v.children.add(new Node(southEastRegion, SplitRegion.SOUTH_EAST, newHeight));
    for (Node u : v.getChildren()) {
      for (LineSegment lineSegment : v.getLineSegments()) {
        insert(lineSegment, u);
      }
    }
  }

  public void report(Rectangle queryDisk) {
    resetAllLineSegments(root);
    report(queryDisk, root);
  }

  /**
   * Will not return a list, will only modify the LineSegment objects that are contained in the QueryDisk.
   * So in the draw method you will only have to go through the lineSegments list and it will have the width, and
   * color modified.
   */
  public void report(Rectangle queryDisk, Node v) {
    // 1.If v is NULL – return.
    if (v == null) {
      return;
    }

    // 2.If R(v) is disjoint from Q – return
    if (v.getRegion().isDisjoint(queryDisk)) {
      return;
    }

    // 3.If R(v) is fully contained in Q –
    // report all points in the subtree
    // rooted at v.
    if (v.getRegion().isFullyContained(queryDisk)) {
      changeLineSegments(v);
    }

    // 4.If v is a leaf – check each point
    // in R(v) if inside Q
    if (v.isLeaf()) {
      for (LineSegment lineSegment : v.getLineSegments()) {
        if (v.getRegion().doesIntersectWith(lineSegment)) {
          changeLineSegment(lineSegment);
        }
      }
    } else {
      for (Node u : v.getChildren()) {
        report(queryDisk, u);
      }
    }
    return;
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
    } else {
      println("[ Region: " + node.getSplitRegion() + ".\t" + node.getRegion()+"\t Width: " + node.getRegion().getWidth() + "\t Height: " + node.getRegion().getHeight());
      print("line segments: ");
      for (LineSegment lineSegment : node.getLineSegments()) {
        print(lineSegment + ", ");
      }
      println("]");
    }
    return;
  }

  private void resetAllLineSegments(Node v) {
    for (LineSegment lineSegment : v.getLineSegments()) {
      lineSegment.getColor().setBlack();
      lineSegment.setWeight(4);
    }
    if (!v.isLeaf()) {
      for (Node u : v.getChildren())
        resetAllLineSegments(u);
    }
  }
  private void changeLineSegment(LineSegment lineSegment) {
    lineSegment.setColor(new Color(0, 0, 255));
    lineSegment.setWeight(8);
  }

  private void changeLineSegments(Node v) {
    for (LineSegment lineSegment : v.getLineSegments()) {
      changeLineSegment(lineSegment);
    }
    if (!v.isLeaf()) {
      for (Node u : v.getChildren()) {
        changeLineSegments(u);
      }
    }
  }

  int getNumberOfNodes() {
    numberOfNodes = 0;
    travsereTreeGetNumberOfNodes(root);
    int temp = numberOfNodes;
    numberOfNodes = 0;
    return temp;
  }

  void travsereTreeGetNumberOfNodes(Node node) {
    if (!node.isLeaf()) {
      numberOfNodes++;
      for (Node u : node.getChildren()) {
        travsereTreeGetNumberOfNodes(u);
      }
    } else {
      numberOfNodes++;
    }
  }

  int getNumberOfSegments() {
    numberOfSegments = 0;
    travsereTreeGetNumberOfSegments(root);
    int temp = numberOfSegments;
    numberOfSegments = 0;
    return temp;
  }

  void travsereTreeGetNumberOfSegments(Node node) {
    if (!node.isLeaf()) {
      for (Node u : node.getChildren()) {
        travsereTreeGetNumberOfSegments(u);
      }
    } else {
      numberOfSegments = numberOfSegments + node.getLineSegments().size();
    }
  }

  public void displayQuadTree(Node node) {
    if (!node.isLeaf()) {
      drawSplitRegion(node);
      flush();
      for (Node u : node.getChildren()) {
        displayQuadTree(u);
      }
    } else {
      java.util.List<LineSegment> segs = node.getLineSegments();
      strokeWeight(3);
      stroke(51, 51, 255);
      for (int i = 0; i < segs.size(); i++) {
        line(segs.get(i).getLeftPoint().getX(), segs.get(i).getLeftPoint().getY(), segs.get(i).getRightPoint().getX(), segs.get(i).getRightPoint().getY());
      }
      flush();
    }
  }

  public void drawSplitRegion(Node node) {
    stroke(0);
    strokeWeight(2);
    // Draw upper segment of rectangle node
    line(node.getRegion().getXMin(), node.getRegion().getYMin(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin());
    // Draw lower segment of rectangle
    line(node.getRegion().getXMin(), node.getRegion().getYMin() + node.getRegion().getHeight(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw right segment of rectangle
    line(node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw left segment of rectangle
    line(node.getRegion().getXMin(), node.getRegion().getYMin(), node.getRegion().getXMin(), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw vertical segment down the middle
    line(node.getRegion().getXMin() + (node.getRegion().getWidth() / 2), node.getRegion().getYMin(), node.getRegion().getXMin() + (node.getRegion().getWidth() / 2), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw horizontal segment
    line(node.getRegion().getXMin(), node.getRegion().getYMin() + (node.getRegion().getHeight() / 2), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin() + (node.getRegion().getHeight() / 2));
  }
}