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
/****************  SelectListBox (extends ListBox from CP5)                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.util.Map; 
import java.util.HashMap; 

import processing.event.KeyEvent; 

Object getFromClipboard(DataFlavor flavor)
{
  Clipboard clipboard = getToolkit().getSystemClipboard();
  Transferable contents = clipboard.getContents(null);
  Object obj = null;
  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try {
      obj = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException exu) { // Unlikely but we must catch it 
      println("Unsupported flavor: " + exu);
      //~ exu.printStackTrace();
    }
    catch (java.io.IOException exi) {
      println("Unavailable data: " + exi);
      //~ exi.printStackTrace();
    }
  }
  return obj;
} 

void putToClipboard(String text)
{
  Clipboard clipboard = getToolkit().getSystemClipboard();
  StringSelection content = new StringSelection(text);

  clipboard.setContents(content, null);

}


/*************************************************************************************************/
/****************  Extended Textfield                                                      *******/
/*************************************************************************************************/

public class LTextfield extends Textfield {
  
   public static final int KEY_HOME = 36;
   public static final int KEY_END = 35;
  
   protected Map<Integer, Boolean> myKeyMapping; 
  
   public LTextfield(ControlP5 theControlP5, String theName) {  
    super( theControlP5, theName );
    _myCaptionLabel.toUpperCase( false );
    _myCaptionLabel.align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER); 


    myKeyMapping = new HashMap<Integer, Boolean>();
    // true for ctrl mapping
    myKeyMapping.put(LEFT, false); 
    myKeyMapping.put(RIGHT, false); 

    myKeyMapping.put(KEY_HOME,false); 
    myKeyMapping.put(KEY_END, false); 

    myKeyMapping.put((int) 'C', true); 
    myKeyMapping.put((int) 'V', true); 
 
    }



    public void keyEvent(KeyEvent theKeyEvent) {
      boolean blnhandled = false;
      if (isUserInteraction && isTexfieldActive && isActive && theKeyEvent.getAction() == KeyEvent.PRESS) {
//        println( "Key is pressed : " + theKeyEvent.getKeyCode() );
        if ( ( theKeyEvent.isControlDown() ) && ( myKeyMapping.containsKey(theKeyEvent.getKeyCode())) && ( myKeyMapping.get(cp5.getKeyCode()).booleanValue() ) ) {
//            println(" In Control handler");
            blnhandled = true;
            myKeyHandler( theKeyEvent );
        } else if (myKeyMapping.containsKey(theKeyEvent.getKeyCode())) {
//             println(" In key handler " + theKeyEvent.isControlDown() + " " + theKeyEvent.isAltDown() );
            blnhandled = true;
            myKeyHandler( theKeyEvent );
        }
      }

      if ( ! blnhandled ) {
        super.keyEvent( theKeyEvent );
      }

    }
 

    
    public void myKeyHandler( KeyEvent theKeyEvent ) {
      switch ( theKeyEvent.getKeyCode() ) {
        case 'C':
          keyHandlerCopy(theKeyEvent);
          break;
        case 'V':
          keyHandlerPaste(theKeyEvent);
          break;
        case LEFT:
          keyHandlerLeft(theKeyEvent);
          break;
        case RIGHT:
          keyHandlerRight(theKeyEvent);
          break;
          
        case KEY_HOME:
          keyHandlerHome(theKeyEvent);
          break;
        case KEY_END:
          keyHandlerEnd(theKeyEvent);
          break;
      }
    }

    protected LTextfield mySetIndex( int theIndex ) {             
      _myTextBufferIndex = theIndex;
      changed = true;
      return this;
    } 

    public void keyHandlerCopy(KeyEvent theKeyEvent ) {
      if ( _myTextBuffer.length() > 0 ) {
        String text = new String( _myTextBuffer );
        putToClipboard( text );
      }
    }

    public void keyHandlerPaste(KeyEvent theKeyEvent ) {
      String text = (String) getFromClipboard(DataFlavor.stringFlavor);
      if ( text != null ) {
        _myTextBuffer = new StringBuffer( text );
        mySetIndex(_myTextBuffer.length());             
      }
    }

    public void keyHandlerHome(KeyEvent theKeyEvent ) {
      mySetIndex(0);
    }

    public void keyHandlerEnd(KeyEvent theKeyEvent ) {
      mySetIndex(_myTextBuffer.length());
    }

    public void keyHandlerLeft(KeyEvent theKeyEvent ) {
      mySetIndex((theKeyEvent.isControlDown()) ? 0 : PApplet.max(0, _myTextBufferIndex - 1));
    }

    public void keyHandlerRight(KeyEvent theKeyEvent ) {
      mySetIndex((theKeyEvent.isControlDown()) ? _myTextBuffer.length() : PApplet.min(_myTextBuffer.length(),
                      _myTextBufferIndex + 1));
    }

}


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

    _myLabel.setColorBackground( getColor().getActive() );
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
  protected boolean isActiveSync = true;

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


  public SelectListBox setActiveSync(boolean aVal) {
    isActiveSync = aVal;
    return this;
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
      if ( isActiveSync ) {
        anSLB.setActiveValue( _myActiveValue );
      } else {
        anSLB.setActiveValue( -1 );
      }
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
