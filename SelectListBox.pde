/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  SelectListBox (extends ListBox from CP5)                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

/*************************************************************************************************/
/****************  Extended Controls with Label handled specific                           *******/
/*************************************************************************************************/


public class InToggle extends Toggle {
 
   public InToggle(ControlP5 theControlP5, String theName) {  
    super( theControlP5, theName );
    _myCaptionLabel.toUpperCase( false );
    _myCaptionLabel.align(ControlP5.CENTER, ControlP5.CENTER); 
   }
}




public class LTextfield extends Textfield {
 
   public LTextfield(ControlP5 theControlP5, String theName) {  
    super( theControlP5, theName );
    _myCaptionLabel.toUpperCase( false );
    _myCaptionLabel.align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER); 
   }
}

public class LDropdownList extends DropdownList {
 
  protected float _myActiveValue = -1; 
 
  protected CColor actColor;

   public LDropdownList(ControlP5 theControlP5, String theName, int theX, int theY, int theW, int theH) {  
    super( theControlP5, theName );

    setPosition( theX, theY );
    setSize( theW, theH );
    setBarHeight( 10+4 );

    actColor = new CColor( getColor() );
    actColor.setForeground( getColor().getActive() );

    _myValueLabel.toUpperCase( false );
    _myValueLabel.align(ControlP5.LEFT_OUTSIDE, ControlP5.TOP_OUTSIDE); 
   }

  public LDropdownList setLabelText(String aText) {
    _myValueLabel.setText(aText);
    return this;
  }
 
  public LDropdownList setActiveValue( float actValue ) {
    for (int i = 0; i < items.size(); i++) {
      if ( (items.get(i)).getValue() == _myActiveValue ) {
        (items.get(i)).setColor( getColor() );
      }
   } 
    _myActiveValue = actValue;
    for (int i = 0; i < items.size(); i++) {
      if ( (items.get(i)).getValue() == _myActiveValue ) {
        (items.get(i)).setColor( actColor );
      }
   } 

   return this;
  }


  public ListBoxItem addItem(String theName, int theValue) {
    String modifName = theName.toUpperCase();
    int twidth = ControlFont.getWidthFor( modifName, dummyLabel, cp5.papplet );
    
    while ( twidth > (_myWidth-2*Label.paddingX) ) {
//      println("Shorten: " + modifName + "  (" + twidth + ")" );
      modifName = modifName.substring( 0, modifName.length() - 1 );
      twidth = ControlFont.getWidthFor( modifName, dummyLabel, cp5.papplet );
    }

    return super.addItem( modifName, theValue );
  } 




}




/*************************************************************************************************/
/****************  Extended SelectListBox                                                  *******/
/*************************************************************************************************/

public class SelectListBox extends ListBox { 
  
  protected ArrayList otherBoxes; 
  protected float _myActiveValue = -1; 
 
  protected CColor actColor;
 
  protected boolean isDep = false;

  SelectListBox(ControlP5 cp5, String theName) {
    super(cp5, theName); 

    actColor = new CColor( getColor() );
    actColor.setForeground( getColor().getActive() );
    
    otherBoxes = new ArrayList();
    _myValueLabel.align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER); 
    _myValueLabel.toUpperCase( false );
    _myValueLabel.setText("");
}

  public SelectListBox setLabelText(String aText) {
    _myValueLabel.setText(aText);
    return this;
  }
 
  
  public void addOther( SelectListBox aSLB ) {
    if ( ! ( aSLB.equals( this ) ) ) {
      otherBoxes.add ( aSLB );
    }
  }

  public void addOthers( ArrayList arrSLB ) {
    for (int i = 0; i < arrSLB.size(); i++) {
      addOther( (SelectListBox) arrSLB.get(i) );
    }
  }


  public int itemCount() {
    return items.size();
  }


  public SelectListBox setActiveValue( float actValue ) {
    for (int i = 0; i < items.size(); i++) {
      if ( (items.get(i)).getValue() == _myActiveValue ) {
        (items.get(i)).setColor( getColor() );
      }
   } 
    _myActiveValue = actValue;
    for (int i = 0; i < items.size(); i++) {
      if ( (items.get(i)).getValue() == _myActiveValue ) {
        (items.get(i)).setColor( actColor );
      }
   } 

  if ( ( ! isDep ) && ( otherBoxes != null ) ) {
    for (int i = 0; i < otherBoxes.size(); i++) {
//      println("scroll position " + _myScrollValue + " / " + itemOffset);
      SelectListBox anSLB = ((SelectListBox) otherBoxes.get(i) );
      anSLB.isDep = true;
      anSLB.setActiveValue( _myActiveValue );
      anSLB.isDep = false;
    }
  }    

   return this;
  }

  protected void scroll() { 
    super.scroll();

    if ( ( ! isDep ) && ( otherBoxes != null ) ) {
      for (int i = 0; i < otherBoxes.size(); i++) {
//        println("scroll position " + _myScrollValue + " / " + itemOffset);
        SelectListBox anSLB = ((SelectListBox) otherBoxes.get(i) );
        anSLB.isDep = true;
        anSLB._myScrollValue = _myScrollValue;
        anSLB.scroll();
        anSLB.isDep = false;
      }
    }    
  }

/* 
  public void controlEvent(ControlEvent theEvent) {
    if ( ! ( theEvent.getController() instanceof Button) ) {  
      println("Scroll event ");
    }
    super.controlEvent( theEvent );
  }
  */

  public ListBoxItem addItem(String theName, int theValue) {
    String modifName = theName.toUpperCase();
    int twidth = ControlFont.getWidthFor( modifName, dummyLabel, cp5.papplet );
    
    while ( twidth > (_myWidth-2*Label.paddingX) ) {
//      println("Shorten: " + modifName + "  (" + twidth + ")" );
      modifName = modifName.substring( 0, modifName.length() - 1 );
      twidth = ControlFont.getWidthFor( modifName, dummyLabel, cp5.papplet );
    }

    return super.addItem( modifName, theValue );
  } 

}
