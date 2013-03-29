/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  GUIHELPER                                                               *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

import javax.swing.*;

/* Other Status flags and data */
ConfEntry actCE;
ArrayList actCEList = new ArrayList();

boolean isEditMode;
boolean isUpdateEnabled = true;

/*************************************************************************************************/
/****************  Central Event Handler and Buttons                                       *******/
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

    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (  ( theEvent.getController() instanceof Slider) ) {  
  } else if (  ( theEvent.getController() instanceof Toggle) ) {  
    if ( ( theEvent.getController().equals( togAll ) ) || ( theEvent.getController().equals( togOnlyActive ) ) ) { 
      updateToggle((Toggle) theEvent.getController());
    }
  }

}

/*************************************************************************************************/
public void btnWriteFull(int theValue) {
  if ( ! isModified() ) {
    writeAConfig( false );
  }
}

/*************************************************************************************************/
public void btnWriteMinimal(int theValue) {
  if ( ! isModified() ) {
    writeAConfig( true );
  }
}

/*************************************************************************************************/
/****************  Cascading update for UI  (Lists)                                        *******/
/*************************************************************************************************/


/*************************************************************************************************/
public void updateToggle(Toggle aToggle) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( isModified() ) {
    // disable event handling
    isUpdateEnabled = false;
    aToggle.setState( ! aToggle.getState() );
    isUpdateEnabled = true;
    return;
  } else if ( isEditMode ) {
    finalizeEdit( false );
  }

  updateSection(-1);

}

/*************************************************************************************************/
/************* newId -1 means just refresh the UI */
public void updateSection(int newId) {
  
  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( newId >= 0 ) {
    if ( isModified() ) {
      // disable event handling
      isUpdateEnabled = false;
      drpSection.setValue( drpSection.getId() );
      isUpdateEnabled = true;
      return;
    } else if ( isEditMode ) {
      finalizeEdit( false );
    }
    drpSection.setId( newId );
  }

  ConfSection cs = g_config.get(drpSection.getId());
  drpGroup.setIndex(0);
  drpGroup.clear();  
  if ( cs.size() > 0 ) 
    drpGroup.addItems( cs.getDisplayNames() );
  else
    drpGroup.addItems( dummylist );
  drpGroup.setIndex(0);

  println(" Entries in group :" + cs.size() );

  if ( newId >= 0 ) {
    updateGroup(0);
  } else {
    updateGroup(-1);
  }
}

/*************************************************************************************************/
public void updateGroup(int newId) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( newId >= 0 ) {
    if ( isModified() ) {
      // disable event handling
      isUpdateEnabled = false;
      drpGroup.setValue( drpGroup.getId() );
      isUpdateEnabled = true;
      return;
    } else if ( isEditMode ) {
      finalizeEdit( false );
    }
    drpGroup.setId( newId );
  }

  ConfSection cs = g_config.get(drpSection.getId());
  ConfGroup cg = cs.get(drpGroup.getId());
  ConfObject co;
  
  int id = drpGroup.getId();
  txtGroupComment.setText( "" );
  
  actCEList.clear();

  if ( togAll.getState() ) {
    updateCEList( g_config, togOnlyActive.getState() );
  } else if ( togOnlyActive.getState() ) {
    updateCEList( cs, togOnlyActive.getState() );
  } else {
    updateCEList( cg, togOnlyActive.getState() );
  }

  if ( ! togAll.getState() ) {
    println("Selected Group Index : " + drpGroup.getId() );
    grpSubSection.setText(cg.subsectionName);    

    if ( cg.hasComments() ) {
      txtGroupComment.setText( cg.comments );
    }
  }
  
  updatelst( lstEntryName, togOnlyActive.getState(), 0 );
  updatelst( lstEntryStatus, togOnlyActive.getState(), 1 );
  updatelst( lstEntryComm, togOnlyActive.getState(), 2 );
  
  if (newId >= 0 ) {
    updateEntry(0);
  } else {
    updateEntry(-1);
  }
}


/*************************************************************************************************/
public void updateEntry(int newId) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( newId >= 0 ) {
    if ( isModified() ) {
      // disable event handling
      isUpdateEnabled = false;
      lstEntryName.setValue( lstEntryName.getId() );
      isUpdateEnabled = true;
      return;
    } else if ( isEditMode ) {
      finalizeEdit( false );
    }
    lstEntryName.setId(newId);
    lstEntryName.setActiveValue(newId);
  }

  int actId = lstEntryName.getId();
  
