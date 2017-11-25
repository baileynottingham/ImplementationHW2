//<>// //<>//
//Buttons
Button readFileButton;
Button restartButton;
Button insertButton;
Button animationButton;
Button reportButton;
Button partyButton;
QuadTree quadTree = null;
java.util.List<LineSegment> lineSegments = new ArrayList<LineSegment>();

boolean quadTreeInitialized = false;
boolean animationOn = true;
boolean insertOn = false;
boolean reportOn = false;

int tempX = 0;
int tempY = 0;
int topLeftX = 0;
int topLeftY = 0;
int bottomRightX = 0;
int bottomRightY = 0;
int clicks = 0;
boolean justInserted = false;

double highlightTime=3000;
double startTime = 0;

void setup() {
  size(512, 630);
  smooth();
  textSize(16);

  //Create Clickable Buttons
  restartButton = new Button("Restart", 10, 520, 80, 35);
  readFileButton = new Button("Read File", 110, 520, 80, 35);
  animationButton = new Button("Animation", 210, 520, 90, 35);
  insertButton = new Button("Insert", 320, 520, 80, 35);
  reportButton = new Button("Report", 420, 520, 80, 35);
} //END setup


void draw() {
  smooth();
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(256, 256, 256);
  rect(0, 0, 512, 512);

  fill(102, 255, 178);
  rect(0, 512, 512, 188);
  fill(256, 256, 256);
  drawButtons();
  fill(256, 256, 256);
  textAlign(LEFT, TOP);
  text("Type Filename: " + "sample text goes here", 10, 410, width, height);
  displayBottomText();
  fill(250, 0, 0);

  double currentTime= millis();
  if (quadTreeInitialized && (currentTime-startTime) > highlightTime || animationOn == false) {
    quadTree.displayQuadTree(quadTree.getRoot());
  }
  if (quadTreeInitialized && animationOn && justInserted && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot());
    quadTree.animateInsert(tempX, tempY, quadTree.getRoot());
  }

  if (quadTreeInitialized && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot());
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReport(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if ((currentTime-startTime) > highlightTime) {
    justInserted = false;
  }
  flush();
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
  if (insertOn) {
    tempX = mouseX;
    tempY = mouseY;
    quadTree.insert(new LineSegment(tempX, tempX, tempY));
    justInserted = true;
    startTime= millis();
  }

  if (reportOn) {
    if (clicks == 2) {
      clicks = 0;
    }
    if (clicks == 0) {
      topLeftX = mouseX;
      topLeftY = mouseY;
    }
    if (clicks == 1) {
      bottomRightX = mouseX;
      bottomRightY = mouseY;
      startTime= millis();
    }
    clicks++;
  }

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
    if (reportOn == false) {
      reportOn = true;
    } else {
      reportOn = false;
    }
  }
  // user presses "Animation"
  else if (animationButton.mouseOver() ) {
    if (animationOn == false) {
      animationOn = true;
    } else {
      animationOn = false;
    }
  }
  // user presses "Insert"
  else if (insertButton.mouseOver()) {
    if (insertOn == false) {
      insertOn = true;
    } else {
      insertOn = false;
    }
  }
} //END mousePressed

void processFile(String fileName) {
  int height = parseFileForHeight(fileName);
  quadTree = new QuadTree(height);
  // quadTree.traverseTree();
  parseFileForLineSegments(fileName);
  println("Number of line segments: "+ lineSegments.size());

  for (LineSegment lineSegment : lineSegments) {
    quadTree.insert(lineSegment);
  }
  quadTree.traverseTree();
  quadTreeInitialized = true;
}

int parseFileForHeight(String filename) {
  BufferedReader reader = createReader(filename);
  try {
    int height = Integer.parseInt(reader.readLine());
    reader.close();
    return height;
  } 
  catch (Exception e) {
  }
  return -1;
}

void parseFileForLineSegments(String filename) {
  BufferedReader reader;
  String line = null;
  reader = createReader(filename);

  try {
    // read the first line, but dont do anything with it.
    Integer.parseInt(reader.readLine());
    // Since we don't know how many points we will have,
    // we just check if line is not null. Kinda like in C.
    while ((line = reader.readLine()) != null) {
      String[] ints = line.split(",");
      if (ints.length != 3) {
        System.err.println("Excpeted 3 integers.");
        continue;
      }
      int x1 = Integer.parseInt(ints[0].trim());
      int x2 = Integer.parseInt(ints[1].trim());
      int y = Integer.parseInt(ints[2].trim());
      lineSegments.add(new LineSegment(x1, x2, y));
    }
    reader.close();
  }
  catch (Exception e) {
    System.err.println("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
  }
  return;
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

void displayBottomText() {
  fill(0);
  text("Animation Mode = ", 10, 565, width, height);
  if (animationOn) {
    text("ON", 157, 565, width, height);
  } else {
    text("OFF", 157, 565, width, height);
  }
  text("Insert Mode = ", 10, 585, width, height);
  if (insertOn) {
    text("ON", 122, 585, width, height);
  } else {
    text("OFF", 122, 585, width, height);
  }
  text("Report Mode = ", 10, 605, width, height);
  if (reportOn) {
    text("ON", 128, 605, width, height);
  } else {
    text("OFF", 128, 605, width, height);
  }
  if (quadTreeInitialized) {
    text("Number of Nodes = " + quadTree.getNumberOfNodes(), 280, 585, width, height);
    text("Number of Segments = " + quadTree.getNumberOfSegments(), 280, 565, width, height);
  } else {
    text("Number of Nodes = 0", 280, 585, width, height);
    text("Number of Segments = 0", 280, 565, width, height);
  }
}