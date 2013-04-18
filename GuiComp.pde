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
/****************  GUIDELTA                                                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

Config g_CompConfig;
ArrayList deltaList = new ArrayList();
int G_SelectedId = -1;
boolean G_IsLeft = false;

/*********************************************************************************/

public boolean tabCompareIsReady() {
 return ( g_CompConfig != null ); 
}

/*************************************************************************************************/
/****************  Cascading update for UI  (Lists)                                        *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void updateCompToggle(Toggle aToggle) {

  if ( ! isUpdateEnabled ) {
    return;
  }

  updateCompLists();
}  

/*************************************************************************************************/
public void updateCompConfig(Config aConfig) {
  g_CompConfig = aConfig;

  if ( aConfig == null ) {
    isUpdateEnabled = false;
    drpLCSection.clear();
    drpRCSection.clear();
    isUpdateEnabled = true;
    updateTab( tabDefault );
    return;
  }    

  G_SelectedId = 0;
  
  // fill section dropdowns
  isUpdateEnabled = false;
  drpLCSection.addItems( g_config.getDisplayNames() );
  drpRCSection.addItems( g_CompConfig.getDisplayNames() );
  drpLCSection.setIndex(0);
  drpRCSection.setIndex(0);
  isUpdateEnabled = true;

  updateCompLists();

  updateTab( tabCompare );
}


/*************************************************************************************************/
public void updateCompLists() {
  DeltaEntry de;

  // calculate delta list 
  calcDeltaList(togCompareDiff.getState(), togCompareActive.getState() );

  // create list with all entries
  lstEntryLeft.beginItems();
  lstEntryInfo.beginItems();
  lstEntryRight.beginItems();

  lstEntryLeft.setValue( 0 ).clear();
  lstEntryInfo.setValue( 0 ).clear();
  lstEntryRight.setValue( 0 ).clear();

  for (int j = 0 ; j < deltaList.size(); j++) {
    de = (DeltaEntry) deltaList.get(j);
    
    if ( de.hasLeft() ) {
      lstEntryLeft.addItem( de.getDNameLeft(), j );
    } else {
      lstEntryLeft.addItem( "--", j );
    }
    
    if ( de.hasRight() ) {
      lstEntryRight.addItem( de.getDNameRight(), j );
    } else {
      lstEntryRight.addItem( "--", j );
    }
    
    if ( de.hasBoth() ) {
      lstEntryInfo.addItem( de.getDifference(), j );
    } else if ( de.hasRight() ) {
      lstEntryInfo.addItem( "++", j );
    } else {
      lstEntryInfo.addItem( "--", j );
    } 
    
  }

  lstEntryLeft.setValue( 0 ).endItems();
  lstEntryInfo.setValue( 0 ).endItems();
  lstEntryRight.setValue( 0 ).endItems();
  
}

/*************************************************************************************************/
public void calcDeltaList(boolean onlyDiff, boolean onlyActive) {
  int lSize = g_config.getSortedNamesSize();
  int rSize = g_CompConfig.getSortedNamesSize();
  int lPos = 0;
  int rPos = 0;
  int compare;
  ConfEntry aLCE, aRCE;
  boolean addEntry;
  
  // Calculate entry diff based on sorted lists
  deltaList.clear();
    
  while ( ( lPos < lSize ) && ( rPos < rSize ) ) {
    addEntry = true;
    aLCE = (ConfEntry) g_config.getSortedNamesByIndex( lPos );
    aRCE = (ConfEntry) g_CompConfig.getSortedNamesByIndex( rPos );
    compare = aLCE.getName().compareTo( aRCE.getName() );
    if ( compare == 0 ) {
      lPos++;
      rPos++;
      if ( onlyDiff ) {
        addEntry = ! areEntriesEqual( aLCE, aRCE );
      }
      if ( onlyActive ) {
        addEntry = addEntry && ( ( aLCE.isActive() ) || ( aRCE.isActive() ) );
      } 
    } else if ( compare > 0 ) {
      // right smaller
      aLCE = null;
      rPos++;
      if ( onlyActive ) {
        addEntry = ( aRCE.isActive() ) ;
      }
    } else {
      // left smaller
      aRCE = null;
      lPos++;
      if ( onlyActive ) {
        addEntry = ( aLCE.isActive() ) ;
      }
    }
    if ( addEntry ) {
      deltaList.add(  new DeltaEntry( aLCE, aRCE ) );
    }
  }   
  aRCE = null;
  while ( lPos < lSize ) {
    aLCE = (ConfEntry) g_config.getSortedNamesByIndex( lPos );
    if ( ( ! onlyActive ) || ( aLCE.isActive() ) ) {
      deltaList.add(  new DeltaEntry( aLCE, null ) );
    }
    lPos++;
  }

  aLCE = null;
  while ( rPos < rSize ) {
    aRCE = (ConfEntry) g_CompConfig.getSortedNamesByIndex( rPos );
    if ( ( ! onlyActive ) || ( aLCE.isActive() ) ) {
      deltaList.add(  new DeltaEntry( null, aRCE ) );
    }
    rPos++;
  }

  if ( deltaList.size() == 0 ) {
    deltaList.add(  new DeltaEntry( null, null ) );
  }    

}  
    
    
/*************************************************************************************************/
public void updateCompSection(LDropdownList eventDDLB, int newId) {
  updateDeltaEntry( null, -1 );
}  
    
