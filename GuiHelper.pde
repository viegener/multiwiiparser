/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  GUIHELPER                                                               *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

import javax.swing.*;

/* Other Status flags and data */
ConfEntry actEditCE;

// Current List shown in the ListBoxes
ArrayList CurrentCEList = new ArrayList();

boolean isEditMode;
boolean isCreateEditor = false;
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
/************* newId -2 means just refresh the UI and do not promote to subsequent controls */
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

  isUpdateEnabled = false;
  ConfSection cs = g_config.get(drpSection.getId());
  drpGroup.setIndex(0);
  drpGroup.clear();  
  if ( cs.size() > 0 ) 
    drpGroup.addItems( cs.getDisplayNames() );
  else
    drpGroup.addItems( dummylist );
  drpGroup.setIndex(0);
  isUpdateEnabled = true;

  if ( newId >= 0 ) {
    updateGroup(0);
  } else if ( newId == - 1 ) {
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
  
  int id = drpGroup.getId();
  txtGroupComment.setText( "" );
  
  
  CurrentCEList.clear();

  if ( togAll.getState() ) {
    updateCEList( g_config, togOnlyActive.getState() );
  } else if ( togOnlyActive.getState() ) {
    updateCEList( cs, togOnlyActive.getState() );
  } else {
    updateCEList( cg, togOnlyActive.getState() );
  }

  if ( ! togAll.getState() ) {
    println("Selected Group Index : " + drpGroup.getId() );
    grpSubSection.setText(cg.getSubsectionName());    

    if ( cg.hasComments() ) {
      txtGroupComment.setText( cg.getComments() );
    }
  }
  
  updatelst( lstEntryName, togOnlyActive.getState(), 0 );
  updatelst( lstEntryStatus, togOnlyActive.getState(), 1 );
  updatelst( lstEntryComm, togOnlyActive.getState(), 2 );
  
  if (newId >= 0 ) {
    updateEntry(0);
  } else if ( newId == - 1 ) {
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
  
  ConfEntry aCE = null;
  
  int actId = lstEntryName.getId();
  if ( ( actId >= 0 ) && ( actId < lstEntryName.itemCount() ) ) {
    aCE = (ConfEntry) CurrentCEList.get(actId);
    if ( togAll.getState() ) {
      // If ALl is activted DropDowns must be refreshed based on ACE
      ConfGroup cg = (ConfGroup) aCE.getParent();
      ConfSection cs = (ConfSection) cg.getParent();

      isUpdateEnabled = false;
      for (int j = 0 ; j < g_config.size(); j++) {
        if ( g_config.get(j).equals( cs ) ) {
          drpSection.setValue( j );
        }
      }
      isUpdateEnabled = true;
      updateSection( -2 );

      isUpdateEnabled = false;
      for (int j = 0 ; j < cs.size(); j++) {
        if ( cs.get(j).equals( cg ) ) {
          drpGroup.setValue( j );
        }
      }
      isUpdateEnabled = true;
      
    }

  }

  setEditorFieldsFromEntry( aCE );
}


/*************************************************************************************************/
void setEditorFieldsFromEntry( ConfEntry aCE ) {
  if ( aCE == null ) {
    txtEntryComment.setText( "" );
    txfName.setText( "" );
    txfValue.setText( "" );
    txfComment.setText( "" );
    togEntryActive.setState( false );
  } else {
    if ( aCE.hasComments() ) {
      txtEntryComment.setText( aCE.getComments() );
    } else {
      txtEntryComment.setText( "" );
    }
      
    txfName.setValue( aCE.getName() );
    if ( aCE.hasValue() ) {
      txfValue.setValue( aCE.getValue() );
    } else {
      txfValue.setValue( "" );
    }
    
    txfComment.setValue( aCE.getLineComment() );
    togEntryActive.setState( aCE.isActive() );
  }
}



/*************************************************************************************************/
public void updateCEList( ConfObject co, boolean blnActiveOnly ) {

  if ( co instanceof ConfGroup ) {
    for (int j = 0 ; j < co.size(); j++) {
      ConfEntry ce = (ConfEntry) co.get(j);
      if ( ( ! blnActiveOnly ) || (ce.isActive() ) ) {
        CurrentCEList.add ( ce );
      }
    }
  } else if ( co instanceof Config ) {
    Config con = (Config) co;
    
    for (int j = 0 ; j < con.getSortedNamesSize(); j++) {
      ConfEntry ce = (ConfEntry) ( con.getSortedNamesByIndex(j));
      if ( ( ! blnActiveOnly ) || (ce.isActive() ) ) {
        CurrentCEList.add ( ce );
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
  

  lstSel.beginItems();
  lstSel.setValue( 0 ).clear();
  for (int j = 0 ; j < CurrentCEList.size(); j++) {
    ConfEntry ce = (ConfEntry) CurrentCEList.get(j);
    lstSel.addItem( getEntryText( ce, which ), j );
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
  
  if ( isCreateEditor ) {
    return true;
  }
  
  if ( actEditCE.getName().equals( txfName.getText() ) ) {
    if ( actEditCE.isActive() == togEntryActive.getState() ) {
      if ( ( ! actEditCE.hasValue() ) || ( actEditCE.getValue().equals( txfValue.getText() )  ) ) {
        if ( actEditCE.getLineComment().equals( txfComment.getText() ) ) {
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
  ConfEntry ce = (ConfEntry) CurrentCEList.get(lstEntryName.getId());

  // If newly activeated then check for haveSameName
  if ( ( cg.haveSameName() ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.isActive() ) && ( ! ance.equals( ce ) ) ) {
        return "Multiple active entries in ZeroOne group - Deactive other entry first";
      }
    }
  }

  // If Mixed check for other active value with same name
  if ( ( cg.isMixed() ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.isActive() ) && ( ! ance.equals( ce ) ) && ( ! ance.getName().equals( ce.getName() ) ) ) {
        return "Multiple active entries with name \"" + ce.getName() + "\"in Mixed group - Deactive other entry first";
      }
    }
  }

  // If haveNoValue (meaning all entries only defines) I assume this is a toggle group where only one entry should be active  
  if ( ( cg.haveNoValue() ) && ( active ) ){
    for( int i = 0; i<cg.size(); i++ ) {
      ConfEntry ance = (ConfEntry) cg.get(i);
      if ( ( ance.isActive() ) && ( ! ance.equals( ce ) ) ) {
        return "Multiple active entries in haveNoValue group - Deactive other entry first";
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
  actEditCE.setModified(true);
  actEditCE.setActive( active );
  actEditCE.setName( name );
  actEditCE.setValue( value );
  actEditCE.setLineComment( comment );

  // on Create new entry needs to be added
  if ( isCreateEditor ) {
    ConfSection cs = g_config.get(drpSection.getId());
    ConfGroup cg = cs.get(drpGroup.getId());
    cg.add(actEditCE );
  }

  g_config.rebuild();
  
  // updateEntry
  updateGroup( -1 );

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

    btnEditCreate.setVisible( true );
    btnEditRemove.setVisible( true );


  }
}

/*************************************************************************************************/
public void startEdit(boolean blnWithName, boolean blnWithValue, boolean blnWithComment, boolean blnWithActive) {
  // modify UI for starting edit

  // set color for active fields
  if ( blnWithName ) {
    txfName.setColor( ControlP5.RED );
    txfName.unlock();
  }
  if ( blnWithValue ) {
    txfValue.setColor( ControlP5.RED );
    txfValue.unlock();
  }
  if ( blnWithComment ) {
    txfComment.unlock();
    txfComment.setColor( ControlP5.RED );
  }
  
  if ( blnWithActive ) {
    togEntryActive.setColor( ControlP5.RED );
    togEntryActive.unlock();
  }
  
  btnEditCancel.setColor( ControlP5.RED );
  btnEditSave.setColor( ControlP5.RED );

  btnEditCreate.setVisible( false );
  btnEditRemove.setVisible( false );

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
    ConfSection cs = g_config.get(drpSection.getId());
    ConfGroup cg = cs.get(drpGroup.getId());
    ConfEntry ce = (ConfEntry) CurrentCEList.get(lstEntryName.getId());
    
    boolean blnWithName =  ! cg.haveSameName() ;
    boolean blnWithActive = true;

    if ( cg.haveNoValue() ) {
      ConfEntry activeCE = cg.getFirstActive();
      if ( activeCE != null )
        if ( ! ( activeCE.equals( ce ) ) ) {
          blnWithActive = false;
        }    
    }

    isCreateEditor = false;
    actEditCE = ce;
    startEdit(blnWithName, (ce.hasValue()), true, blnWithActive);
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


/*************************************************************************************************/
public void btnEditCreate(int theValue) {
  // Create in haveSameName --> Means: Can not be active if another active entry is existing / name is fixed to group name
  // create in haveNoValue --> Means: Can not be active if another active entry is existing / no value
  // create in mixed --> Active and duplicate name in group is not possible

  ConfSection cs = g_config.get(drpSection.getId());
  ConfGroup cg = cs.get(drpGroup.getId());
  ConfEntry ce = (ConfEntry) CurrentCEList.get(lstEntryName.getId());
  
  boolean blnWithName =  ! cg.haveSameName() ;
  boolean blnWithActive = true;
  boolean blnWithValue = ! cg.haveNoValue();

  if ( cg.haveNoValue() ) {
    ConfEntry activeCE = cg.getFirstActive();
    if ( activeCE != null )
      if ( ! ( activeCE.equals( ce ) ) ) {
        blnWithActive = false;
      }    
  }

  String dummyLine = "    ";
  if ( ! blnWithActive ) {
    dummyLine += "//";
  }
  dummyLine += SL_SETTING;
  if ( cg.haveSameName() ) {
    dummyLine += ce.getName();
  } else {
    dummyLine += DUMMY_NAME;
  }
  actEditCE = new ConfEntry(g_config, dummyLine);
  setEditorFieldsFromEntry( actEditCE );

  isCreateEditor = true;
  startEdit(blnWithName, blnWithValue, true, blnWithActive);
}


/*************************************************************************************************/
public void btnEditRemove(int theValue) {
  ConfSection cs = g_config.get(drpSection.getId());
  ConfGroup cg = cs.get(drpGroup.getId());
  ConfEntry ce = (ConfEntry) CurrentCEList.get(lstEntryName.getId());
  boolean groupDel = false;


  // Check if entry can be deleted
  if ( ( cg.size() == 1 ) && ( cs.size() == 1 ) ) {
    JOptionPane.showMessageDialog(null,
        "Last entry in Section can not be removed !", "Remove Entry", 
        JOptionPane.ERROR_MESSAGE);
    return;
  }
  
  // Ask for confirmation
  int choice = JOptionPane.showConfirmDialog(null,
      "Are you sure you want to delete the current entry (\"" + ce.getName() + "\") ?", "Remove Entry", 
      JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
  if ( ( choice == JOptionPane.CANCEL_OPTION ) || ( choice == JOptionPane.NO_OPTION ) ) { 
    return;
  }

  // Remove ce from cg
  cg.remove( lstEntryName.getId() );
  
  // check if group is empty and needs to be deleted as well
  if ( cg.size() == 0 ) {
    groupDel = true;
    cs.remove(drpGroup.getId());
  }
  
  // rebuild list
  g_config.rebuild();

  // refresh
  if ( groupDel )
    updateSection( drpSection.getId() );
  else 
    updateGroup( drpGroup.getId() );
}  
