/* ***************************** */
/* Multimedia Demonstration v1.0 */
/*  Developed  by Jeferson Lima  */
/* ***************************** */
/* Description: Lookup Table     */
/* ***************************** */
/* Libraries used: ControlP5     */
/* ***************************** */
/* INSTALL LIBRARIES BEFORE RUN! */
/* ***************************** */

/* Imports */
import controlP5.*;

/* Box description */
final String boxHeader      = "Lookup Table";
final String boxDescription = "This is a demonstration of how a LUT(Lookup Table) works and how "  +
                              "we can represent colors in a adaptive way.\n" +
                              "Look how LUT can be really fast for adaptively convert colors in images.\n";

/* Controller for P5 */
ControlP5 controlP5;

/* Color & Interface constants */
final int GREY_COLOR = 205;
final int BLACK_COLOR = 50;
final int WHITE_COLOR = 255;

/* Interface constants */
final color backgroundColor = color(GREY_COLOR);    /* Grey  */
final color textColor = color(BLACK_COLOR);         /* Black */
final color boxColor = color(WHITE_COLOR);          /* White */
final int guiWidth = 640;
final int guiHeight = 380;
final int guiSpacing = 10;
final int guiBoxHeight = 120;
final int guiBoxTextSize = 15;
final int guiBoxHeaderSize = 20;

/* Text Description constants */
final int descriptionBoxHeight = guiBoxHeight;
final int descriptionBoxWidth = guiWidth - (2 * guiSpacing);

/* Default Box constants */
final int defaultBoxHeight = guiHeight - (descriptionBoxHeight + (2 * guiSpacing)) - guiSpacing;
final int defaultBoxWidth = (guiWidth / 2) - guiSpacing - (guiSpacing / 2);
final int defaultBoxX1 = guiSpacing;
final int defaultBoxX2 = (guiWidth / 2) + 5;
final int defaultBoxY = descriptionBoxHeight + (2 * guiSpacing);
final int defaultBoxHeaderX = defaultBoxX2 + guiSpacing;
final int defaultBoxHeaderY = defaultBoxY + (int)(2.5 * guiSpacing);
final int defaultBoxDescriptionX = defaultBoxX2 + guiSpacing;
final int defaultBoxDescriptionY = defaultBoxHeaderY + guiSpacing;
final int defaultBoxDescriptionWidth = defaultBoxWidth - (guiSpacing * 2);
final int defaultBoxDescriptionHeight = guiHeight - defaultBoxDescriptionY - guiSpacing;

/* Buttons */
final int generalButtonWidth = 110;
final int generalButtonHeight = 30;
final int generalButtonX1 = guiSpacing * 2;
final int generalButtonX2 = generalButtonX1 + guiSpacing + generalButtonWidth;
final int generalButtonY1 = 205;
final int generalButtonY2 = generalButtonY1 + generalButtonHeight + (guiSpacing / 2);
final int generalButtonY3 = generalButtonY2 + generalButtonHeight + (guiSpacing / 2);

/* Routines of interface */
void setup() {
  /* GUI Setup */
  size(640, 380);
  background(backgroundColor);
  
  /* P5 Initialization */
  controlP5 = new ControlP5(this);
    
  /* Box 1 Description */
  fill(boxColor);
  rect(guiSpacing, guiSpacing, descriptionBoxWidth, descriptionBoxHeight);
    
  /* Box 2 Description */
  fill(boxColor);
  rect(defaultBoxX2, defaultBoxY, defaultBoxWidth, defaultBoxHeight);
  fill(textColor);
  textSize(guiBoxHeaderSize);
  text(boxHeader, defaultBoxHeaderX, defaultBoxHeaderY);
  fill(textColor);
  textSize(guiBoxTextSize);
  text(boxDescription, defaultBoxDescriptionX, defaultBoxDescriptionY, defaultBoxDescriptionWidth, defaultBoxDescriptionHeight);
  
  /* Action Box */
  fill(boxColor);
  rect(defaultBoxX1, defaultBoxY, defaultBoxWidth, defaultBoxHeight);
  
  /* Buttons */
  /* Col 1 */
  controlP5.addButton("ButtonA_Col1")
           .setPosition(generalButtonX1,generalButtonY1)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .setOn()
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("ButtonB_Col1")
           .setPosition(generalButtonX1,generalButtonY2)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("ButtonC_Col1")
           .setPosition(generalButtonX1,generalButtonY3)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  
  /* Col 2 */
  controlP5.addButton("ButtonA_Col2")
           .setPosition(generalButtonX2,generalButtonY1)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .setOn()
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("ButtonB_Col2")
           .setPosition(generalButtonX2,generalButtonY2)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("ButtonC_Col2")
           .setPosition(generalButtonX2,generalButtonY3)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
}

/* Draw Objects */
void draw() {
}

/* Help Functions */
void disableButton(String buttonName){
  if(controlP5.getController(buttonName) != null){
    ((Button)controlP5.getController(buttonName)).setOff();
  }
}

void reEnableButton(String buttonName){
  if(controlP5.getController(buttonName) != null){
    ((Button)controlP5.getController(buttonName)).setOn();
  }
}

/* Actions */
/* Buttons Col 1 */
public void ButtonA_Col1(boolean buttonState){
}

public void ButtonB_Col1(boolean buttonState){
}

public void ButtonC_Col1(boolean buttonState){
}

/* Buttons Col 2 */
public void ButtonA_Col2(boolean buttonState){
}

public void ButtonB_Col2(boolean buttonState){
}

public void ButtonC_Col2(boolean buttonState){
}