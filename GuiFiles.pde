/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  GUIFILES                                                               *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

/*********************************************************************************/
ArrayList<FavoriteFile> g_Favorites = new ArrayList<FavoriteFile>();

public static final String FAVORITE_FILE_NAME = "favorites.txt";

/*************************************************************************************************/


/*************************************************************************************************/
/****************  Favorites class                                                                 *******/
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
/****************  File selection                                            *******/
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
  }
}



void fileSelected( File aFile ) {
  isFileSelected = true;
  g_file = aFile;
}

/*************************************************************************************************/
/****************  File handling for favorite list                                         *******/
/*************************************************************************************************/
public void loadFavorites()
{
  String[] strings = loadStrings( FAVORITE_FILE_NAME );

  if ( strings == null ) return;
  if ( ( strings.length % 2 ) == 1 ) return;

  g_Favorites.clear();
  for (int i=0; i <  strings.length; i+=2 ) {
    g_Favorites.add( new FavoriteFile( new File( strings[i] ), strings[i+1] ) );    
  }
}

public void saveFavorites()
{
  String[] strings = new String[g_Favorites.size() * 2];
 
  for (int i=0; i <  g_Favorites.size(); i++) {
    strings[(i*2)] = g_Favorites.get(i).getPath();
    strings[(i*2)+1] = g_Favorites.get(i).getComment();
  }

  saveStrings( FAVORITE_FILE_NAME, strings );
}




/*************************************************************************************************/
/****************  Buttons                                                                 *******/
/*************************************************************************************************/

/*************************************************************************************************/
public void btnSelectFile(int theValue) {
  Config aConfig = readAConfig(null);

  if ( aConfig != null ) {
    g_CompConfig = null;
    updateConfig( aConfig );
    updateFavorites( null );
  }
}


/*************************************************************************************************/
public void btnCleanFile(int theValue) {
  btnCleanCompFile( theValue );

  if ( g_config != null ) {
    updateConfig( null );
    updateFavorites( null );
  }

}



/*************************************************************************************************/
public void btnSelectCompFile(int theValue) {
  Config aConfig = readAConfig(null);

  if ( aConfig != null ) {
    updateCompConfig( aConfig );
    updateFavorites( null );
  }
}


/*************************************************************************************************/
public void btnAddToFavorites(int theValue) {
  String filename = txfFilename.getText().trim();
  
  if ( filename.length() > 0 ) {
    updateFavorites( new FavoriteFile( new File( filename ), "" ));
  }
}


/*************************************************************************************************/
public void btnCompAddToFavorites(int theValue) {
  String filename = txfCompareFile.getText().trim();
  
  if ( filename.length() > 0 ) {
    updateFavorites( new FavoriteFile( new File( filename ), "" ));
  }
}

/*************************************************************************************************/
public void btnCleanCompFile(int theValue) {

  if ( g_CompConfig != null ) {
    updateCompConfig( null );
    updateFavorites( null );
  }

}

/*************************************************************************************************/
public void btnFileSave(int theValue) {

  saveFavorites();
}

/*************************************************************************************************/
public void btnFileRemove(int theValue) {
  int actId = lstFilePath.getId();
  if ( ( actId >= 0 ) && ( actId < g_Favorites.size() ) ) {
    g_Favorites.remove( actId );
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
    g_Favorites.add( aNewFF );  
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
    lstFilePath.setId( newId );
    lstFilePath.setActiveValue(newId);

    if ( isCurrentlyDoubleClick ) {
      isCurrentlyDoubleClick = false;
      // on DOuble Click fill in to either next empty slot or last selected
      Config aConfig = readAConfig(g_Favorites.get(newId).getPath());

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
    setEditorFieldsFromFavorite( g_Favorites.get(actId) );
  }

}


/*************************************************************************************************/
void setEditorFieldsFromFavorite( FavoriteFile aFF ) {
  if ( aFF == null ) {
    txfName.setText( "" );
    txfComment.setText( "" );
  } else {
    txfName.setValue( aFF.getPath() );
    txfComment.setValue( aFF.getComment() );
  }
}





  /*************************************************************************************************/
public void updateFavList(SelectListBox lstSel, int which) {
  lstSel.beginItems();
  lstSel.setValue( 0 ).clear();
  for (int j = 0 ; j < g_Favorites.size(); j++) {
    FavoriteFile ff = g_Favorites.get(j);
    if ( which == 0 ) {
      lstSel.addItem( ff.getPath(), j );
    } else if ( which == 1 ) {
      lstSel.addItem( ff.getName(), j );
    } else {
      lstSel.addItem( ff.getComment(), j );
    }
  }

  lstSel.endItems();
}






