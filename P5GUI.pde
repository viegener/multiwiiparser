
ControlP5 cp5;

Label dummyLabel;

Textlabel lblSection; 
Textlabel lblGroup; 
Textlabel lblEntry; 

Textlabel lblName; 
Textlabel lblValue; 
Textlabel lblComment; 

DropdownList  drpSection;
DropdownList  drpGroup;
DropdownList  drpEntry;

Textarea txtGroupComment; 
Textarea txtEntryComment; 
Textarea grpSubSection; 

SelectListBox lstEntryName;
SelectListBox lstEntryStatus;
SelectListBox lstEntryComm;

Toggle togAll;
Toggle togOnlyActive;

Toggle togEntryActive;

Textfield txfName;
Textfield txfValue;
Textfield txfComment;
Toggle togSetActive;

Button btnWriteMinimal;
Button btnWriteFull;

Button btnEditCancel;
Button btnEditSave;

ControlGroup grpButtons;
ControlGroup grpSelectors;
ControlGroup grpEditor;



/*************************************************************************************************/
public void initializeGUI() {
  size(800, 450);

  PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
  PFont pfontEditor = createFont("Courier",12,true); // use true/false for smooth/no-smooth
  PFont pfontBig = createFont("Arial",12);
  
  cp5 = new ControlP5(this, pfont);
  
  int pfont_height = 10;
  int pfontBig_height = 12;
  
  /***************************/

  int LabelXPos = 11;
  int ControlXPos = 92;
  int AdditionalXPos = 550;

  int SectionYPos = 15;
  int GroupYPos = 70;
  int EntryYPos = 200;
  int DetailYPos = 340;
  int ButtonYPos = 410;


  /***********/
  
  dummyLabel = new Label( cp5, "" );

  /*********************/
  grpSelectors = cp5.addGroup( "grpSelectors" );

  /*********************/

  txtGroupComment = cp5.addTextarea("txtGroupComment")
                  .setPosition(ControlXPos, GroupYPos+(pfont_height/2))
                  .setSize(405, 50)
//                  .setColorBackground( 50 )
    .disableColorBackground()
                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( grpSelectors )
                  ;
  
  
  grpSubSection = cp5.addTextarea("grpSubSection")
                  .setPosition(ControlXPos, GroupYPos-4*(pfont_height))
                  .setSize(405, 20)
//                  .setColorBackground( 50 )
    .disableColorBackground()

                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( grpSelectors )
                  ;

  txtEntryComment = cp5.addTextarea("txtEntryComment")
                  .setPosition(ControlXPos, EntryYPos-7*pfont_height)
                  .setSize(405, 5*pfont_height)
//                  .setColorBackground( 50 )
    .disableColorBackground()
                  .setFont(pfont)
                  .setLineHeight(pfont_height+4)
                  .moveTo( grpSelectors )
                  ;
  
  lstEntryName = new SelectListBox( cp5, "lstEntryName" );
        ((ListBox) lstEntryName)
         .setPosition(ControlXPos, EntryYPos-(pfont_height+4))
         .setSize(307, 150)
         .setItemHeight(15)
         .setBarHeight(15)
         .setScrollbarVisible( true )
         .setScrollbarWidth(0)
         .actAsPulldownMenu( false )
         .setUpdate( true )
         .hideBar()
         .setColorBackground(color(255, 128))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( grpSelectors )
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
         .setColorBackground(color(255, 128))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( grpSelectors )
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
         .setColorBackground(color(255, 128))
         .setColorActive(color(0))
         .setColorForeground(color(255, 100,0))
         .moveTo( grpSelectors )
         ;

  ArrayList arrSLB = new ArrayList();
  arrSLB.add( lstEntryStatus );
  arrSLB.add( lstEntryName );
  arrSLB.add( lstEntryComm );
  
  lstEntryStatus.addOthers( arrSLB );
  lstEntryName.addOthers( arrSLB );
  lstEntryComm.addOthers( arrSLB );

  togAll = cp5.addToggle("Show All")
     .setPosition(AdditionalXPos,SectionYPos-(pfont_height+4) )
     .setSize(50,20)
     .setValue(false)
     .moveTo( grpSelectors )
     ;

  togOnlyActive = cp5.addToggle("Only Active")
     .setPosition(AdditionalXPos+togAll.getWidth()+20,SectionYPos -(pfont_height+4))
     .setSize(50,20)
     .setValue(false)
     .moveTo( grpSelectors )
     ;
     
     
  lblName = cp5.addTextlabel("lblName")
    .setText( "Name" )
    .setPosition( LabelXPos, DetailYPos )
    ;


  txfName = cp5.addTextfield("txfName")
    .setPosition(ControlXPos, DetailYPos)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .lock()
    ;

  togEntryActive = cp5.addToggle("Active")
     .setPosition(ControlXPos + 600,DetailYPos )
     .setSize(50,20)
     .setValue(false)
     .lock()
     ;


  lblValue = cp5.addTextlabel("lblValue")
    .setText( "Value" )
    .setPosition( LabelXPos, DetailYPos+22 );

  txfValue = cp5.addTextfield("txfValue")
    .setPosition(ControlXPos, DetailYPos+22)
    .setSize(550,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .lock()
    ;
       
  lblComment = cp5.addTextlabel("lblComment")
    .setText( "Comment" )
    .setPosition( LabelXPos, DetailYPos+44 );

  txfComment = cp5.addTextfield("txfComment")
    .setPosition(ControlXPos, DetailYPos+44)
    .setSize(650,20)
    .setAutoClear(false)
    .setFont( pfontEditor )
    .lock()
    ;
    



  btnEditSave = cp5.addButton("btnEditSave")
     .setPosition(ControlXPos,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Edit" )
     ;

  btnEditCancel = cp5.addButton("btnEditCancel")
     .setPosition(ControlXPos+btnEditSave.getWidth()+20,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Cancel" )
     .setVisible(false)
     ;

  btnWriteFull = cp5.addButton("btnWriteFull")
     .setPosition(AdditionalXPos,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Write" )
     ;

  btnWriteMinimal = cp5.addButton("btnWriteMinimal")
     .setPosition(AdditionalXPos+btnWriteFull.getWidth()+20,ButtonYPos)
     .setSize(80,20)
     .setCaptionLabel( "   Minimal" )
     ;

  lblEntry = cp5.addTextlabel("lblEntry")
    .setText( "Entry" )
    .setPosition( LabelXPos, EntryYPos-(pfont_height+4) );

  lblGroup = cp5.addTextlabel("lblGroup")
    .setText( "Group" )
    .setPosition( LabelXPos, GroupYPos-(pfont_height+4) );
  drpGroup = cp5.addDropdownList("drpGroup", ControlXPos, GroupYPos, 406, 110)
        .setBarHeight( pfont_height+4 ); 

  lblSection = cp5.addTextlabel("lblSection")
    .setText( "Section" )
    .setPosition( LabelXPos, SectionYPos-(pfont_height+4) );
  drpSection = cp5.addDropdownList("drpSection", ControlXPos, SectionYPos, 406, 70)
        .setBarHeight( pfont_height+4 ); 


  println("createGUI : End create controls");

  drpSection.clear();  
  drpSection.addItems( g_config.getDisplayNames() );
  drpSection.setIndex(0);
  updateSection(0);

  println("createGUI : End");

}


