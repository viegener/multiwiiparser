/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  P5GUI only init                                                         *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


import javax.swing.*;

import controlP5.*;

/*************************************************************************************************/
/****************  All Controls are currently Global                                       *******/
/*************************************************************************************************/

ControlP5 cp5;

Label dummyLabel;


/***************************/

LDropdownList  drpSection;
LDropdownList  drpGroup;

Textarea txtGroupComment; 
Textarea txtEntryComment; 
Textarea grpSubSection; 

SelectListBox lstEntryName;
SelectListBox lstEntryStatus;
SelectListBox lstEntryComm;

InToggle togAll;
InToggle togShowOnlyActive;

InToggle togEntryActive;

InToggle togNoValue;
InToggle togSameName;

LTextfield txfName;
LTextfield txfValue;
LTextfield txfComment;
InToggle togSetActive;

Button btnWriteMinimal;
Button btnWriteFull;

Button btnEditCancel;
Button btnEditSave;
Button btnEditCreate;
Button btnEditRemove;

/***************************/

Textfield txfFilename;
Textfield txfCompareFile;

Button btnAddToFavorites;
Button btnSelectFile;

Button btnCompAddToFavorites;
Button btnSelectCompFile;



/***************************/

SelectListBox lstEntryLeft;
SelectListBox lstEntryInfo;
SelectListBox lstEntryRight;

/***************************/

CColor notrans;

/*************************************************************************************************/

Tab tabDefault;
Tab tabDetails;
Tab tabCompare;

static final int TAB_DETAILS = 1;
static final int TAB_DEFAULT = 2;
static final int TAB_COMPARE = 3;

int CurrentTabMode = 0;

/*************************************************************************************************/

/*************************************************************************************************/
/****************  Create the GUI during setup()                                           *******/
/*************************************************************************************************/

