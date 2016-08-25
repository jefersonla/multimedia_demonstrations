/* ***************************** */
/* Multimedia Demonstration v1.0 */
/*  Developed  by Jeferson Lima  */
/* ***************************** */
/* Description: Example of audio */
/*              Nyquist Theorem  */
/* ***************************** */
/* Libraries used: ControlP5     */
/*                 Beads         */
/* ***************************** */
/* INSTALL LIBRARIES BEFORE RUN! */
/* ***************************** */

/* Imports */
import controlP5.*;
import beads.*; 

/* Gui Description */
final String guiDescription = "A 15 second clip of music from a compact disc was digitized " +
                              "at three different sampling rates (11khz, 22khz and 44khz) "  +
                              "with 8-bit, 16-bit and 32-bit precision.\n"                   +
                              "The effects of the different sampling rates are clearly "     +
                              "audible.\n"                                                   +
                              "This is a demonstration of the Nyquist Theorem.";

/* Box description */
final String boxDescription = "The minimum sampling frequency of an A/D converter should be"  +
                              " at least twice the frequency of the signal being measured.\n" +
                              "Note how final size and badwidth change with different setups.\n" +
                              "These files are not compressed.";
final String boxHeader      = "Nyquist Theorem";

/* Action Box description */
final String actionDescription = "Select precision and frequency\n" +
                                 "after that, press play or stop";

/* Controller for P5 */
ControlP5 controlP5;

/* Color & Interface constants */
final int GREY_COLOR = 205;
final int BLACK_COLOR = 50;
final int WHITE_COLOR = 255;
final int FREQUENCY_11KHZ = 0;
final int FREQUENCY_22KHZ = 1;
final int FREQUENCY_44KHZ = 2;
final int PRECISION_8BIT = 3;
final int PRECISION_16BIT = 4;
final int PRECISION_32BIT = 5;
final String VALUE_11KHZ = "11";
final String VALUE_22KHZ = "22";
final String VALUE_44KHZ = "44";
final String VALUE_8BIT = "8";
final String VALUE_16BIT = "16";
final String VALUE_32BIT = "32";
final boolean MUSIC_STOPPED = false;
final boolean MUSIC_PLAYING = true;

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
final int textSpacing = 2 * guiSpacing;
final int textDescriptionBoxHeight = descriptionBoxHeight - (2 * guiSpacing);
final int textDescriptionBoxWidth = descriptionBoxWidth - (2 * guiSpacing);

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

/* Itens Positions constants */
final int volSliderHeight = 120;
final int volSliderWidth = 15;
final int volSliderX = (guiWidth / 2) - guiSpacing - volSliderWidth - 11;
final int volSliderY = defaultBoxHeaderY + 55;
final int actionDescriptionX = guiSpacing * 3;
final int actionDescriptionY = guiWidth / 4;

/* Buttons */
final int generalButtonWidth = 110;
final int generalButtonHeight = 30;
final int generalButtonX1 = guiSpacing * 2;
final int generalButtonX2 = generalButtonX1 + guiSpacing + generalButtonWidth;
final int generalButtonY1 = 205;
final int generalButtonY2 = generalButtonY1 + generalButtonHeight + (guiSpacing / 2);
final int generalButtonY3 = generalButtonY2 + generalButtonHeight + (guiSpacing / 2);
final int playButtonWidth = (generalButtonWidth * 2) + guiSpacing;
final int playButtonHeight = 40;

/* Sample Audio constants and variables */
final String soundFilenameTemplate = "sample-{FREQ}khz-{PRECISION}bit.wav";
String soundFilename;

/* Audio context */
AudioContext audioContext;
SamplePlayer player;
Gain musicGain;
Glide musicGainGlide;

/* Button states */
int selectedButtonFrequency;
int selectedButtonPrecision;
String selectedFrequency;
String selectedPrecision;
boolean musicState;
boolean playingMusic;