//  println( "ID: " + lstEntryName.getId() );
//  println( "Size: " + actCEList.size() );
  if ( actId >= actCEList.size() ) {
    txtEntryComment.setText( "" );
    txfName.setText( "" );
    txfValue.setText( "" );
    txfComment.setText( "" );
    togEntryActive.setState( false );
  } else {
    actCE = (ConfEntry) actCEList.get(actId);
  
    if ( actCE.hasComments() ) {
      txtEntryComment.setText( actCE.comments );
    } else {
      txtEntryComment.setText( "" );
    }
      
    txfName.setValue( actCE.getName() );
    if ( actCE.hasValue ) {
      txfValue.setValue( actCE.getValue() );
    } else {
      txfValue.setValue( "" );
    }
    
    txfComment.setValue( actCE.getLineComment() );

    togEntryActive.setState( actCE.active );

  }
}



/*************************************************************************************************/
public void updateCEList( ConfObject co, boolean blnActiveOnly ) {

  if ( co instanceof ConfGroup ) {
    for (int j = 0 ; j < co.size(); j++) {
      ConfEntry ce = (ConfEntry) co.get(j);
      if ( ( ! blnActiveOnly ) || (ce.active ) ) {
        actCEList.add ( ce );
      }
    }
  } else if ( co instanceof Config ) {
    Config con = (Config) co;
    
    for (int j = 0 ; j < con.sortedNames.size(); j++) {
      ConfEntry ce = (ConfEntry) ( con.sortedNames.get(j));
      if ( ( ! blnActiveOnly ) || (ce.active ) ) {
        actCEList.add ( ce );
      }
    }
  } else {
    for (int j = 0 ; j < co.size(); j++) {
      updateCEList( co.get(j), blnActiveOnly );
    }
  }

}

  
  /*************************************************************************************************/
public void updatelst(SelectListBox lstSel, boolean blnActiveOnly, int which) {
  String[] texts;
  ArrayList textList = new ArrayList();
  
  for (int j = 0 ; j < actCEList.size(); j++) {
    ConfEntry ce = (ConfEntry) actCEList.get(j);
    textList.add( getEntryText( ce, which ) );
  }
  
  // no convert ArrayList into String array
  texts = (String[]) textList.toArray( new String[] {} );
  
  lstSel.beginItems();
  lstSel.setValue( 0 ).clear();

  // add to list box 
  if ( texts.length > 0 ) {
    lstSel.addItems( texts );
  } else {
    lstSel.addItems( dummylist );
  }

  lstSel.endItems();
  lstSel.setValue( drpGroup.getId() );

}


/*************************************************************************************************/
String getEntryText( ConfEntry ce, int which ) {
  if ( which == 0 ) {
    return ce.getDisplayName();
  } else if ( which == 1 ) {
    return ce.getStatusText();
  } else {
    return ce.getLineComment();
  }
} 




/*************************************************************************************************/
/*
public void updateTxtList(String[] names ) {
  String str = "";

  if ( chkGlobal.getState(0) ) {
    for( int i = 0; i<names.length; i++ ) {
      str += names[i] + char(10);
    }

  } else {
  
    for( int i = 0; i<g_config.sortedNames.size(); i++ ) {
      str += ((String) g_config.sortedNames.get(i)) + char(10);
    }
  }

  txtList.setText(str);
}
*/



/*************************************************************************************************/
/****************  Handle Entry Edit                                                       *******/
/*************************************************************************************************/

/*************************************************************************************************/
public boolean isModified() {
  if ( ! isEditMode ) {
    return false;
  }
  
  if ( actCE.getName().equals( txfName.getText() ) ) {
    if ( actCE.active == togEntryActive.getState() ) {
      if ( ( ! actCE.hasValue() ) || ( actCE.value.equals( txfValue.getText() )  ) ) {
        if ( actCE.getLineComment().equals( txfComment.getText() ) ) {
          return false;
        }
      }
    }
  }

  return true;
}


/*************************************************************************************************/
public String validateEntry(String name, String value, String comment, boolean active) {
  ConfSection cs = g_config.get(drpSection.getId());
  ConfGroup cg = cs.get(drpGroup.getId());
  ConfEntry ce = cg.get(lstEntryName.getId());

  // If newly activeated then check for ZERO-ONE
  if ( ( cg.isZeroOne ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.active ) && ( ! ance.equals( ce ) ) ) {
        return "Multiple active entries in ZeroOne group - Deactive other entry first";
      }
    }
  }

  // If Mixed check for other active value with same name
  if ( ( cg.isMixed ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.active ) && ( ! ance.equals( ce ) ) && ( ! ance.getName().equals( ce.getName() ) ) ) {
        return "Multiple active entries with name \"" + ce.getName() + "\"in Mixed group - Deactive other entry first";
      }
    }
  }

  // If hasNoValue (meaning all entries only defines) I assume this is a toggle group where only one entry should be active  
  if ( ( cg.hasNoValue ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.active ) && ( ! ance.equals( ce ) ) ) {
        return "Multiple active entries in HasNoValue group - Deactive other entry first";
      }
    }
  }
  
  // name should not contain any spaces and only chars, numbers, _
  for( int i = 0; i<name.length(); i++ ) {
    if ( ! isNamePart( name.charAt( i ) ) ) {
      return "Name should only contain letters, numbers and '_' ";
    }
  }
  
  // check for duplicate name
  ConfEntry foundCE = g_config.getEntryByName( name );
  if ( foundCE != null ) {
    if ( ! foundCE.equals( ce ) ) {
      return "Duplicate name \"" + name + "\" not allowed";
    }
  }
  
  // ?? check for comment --> either start with "//" or be /* followed by */
  if ( comment.length() > 0 ) {
    if ( ! comment.startsWith( "//" ) ) {
      if ( ! comment.startsWith( "/*" ) ) {
        return "No comment start sequence // or /* ";
      }
      if ( ! comment.endsWith( "*/" ) ) {
        return "No comment end */ ";
      }
    }    
  }
  return "";
}



