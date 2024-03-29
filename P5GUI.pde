/************************************************************************************************
 *
 *  MultiWiiParser
 *
 *  Copyright 2013 by Johannes Viegener
 *
 *  This file is part of MultiWiiParser.
 *
 *  MultiWiiParser is free software: you can redistribute it and/or modify
 *  it under the terms of the Lesser GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  MultiWiiParser is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Lesser GNU General Public License
 *  along with MultiWiiParser.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author     Johannes Viegener
 *
 *************************************************************************************************/ 

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
Tab lastTab;
boolean isUpdateEnabled = true;
boolean isCurrentlyDoubleClick;

/***************************/


Tab tabDefault;
Tab tabDetails;
Tab tabCompare;

static final int TAB_DETAILS = 1;
static final int TAB_DEFAULT = 2;
static final int TAB_COMPARE = 3;

int CurrentTabMode = 0;

/*************************************************************************************************/

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


InToggle togNoValue;
InToggle togSameName;

LTextfield txfName;
LTextfield txfValue;
LTextfield txfComment;
InToggle togEntryActive;

InToggle togSetActive;

Button btnWriteMinimal;
Button btnWriteFull;

Button btnEditCancel;
Button btnEditSave;
Button btnEditCreate;
Button btnEditRemove;

/***************************/

LTextfield txfFilename;
LTextfield txfCompareFile;

Button btnAddToFavorites;
Button btnSelectFile;
Button btnCleanFile;
Button btnRestoreFiles;

Button btnCompAddToFavorites;
Button btnSelectCompFile;
Button btnCleanCompFile;

SelectListBox lstFilePath;
SelectListBox lstFileName;
SelectListBox lstFileComm;

Button btnFileSave;
Button btnFileCancel;
Button btnFileRemove;
Button btnFavoritesSave;
Button btnFileOpen;

/***************************/

SelectListBox lstEntryLeft;
SelectListBox lstEntryInfo;
SelectListBox lstEntryRight;

InToggle togCompareDiff;
InToggle togCompareActive;

LDropdownList  drpLCSection;
LDropdownList  drpRCSection;

Button btnAlignActive;
Button btnAlignValue;
Button btnAlignEntry;
Button btnAlignAddRemove;

Textarea txtGroupName; 
Textlabel lblGroupName;

/***************************/

CColor notrans;

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

  int LabelXPos = 10;
  int ControlXPos = 90;
  int AdditionalXPos = 630;

  int SectionYPos = 40;
  int GroupYPos = 80;
  int EntryYPos = 200;
  int DetailYPos = 340;
  int ButtonYPos = 420;

  /***********/
  
  dummyLabel = new Label( cp5, "");
  dummyLabel.hide();

  isUpdateEnabled = false;

  /*********************/
  /* Tabs */
  
  tabDefault = cp5.getTab("default")
     .setLabel("  File  ")
     .setId(1)
     .activateEvent( true )
     ;

  tabDetails = cp5.addTab("details")
   .setLabel("  Config Details  ")
