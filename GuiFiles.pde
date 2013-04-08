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
/****************  GUIFILES                                                                *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

/*********************************************************************************/
Favorites g_Favorites = new Favorites();

public static final String FAVORITE_FILE_NAME = "favorites.txt";

/*************************************************************************************************/

boolean isFileEditMode;

/*************************************************************************************************/
/****************  FavoriteFile class                                                      *******/
/*************************************************************************************************/

class FavoriteFile {
  protected File mFile;
  protected String mComment;
  
  /************** ConfObject ************************/
  FavoriteFile( File aFile, String aComment ) {
    mFile = aFile;
    mComment = aComment;    
  }
  
  /************** getName ************************/
  String getName() {
    return mFile.getName();
  }


  /************** getPath ************************/
  String getPath() {
    return mFile.getPath();
  }


  /************** getComment ************************/
  String getComment() {
    return mComment;
  }

  /************** getCmmment ************************/
  void setComment(String aComment) {
    mComment = aComment;
  }

}


/*************************************************************************************************/
/****************  Favorites class                                                         *******/
/*************************************************************************************************/

class Favorites {
  ArrayList<FavoriteFile> mList;
 
  Favorites() {
    mList = new ArrayList<FavoriteFile>();
  }

  /***********************/
  public int size() {
    return mList.size();
  }

  /****************  File handling for favorite list         *******/
  public void loadFavorites()
  {
    String[] strings = loadStrings( FAVORITE_FILE_NAME );
  
    if ( strings == null ) return;
    if ( ( strings.length % 2 ) == 1 ) return;
  
    mList.clear();
    for (int i=0; i <  strings.length; i+=2 ) {
      mList.add( new FavoriteFile( new File( strings[i] ), strings[i+1] ) );    
    }
  }

  public void saveFavorites()
  {
    String[] strings = new String[g_Favorites.size() * 2];
    for (int i=0; i <  mList.size(); i++) {
      strings[(i*2)] = mList.get(i).getPath();
      strings[(i*2)+1] = mList.get(i).getComment();
    }
  
    saveStrings( FAVORITE_FILE_NAME, strings );
  }

  /****************  Favorites list handling   *******/
  public void addFavorite( FavoriteFile aFF ) {
    mList.add( aFF );  
    if (CONFIG_AUTOSAVE_FAVORITES ) saveFavorites();
  }
  
  public void delFavorite( int idxToDel ) {
    if ( ( idxToDel >= 0 ) && ( idxToDel < g_Favorites.size() ) ) {
      mList.remove( idxToDel );
      if (CONFIG_AUTOSAVE_FAVORITES ) saveFavorites();
    }
  }


  /************** getName ************************/
  String getName(int id) {
    return mList.get(id).getName();
  }


  /************** getPath ************************/
  String getPath(int id) {
    return mList.get(id).getPath();
  }


  /************** getComment ************************/
  String getComment(int id) {
    return mList.get(id).getComment();
  }

  /************** getCmmment ************************/
  void setComment(int id, String aComment) {
    mList.get(id).setComment( aComment );
    if (CONFIG_AUTOSAVE_FAVORITES ) saveFavorites();
  }



}



/*************************************************************************************************/
/****************  File selection                                                          *******/
/*************************************************************************************************/

Config readAConfig( String givenFileName ) {
  Config config = null;
  
  if ( givenFileName != null ) {
    g_file =  new File( givenFileName );
    if ( ! g_file.exists() ) {
      g_file = null;
    }
  } else if ( isDebug( DEBUG_FIXED_FILE ) ) {
    println("Fixed file");
    g_file = new File("test\\config.h");
  } else {
    g_file = null;
    isFileSelected = false;
    selectInput( "Select a config.h file", "fileSelected" );

    // wait for file selected (ouch)
    while ( ! isFileSelected ) {
      delay(200);
    }
  }
  
  if ( ! ( g_file == null ) ) {
    config = parseConfig(g_file.getAbsolutePath() );
  }
  
  return config;
}




void writeAConfig( boolean doMinimal ) {
  g_file = null;
  
  String prpart = "";
  if ( doMinimal ) {
      prpart = " MINIMAL";
  }

  isFileSelected = false;
  selectOutput( "Select an Output File to store" + prpart + " config file", "fileSelected" );

  while ( ! isFileSelected ) {
    delay(200);
  }

  if ( ! ( g_file == null ) ) {
    String[] configText;
    if ( doMinimal ) {
      configText = (String[] ) g_config.getOutputText( doMinimal ).toArray( new String[] {} );
    } else {
      configText = (String[] ) g_config.getOriginalText().toArray( new String[] {} );
    }
  
    saveStrings(g_file.getAbsolutePath(), configText );
    isConfigModified = false;
    setWriteReminder();
    }
}