/*************************************************************************************************/
public boolean changeEntryfromForm() {

  // get values from form
  
  String name =  trim(txfName.getText());
  String value =  trim(txfValue.getText());
  String comment =  trim(txfComment.getText());
  boolean active = togEntryActive.getState();

  // Validate
  String validation = validateEntry(name, value, comment, active);
  if ( validation.length() > 0 ) {
    JOptionPane.showMessageDialog(null,
        validation, "Entry validation failed", 
        JOptionPane.ERROR_MESSAGE);
    return false;
  }
    
  // Change entry
  actCE.modified = true;
  actCE.active =  active;
  actCE.name =  name;
  actCE.value =  value;
  actCE.setLineComment( comment );
  g_config.rebuild();
  
  // updateEntry
  updateGroup( -1 );

  // update current Entry (actCE)
  // ?? update and validation --> return false if validation does not work
/*
    * Activate an entry --> Toggle active
      Validate: Check if ZeroOne or if entry is there multiple times => Invalidate other entry and change ref in sortedarray
      Validate: Check if HasNoValue and show message to deactivate the other sets
    * Deactivate an entry --> Toglle active
    * Add a new entry
      Validate: Check name available in other group => Fail
          Check name active in this group and not a 
    * Remove an entry
    * Change Value for an entry
      Validate: Check the value on syntax?
    * Rename an entry?
    
    * check for isSingleLineComment
*/
  return true;
}


/*************************************************************************************************/
public void finalizeEdit(boolean doSave) {
  boolean isEnded = true;
  
  if ( ( ! doSave ) && ( isModified() ) ) {
    int choice = JOptionPane.showConfirmDialog(null,
        "Discard changes to the current entry ?", "Unsaved Entry", 
        JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
    if ( ( choice == JOptionPane.CANCEL_OPTION ) || ( choice == JOptionPane.NO_OPTION ) ) { 
      return;
    } else if ( choice == JOptionPane.YES_OPTION ) {
      isEnded = true;
    }
  } else {
    if ( ( doSave ) && ( isModified() ) ) {
      isEnded = changeEntryfromForm();
    }
  }

  // reset UI if really finalized
  if ( isEnded ) {

    txfValue.lock();
    txfComment.lock();
    togEntryActive.lock();

    txfName.setColor( ControlP5.CP5BLUE );
    txfValue.setColor( ControlP5.CP5BLUE );
    txfComment.setColor( ControlP5.CP5BLUE );
    togEntryActive.setColor( ControlP5.CP5BLUE );
  
    btnEditCancel.setColor( ControlP5.CP5BLUE );
    btnEditSave.setColor( ControlP5.CP5BLUE );

    isEditMode = false;
    btnEditSave.setCaptionLabel( "   Edit" );
    btnEditCancel.setVisible( false );
  }
}

/*************************************************************************************************/
public void startEdit() {
  // modify UI for starting edit

  // set color for active fields
  txfName.setColor( ControlP5.RED );
  txfName.unlock();
  if ( actCE.hasValue() ) {
    txfValue.setColor( ControlP5.RED );
    txfValue.unlock();
  }
  txfComment.unlock();
  txfComment.setColor( ControlP5.RED );

  togEntryActive.setColor( ControlP5.RED );
  togEntryActive.unlock();
  
  btnEditCancel.setColor( ControlP5.RED );
  btnEditSave.setColor( ControlP5.RED );


  isEditMode = true;
  btnEditSave.setCaptionLabel( "   Save" );
  btnEditCancel.setVisible( true );
}


/*************************************************************************************************/
public void btnEditSave(int theValue) {
  if ( isEditMode ) {
    finalizeEdit( true );
    if ( ! isEditMode ) {
      // Refresh fields from Entry
      // full screen needs refresh probably
      updateEntry( -1 );
    }
  } else {
    startEdit();
  }
}


/*************************************************************************************************/
public void btnEditCancel(int theValue) {
  finalizeEdit( false );
  if ( ! isEditMode ) {
    // Refresh fields from Entry
    // full screen needs refresh probably
    updateEntry( -1 );
  }
}