/*************************************************************************************************/
public void updateDeltaEntry(SelectListBox eventSLB, int newId) {
  int selId;
  
  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( eventSLB == lstEntryInfo ) {
    return;
  }
  
  if ( newId >= 0 ) {
    if ( newId >= eventSLB.itemCount() ) {
      newId = eventSLB.itemCount()-1;
    }

    eventSLB.setId(newId);
    eventSLB.setActiveValue(newId);
    G_SelectedId = newId;
  }
  
  ConfEntry aCE = null;
  DeltaEntry de;
  de = ((DeltaEntry) deltaList.get(G_SelectedId));
  if ( eventSLB == lstEntryLeft ) {
    aCE = de.getLeft();
    G_IsLeft = true;
  } else {
    aCE = de.getRight();
    G_IsLeft = false;
  }
  
  // select corresponding entry in section dropdown
  isUpdateEnabled = false;
  if ( de.getLeft() == null ) {
    drpLCSection.hide();
  } else {
    drpLCSection.show();
    ConfSection cs = (ConfSection) ((ConfGroup) de.getLeft().getParent()).getParent();
    for (int j = 0 ; j < g_config.size(); j++) {
      if ( g_config.get(j).equals( cs ) ) {
        drpLCSection.setValue( j );
      }
    }
  }   
  if ( de.getRight() == null ) {
    drpRCSection.hide();
  } else {
    drpRCSection.show();
    ConfSection cs = (ConfSection) ((ConfGroup) de.getRight().getParent()).getParent();
    for (int j = 0 ; j < g_CompConfig.size(); j++) {
      if ( g_CompConfig.get(j).equals( cs ) ) {
        drpRCSection.setValue( j );
      }
    }
  }   
  isUpdateEnabled = true;
  

  // update buttons
  updateDeltaButtons( de );
  
  // set group/subsection
  txtGroupName.setText( ((ConfGroup) de.getRight().getParent()).getDisplayName() );

  // Update Details ?
  setEditorFieldsFromEntry( aCE );

}


/*************************************************************************************************/
public void updateDeltaButtons(DeltaEntry de) {
  if ( de.getLeft() == null ) {
    btnAlignActive.hide();  
    btnAlignValue.hide();  
    btnAlignEntry.hide();  

    if ( de.getRight() != null ) {
      btnAlignAddRemove.show()
          .setCaptionLabel( "  Add Entry" );    
    } else {
      btnAlignAddRemove.hide();
    }

  } else if ( de.getRight() == null ) {
    btnAlignActive.hide();  
    btnAlignValue.hide();  
    btnAlignEntry.hide();  
    btnAlignAddRemove.show()
        .setCaptionLabel( "  Remove Entry" );    
  } else if ( areEntriesEqual( de.getRight(), de.getLeft() ) ) {
    btnAlignActive.hide();  
    btnAlignValue.hide();  
    btnAlignEntry.hide();  
    btnAlignAddRemove.hide();  
  } else {
    if ( de.getRight().isActive() != de.getLeft().isActive() ) { 
        btnAlignActive.show();
        if ( de.getLeft().isActive() ) {
          btnAlignActive.setCaptionLabel( "  DEactivate" );
        } else {
          btnAlignActive.setCaptionLabel( "  Activate" );
        }
    } else {
        btnAlignActive.hide();
    }    
    if ( de.getRight().getValue().equals( de.getLeft().getValue() ) ) { 
        btnAlignValue.hide();
    } else {
        btnAlignValue.show();
        if ( ! de.getRight().hasValue() ) {
          btnAlignValue.setCaptionLabel( "  Remove Value" );
        } else {
          btnAlignValue.setCaptionLabel( "  Align Value" );
        }
    }    
    btnAlignEntry.show()
        .setCaptionLabel( "  Align" );    
    btnAlignAddRemove.hide();  
  }
}


/*************************************************************************************************/
/****************  Buttons                                                                 *******/
/*************************************************************************************************/


