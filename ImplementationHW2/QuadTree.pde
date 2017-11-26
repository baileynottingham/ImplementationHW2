/* //<>//
 * Maintains a pointer to the root, and has the responsibility
 * to add line segments to its children, and query itself.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class QuadTree {

  private int height = 0;
  private Node root;
  private int numberOfNodes = 0;
  private int numberOfSegments = 0;
  private java.util.Set<LineSegment> segments = new java.util.HashSet<LineSegment>();
  private int partyModeCounter = 0;
  private java.util.List<String> errorMessages = new java.util.ArrayList<String>();

  /**
   * Sets up an empty Quad Tree with a given height as a parameter.
   * Then does the initial splitting of the four regions.
   */
  QuadTree(int height) {
    this.height = height;
    int numPixels = (int) java.lang.Math.pow(2, height);
    root = new Node(new Rectangle(0, numPixels, 0, numPixels), SplitRegion.WHOLE_GRAPH, 0);
    root.markReported();
    split(root);
  }

  /**
   * @returns The current line segments in the Quad Tree.
   */
  public java.util.Set<LineSegment> getLineSegments() {
    return segments;
  }

  /**
   * Inserts the a new line segment.
   */
  public void insert(LineSegment lineSegment) {
    insert(lineSegment, root);

    if (!(root.getRegion().isDisjoint(lineSegment))) { 
      numberOfSegments++;
      segments.add(lineSegment);
    }
  }

  /**
   * The recursive steps to insert a new line segment into the Quad Tree.
   */
  public void insert(LineSegment lineSegment, Node v) {
    if (v == null) {
      System.err.println("QuadTree[ insert ] v is null. This shouldn't happen.");
      errorMessages.add("QuadTree[ insert ] v is null. This shouldn't happen.");
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
        split(v);
      }
    }
  }

  /**
   * Takes in the node that needs to be split into four new regions to distribute the data.
   * Creates four new nodes that represent North-East, North-West, South-East, and South-West.
   * Then distributes the four line segments into the respecitve regions.
   */
  public void split(Node v) {
    if (v.getHeight() >= this.height) {
      System.err.println("Can not split anymore becuase we have reached the max height");
      System.err.println("Going to delete the line segment that was just inserted, because it doesn't fit.");
      // delete the line segment that we just added because we have reached the maximum split level.
      if (v.getLineSegments().size() >= 1) {
        v.getLineSegments().remove(v.getLineSegments().size() - 1);
      }
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
  /**
   * Mark all of the nodes in the query region in O(h) time.
   */
  public void report(Rectangle queryDisk) {
    unmark(root);
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
    if (queryDisk.containsRect(v.getRegion())) {
      v.markReported();
      changeLineSegments(v);
    }

    if (v.getRegion().containsRect(queryDisk) || !(v.getRegion().isDisjoint(queryDisk))) {
      v.markReported();
    }

    // 4.If v is a leaf – check each point
    // in R(v) if inside Q
    if (v.isLeaf()) {
      for (LineSegment lineSegment : v.getLineSegments()) {
        if (queryDisk.doesIntersectWith(lineSegment)) {
          lineSegment.markReported();
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
    println("Node reported? = " + node.reported);
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
  /**
   * Animation helper method.
   * Will traverse through all of the nodes and 'unmark' the nodes.
   */
  public void unmark(Node node) {
    if (!node.isLeaf()) {
      node.unmarkReported();
      for (Node u : node.getChildren()) {
        unmark(u);
      }
    } else {
      node.unmarkReported();
      for (LineSegment lineSegment : node.getLineSegments()) {
        lineSegment.unmarkReported();
      }
    }
    return;
  }
  /**
   * Animation helper method.
   * Will mark the line segment as reported.
   */
  private void changeLineSegment(LineSegment lineSegment) {
    lineSegment.markReported();
  }
  /**
   * Animation helper method.
   * Will traverse through all of the line segments in this node's region
   * and mark them.
   */
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
    return numberOfSegments;
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

  public void displayQuadTree(Node node, boolean partyMode) {
    if (!node.isLeaf()) {
      drawSplitRegion(node);
      flush();
      for (Node u : node.getChildren()) {
        displayQuadTree(u, partyMode);
      }
    } else {
      java.util.List<LineSegment> segs = node.getLineSegments();
      strokeWeight(3);
      for (int i = 0; i < segs.size(); i++) {
        if (partyMode && partyModeCounter++ % 60 == 0) {
          java.util.Random random_color = new java.util.Random();
          int r = random_color.nextInt(256);
          int g = random_color.nextInt(256);
          int b = random_color.nextInt(256);
          stroke(r, g, b);
        } else {
          stroke(51, 51, 255);
        }
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

  public void drawSplitRegionReport(Node node) {
    stroke(255, 0, 0);
    strokeWeight(5);
    // Draw upper segment of rectangle node
    line(node.getRegion().getXMin(), node.getRegion().getYMin(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin());
    // Draw lower segment of rectangle
    line(node.getRegion().getXMin(), node.getRegion().getYMin() + node.getRegion().getHeight(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw right segment of rectangle
    line(node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin(), node.getRegion().getXMin() + node.getRegion().getWidth(), node.getRegion().getYMin() + node.getRegion().getHeight());
    // Draw left segment of rectangle
    line(node.getRegion().getXMin(), node.getRegion().getYMin(), node.getRegion().getXMin(), node.getRegion().getYMin() + node.getRegion().getHeight());
  }

  public void drawSplitRegionReport(Rectangle rect) {
    stroke(0, 255, 0);
    strokeWeight(5);
    // Draw upper segment of rectangle node
    line(rect.getXMin(), rect.getYMin(), rect.getXMin() + rect.getWidth(), rect.getYMin());
    // Draw lower segment of rectangle
    line(rect.getXMin(), rect.getYMin() + rect.getHeight(), rect.getXMin() + rect.getWidth(), rect.getYMin() + rect.getHeight());
    // Draw right segment of rectangle
    line(rect.getXMin() + rect.getWidth(), rect.getYMin(), rect.getXMin() + rect.getWidth(), rect.getYMin() + rect.getHeight());
    // Draw left segment of rectangle
    line(rect.getXMin(), rect.getYMin(), rect.getXMin(), rect.getYMin() + rect.getHeight());
  }

  public void animateInsert(int x, int y, Node node) {
    if (!node.isLeaf() && node.getRegion().containsPoint(x, y)) {
      drawSplitRegionReport(node);
      for (Node u : node.getChildren()) {
        animateInsert(x, y, u);
      }
    } else {
      if (node.isLeaf() && node.getRegion().containsPoint(x, y)) {
        drawSplitRegionReport(node);
      }
    }
    return;
  }

  public void animateReport(Node node) {
    if (!node.isLeaf()) {
      if (node.reported) {
        drawSplitRegionReport(node);
      }
      for (Node u : node.getChildren()) {
        animateReport(u);
      }
    } else {
      if (node.isLeaf()) {
        if (node.reported) {
          drawSplitRegionReport(node);
        }
        java.util.List<LineSegment> segs = node.getLineSegments();
        stroke(51, 51, 255);
        strokeWeight(5);
        for (int i = 0; i < segs.size(); i++) {
          if (segs.get(i).reported) {
            line(segs.get(i).getLeftPoint().getX(), segs.get(i).getLeftPoint().getY(), segs.get(i).getRightPoint().getX(), segs.get(i).getRightPoint().getY());
          }
        }
      }
    }

    return;
  }

  public void animateReportNoAnimation(Node node) {
    if (!node.isLeaf()) {
      for (Node u : node.getChildren()) {
        animateReportNoAnimation(u);
      }
    } else {
      if (node.isLeaf()) {
        java.util.List<LineSegment> segs = node.getLineSegments();
        stroke(51, 51, 255);
        strokeWeight(5);
        for (int i = 0; i < segs.size(); i++) {
          if (segs.get(i).reported) {
            line(segs.get(i).getLeftPoint().getX(), segs.get(i).getLeftPoint().getY(), segs.get(i).getRightPoint().getX(), segs.get(i).getRightPoint().getY());
          }
        }
      }
    }
    return;
  }

  public void setErrorMessages(java.util.List<String> errorMessages) {
    this.errorMessages = errorMessages;
  }
}