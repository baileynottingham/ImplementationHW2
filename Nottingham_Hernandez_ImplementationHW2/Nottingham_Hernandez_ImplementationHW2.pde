//Buttons
Button readFileButton;
Button partyButton;
Button insertButton;
Button animationButton;
Button reportButton;

QuadTree quadTree = null;
java.util.List<LineSegment> lineSegments = new java.util.ArrayList<LineSegment>();
private String fileName;

boolean quadTreeInitialized = false;
boolean animationOn = true;
boolean insertOn = false;
boolean reportOn = false;
boolean partyMode = false;

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
double startTimeParty = 0;

Firework[] fs = new Firework[10];
boolean once;

private static final int FILE_ERROR = -1;

/**
 * Sets up the canvas, and the buttons.
 */
void setup() {
  size(512, 630);
  smooth();
  textSize(16);

  //Create Clickable Buttons
  partyButton = new Button("Party", 10, 520, 80, 35);
  readFileButton = new Button("Read File", 110, 520, 80, 35);
  animationButton = new Button("Animation", 210, 520, 90, 35);
  insertButton = new Button("Insert", 320, 520, 80, 35);
  reportButton = new Button("Report", 420, 520, 80, 35);

  smooth();
  for (int i = 0; i < fs.length; i++) {
    fs[i] = new Firework();
  }
} //END setup


/**
 * Draw all of the components necessary to display the quad tree.
 */
