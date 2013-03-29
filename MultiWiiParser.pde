import controlP5.*;


/*********************************************************************************/

static final String E_SECTION = "section";
static final String E_SUBSECTION = "subsection";
static final String E_GROUP = "group";
static final String E_ENTRY = "entry";

/*********************************************************************************/

static final String SL_COMMENT  = "//";
static final String SL_COMM_START = "/*";
static final String SL_COMM_END = "*/";
static final String SL_SETTING ="#define ";

/*********************************************************************************/

Config g_config;
File g_file;

String[] dummylist = { "---" };

boolean isFileSelected;

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

static final int debug = DEBUG_FIXED_FILE;
//static final int debug = DEBUG_PARSER_RESULT;
// static final int debug = DEBUG_PARSER_DETAIL ;





boolean isDebug( int level ) {
  return ( ( level & debug ) > 0 );
}

/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  parser and helper                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

public String createString(int length, char ch) {
    char[] chars = new char[length];
    for (int i = 0 ; i < length; i++) {
      chars[i] = ch;
    }
    return new String(chars);
}

boolean isNamePart(char aChar) {
  return ( ( aChar >= 'A' ) && ( aChar <= 'Z' ) ) ||
         ( ( aChar >= 'a' ) && ( aChar <= 'z' ) ) ||
         ( ( aChar >= '0' ) && ( aChar <= '9' ) ) ||
         ( aChar == '_' ) ;
}


String stripStars( String aLine ) {
  String baseLine = aLine.trim();
  int idx = 0;
  int len = baseLine.length();

  if ( baseLine.charAt(idx) == '/' ) 
    idx++;

  if ( baseLine.charAt(len-1) == '/' ) 
    len--;

  while ( ( idx < len ) && ( baseLine.charAt(idx) == '*' ) ) {
    idx++;
  }  

  while ( ( idx < len ) && ( baseLine.charAt(len-1) == '*' ) ) {
    len--;
  }
  
  return baseLine.substring(idx,len).trim();
}


boolean endsWith(String line, String pattern) {
  if ( line.length() < pattern.length() )
    return false;
  return ( pattern.equals( line.substring(line.length()-pattern.length())) );
}

boolean startsWith(String line, String pattern) {
  if ( line.length() < pattern.length() )
    return false;
  return ( pattern.equals( line.substring(0,pattern.length()) ) );
}

boolean isEndSimpleCommentBlockLine(String line) {
  return ( endsWith( line, "*/" ) ) && ( ! endsWith( line, "**/" ) );
}

boolean isSimpleCommentBlockLine(String line) {
  return ( startsWith( line, "/*" ) ) && ( ! startsWith( line, "/***" ) );
}

boolean isEmptyLine(String line) {
  return ( line.length() == 0 ); 
}

boolean isStarLine(String line) {
  return ( startsWith(line, "/***") ); 
}



boolean isDefinitionLine(String line) {
  return ( startsWith( line, "#define " ) ) || ( ( startsWith( line, "//" ) ) && ( startsWith( line.substring(2).trim(), "#define " )  ) ); 
}

boolean isSingleCommentLine(String line) {
  return ( startsWith( line, "//" ) ) && ( ! startsWith( line.substring(2).trim(), "#define " ) ); 
}