public void initializeGUI() {
  size(800, 450);
  frameRate(30); 
  frame.setTitle(MULTIWII_PARSER_TITLE_REV);

  PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
  PFont pfontEditor = createFont("Courier",12,true); // use true/false for smooth/no-smooth
  PFont pfontBig = createFont("Arial",12);
  
  cp5 = new ControlP5(this, pfont);
  
  notrans = new CColor(0x00016c9e, 0x0002344d, 0x0000b4ea, 0x00ffffff, 0x00ffffff); 
    
  int pfont_height = 10;
  int pfontBig_height = 12;
  
  /***************************/

  int LabelXPos = 11;
  int ControlXPos = 92;
  int AdditionalXPos = 630;

  int SectionYPos = 40;
  int GroupYPos = 80;
  int EntryYPos = 200;
  int DetailYPos = 340;
  int ButtonYPos = 420;

  /***********/
  
  dummyLabel = new Label( cp5, "");
  dummyLabel.hide();

  /*********************/
  /* Tabs */
  
  tabDefault = cp5.getTab("default")
     .setLabel("  File Store  ")
     .setId(1)
     ;

  tabDetails = cp5.addTab("details")
   .setLabel("  Config Details  ")
//   .setColorBackground(color(0, 160, 100))
//   .setColorLabel(color(255))
//   .setColorActive(color(255,128,0))
   .setId(2)
   ;


  tabCompare = cp5.getTab("compare")
     .setLabel("  Compare  ")
     .setId(3)
     ;


  /***********************************/
  /********* DETAILS *****************/
  /***********************************/
  
  txtGroupComment = cp5.addTextarea("txtGroupComment")
                  .setPosition(ControlXPos, GroupYPos+(pfont_height/2))
                  .setSize(405, 50)
                  .disableColorBackground()
                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( tabDetails )
                  ;
  
  
  grpSubSection = cp5.addTextarea("grpSubSection")
                  .setPosition(ControlXPos, GroupYPos-4*(pfont_height))
                  .setSize(405, 20)
                  .disableColorBackground()
                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( tabDetails )
                  ;

  txtEntryComment = cp5.addTextarea("txtEntryComment")
                  .setPosition(ControlXPos, EntryYPos-7*pfont_height)
                  .setSize(405, 5*pfont_height)
                  .disableColorBackground()
                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( tabDetails )
                  ;
  
  lstEntryName = new SelectListBox( cp5, "lstEntryName" );
  lstEntryName.setLabelText("Entry   ")
         .setPosition(ControlXPos, EntryYPos-(pfont_height+4))
         .setSize(307, 150)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .setScrollbarWidth(0)
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabDetails )
         ;

  lstEntryStatus = new SelectListBox( cp5, "lstEntryStatus" );
        ((ListBox) lstEntryStatus)
         .setPosition(ControlXPos+lstEntryName.getWidth()+5, EntryYPos-(pfont_height+4))
         .setSize(100, 150)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarWidth(0)
         .setScrollbarVisible( true )
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabDetails )
         ;

  lstEntryComm = new SelectListBox( cp5, "lstEntryComm" );
        ((ListBox) lstEntryComm)
         .setPosition(ControlXPos+lstEntryName.getWidth()+5+lstEntryStatus.getWidth()+5, EntryYPos-(pfont_height+4))
         .setSize(250, 150)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabDetails )
         ;

  ArrayList arrSLB = new ArrayList();
  arrSLB.add( lstEntryStatus );
  arrSLB.add( lstEntryName );
  arrSLB.add( lstEntryComm );
  
  lstEntryStatus.addOthers( arrSLB );
  lstEntryName.addOthers( arrSLB );
  lstEntryComm.addOthers( arrSLB );

  /******** TOGGLE for Group properties */
  togNoValue = new InToggle( cp5, "NO Value");
  togNoValue.setPosition(AdditionalXPos,EntryYPos-40 )
     .setSize(60,20)
     .setValue(false)
     .moveTo( tabDetails )
     ;

  togSameName = new InToggle( cp5, "=Name");
  togSameName.setPosition(AdditionalXPos+togNoValue.getWidth()+10,EntryYPos-40 )
     .setSize(50,20)
     .setValue(false)
     .lock()
     .moveTo( tabDetails )
     ;

  /******** TOGGLE for Special displays */
  togAll = new InToggle( cp5, "Show All");
  togAll.setPosition(AdditionalXPos,SectionYPos-(pfont_height+4) )
     .setSize(60,20)
     .setValue(false)
     .moveTo( tabDetails )
     ;

  togShowOnlyActive = new InToggle( cp5, "Only Active");
  togShowOnlyActive.setPosition(AdditionalXPos+togAll.getWidth()+20,SectionYPos -(pfont_height+4))
     .setSize(70,20)
     .setValue(false)
     .moveTo( tabDetails )
     ;
     

  /******** EDitor Fields */

  txfName = new LTextfield( cp5, "txfName" );
  txfName.setPosition(ControlXPos, DetailYPos)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .setCaptionLabel("Name   ")
    .lock()
    .moveTo( tabDetails )
    ;

  togEntryActive = new InToggle( cp5, "Active");
  togEntryActive.setPosition(ControlXPos + 600,DetailYPos )
     .setSize(50,20)
     .setValue(false)
     .lock()
     .moveTo( tabDetails )
     ;


  txfValue = new LTextfield( cp5, "txfValue" );
  txfValue.setPosition(ControlXPos, DetailYPos+22)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .setCaptionLabel("Value   ")
    .lock()
     .moveTo( tabDetails )
    ;
       
  txfComment = new LTextfield( cp5, "txfComment" );
  txfComment.setPosition(ControlXPos, DetailYPos+44)
    .setSize(670,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .setCaptionLabel("Comment   ")
    .lock()
    .moveTo( tabDetails )
    ;


  /******** Buttons */
  btnEditSave = cp5.addButton("btnEditSave")
     .setPosition(ControlXPos,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Edit" )
     .moveTo( tabDetails )
     ;

  btnEditCancel = cp5.addButton("btnEditCancel")
     .setPosition(btnEditSave.getPosition().x+btnEditSave.getWidth()+20,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Cancel" )
     .setVisible(false)
     .moveTo( tabDetails )
     ;

  btnEditCreate = cp5.addButton("btnEditCreate")
     .setPosition(btnEditCancel.getPosition().x+btnEditCancel.getWidth()+30,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Create" )
     .moveTo( tabDetails )
     ;

  btnEditRemove = cp5.addButton("btnEditRemove")
     .setPosition(btnEditCreate.getPosition().x+btnEditCreate.getWidth()+30,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Remove" )
     .moveTo( tabDetails )
     ;

  btnWriteFull = cp5.addButton("btnWriteFull")
     .setPosition(AdditionalXPos,ButtonYPos)
     .setSize(50,20)
     .setCaptionLabel( " Write" )
     .moveTo( tabDetails )
     ;

  btnWriteMinimal = cp5.addButton("btnWriteMinimal")
     .setPosition(AdditionalXPos+btnWriteFull.getWidth()+15,ButtonYPos)
     .setSize(60,20)
     .setCaptionLabel( " Minimal" )
     .moveTo( tabDetails )
     ;

  /******** DropDownLists */
  drpGroup  = new LDropdownList( cp5, "drpGroup", ControlXPos, GroupYPos, 590, 130);
  drpGroup.setLabelText( "Group   " )
     .setBarHeight( pfont_height+4 )
     .moveTo( tabDetails )
     .setBackgroundColor(color(0,0))
     .setColorBackground(color(255, 20))
     .setColorActive(color(0))
     .setColorForeground(color(255, 100,0))
        ; 

  drpSection = new LDropdownList( cp5, "drpSection", ControlXPos, SectionYPos, 530, 100);
  drpSection.setLabelText( "Section   " )
     .setBarHeight( pfont_height+4 )
     .moveTo( tabDetails )
     .setBackgroundColor(color(0,0))
     .setColorBackground(color(255, 20))
     .setColorActive(color(0))
     .setColorForeground(color(255, 100,0))
        ; 

  /***********************************/
  /********* DEFAULT *****************/
  /***********************************/


  txfFilename = new LTextfield( cp5, "txfFilename" );
  txfFilename.setPosition(ControlXPos, SectionYPos)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .lock()
    .setCaptionLabel("Filename  ")
     .moveTo( tabDefault )
    ;

  /******** Buttons */
  btnAddToFavorites = cp5.addButton("btnAddToFavorites")
     .setPosition(ControlXPos,SectionYPos + 30)
     .setSize(120,20)
     .setCaptionLabel( "   Add to Favorites" )
     .moveTo( tabDefault )
     ;

  btnSelectFile = cp5.addButton("btnSelectFile")
     .setPosition(ControlXPos + btnAddToFavorites.getWidth() + 10,SectionYPos + 30)
     .setSize(120,20)
     .setCaptionLabel( "   Select File" )
     .moveTo( tabDefault )
     ;

  /************** Compare ********/
  txfCompareFile = new LTextfield( cp5, "txfCompareFile" );
  txfCompareFile.setPosition(ControlXPos, SectionYPos+70)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .lock()
    .setCaptionLabel("Compared to   ")
     .moveTo( tabDefault )
    ;

  /******** Buttons */
  btnCompAddToFavorites = cp5.addButton("btnCompAddToFavorites")
     .setPosition(ControlXPos,SectionYPos + 30+70)
     .setSize(120,20)
     .setCaptionLabel( "   Add to Favorites" )
     .moveTo( tabDefault )
     ;

  btnSelectCompFile = cp5.addButton("btnSelectCompFile")
     .setPosition(ControlXPos + btnAddToFavorites.getWidth() + 10,SectionYPos + 30+70)
     .setSize(120,20)
     .setCaptionLabel( "   Select File" )
     .moveTo( tabDefault )
     ;


  /***********************************/
  /********* COMPARE *****************/
  /***********************************/


  /***************************/
  int LeftXPos = 100;
  int MiddleXPos = 400;
  int RightXPos = 450;

  /***************************/

  lstEntryLeft = new SelectListBox( cp5, "lstEntryLeft" );
  lstEntryLeft.setLabelText("Entry   ")
         .setPosition(LeftXPos, GroupYPos)
         .setSize(300, 260)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .setScrollbarWidth(0)
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabCompare )
         ;

  lstEntryInfo = new SelectListBox( cp5, "lstEntryInfo" );
  lstEntryInfo.setLabelText("")
         .setPosition(MiddleXPos+5, GroupYPos)
         .setSize(30, 260)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarWidth(0)
         .setScrollbarVisible( true )
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabCompare )
         ;

  lstEntryRight = new SelectListBox( cp5, "lstEntryRight" );
  lstEntryRight.setLabelText("")
         .setPosition(RightXPos, GroupYPos)
         .setSize(300, 260)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         ;

  ArrayList arrSLB2 = new ArrayList();
  arrSLB2.add( lstEntryLeft );
  arrSLB2.add( lstEntryInfo );
  arrSLB2.add( lstEntryRight );
  
  lstEntryLeft.addOthers( arrSLB2 );
  lstEntryInfo.addOthers( arrSLB2 );
  lstEntryRight.addOthers( arrSLB2 );



  /***********************************/
  /*********  *****************/
  /***********************************/


  // add mousewheel support, now hover the slide with your mouse
  // and use the mousewheel (or trackpad on a macbook) to change the 
  // value of the slider.   
  addMouseWheelListener();

//  grpSelectors.hide();

  println("createGUI : End");

}


// When working in desktop mode, you can add mousewheel support for 
// controlP5 by using java.awt.event.MouseWheelListener and 
// java.awt.event.MouseWheelEvent

void addMouseWheelListener() {
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  }
  );
}