//   .setColorBackground(color(0, 160, 100))
//   .setColorLabel(color(255))
//   .setColorActive(color(255,128,0))
   .setId(2)
   .activateEvent( true )
   ;


  tabCompare = cp5.getTab("compare")
     .setLabel("  Compare Configurations ")
     .setId(3)
     .activateEvent( true )
     ;

  lastTab = tabDetails;

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
  togNoValue = new InToggle( cp5, "togNoValue");
  togNoValue.setPosition(AdditionalXPos,EntryYPos-40 )
     .setSize(60,20)
     .setValue(false)
     .setCaptionLabel("NO Value")
     .moveTo( tabDetails )
     ;

  togSameName = new InToggle( cp5, "togSameName");
  togSameName.setPosition(AdditionalXPos+togNoValue.getWidth()+10,EntryYPos-40 )
     .setSize(50,20)
     .setValue(false)
     .lock()
     .setCaptionLabel("=Name")
     .moveTo( tabDetails )
     ;

  /******** TOGGLE for Special displays */
  togAll = new InToggle( cp5, "togAll");
  togAll.setPosition(AdditionalXPos,SectionYPos-(pfont_height+4) )
     .setSize(60,20)
     .setValue(false)
     .setCaptionLabel("Show All")
     .moveTo( tabDetails )
     ;

  togShowOnlyActive = new InToggle( cp5, "togShowOnlyActive");
  togShowOnlyActive.setPosition(AdditionalXPos+togAll.getWidth()+20,SectionYPos -(pfont_height+4))
     .setSize(70,20)
     .setValue(false)
     .setCaptionLabel("Only Active")
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
     .setColorBackground(color(255, 20))
     .setColorForeground(color(0, 0,0))
    ;

  togEntryActive = new InToggle( cp5, "Active");
  togEntryActive.setPosition(ControlXPos + 600,DetailYPos )
     .setSize(50,20)
     .setValue(false)
     .lock()
     .moveTo( tabDetails )
         .setColorBackground(color(255, 20))
         .setColorForeground(color(255, 100,0))
     ;

  txfValue = new LTextfield( cp5, "txfValue" );
  txfValue.setPosition(ControlXPos, DetailYPos+22)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .setCaptionLabel("Value   ")
    .lock()
     .moveTo( tabDetails )
     .setColorBackground(color(255, 20))
     .setColorForeground(color(0, 0,0))
    ;
       
  txfComment = new LTextfield( cp5, "txfComment" );
  txfComment.setPosition(ControlXPos, DetailYPos+44)
    .setSize(670,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .setCaptionLabel("Comment   ")
    .lock()
    .moveTo( tabDetails )
     .setColorBackground(color(255, 20))
     .setColorForeground(color(0, 0,0))
    ;


  /******** Buttons */
  btnEditSave = cp5.addButton("btnEditSave")
     .setPosition(ControlXPos,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Edit" )
     .moveTo( tabDetails )
     ;
  cp5.getTooltip().register("btnEditSave","Or double click entry to edit");

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
     .setColorBackground(color(255, 20))
         .setColorActive(color(0))
     .setColorForeground(color(0, 0,0))
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

  btnCleanFile = cp5.addButton("btnCleanFile")
     .setPosition(ControlXPos + btnAddToFavorites.getWidth() + 10 + btnSelectFile.getWidth() + 10,SectionYPos + 30)
     .setSize(100,20)
     .setCaptionLabel( "   Clear " )
     .moveTo( tabDefault )
     ;

  btnRestoreFiles = cp5.addButton("btnRestoreFiles")
     .setPosition(AdditionalXPos,SectionYPos + 30)
     .setSize(120,20)
     .setCaptionLabel( "  Restore Files " )
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
     .setColorBackground(color(255, 20))
     .setColorActive(color(0))
     .setColorForeground(color(0, 0))
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

  btnCleanCompFile = cp5.addButton("btnCleanCompFile")
     .setPosition(ControlXPos + btnAddToFavorites.getWidth() + 10 + btnSelectCompFile.getWidth() + 10,SectionYPos + 30+70)
     .setSize(100,20)
     .setCaptionLabel( "   Clear " )
     .moveTo( tabDefault )
     ;

  lstFilePath = new SelectListBox( cp5, "lstFilePath" );
  lstFilePath.setLabelText("Favorites   ")
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
         .moveTo( tabDefault )
         ;

  lstFileName = new SelectListBox( cp5, "lstFileName" );
        ((ListBox) lstFileName)
         .setPosition(ControlXPos+lstFilePath.getWidth()+5, EntryYPos-(pfont_height+4))
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
         .moveTo( tabDefault )
         ;

  lstFileComm = new SelectListBox( cp5, "lstFileComm" );
        ((ListBox) lstFileComm)
         .setPosition(ControlXPos+lstFilePath.getWidth()+5+lstFileName.getWidth()+5, EntryYPos-(pfont_height+4))
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
         .moveTo( tabDefault )
         ;

  arrSLB = new ArrayList();
  arrSLB.add( lstFilePath );
  arrSLB.add( lstFileName );
  arrSLB.add( lstFileComm );
  
  lstFilePath.addOthers( arrSLB );
  lstFileName.addOthers( arrSLB );
  lstFileComm.addOthers( arrSLB );

  /******** Buttons */
  btnFileSave = cp5.addButton("btnFileSave")
     .setPosition(ControlXPos,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Edit" )
     .moveTo( tabDefault )
     ;

  btnFileCancel = cp5.addButton("btnFileCancel")
     .setPosition(btnFileSave.getPosition().x+btnFileSave.getWidth()+20,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Cancel" )
     .setVisible(false)
     .moveTo( tabDefault )
     ;

  btnFileRemove = cp5.addButton("btnFileRemove")
     .setPosition(btnFileCancel.getPosition().x+btnFileCancel.getWidth() + 50,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Remove" )
     .moveTo( tabDefault )
     ;

  btnFileOpen = cp5.addButton("btnFileOpen")
     .setPosition(btnFileRemove.getPosition().x+btnFileRemove.getWidth()+50,ButtonYPos)
     .setSize(120,20)
     .setCaptionLabel( "   Load favorite" )
     .moveTo( tabDefault )
     ;
  cp5.getTooltip().register("btnFileOpen","Or double click entry to load");


  btnFavoritesSave = cp5.addButton("btnFavoritesSave")
     .setPosition(AdditionalXPos,ButtonYPos)
     .setSize(120,20)
     .setCaptionLabel( "   Save Favorites" )
     .moveTo( tabDefault )
     ;
  if (CONFIG_AUTOSAVE_FAVORITES ) btnFavoritesSave.hide();


  /***********************************/
  /********* COMPARE *****************/
  /***********************************/

  /***************************/
  int LeftXPos = 90;
  int MiddleXPos = 390;
  int RightXPos = 440;

  /***************************/

  lstEntryLeft = new SelectListBox( cp5, "lstEntryLeft" );
  lstEntryLeft.setLabelText("Entry   ")
         .setActiveSync( false )
         .setPosition(LeftXPos, GroupYPos)
         .setSize(300, 230)
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
         .setActiveSync( false )
         .setPosition(MiddleXPos+5, GroupYPos)
         .setSize(40, 230)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarWidth(0)
         .setScrollbarVisible( true )
         .setScrollbarWidth(0)
         .actAsPulldownMenu( false )
         .setUpdate( false )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabCompare )
         ;

  lstEntryRight = new SelectListBox( cp5, "lstEntryRight" );
  lstEntryRight.setLabelText("")
         .setActiveSync( false )
         .setPosition(RightXPos, GroupYPos)
         .setSize(300, 230)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 20))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( tabCompare )
         ;

  ArrayList arrSLB2 = new ArrayList();
  arrSLB2.add( lstEntryLeft );
  arrSLB2.add( lstEntryInfo );
  arrSLB2.add( lstEntryRight );
  
  lstEntryLeft.addOthers( arrSLB2 );
  lstEntryInfo.addOthers( arrSLB2 );
  lstEntryRight.addOthers( arrSLB2 );

  txtGroupName = new Textarea(cp5, "txtGroupName")
                  .setPosition(ControlXPos, GroupYPos+230+10)
                  .setSize(405, 20)
                  .setFont(pfont)
                  .disableColorBackground()
                  .hideScrollbar()
                  .setLineHeight(pfont_height+4)
                  .moveTo( tabCompare )
                  ;
  lblGroupName = cp5.addTextlabel("lblGroupName")
    .setText( "             Group " )
    .setPosition( LabelXPos, GroupYPos+230+10 )
    .moveTo( tabCompare )
    ;
  
  /******** TOGGLE for Special displays */
  drpLCSection = new LDropdownList( cp5, "drpLCSection", LeftXPos, GroupYPos, 300, 100);
  drpLCSection.setLabelText( "Section " )
     .setBarHeight( pfont_height+4 )
     .moveTo( tabCompare )
     .setBackgroundColor(color(0,0))
     .setColorBackground(color(255, 20))
     .setColorActive(color(0))
     .setColorForeground(color(255, 100,0))
        ; 

  drpRCSection = new LDropdownList( cp5, "drpRCSection", RightXPos, GroupYPos, 300, 100);
  drpRCSection.setLabelText( "" )
     .setBarHeight( pfont_height+4 )
     .moveTo( tabCompare )
     .setBackgroundColor(color(0,0))
     .setColorBackground(color(255, 20))
     .setColorActive(color(0))
     .setColorForeground(color(255, 100,0))
        ; 

  /******** TOGGLE for Special displays */
  togCompareDiff = new InToggle( cp5, "togCompareDiff");
  togCompareDiff.setPosition(AdditionalXPos,SectionYPos-(pfont_height+4) )
     .setSize(80,20)
     .setValue(false)
     .setCaptionLabel("Only Different")
     .moveTo( tabCompare )
     ;

  togCompareActive = new InToggle( cp5, "togCompareActive");
  togCompareActive.setPosition(AdditionalXPos+togCompareDiff.getWidth()+10,SectionYPos -(pfont_height+4))
     .setSize(80,20)
     .setValue(false)
     .setCaptionLabel("Only Active")
     .moveTo( tabCompare )
     ;
     

  /******** Buttons */
  btnAlignActive = cp5.addButton("btnAlignActive")
     .setPosition(ControlXPos,ButtonYPos)
     .setSize(100,20)
     .setCaptionLabel( "  Activate" )
     .moveTo( tabCompare )
     ;

  btnAlignValue = cp5.addButton("btnAlignValue")
     .setPosition(btnAlignActive.getPosition().x+btnAlignActive.getWidth() + 20,ButtonYPos)
     .setSize(100,20)
     .setCaptionLabel( "  Copy Value" )
     .moveTo( tabCompare )
     ;

  btnAlignEntry = cp5.addButton("btnAlignEntry")
     .setPosition(btnAlignValue.getPosition().x+btnAlignValue.getWidth() + 20,ButtonYPos)
     .setSize(100,20)
     .setCaptionLabel( "  Copy" )
     .moveTo( tabCompare )
     ;

  btnAlignAddRemove = cp5.addButton("btnAlignAddRemove")
     .setPosition(btnAlignEntry.getPosition().x+btnAlignEntry.getWidth() + 20,ButtonYPos)
     .setSize(100,20)
     .setCaptionLabel( "  Add/Remove" )
     .moveTo( tabCompare )
     ;



  /***********************************/
  /********* Tooltips ****************/
  /***********************************/

  cp5.getTooltip().setDelay(500);
  cp5.getTooltip().setPositionOffset(10,-20);

  /***********************************/
  /*********  *****************/
  /***********************************/


  // add mousewheel support, now hover the slide with your mouse
  // and use the mousewheel (or trackpad on a macbook) to change the 
  // value of the slider.   
  addMouseWheelListener();

  isUpdateEnabled = true;

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

  if (theEvent.isGroup()) {
    // Check if Event was triggered from drpSection
    if ( theEvent.getGroup().equals( drpSection ) ) {
      if ( isDebug( DEBUG_EVENT ) ) println("  event from drpSection ");
      updateSection((int(theEvent.getGroup().getValue())));     
    } else     if ( theEvent.getGroup().equals( drpGroup ) ) {
      if ( isDebug( DEBUG_EVENT ) ) println("  event from drpGroup ");
      updateGroup((int(theEvent.getGroup().getValue())));     
    } else if ( ( theEvent.getGroup().equals( drpLCSection ) ) || ( theEvent.getGroup().equals( drpRCSection ) ) ) {
      if ( isDebug( DEBUG_EVENT ) ) println("  event from drpL/RCSection ");
      updateCompSection((LDropdownList) theEvent.getGroup(), (int(theEvent.getGroup().getValue())));     
    } else if (theEvent.getGroup() instanceof SelectListBox ) {
      if ( isDebug( DEBUG_EVENT ) ) println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
      if ( theEvent.getGroup().getTab() == tabCompare ) {
        updateDeltaEntry((SelectListBox) theEvent.getGroup(), (int(theEvent.getGroup().getValue())));     
      } else if ( theEvent.getGroup().getTab() == tabDetails ) {
        updateEntry((int(theEvent.getGroup().getValue())));     
      } else {
        updateFavEntry((int(theEvent.getGroup().getValue())));
      }
    }
  } else if ( theEvent.isTab()  ) {  
      if ( isDebug( DEBUG_EVENT ) ) println("event from tab ");
      updateTab(  theEvent.getTab() );
  } else if (  ( theEvent.getController() instanceof Toggle) ) {  
    if ( ( theEvent.getController().equals( togAll ) ) || ( theEvent.getController().equals( togShowOnlyActive ) ) ) { 
      updateToggle((Toggle) theEvent.getController());
    } else if  ( ( theEvent.getController().equals( togCompareActive ) ) || ( theEvent.getController().equals( togCompareDiff ) ) ) { 
      updateCompToggle((Toggle) theEvent.getController());
    } else if ( ( theEvent.getController().equals( togNoValue ) )  ) { 
      updateToggleNoValue();
    }
  }

}

/*************************************************************************************************/
/****************  makeTabReady                                                            *******/
/*************************************************************************************************/

public void makeTabReady( Tab aTab ) {

  if ( ( aTab == tabDetails ) || ( aTab == tabCompare ) ) {
    txfValue.moveTo( aTab );
    togEntryActive.moveTo( aTab );

    btnWriteFull.moveTo( aTab );
    btnWriteMinimal.moveTo( aTab );

  }
  txfName.moveTo( aTab );
  txfComment.moveTo( aTab );
  if ( aTab == tabDetails ) {
    updateEntry(-1);
  } else if ( aTab == tabCompare ) {
    boolean isLeft = G_IsLeft;
    int selId = G_SelectedId;
    updateCompLists();
    if ( isLeft ) {
      updateDeltaEntry(lstEntryLeft,selId);
    } else {
      updateDeltaEntry(lstEntryRight,selId);
    }
  } else if ( aTab == tabDefault ) {
    updateFavorites( null );
//    updateFavEntry(-1);
  }

}

/*************************************************************************************************/
/****************  SwitchTabs                                                              *******/
/*************************************************************************************************/

public void updateTab( Tab aTab ) {
  boolean makeReady = true;
  
  // no change of tab in edit mode
  if ( isFileEditMode || isEditMode ) { 
    aTab = lastTab;
    makeReady = false; 
  }

  // no change to Compare if no data available (not ready)
  if ( ( aTab == tabCompare ) && ( ! tabCompareIsReady() ) ) {
    aTab = lastTab;
    makeReady = false; 
  }

  // no change to Details if no data available (not ready)
  if ( ( aTab == tabDetails ) && ( ! tabDetailsIsReady() ) ) {
    aTab = tabDefault;
    makeReady = false; 
  }

  aTab.bringToFront();
  lastTab = aTab;

  if ( makeReady ) {
    makeTabReady( lastTab );
  }
}