void draw() {
  clear();
  smooth();
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(256, 256, 256);
  rect(0, 0, 620, 512);

  fill(0, 147, 239);
  rect(0, 512, 620, 188);
  drawButtons();
  fill(256, 256, 256);
  textAlign(LEFT, TOP);
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

  if (quadTreeInitialized && animationOn && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime && !partyMode) {
    quadTree.displayQuadTree(quadTree.getRoot());
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReport(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }
  if (quadTreeInitialized && animationOn && reportOn && clicks != 2 && (currentTime-startTime) <= highlightTime && !partyMode) {
    quadTree.displayQuadTree(quadTree.getRoot());
  }

  if (quadTreeInitialized && animationOn == false && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime && !partyMode) {
    quadTree.displayQuadTree(quadTree.getRoot());
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReportNoAnimation(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if ((currentTime-startTime) > highlightTime) {
    justInserted = false;
  }

  // Redraw the lower portion of GUI in case an h > 9 and the segments and split points appear over our buttons
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(256, 256, 256);
  fill(0, 147, 239);
  rect(0, 512, 620, 188);
  drawButtons();
  fill(256, 256, 256);
  textAlign(LEFT, TOP);
  displayBottomText();
  fill(250, 0, 0);

  if (quadTreeInitialized && partyMode) {
    java.util.Random random_color = new java.util.Random();
    int r = random_color.nextInt(256);
    int g = random_color.nextInt(256);
    int b = random_color.nextInt(256);
    // If you uncomment this it may cause seizures....
    //fill(r, g, b);
    //rect(0, 0, 512, 512);

    quadTree.party(quadTree.getRoot());
    r = random_color.nextInt(256);
    g = random_color.nextInt(256);
    b = random_color.nextInt(256);
    fill(r, g, b);
    rect(0, 512, 620, 188);
    displayBottomText();
    drawButtonsParty();

    stroke(10);
    fill(50, 0, 40, 20);
    rect(0, 0, width, height);
    for (int i = 0; i < fs.length; i++) {
      fs[i].draw();
    }
    flush();
  }
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
  if (insertOn && partyMode == false) {
    tempX = mouseX;
    tempY = mouseY;
    LineSegment pointToBeInserted = new LineSegment(tempX, tempX, tempY);
    for (LineSegment line : quadTree.getLineSegments()) {
      if (line.isPoint()) {
        if (tempX >= (line.getRightPoint().getX() - 2) &&
          tempX <= (line.getRightPoint().getX() + 2) &&
          tempY >= (line.getVerticalShift() - 2) &&
          tempY <= (line.getVerticalShift() + 2)) {
          System.err.println("[ERR] two points are on each other.");
          return;
        }
      } else {
        if (pointToBeInserted.isIntersecting(line)) {
          System.err.println("[ERR] a line and the point you want to insert intersect each other.");
          return;
        }
      }
    }

    quadTree.insert(pointToBeInserted);
    justInserted = true;
    startTime = millis();
  }

  if (reportOn && quadTreeInitialized && !partyMode) {
    if (clicks == 2) {
      clicks = 0;
    }

    if (clicks == 0) {
      topLeftX = mouseX;
      topLeftY = mouseY;
      if (quadTree.getRoot().getRegion().containsPoint(topLeftX, topLeftY)) {
        javax.swing.JOptionPane.showMessageDialog(null, "Top left corner selected. Click where you want the bottom right corner of the query region to be.");
      } else {
        clicks--;
      }
    }

    if (clicks == 1) {
      bottomRightX = mouseX;
      bottomRightY = mouseY;

      boolean isToLeft = topLeftX < bottomRightX;
      boolean isToBottom = topLeftY < bottomRightY;

      if (!isToLeft || !isToBottom) {
        javax.swing.JOptionPane.showMessageDialog(null, "Invalid bottom right selection. Please ensure your click is to the bottom right.");
        return;
      }

      if (quadTree.getRoot().getRegion().containsPoint(bottomRightX, bottomRightY)) {
        startTime= millis();
      } else {
        clicks--;
      }
    }
    clicks++;
  }

  // user presses "Restart"
  if (partyButton.mouseOver()) {
    partyMode = !partyMode;
    insertOn = false;
    reportOn = false;
  } else if (readFileButton.mouseOver() && !partyMode) { // user presses "Read File"
    String fileName = javax.swing.JOptionPane.showInputDialog( null, "File Name", "" );
    processFile( fileName );
  } else if (reportButton.mouseOver() && !partyMode) { // user presses "Report"
    if (reportOn == false) {
      reportOn = true;
      insertOn = false;
      javax.swing.JOptionPane.showMessageDialog(null, "You are now in report mode. Click where you want the top left corner of query region to be.");
    } else {
      reportOn = false;
    }
  } else if (animationButton.mouseOver() && quadTreeInitialized && !partyMode) { // user presses "Animation"
    if (animationOn == false) {
      animationOn = true;
    } else {
      animationOn = false;
    }
  } else if (insertButton.mouseOver() && quadTreeInitialized && !partyMode) { // user presses "Insert"
    if (insertOn == false) {
      insertOn = true;
      reportOn = false;
    } else {
      insertOn = false;
    }
  }
} //END mousePressed

/**
 * launch a fire work if we click on the canvas.
 */
void mouseReleased() {
  if (partyMode) {
    once = false;
    for (int i = 0; i < fs.length; i++) {
      if ((fs[i].hidden)&&(!once)) {
        fs[i].launch();
        once = true;
      }
    }
  }
}

/**
 * Process the file, and construct the Quad-Tree.
 */
void processFile(String fileName) {
  if (fileName == null || fileName.isEmpty()) {
    return;
  }
  this.fileName = fileName;
  int height = parseFileForHeight(this.fileName);

  if (height == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    return;
  }

  quadTree = new QuadTree(height);
  int rtnCode = parseFileForLineSegments(this.fileName);
  if (rtnCode == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    return;
  }
  for (LineSegment lineSegment : lineSegments) {
    quadTree.insert(lineSegment);
  }
  quadTreeInitialized = true;
}

/**
 * Grab the height of the Quad-Tree from the file.
 */
int parseFileForHeight(String filename) {
  BufferedReader reader = createReader(filename);
  try {
    int height = Integer.parseInt(reader.readLine());
    reader.close();
    return height;
  } 
  catch (Exception e) {
    return FILE_ERROR;
  }
}

/**
 * Go through the input file and read in the line segments.
 */
int parseFileForLineSegments(String filename) {
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
    return FILE_ERROR;
  }
  return 1;
}

/*******************************************************************************
 * drawButtons()
 *
 * Description: Draws all program buttons (defined as global variables)
 *******************************************************************************/
void drawButtons() {
  readFileButton.setText("Read File");
  partyButton.drawButton();
  readFileButton.drawButton();
  animationButton.drawButton();
  insertButton.drawButton();
  reportButton.drawButton();
  //  partyButton.drawButton();
}

/**
 * Draw the buttons in party mode.
 */
void drawButtonsParty() {
  readFileButton.setText("Read File");
  partyButton.drawButtonParty();
  readFileButton.drawButtonParty();
  animationButton.drawButtonParty();
  insertButton.drawButtonParty();
  reportButton.drawButtonParty();
  // partyButton.drawButtonParty();
}

/**
 * Draws the status of the program.
 */
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
  String party = (partyMode) ? "ON" : "OFF";
  text("Party Mode = " + party, 280, 605);
}

/**
 * Creates a firework object for the party mode.
 * @author Bailey Nottingham
 * @author Mairo Hernandez
 * Credit: https://www.openprocessing.org/sketch/17259
 */
class Firework {
  float x, y, oldX, oldY, ySpeed, targetX, targetY, explodeTimer, flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched, exploded, hidden;
  color flare;

  /**
   * Initalizes the firework object.
   */
  Firework() {
    launched = false;
    exploded = false;
    hidden = true;
  }
  /**
   * Implements the logic to draw the firework.
   */
  void draw() {
    if (launched && !exploded && !hidden) {
      launchMath();
      strokeWeight(5);
      stroke(255);
      line(x, y, oldX, oldY);
    }
    if (!launched && exploded && !hidden) {
      explodeMath();
      noStroke();
      strokeWeight(flareWeight);
      stroke(flare);
      for (int i = 0; i < flareAmount + 1; i++) {
        pushMatrix();
        translate(x, y);
        point(sin(radians(i*flareAngle))*explodeTimer, cos(radians(i*flareAngle))*explodeTimer);
        popMatrix();
      }
    }
  }
  void launch() {
    x = oldX = mouseX + ((random(5)*10) - 25);
    y = oldY = height;
    targetX = mouseX;
    targetY = mouseY;
    ySpeed = random(3) + 2;
    flare = color(random(3)*50 + 105, random(3)*50 + 105, random(3)*50 + 105);
    flareAmount = ceil(random(30)) + 20;
    flareWeight = ceil(random(10));
    duration = ceil(random(4))*20 + 30;
    flareAngle = 360/flareAmount;
    launched = true;
    exploded = false;
    hidden = false;
  }

  /**
   * Compute the calculations necessary for launching.
   */
  void launchMath() {
    oldX = x;
    oldY = y;
    if (dist(x, y, targetX, targetY) > 6) {
      x += (targetX - x)/2;
      y += -ySpeed;
    } else {
      explode();
    }
  }

  /**
   * Explode the firework.
   */
  void explode() {
    explodeTimer = 0;
    launched = false;
    exploded = true;
    hidden = false;
  }

  /**
   * The calculations to explode.
   */
  void explodeMath() {
    if (explodeTimer < duration) {
      explodeTimer+= 0.4;
    } else {
      hide();
    }
  }

  /**
   * Hide the firework.
   */
  void hide() {
    launched = false;
    exploded = false;
    hidden = true;
  }
}