/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  MainProgram                                                             *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

File g_file;
boolean isFileSelected;

static final String[] dummylist = { "---" };

/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  Config                                                                  *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

public static final boolean CONFIG_AUTOSAVE_FAVORITES = true;
public static final boolean CONFIG_START_WITH_FILESELECTION= false;


/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  debug                                                                   *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

static final int NO_DEBUG = 0;
static final int DEBUG_PARSER = 1;
static final int DEBUG_PARSER_DETAIL = 2 + 1;
static final int DEBUG_PARSER_RESULT = 4;
static final int DEBUG_FIXED_FILE = 8;
static final int DEBUG_EVENT = 16;

//static final int debug = DEBUG_FIXED_FILE;
static final int debug = 0 ;
//static final int debug = DEBUG_PARSER_RESULT;
// static final int debug = DEBUG_PARSER_DETAIL ;


boolean isDebug( int level ) {
  return ( ( level & debug ) > 0 );
}


   
/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  SETUP AND DRAW main routines                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


void setup(){

  Config aConfig = null;
 
  if ( CONFIG_START_WITH_FILESELECTION )
    aConfig = readAConfig(null);

  g_config = null;

  initializeGUI();
  g_Favorites.loadFavorites();
  updateConfig( aConfig );
  updateFavorites( null );
  println("Ende Setup");

} // end void setup



void draw() {
  background(128);
}


void mousePressed() {
  isCurrentlyDoubleClick = (mouseEvent.getClickCount()%2 == 0);
/*
  if (mouseEvent.getClickCount()%2 == 0) {
      println("DOuble click");
  }
*/
}