void fileSelected( File aFile ) {
  isFileSelected = true;
  g_file = aFile;
}

/*************************************************************************************************/
/****************  Buttons                                                                 *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void btnSelectFile(int theValue) {
  if ( isFileEditMode ) return;

  Config aConfig = readAConfig(null);

  if ( aConfig != null ) {
    g_CompConfig = null;
    updateConfig( aConfig );
    updateFavorites( null );
  }
}


/*************************************************************************************************/
public void btnCleanFile(int theValue) {
  if ( isFileEditMode ) return;

  btnCleanCompFile( theValue );

  if ( g_config != null ) {
    updateConfig( null );
    updateFavorites( null );
  }
}


/*************************************************************************************************/
public void btnSelectCompFile(int theValue) {
  if ( isFileEditMode ) return;

  Config aConfig = readAConfig(null);

  if ( aConfig != null ) {
    updateCompConfig( aConfig );
    updateFavorites( null );
  }
}


/*************************************************************************************************/
public void btnAddToFavorites(int theValue) {
  if ( isFileEditMode ) return;

  String filename = txfFilename.getText().trim();
  
  if ( filename.length() > 0 ) {
    updateFavorites( new FavoriteFile( new File( filename ), "" ));
  }
}


/*************************************************************************************************/
public void btnCompAddToFavorites(int theValue) {
  if ( isFileEditMode ) return;

  String filename = txfCompareFile.getText().trim();
  
  if ( filename.length() > 0 ) {
    updateFavorites( new FavoriteFile( new File( filename ), "" ));
  }
}

/*************************************************************************************************/
public void btnCleanCompFile(int theValue) {
  if ( isFileEditMode ) return;

  if ( g_CompConfig != null ) {
    updateCompConfig( null );
    updateFavorites( null );
  }

}

/*************************************************************************************************/
public void btnFavoritesSave(int theValue) {
  if ( isFileEditMode ) return;
  g_Favorites.saveFavorites();
}

/*************************************************************************************************/
public void btnFileRemove(int theValue) {
  if ( isFileEditMode ) return;

  int actId = lstFilePath.getId();
  if ( ( actId >= 0 ) && ( actId < g_Favorites.size() ) ) {
    g_Favorites.delFavorite( actId );
    if ( actId == g_Favorites.size() )
      actId--;
    updateFavorites( actId );      
  }
}



/*************************************************************************************************/
/****************  Cascading update for UI  (Lists)                                        *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void updateFavorites(int newId) {
  updateFavorites( null, newId );
}
  
public void updateFavorites(FavoriteFile aNewFF) {
  updateFavorites( aNewFF, -1 );
}
  
public void updateFavorites(FavoriteFile aNewFF, int newId) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  // set buttons and fields based on current selections
  btnAddToFavorites.setVisible( ( g_config != null ) ); 
  btnCleanFile.setVisible( ( g_config != null ) );

  btnSelectCompFile.setVisible( ( g_config != null ) );

  btnCompAddToFavorites.setVisible( ( g_CompConfig != null ) ); 
  btnCleanCompFile.setVisible( ( g_CompConfig != null ) ); 

  if ( g_config == null ) {
    txfFilename.setText( "" );
  } else {
    txfFilename.setText( g_config.getName() );
  }   
  if ( g_CompConfig == null ) {
    txfCompareFile.setText( "" );
  } else {
    txfCompareFile.setText( g_CompConfig.getName() );
  }   

  if ( aNewFF != null ) {
    g_Favorites.addFavorite( aNewFF );
  }
  updateFavList( lstFilePath, 0 );
  updateFavList( lstFileName, 1 );
  updateFavList( lstFileComm, 2 );
  
  if ( aNewFF != null ) {
    updateFavEntry( g_Favorites.size() - 1);
  } else {
    updateFavEntry( newId );
  }
}


/*************************************************************************************************/
public void updateFavEntry(int newId) {

  if ( ! isUpdateEnabled ) {
    return;
  }
  
  if ( newId >= 0 ) {
    if ( isCommModified() ) {
      // disable event handling
      isUpdateEnabled = false;
      lstFilePath.setValue( lstFilePath.getId() );
      isUpdateEnabled = true;
      return;
    } else if ( isFileEditMode ) {
      finalizeCommEdit( false );
    }

    lstFilePath.setId( newId );
    lstFilePath.setActiveValue(newId);

    if ( isCurrentlyDoubleClick ) {
      isCurrentlyDoubleClick = false;
      // on DOuble Click fill in to either next empty slot or last selected
      Config aConfig = readAConfig(g_Favorites.getPath(newId));

      if ( aConfig != null ) {
        if ( g_config == null ) {
          g_CompConfig = null;
          updateConfig( aConfig );
          updateFavorites( null );
        } else {
          g_CompConfig = null;
          updateCompConfig( aConfig );
          updateFavorites( null );
        }
      }
    }

  }

  int actId = lstFilePath.getId();
  if ( ( actId >= 0 ) && ( actId < lstFilePath.itemCount() ) ) {
    if ( lastTab == tabDefault )
      setEditorFieldsFromFavorite( actId );
  }

}


