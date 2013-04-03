/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  GUIDELTA                                                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

Config g_CompConfig;
ArrayList deltaList = new ArrayList();


/*********************************************************************************/

public boolean tabCompareIsReady() {
 return ( g_CompConfig != null ); 
}

/*************************************************************************************************/
/****************  Cascading update for UI  (Lists)                                        *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void updateCompConfig(Config aConfig) {
  DeltaEntry de;
  
  g_CompConfig = aConfig;
  txfCompareFile.setText( g_CompConfig.getName() );
  
  updateTab( tabCompare );

  // ?? Set Labels with filenames (for both configs)
  

  // calculate delta list 
  calcDeltaList();

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
public void calcDeltaList() {
  int lSize = g_config.getSortedNamesSize();
  int rSize = g_CompConfig.getSortedNamesSize();
  int lPos = 0;
  int rPos = 0;
  int compare;
  ConfEntry aLCE, aRCE;

  // ?? Calculate entry diff based on sorted lists
  deltaList.clear();
    
  while ( ( lPos < lSize ) && ( rPos < rSize ) ) {
    aLCE = (ConfEntry) g_config.getSortedNamesByIndex( lPos );
    aRCE = (ConfEntry) g_CompConfig.getSortedNamesByIndex( rPos );
    compare = aLCE.getName().compareTo( aRCE.getName() );
    if ( compare == 0 ) {
      lPos++;
      rPos++;
    } else if ( compare > 0 ) {
      // right smaller
      aLCE = null;
      rPos++;
    } else {
      // left smaller
      aRCE = null;
      lPos++;
    }
    deltaList.add(  new DeltaEntry( aLCE, aRCE ) );
  }   
  aRCE = null;
  while ( lPos < lSize ) {
    aLCE = (ConfEntry) g_config.getSortedNamesByIndex( lPos );
    deltaList.add(  new DeltaEntry( aLCE, null ) );
    lPos++;
  }

  aLCE = null;
  while ( rPos < rSize ) {
    aRCE = (ConfEntry) g_CompConfig.getSortedNamesByIndex( rPos );
    deltaList.add(  new DeltaEntry( null, aRCE ) );
    rPos++;
  }

}  
    
    
/*************************************************************************************************/
    
    
/*************************************************************************************************/
public void updateDeltaEntry(SelectListBox eventSLB, int newId) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( eventSLB == lstEntryInfo ) {
    return;
  }
  
  if ( newId >= 0 ) {
    eventSLB.setId(newId);
    eventSLB.setActiveValue(newId);
  }
  
  ConfEntry aCE = null;
  if ( eventSLB == lstEntryLeft ) {
    aCE = ((DeltaEntry) deltaList.get(eventSLB.getId())).getLeft();
  } else {
    aCE = ((DeltaEntry) deltaList.get(eventSLB.getId())).getRight();
  }
  
  // Update Details ?
  setEditorFieldsFromEntry( aCE );
}

