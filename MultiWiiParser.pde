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
/****************  debug                                                                   *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

static final int NO_DEBUG = 0;
static final int DEBUG_PARSER = 1;
static final int DEBUG_PARSER_DETAIL = 2 + 1;
static final int DEBUG_PARSER_RESULT = 4;
static final int DEBUG_FIXED_FILE = 8;

//static final int debug = DEBUG_FIXED_FILE;
static final int debug = 0 ;
//static final int debug = DEBUG_PARSER_RESULT;
// static final int debug = DEBUG_PARSER_DETAIL ;


boolean isDebug( int level ) {
  return ( ( level & debug ) > 0 );
}


   
/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  File selection                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


Config readAConfig( ) {
  Config config = null;
  
  if ( isDebug( DEBUG_FIXED_FILE ) ) {
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
/*****************                                                                 ***************/
/****************  SETUP AND DRAW main routines                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


void setup(){

  Config aConfig = readAConfig();

  g_config = null;

  if ( aConfig == null ) {
    exit();
  } else {
    initializeGUI();
    updateConfig( aConfig );
    println("Ende Setup");
  }

} // end void setup



void draw() {
  background(128);
}




