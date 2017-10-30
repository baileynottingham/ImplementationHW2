

class QuadTree {

  private int height;
  java.util.List<LineSegment> lineSegments;
  private Node root;

  QuadTree(String filename) {
    setLineSegments(parseFile(filename));
    root = new Node();
    int numPixels = (int) java.lang.Math.pow(2, getHeight()); // 2^h is the number of 'cells' in our image.
    root.setRegion(new Rectangle(0, numPixels, 0, numPixels));
  }

  public void insert(LineSegment lineSegment, Node v) throws Exception {
    if (v == null) {
      throw new NullPointerException("v shouldn't be null.");
    }
    if (v.getRegion().isDisjoint(lineSegment)) {
    }
  }

  public void split(Node v) {
    for (Node child : v.getChildren()) {
      for (LineSegment ls : child.getLineSegments()){
        try {
          insert(ls, child);
        } catch (Exception e) {
          System.err.println(e);
        }
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

  public java.util.List getLineSegments() {
    return lineSegments;
  }

  public void setLineSegments(java.util.List lineSegments) {
    this.lineSegments = lineSegments;
  }

  java.util.List<LineSegment> parseFile(String filename) {
    BufferedReader reader;
    String line = null;
    reader = createReader(filename);
    java.util.List<LineSegment> lineSegs = new ArrayList<LineSegment>();

    try {
      setHeight(Integer.parseInt(reader.readLine()));
      // Since we don't know how many points we will have,
      // we just check if line is not null. Kinda like in C.
      while ((line = reader.readLine()) != null) {
        String[] ints = line.split(",");
        if (ints.length != 3){
          throw new Exception("Excpeted 3 integers.");
        }
        int x1 = Integer.parseInt(ints[0]);
        int x2 = Integer.parseInt(ints[1]);
        int y = Integer.parseInt(ints[2]);
        lineSegs.add(new LineSegment(x1, x2, y));
      }
      reader.close();
    }
    catch (Exception e) {
      System.err.println("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
    }

    return lineSegs;
  }

}