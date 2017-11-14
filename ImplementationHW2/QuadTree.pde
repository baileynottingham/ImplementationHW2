/**
 * Maintains a pointer to the root, and has the responsibility
 * to add line segments to its children, and query itself.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class QuadTree {

  int i = 0;
  private int height = 0;
  private Node root = new Node();

  QuadTree(int height) {
    this.height = height;
    root.setRegion(new Rectangle(0, 512, 0, 512));
    int numPixels = (int) java.lang.Math.pow(2, height);
    root.setRegion(new Rectangle(0, numPixels, 0, numPixels));
    root.setSplitRegion(SplitRegion.WHOLE_GRAPH);
    // Regardless of the data, the QuadTree always has four leaf nodes to begin with.
    split(root);
  }

  public void insert(LineSegment lineSegment) {
    insert(lineSegment, root);
  }

  public void insert(LineSegment lineSegment, Node v) {
    if (v == null) {
      System.err.println("QuadTree[ insert ] v is null. This shouldn't happen.");
      return;
    }
    if (v.getRegion().isDisjoint(lineSegment)) {
      if ( i >= 2) {
        println("Line segment is disjoint from node.");
        println("region: "+v.getRegion() + ".\tlineSegment: " + lineSegment );
      }      
      return;
    } else if (!v.isLeaf()) {
      for (Node u : v.getChildren()) {
        insert(lineSegment, u);
      }
    } else {
      println("QuadTree[ insert ]: v is a leaf, let us insert.");
      v.addLineSegment(lineSegment);
      if (v.shouldSplit()) {
        split(v);
      } //<>//
    }
  }

  public void split(Node v) { //<>//
    System.err.println("QuadTree[ split ]: splitting: " + v.getRegion()+" " + v.getSplitRegion());
    if (i++ == 2) {
      println();
    }
    java.util.List<Node> children = v.getChildren();
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
    yShift = ymin;
    Rectangle northEastRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);
    yShift = ymin + ((ymax/2) - ymin);
    Rectangle southEastRegion = new Rectangle(xShift, xShift + width / 2, yShift, yShift + height / 2);

    children.add(new Node(northWestRegion, SplitRegion.NORTH_WEST));
    children.add(new Node(northEastRegion, SplitRegion.NORTH_EAST));
    children.add(new Node(southWestRegion, SplitRegion.SOUTH_WEST));
    children.add(new Node(southEastRegion, SplitRegion.SOUTH_EAST));

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
    } else {
      print("[ Region: " + node.getSplitRegion() + ".\t" + node.getRegion()+"\t");
      //  + ".\t" + "Number of line segments: " + node.getLineSegments().size() + " ]"
      print("line segments: ");
      for (LineSegment lineSegment : node.getLineSegments()) {
        print(lineSegment + ", ");
      }
      println("]");
    }
    return;
  }
}