/*******************************/
Config parseConfig(String filename) {

  Config config = new Config(filename);
  
  config.lines = loadStrings("test/config.h");
  if ( isDebug( DEBUG_PARSER ) ) {
    println("there are " + config.lines.length + " lines");
  }
  
  ArrayList currentBlock = new ArrayList();
  
  String baseLine;
  int commNo = 0;
  int starNo = 0;
  int groupNo = 0;
  int lineNo = 0;
  int blockStart = 0;

  boolean sectionBlock = false;

  String sectionName = "";
  String subsectionName = "";
  String groupName = "";
  
  String pendingComments = "";
  
  ConfEntry ce = null;
  ConfGroup cg = null;

  ConfSection cs = null;

  while ( lineNo < config.lines.length ) {
    baseLine = trim(config.lines[lineNo]);
    if ( isDebug( DEBUG_PARSER ) ) {
      println("D " + lineNo + " C=" + commNo + " S=" + starNo + " G=" + groupNo );
    if ( isDebug( DEBUG_PARSER_DETAIL ) ) {
        println( "   :" + baseLine + ":");
      }
    }
    
    if ( commNo > 0 ) {
      // add comment line to pendingComments these will be associated to the next group that will be created
      pendingComments += baseLine + char(10);
      
      if ( ( commNo == 1 ) && ( isSingleCommentLine(baseLine) ) ) {
        // Single comment line (//) ends immedately
        lineNo++;
        commNo = 0;
      } else if ( isEndSimpleCommentBlockLine(baseLine) ) {
        // End comment is really an end
        lineNo++;
        commNo = 0;
      } else {
        lineNo++;
        commNo++;
      }      
    } else if ( starNo > 0 ) {
      if ( isStarLine( baseLine ) ) {
        starNo ++;
        // check for section or subsection or group
        baseLine = stripStars( baseLine ).trim();
        if ( baseLine.length() > 0 ) {
          // found text
          if ( starNo == 4 ) {
            // section 5 lines
            sectionBlock = true;
            // remove pendingComments before new section
            if ( pendingComments.length() > 0 ) {
              println("*************** Comments will be discarded ****************");
              println(pendingComments);
              pendingComments = "";
            }

            cs = new ConfSection( config, baseLine );
            config.add( cs );
            
            subsectionName = "";
            groupName = "";
            
          } else if ( starNo == 2 ) {
            // group 1 lines
            groupName = baseLine;
            cg = null;
          } else  {
            // subsection normally 3 lines
            subsectionName = baseLine;
            groupName = "";
            cg = null;
          }        
        }
        lineNo++;
      } else {
        // Star lines finished 
        starNo = 0;
  
        if ( sectionBlock ) {
          sectionBlock = false;
          cs.setBlock( blockStart, lineNo-1 );
          blockStart = lineNo;
        }
      }      
    } else if ( groupNo > 0 ) {
      if ( isDefinitionLine( baseLine ) ) {
        groupNo ++;
        // parse definition and make definition entry in group
        ce = new ConfEntry( config, baseLine );
        if ( cg == null ) {
          if ( groupName.length() == 0 ) {
            if ( subsectionName.length() > 0 ) {
              // Exchange subsection and group here
              groupName = subsectionName;
              subsectionName = "";
            } else {
              println("!! NO name for ssn/gN in Line :"+ baseLine + ":" );
            }
          }
          cg = new ConfGroup( config, subsectionName, groupName );
          if ( cs == null ) {
            println("!! NO section for ssn/gN :"+  subsectionName + "/" + groupName + ":" );
            exit();
          }
          cs.add( cg );
          // add pending comments to group (if new group created) otherwise to Entry
          if ( pendingComments.length() > 0 ) {
            cg.addComment( pendingComments );
            cg.setBlock( blockStart, lineNo-1 );
            blockStart = lineNo;
            pendingComments = "";
          }
        }
        if ( pendingComments.length() > 0 ) {
          ce.addComment( pendingComments );
          pendingComments = "";
        }

        cg.add( ce );
        ce.setBlock( blockStart, lineNo );
        lineNo++;
        blockStart = lineNo;        
      } else if ( isSimpleCommentBlockLine(baseLine) ) {
        // Pause group for comment processing / continue group afterwards
        commNo=1;
      } else {
        // Finish group      
        groupNo = 0;
      }      
    } else { 
      if ( isSimpleCommentBlockLine(baseLine) ) {
        commNo = 1;
      } else if ( isStarLine(baseLine) ) {
        starNo = 1;
      } else if ( isDefinitionLine(baseLine) ) {
        groupNo = 1;
      } else if ( isEmptyLine(baseLine) ) {
        lineNo++;
      } else if ( isSingleCommentLine(baseLine) ) {
        commNo = 1;
      } else {
        // This is an unexpected type of line --> ignore ??
        print("!! Unexpected line :");
        print(baseLine);
        println(":");
        lineNo++;
      }
    }
/* 
  if ( lineNo > 100) 
    lineNo = 2000;
/* */
  } // end while lineNo
  

  // add remaining lines to config
  if ( blockStart < (lineNo-1) ) {
    config.setBlock( blockStart, lineNo-1 );
  }

  println("Ende parseConfig");

  // build secondary config structures
  config.rebuild();  

  println("Ende Rebuild");

  if ( isDebug( DEBUG_PARSER_RESULT ) ) {
    config.printIt();
  }

  return config;
}

/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  Misc                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


void test()  {

/*

  String parts[] = split("abc def  ghi "," ");
  
  println("there are " + parts.length + " elements");
  for (int i = 0 ; i < parts.length; i++) {
    print(i);
    println("   :" + parts[i] + " :");
  }

*/

  String[] slist = new String[3];
  
  slist[0] = "qabc";
  slist[1] = "sadasdasd";
  slist[2] = "dakdkhaksdhkkc";


  drpSection.clear();
  drpSection.addItems( slist );

//  ConfEntry ce = new ConfEntry( "//#define DEF " );
  ConfEntry ce = new ConfEntry( null, "#define CONTROL_RANGE   { 100, 100 }      //  { ROLL,PITCH }" );
  ce.printIt();

}
   
   
   
/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  File selection                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


Config readAConfig( boolean setGlobal ) {
  Config config;
  
  if ( isDebug( DEBUG_FIXED_FILE ) ) {
    g_file = new File("test\\config.h");
  } else {
    g_file = null;
    isFileSelected = false;
    selectInput( "Select a config.h file", "fileSelected" );
  }
  
  while ( ! isFileSelected ) {
    delay(200);
  }

  config = parseConfig(g_file.getAbsolutePath() );
  
  if ( setGlobal ) {
    g_config = config;
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


//  test();

  readAConfig( true );

  initializeGUI();

  println("Ende Setup");
} // end void setup



void draw() {
//  exit();
  background(128);

}