/*************************************************************************************************/
/****************  Central Event Handler                                                   *******/
/*************************************************************************************************/

/*************************************************************************************************/
void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // Check if Event was triggered from drpSection
    if ( theEvent.getGroup().equals( drpSection ) ) {
      println("  event from drpSection ");
      updateSection((int(theEvent.getGroup().getValue())));     
    } else     if ( theEvent.getGroup().equals( drpGroup ) ) {
      println("  event from drpGroup ");
      updateGroup((int(theEvent.getGroup().getValue())));     
    } else     if ( theEvent.getGroup() instanceof SelectListBox ) {
      println("  event from lstEntryName ");
      updateEntry((int(theEvent.getGroup().getValue())));     
    }

    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (  ( theEvent.getController() instanceof Toggle) ) {  
    if ( ( theEvent.getController().equals( togAll ) ) || ( theEvent.getController().equals( togShowOnlyActive ) ) ) { 
      updateToggle((Toggle) theEvent.getController());
    } else if ( ( theEvent.getController().equals( togNoValue ) )  ) { 
      updateToggleNoValue();
    }
  }

}

/*************************************************************************************************/
/****************  SwitchTabs                                                              *******/
/*************************************************************************************************/

public boolean switchToTab( Tab aTab ) {
  
  if ( aTab == tabDetails ) {
    if ( g_config != null ) { 
      CurrentTabMode = TAB_DETAILS;
      tabDetails.setActive(true);

      tabDefault.setActive(false);
      tabCompare.setActive(false);
      return true;
    }
  } else if ( aTab == tabDefault ) {
      CurrentTabMode = TAB_DEFAULT;
      tabDefault.setActive(true);

      tabDetails.setActive(false);
      tabCompare.setActive(false);
      return true;
  } else if ( aTab == tabCompare ) {
      CurrentTabMode = TAB_COMPARE;
      tabCompare.setActive(true);

      tabDefault.setActive(false);
      tabDetails.setActive(false);
      return true;
  }

  return false;
}

/*************************************************************************************************/
/****************  Default buttons                                                              *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void btnSelectFile(int theValue) {
  Config aConfig = readAConfig();

  if ( aConfig != null ) {
    updateConfig( aConfig );
  }
}

/*************************************************************************************************/
public void btnSelectCompFile(int theValue) {
  Config aConfig = readAConfig();

  if ( aConfig != null ) {
    updateCompConfig( aConfig );
  }
}


