
//Buttons
Button readFileButton;
Button restartButton;
Button insertButton;
Button animationButton;
Button reportButton;
Button partyButton;
QuadTree quadTree = null;
java.util.List<LineSegment> lineSegments = null;


void setup() {
  size(800, 512);
  smooth();
  textSize(16);

  //Create Clickable Buttons
  restartButton = new Button("Restart", 15, 450, 115, 35);
  readFileButton = new Button("Read File", 145, 450, 115, 35);
  animationButton = new Button("Animation", 275, 450, 115, 35);
  insertButton = new Button("Insert", 405, 450, 115, 35);
  reportButton = new Button("Report", 535, 450, 115, 35);
  
} //END setup


void draw() {
  smooth();
  fill(256,256,256);
  rect(0, 0, 799, 399);
  
  fill(0);
  rect(0, 400, 800, 100);
  fill(256,256,256);
  drawButtons();
  fill(256,256,256);
  textAlign(LEFT, TOP);
  text("Type Filename: " + "sample text goes here", 10, 410, width, height);
  fill(250,0,0);
  
} //END draw

/*******************************************************************************
 * restart()
 *
 * Description: clears all global variables so that the user can restart the
 *              program without stopping the entire thing.
 *******************************************************************************/
void restart() {
  
} //END restart


/*******************************************************************************
 * mousePressed()
 *
 * Description: Handles logic for mouse presses.
 *              A single mouse click could be hitting any of the buttons.
 *******************************************************************************/
void mousePressed() {
  // user presses "Restart"
  if (restartButton.mouseOver()) {
      javax.swing.JOptionPane.showMessageDialog(null, "restart Button Pressed ");
    restart();
  }
  // user presses "Read File" or "Read New File"
  else if (readFileButton.mouseOver()) {
      String fileName = javax.swing.JOptionPane.showInputDialog( null, "File Name", "" );
      processFile( fileName );
   
  }
  // user presses "Quit"
  else if (reportButton.mouseOver()) {
      javax.swing.JOptionPane.showMessageDialog(null, "Quit Button Pressed ");
    exit();
  }
  // user presses "Highlight"
  else if (animationButton.mouseOver() ) {
    
      javax.swing.JOptionPane.showMessageDialog(null, "Highlight Button Pressed ");
   
  }
  // user presses "Next"
  else if (insertButton.mouseOver()) {
    
    javax.swing.JOptionPane.showMessageDialog(null, "Next Button Pressed ");
    
  
    
    }
} //END mousePressed

void processFile(String fileName) {
  quadTree = new QuadTree();
  lineSegments = parseFile(fileName);
  println("number of line segments: "+lineSegments.size());
}

java.util.List<LineSegment> parseFile(String filename) {
  BufferedReader reader;
  String line = null;
  reader = createReader(filename);
  java.util.List<LineSegment> lines = new ArrayList<LineSegment>();
  try {
    quadTree.setHeight(Integer.parseInt(reader.readLine()));
    // Since we don't know how many points we will have,
    // we just check if line is not null. Kinda like in C.
    while ((line = reader.readLine()) != null) {
      String[] ints = line.split(",");
      if (ints.length != 3) {
        throw new Exception("Excpeted 3 integers.");
      }
      int x1 = Integer.parseInt(ints[0]);
      int x2 = Integer.parseInt(ints[1]);
      int y = Integer.parseInt(ints[2]);
      lines.add(new LineSegment(x1, x2, y));
      }
      reader.close();
    }
    catch (Exception e) {
      System.err.println("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
    }
    return lines;
}


/*******************************************************************************
 * drawButtons()
 *
 * Description: Draws all program buttons (defined as global variables)
 *******************************************************************************/
void drawButtons() {
  readFileButton.setText("Read File");
  restartButton.drawButton();
  readFileButton.drawButton();
  animationButton.drawButton();
  insertButton.drawButton();
  reportButton.drawButton();
 
}