/*************************************************************************************************/
void setEditorFieldsFromFavorite( int actId ) {
  if ( actId >= 0 ) {
    txfName.setValue( g_Favorites.getPath(actId) );
    txfComment.setValue( g_Favorites.getComment(actId) );
  } else {
    txfName.setText( "" );
    txfComment.setText( "" );
  }
}


/*************************************************************************************************/
public void updateFavList(SelectListBox lstSel, int which) {
  lstSel.beginItems();
  lstSel.setValue( 0 ).clear();
  for (int j = 0 ; j < g_Favorites.size(); j++) {
    if ( which == 0 ) {
      lstSel.addItem( g_Favorites.getPath(j), j );
    } else if ( which == 1 ) {
      lstSel.addItem( g_Favorites.getName(j), j );
    } else {
      lstSel.addItem( g_Favorites.getComment(j), j );
    }
  }

  lstSel.endItems();
}


/*************************************************************************************************/
/****************  Handle Comment Edit                                                     *******/
/*************************************************************************************************/

/*************************************************************************************************/
public boolean isCommModified() {
  if ( ! isFileEditMode ) {
    return false;
  }
  
  int actId = lstFilePath.getId();
  String comm =  trim(txfComment.getText());

  return ( ! ( comm.equals( g_Favorites.getComment(actId) ) ) );
}


/*************************************************************************************************/
public void finalizeCommEdit(boolean doSave) {
  boolean isEnded = true;

  if ( ( ! doSave ) && ( isCommModified() ) ) {
    int choice = JOptionPane.showConfirmDialog(null,
        "Discard changes to the current Favorites ?", "Unsaved Comment", 
        JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
    if ( ( choice == JOptionPane.CANCEL_OPTION ) || ( choice == JOptionPane.NO_OPTION ) ) { 
      return;
    } else if ( choice == JOptionPane.YES_OPTION ) {
      isEnded = true;
    }
  } else {
    if ( ( doSave ) && ( isCommModified() ) ) {
      int actId = lstFilePath.getId();
      String comm =  trim(txfComment.getText());
      g_Favorites.setComment( actId, comm );

      isEnded = true;
    }
  }

  // reset UI if really finalized
  if ( isEnded ) {
    txfComment.lock();

    txfComment.setColor( ControlP5.CP5BLUE );
  
    btnFileCancel.setColor( ControlP5.CP5BLUE );
    btnFileSave.setColor( ControlP5.CP5BLUE );

    isFileEditMode = false;
    btnFileSave.setCaptionLabel( "   Edit" );
    btnFileCancel.setVisible( false );

    btnFileRemove.setVisible( true );
  }
}

/*************************************************************************************************/
public void startFileEdit() {
  // modify UI for starting edit

  txfComment.unlock();
  txfComment.setColor( ControlP5.RED );
  
  btnFileCancel.setColor( ControlP5.RED );
  btnFileSave.setColor( ControlP5.RED );

  btnFileRemove.setVisible( false );

  isFileEditMode = true;
  btnFileSave.setCaptionLabel( "   Save" );
  btnFileCancel.setVisible( true );
}


/*************************************************************************************************/
public void btnFileSave(int theValue) {
  if ( isFileEditMode ) {
    finalizeCommEdit( true );
    if ( ! isEditMode ) {
      // Refresh fields from Favorite
      // full screen needs refresh probably
      int actId = lstFilePath.getId();
      updateFavorites( actId );
    }
  } else {
    startFileEdit();
  }
}


/*************************************************************************************************/
public void btnFileCancel(int theValue) {
  finalizeCommEdit( false );
  if ( ! isFileEditMode ) {
    // Refresh fields from Entry
    // full screen needs refresh probably
    updateFavEntry( -1 );
  }
}





