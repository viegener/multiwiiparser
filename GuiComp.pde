/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  GUIDELTA                                                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

Config g_CompConfig;
ArrayList deltaList = new ArrayList();
int G_SelectedId = -1;

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
  
  // ?? Set Labels with filenames (for both configs)


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

  // ?? create list with all entries
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
      if ( de.isEqual() ) {
        lstEntryInfo.addItem( "==", j );
      } else {
        
        lstEntryInfo.addItem( "<>", j );
      }
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
  
  // ?? Calculate entry diff based on sorted lists
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
  boolean isLeft;
  
  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( eventSLB == lstEntryInfo ) {
    return;
  }
  
  if ( newId >= 0 ) {
    eventSLB.setId(newId);
    eventSLB.setActiveValue(newId);
    G_SelectedId = newId;
  }
  
  ConfEntry aCE = null;
  DeltaEntry de;
  de = ((DeltaEntry) deltaList.get(G_SelectedId));
  if ( eventSLB == lstEntryLeft ) {
    aCE = de.getLeft();
    isLeft = true;
  } else {
    aCE = de.getRight();
    isLeft = false;
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
  
  // Update Details ?
  setEditorFieldsFromEntry( aCE );
}