/*************************************************************************************************/
public void btnAlignActive(int theValue) {

  ConfEntry aCE = null;
  DeltaEntry de = ((DeltaEntry) deltaList.get(G_SelectedId));
  
  de.getLeft().setActiveWithValidation( de.getRight().isActive() );
  g_config.setModified( true );
  
  updateOnAlign();
}


/*************************************************************************************************/
public void btnAlignValue(int theValue) {

  ConfEntry aCE = null;
  DeltaEntry de = ((DeltaEntry) deltaList.get(G_SelectedId));
  
  if ( de.getLeft().setValueWithValidation( de.getRight().getValue() ) ) {
    g_config.setModified( true );

    updateOnAlign();
  }
}

/*************************************************************************************************/
public void btnAlignEntry(int theValue) {

  ConfEntry aCE = null;
  DeltaEntry de = ((DeltaEntry) deltaList.get(G_SelectedId));
  
  int choice = JOptionPane.showConfirmDialog(null,
      "Copy entry completely from right (including comment) ?", "Align Entry", 
      JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
  if ( ( choice == JOptionPane.CANCEL_OPTION ) || ( choice == JOptionPane.NO_OPTION ) ) { 
    return;
  }

  aCE = de.getLeft();

  if ( aCE.setValueWithValidation( de.getRight().getValue() ) ) {
    aCE.setActiveWithValidation( de.getRight().isActive() );
    aCE.setLineComment( de.getRight().getLineComment() );

    g_config.setModified( true );

    updateOnAlign();
  }
}



/*************************************************************************************************/
public void btnAlignAddRemove(int theValue) {
  boolean modified = false;
  DeltaEntry de = ((DeltaEntry) deltaList.get(G_SelectedId));
  ConfEntry sourceCE = de.getRight();
  
  if ( de.getLeft() == null ) {
    ConfEntry aCE = null;

    // add entry
    println("Add Entry ");
    // adding entry means first identifying the corresponding section (by ID) --> or last section
    // then identifying group by name --> or add that group
    ConfGroup rightCG = (ConfGroup) de.getRight().getParent();
    ConfGroup cg = null;
    String groupName = rightCG.getName();
    
    for (int i = 0 ; i < g_config.size(); i++) {
      // Section
      ConfObject cs = g_config.get(i);
      for (int j = 0 ; j < cs.mList.size(); j++) {
        cg = (ConfGroup) cs.get(j);
        if ( groupName.equals( cg.getName() ) ) {
          println("found and add to group ");
          modified = true;
        }
      }
    }

/*  
    if ( ! modified ) {
      println("NOT found and add to group ");
      modified = true;

      ConfObject cs = g_config.get(g_config.size()-1);
      cg = new ConfGroup( g_config, rightCG.getSubsectionName(), rightCG.getName() );
      cs.add( cg );
    }
*/

    if ( modified ) {
      // add new entry
      aCE = cg.createEntry();
      cg.add( aCE );          
  
      // Change entry
      aCE.setModified(true);
      aCE.setActive( sourceCE.isActive() );
      aCE.setName(  sourceCE.getName() );
      aCE.setValue( sourceCE.getValue() );
      aCE.setLineComment( sourceCE.getLineComment() );
    } else {
      JOptionPane.showMessageDialog(null,
          "Group not found no entry added", "Add entry faileds", 
          JOptionPane.ERROR_MESSAGE);
    }
    
  } else {
    // remove entry

    int choice = JOptionPane.showConfirmDialog(null,
        "Are you sure you want to delete the current entry (\"" + de.getLeft().getName() + "\") ?", "Remove Entry", 
        JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
    if ( ( choice == JOptionPane.CANCEL_OPTION ) || ( choice == JOptionPane.NO_OPTION ) ) { 
      return;
    }

    ConfGroup cg = (ConfGroup) de.getLeft().getParent();
    for (int i = 0 ; i < cg.size(); i++) {
      if ( de.getLeft().equals( ((ConfEntry) cg.get(i)) ) ) {
        cg.remove(i);
        modified = true;
      }
    }
  }
  if ( modified ) {
    g_config.setModified( true );

    updateOnAlign();
  }
}



/*************************************************************************************************/
public void updateOnAlign() {

  boolean isLeft = G_IsLeft;
  int selId = G_SelectedId;

//  println("Scrollposition: " + lstEntryRight.getScrollPosition() );
  float sp = lstEntryRight.getScrollPosition();


  g_config.rebuild();
  updateGroup( -1 );
  

  updateCompLists();
  if ( isLeft ) {
    updateDeltaEntry(lstEntryLeft,selId);
  } else {
    updateDeltaEntry(lstEntryRight,selId);
  }

  lstEntryRight.scroll( 1-sp );

  setWriteReminder();
}

