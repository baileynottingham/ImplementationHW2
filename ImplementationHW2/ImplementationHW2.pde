
//Buttons
Button readFileButton;
Button restartButton;
Button insertButton;
Button animationButton;
Button reportButton;
Button partyButton;



void setup() {
  size(800, 500);
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
  QuadTree tree = new QuadTree(fileName);
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