/* Routines of interface */
void setup() {
  /* GUI Setup */
  size(640, 380);
  background(backgroundColor);
  
  /* P5 Initialization */
  controlP5 = new ControlP5(this);
  
  /* Beads Initialization */
  audioContext = new AudioContext();
  musicGainGlide = new Glide(audioContext, 0.2, 50);
  musicGain = new Gain(audioContext, 2, musicGainGlide);
  audioContext.out.addInput(musicGain); 
  
  /* Box 1 Description */
  fill(boxColor);
  rect(guiSpacing, guiSpacing, descriptionBoxWidth, descriptionBoxHeight);
  fill(textColor);
  textSize(guiBoxTextSize);
  text(guiDescription, textSpacing, textSpacing, textDescriptionBoxWidth, textDescriptionBoxHeight);
  
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
  fill(textColor);
  textSize(18);
  textAlign(CENTER);
  text(actionDescription, actionDescriptionY, defaultBoxHeaderY);
    
  /* Volume Slider */
  Slider volSlider = controlP5.addSlider("VOL");
  volSlider.setPosition(volSliderX, volSliderY)
           .setSize(volSliderWidth, volSliderHeight)
           .setRange(0,100)
           .setColorTickMark(textColor)
           .setColorCaptionLabel(textColor)
           .setNumberOfTickMarks(10)
           .snapToTickMarks(false)
           .setValue(20)
           .setSliderMode(Slider.FLEXIBLE);
           
  /* Change MAX Tick Mark */
  volSlider.getTickMark(0)
           .getLabel()
           .setColor(textColor)
           .setMultiline(false)
           .setText("MAX ")
           .setFixedSize(true)
           .setPaddingX(-20);
   
  /* Change MIN Tick Mark */
  volSlider.getTickMark(9)
           .getLabel()
           .setColor(textColor)
           .setMultiline(false)
           .setText("MIN")
           .setFixedSize(true)
           .setPaddingX(-16);
           
  /* Buttons */
  /* Frequency */
  controlP5.addButton("Frequency_11khz")
           .setPosition(generalButtonX1,generalButtonY1)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .setOn()
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("Frequency_22khz")
           .setPosition(generalButtonX1,generalButtonY2)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("Frequency_44khz")
           .setPosition(generalButtonX1,generalButtonY3)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  
  /* Precision */
  controlP5.addButton("Precision_8Bit")
           .setPosition(generalButtonX2,generalButtonY1)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .setOn()
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("Precision_16Bit")
           .setPosition(generalButtonX2,generalButtonY2)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  controlP5.addButton("Precision_32Bit")
           .setPosition(generalButtonX2,generalButtonY3)
           .setSize(generalButtonWidth,generalButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setSize(10);
  
  /* Start Stop */
  controlP5.addButton("Play_Stop_Music")
           .setPosition(generalButtonX1, 205 + 115)
           .setSize(playButtonWidth,playButtonHeight)
           .activateBy(ControlP5.RELEASE)
           .setSwitch(true)
           .getCaptionLabel()
           .setText("Play_Music")
           .setSize(10);
           
  /* Sound File setup */
  soundFilename = soundFilenameTemplate.replace("{FREQ}", "11")
                                       .replace("{PRECISION}", "8");
  soundFilename = sketchPath("data/") + soundFilename;
  
  /* Set Filesize and Bandwidth values */
  setFilesizeAndBandwidth();
}

/* Draw Objects */
void draw() {
}

/* Get Filesize */
String getFileSize(String filename) {
  File f  = new File(filename);           // read into File object
  long fs = f.length();                   // get file size in bytes

  String fileSize = "";
  if (fs < 1024) {                        // less than 1 kb, measure in bytes
    fileSize += fs + " bytes";
  }
  else if (fs > 1024 && fs < 1022976) {   // 1 kb - .99 MB, measure in kb
    fs /= 1024;
    fileSize += fs + " KB";
  }
  else {
    fileSize += nf(((fs / 1024.0) / 1024.0), 1, 2) + " MB";               // larger? measure in megabytes
  }

  return fileSize;
}

/* Filesize and badwidth */
void setFilesizeAndBandwidth(){
  /* File Details */
  fill(boxColor);
  rect(330, 340, 295, 25);
  fill(textColor);
  textSize(13.5);
  textAlign(LEFT);
  int bandWidth = ((Integer.parseInt(selectedFrequency) * 1000) * Integer.parseInt(selectedPrecision) * 2) / 1024;
  String textBandwidthAndSize = "Size = " + getFileSize(soundFilename) + " | Bandwidth = " + bandWidth + " Kbps";
  text(textBandwidthAndSize, 335, 358);
}

/* VOL Slider */
public void VOL(int theValue){
  if(musicGainGlide != null){
    musicGainGlide.setValue(theValue * 0.01);
  }
  println("VOL = " + theValue * 0.01);
}

/* Play Stop Music */
public void Play_Stop_Music(boolean theValue){
  println("Pressed - " + (theValue ? "PLAY" : "STOP"));
  musicState = theValue;
    
  /* Play or Stop Music */
  if(theValue){
    /* Remove Last SamplePlayer if there any */
    musicGain.clearInputConnections();
    // Play Music
    try{
      player = new SamplePlayer(audioContext, new Sample(soundFilename));
      playingMusic = true;
      /* Stop Button when sample got end */
      player.setEndListener(new Bead() {
        public void messageReceived(Bead message) {
          try {
             if(playingMusic){
               println("Stoping Music...");
               ((Button)controlP5.getController("Play_Stop_Music")).setOff();
             }
          } 
          catch(Exception e) {
            e.printStackTrace();
          }
        }
      });
      musicGain.addInput(player);
      audioContext.start();
    }catch(Exception e){
      println("Can't Load file sorry :/"); 
    }
    /* Change Controller Label */
    controlP5.getController("Play_Stop_Music")
             .getCaptionLabel()
             .setText("Stop_Music");
  }
  else if(!theValue && musicState == MUSIC_STOPPED){
    // Stop Music
    audioContext.stop();
    playingMusic = false;
    controlP5.getController("Play_Stop_Music") //<>//
             .getCaptionLabel()
             .setText("Play_Music");
  }
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

void disableButtonsExcept(int buttonExcept){
  /* Stop Music */
  if((Button)controlP5.getController("Play_Stop_Music") != null && musicState == MUSIC_PLAYING){
    ((Button)controlP5.getController("Play_Stop_Music")).setOff();
  }
  
  if(soundFilename != null){
    /* Sound Filename */
    soundFilename = soundFilenameTemplate.replace("{FREQ}", selectedFrequency)
                                         .replace("{PRECISION}", selectedPrecision);
    soundFilename = sketchPath("data/") + soundFilename;
    println("Sound Filename - " + soundFilename);
    
    /* Set Filesize and Bandwidth values */
    setFilesizeAndBandwidth();
  }
  
  /* Define which button will be disabled */
  if(buttonExcept >= PRECISION_8BIT){
    switch(buttonExcept){
      case PRECISION_8BIT:
        disableButton("Precision_16Bit");
        disableButton("Precision_32Bit");
        break;
      case PRECISION_16BIT:
        disableButton("Precision_8Bit");
        disableButton("Precision_32Bit");
        break;
      case PRECISION_32BIT:
        disableButton("Precision_8Bit");
        disableButton("Precision_16Bit");
        break;
    }
  }
  else{
    switch(buttonExcept){
      case FREQUENCY_11KHZ:
        disableButton("Frequency_22khz");
        disableButton("Frequency_44khz");
        break;
      case FREQUENCY_22KHZ:
        disableButton("Frequency_11khz");
        disableButton("Frequency_44khz");
        break;
      case FREQUENCY_44KHZ:
        disableButton("Frequency_11khz");
        disableButton("Frequency_22khz");
        break;
    }
  }
}

/* Frequency */
public void Frequency_11khz(boolean buttonState){
  if(buttonState){
    selectedButtonFrequency = FREQUENCY_11KHZ;
    selectedFrequency = VALUE_11KHZ;
    disableButtonsExcept(FREQUENCY_11KHZ);
  }
  else if(!buttonState && selectedButtonFrequency == FREQUENCY_11KHZ){
    reEnableButton("Frequency_11khz");
  }
}

public void Frequency_22khz(boolean buttonState){
  if(buttonState){
    selectedButtonFrequency = FREQUENCY_22KHZ;
    selectedFrequency = VALUE_22KHZ;
    disableButtonsExcept(FREQUENCY_22KHZ);
  }
  else if(!buttonState && selectedButtonFrequency == FREQUENCY_22KHZ){
    reEnableButton("Frequency_22khz");
  }
}

public void Frequency_44khz(boolean buttonState){
  if(buttonState){
    selectedButtonFrequency = FREQUENCY_44KHZ;
    selectedFrequency = VALUE_44KHZ;
    disableButtonsExcept(FREQUENCY_44KHZ);
  }
  else if(!buttonState && selectedButtonFrequency == FREQUENCY_44KHZ){
    reEnableButton("Frequency_44khz");
  }
}

/* Precision */
public void Precision_8Bit(boolean buttonState){
  if(buttonState){
    selectedButtonPrecision = PRECISION_8BIT;
    selectedPrecision = VALUE_8BIT;
    disableButtonsExcept(PRECISION_8BIT);
  }
  else if(!buttonState && selectedButtonPrecision == PRECISION_8BIT){
    reEnableButton("Precision_8Bit");
  }
}

public void Precision_16Bit(boolean buttonState){
  if(buttonState){
    selectedButtonPrecision = PRECISION_16BIT;
    selectedPrecision = VALUE_16BIT;
    disableButtonsExcept(PRECISION_16BIT);
  }
  else if(!buttonState && selectedButtonPrecision == PRECISION_16BIT){
    reEnableButton("Precision_16Bit");
  }
}

public void Precision_32Bit(boolean buttonState){
  if(buttonState){
    selectedButtonPrecision = PRECISION_32BIT;
    selectedPrecision = VALUE_32BIT;
    disableButtonsExcept(PRECISION_32BIT);
  }
  else if(!buttonState && selectedButtonPrecision == PRECISION_32BIT){
    reEnableButton("Precision_32Bit");
  }
}