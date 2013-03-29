/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  def conf classes                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


/****************  ConfObject            *******/
class ConfObject {
  String name;
  ArrayList list;
  protected String comments = "";
  boolean haveSameName = false;
  boolean isMixed = false;
  boolean haveNoValue = true;
  Config rootConfig;
  protected ConfObject parent = null;

  int blockStart = -1;
  int blockEnd = -1;

  boolean modified = false;

  ConfObject( Config aConfig, String aName ) {
    rootConfig = aConfig;
    name = aName;
    list = new ArrayList();
  }

  /************** addEntry ************************/
  void add( ConfObject aCE ) {
    // check on addition if a value is in
    if ( haveNoValue ) {
      haveNoValue = ! hasValue();
    }
    
    // when adding a second entry clarify if all entries are equal or all the same or error
    if ( list.size() == 1 ) {
        haveSameName = ( ((ConfObject) list.get(0)).getName().equals( aCE.getName() ) );
    } else if ( haveSameName ) {
        if ( ! ((ConfObject) list.get(0)).getName().equals( aCE.getName() ) ) {
          haveSameName = false;
          isMixed = true;
        }
    } else  {
      for (int i = 0 ; i < list.size(); i++) {
        if ( ((ConfObject) list.get(i)).getName().equals( aCE.getName() ) ) {   
          isMixed = true;
        }
      }
    }   

    list.add( aCE );
    aCE.parent = this;
  }

  /************** addEntry ************************/
  ConfObject remove( int i ) {

    // check valid i
    if ( ( i < 0 ) || ( i >= list.size() ) ) {
      return null;
    } 

    println( "remove Object " + i );
    return (ConfObject) list.remove(i);
  }

  /************** size ************************/
  void setBlock(int aStart, int aEnd) {
    blockStart = aStart;
    blockEnd = aEnd;
  }
  
  /************** size ************************/
  ConfObject getParent() {
    return parent;
  }
  


  /************** size ************************/
  int size() {
    return list.size();
  }
  
  /************** addEntry ************************/
  ConfObject get( int i ) {
    return (ConfObject) list.get(i);
  }
  
    /************** getName ************************/
  String getName() {
    return name;
  }

  /************** getName ************************/
  String getDisplayName() {
    return name;
  }

  /************** hasValue ************************/
  boolean hasValue() {
    return false;
  }

  /************** addComment ************************/
  void addComment( String aComment ) {
    if ( comments.length() > 0 ) {
      comments += char(10);
    }
    comments += aComment;
  }

  /************** hasComments ************************/
  boolean hasComments() {
    return (comments.length() > 0);
  }

  /************** getDisplayNames ************************/
  String[] getDisplayNames() {
    String[] names;
    
    names = new String[ list.size() ];
    for (int i = 0 ; i < list.size(); i++) {
      names[i] = ((ConfObject) list.get(i)).getDisplayName();
    }
    return names;
  }

  /************** appendOriginalText ************************/
  void  appendOriginalText(ArrayList al) {
    if ( blockStart != -1 ) {
      int j = blockStart;
      if ( modified ) {
        while ( j <= (blockEnd-1) ) {
          al.add( rootConfig.lines[j] );
          j++;
        }
        ConfEntry ce = (ConfEntry) this;
        al.add( ce.getEntryLine(false) );
      } else {
        while ( j <= blockEnd ) {
          al.add( rootConfig.lines[j] );
          j++;
        }
      }
    }
    
    for (int i = 0 ; i < list.size(); i++) {
      ConfObject co = (ConfObject) list.get(i);
      co.appendOriginalText( al );
    }
  }
}


/****************  ConfEntry            *******/
class ConfEntry extends ConfObject {
  String value;
  String rawText;
  boolean hasValue;
  boolean active;
  boolean inEEPROM;
  int idxComment;

  
  /************** ConfEntry ************************/
  ConfEntry( Config aConfig, String aLine ) {
    super( aConfig, "" );

    int addIdx = 0;

    rawText = aLine;

    // set COnfEntry from line
    String baseline = rawText.trim();
    
    active = ! startsWith( baseline, "//" );    
    if (  ! active ) {
      addIdx += baseline.length();
      baseline = baseline.substring( 2 ).trim();
      addIdx -= baseline.length();
    }

    if ( isDebug( DEBUG_PARSER_DETAIL ) ) 
      println("1 :" + baseline + ":" );
    
    // remove #define
    addIdx += baseline.length();
    baseline = baseline.substring( SL_SETTING.length() ).trim();
    addIdx -= baseline.length();

    if ( isDebug( DEBUG_PARSER_DETAIL ) ) 
      println("2 :" + baseline + ":" );

    // get name and value (remove trailing comments)
    int idx = 0;

    while ( ( idx < baseline.length() ) && ( isNamePart(baseline.charAt(idx) ) ) ) {
      idx++;
    }

    // set name
    name = baseline.substring(0, idx);

    // remove name
    addIdx += baseline.length();
    baseline = baseline.substring( idx ).trim();
    addIdx -= baseline.length();

    if ( isDebug( DEBUG_PARSER_DETAIL ) ) 
      println("3 :" + baseline + ":" );
    
    stripCommentsToValue(baseline, addIdx);
    hasValue = value.length() > 0 ;
  }

  /************** stripCommentsToValue ************************/
  void stripCommentsToValue(String aLine, int addIdx ) {
    int idx = 0;
    int limit = -1;
    char lastChar = ' ';
    boolean isComment = false;

//    println("aLine :" + aLine + ":" );

    while ( idx < aLine.length()) {
      if ( aLine.charAt(idx) == '\"') {
        // enter string constant so find ending 
        idx++;
        while ( ( idx < aLine.length()) && ( aLine.charAt(idx) != '\"' ) ) {
          if ( aLine.charAt(idx) == '\\' ) {
            idx++;
          }
          idx++;
        }
      } else if ( aLine.charAt(idx) == '\'') {
        // enter string constant so find ending 
        idx++;
        while ( ( idx < aLine.length()) && ( aLine.charAt(idx) != '\'' ) ) {
          if ( aLine.charAt(idx) == '\\' ) {
            idx++;
          }
          idx++;
        }
      } else if ( idx < (aLine.length()-1) ) {
          if ( aLine.charAt(idx) == '/' ) {
            if ( ( aLine.charAt(idx+1) == '/' ) || ( aLine.charAt(idx+1) == '*' ) ) {
              // comment found
              limit = idx;
              idx = aLine.length();
            }
          } else if ( aLine.charAt(idx) == '\\' ) {
            if ( aLine.charAt(idx+1) == '\"' ) {
              // escaped " so go additional +1
              idx++;
            }
          }
          idx++;
      } else {
        idx++;
      }
    }
    
    if ( limit == -1 ) {
      limit = idx;
      idxComment = 0;            
    } else {
       idxComment = limit + addIdx;
    }   
    
    value = aLine.substring(0, limit ).trim();
    
    inEEPROM = (aLine.substring( limit ).indexOf("(*)") != -1);

  }
  
  /************** printIt ************************/
  void printIt() {
    print(">> Entry");
    if ( active ) 
      print(" A ");
    else
      print(" - ");

    print(":" + name + ":");
   
    if ( hasValue ) 
      print(" = :" + value + ":" );
    println();
  }

  /************** getDisplayName ************************/
  String getDisplayName() {
    String text = "";
    if ( active )
      text = "* ";
      
    text += name; 

    if ( hasValue ) 
      text += " = `" + value + "´" ;
    return text;
  }

  /************** hasValue ************************/
  boolean hasValue() {
    return (value.length() > 0);
  }

  /************** getValue ************************/
  String getValue() {
    return value;
  }
  
  /************** getStatusText ************************/
  String getStatusText() {
    String text = " ";
    
    if ( active ) 
      text += "Act  ";
    else
      text += "         ";
      
    if ( inEEPROM ) 
      text += "EE  ";
    else
      text += "       ";
      
    if ( hasValue ) 
      text += "Val  ";
    else
      text += "         ";
      
    if ( idxComment > 0 ) 
      text += "//  ";
    else
      text += "    ";
      
    return text;
  }


  /************** getLineComment ************************/
  String getLineComment() {
    if ( idxComment > 0 ) { 
      return rawText.substring( idxComment );
    }
    return "";
  }


  /************** getLineComment ************************/
  void setLineComment(String strComment) {
    if ( idxComment > 0 ) {
      rawText = rawText.substring(0,idxComment);
      idxComment = 0;
    }

    if ( strComment.length() > 0 ) {
      idxComment = rawText.length();
      rawText += strComment;
    } 
  }


  /************** appendOutput ************************/
  String getEntryLine(boolean doMinimal) {
    String text = "  ";
    if ( ! doMinimal ) {
      text += "  ";
    }  
    if ( !active ) {
      text += "//";
    }
    text += "#define "+name + " ";
    if ( hasValue ) { 
      text += value;
    }
    if ( ! doMinimal ) {
      text += " " + getLineComment();
    }  
    return text;
  }


  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    if ( ( ! doMinimal ) || ( active ) ) {
      al.add( getEntryLine(doMinimal) );
      if ( ! doMinimal ) {
        if ( hasComments() ) {
          al.add( "    " + comments );
        }
      }

    }
  }
}  
  
/***********************************************/
/****************  ConfGroup            *******/
class ConfGroup  extends ConfObject {
  String subsectionName;
    
  /************** Constructor ************************/
  ConfGroup( Config aConfig, String aSubsName, String aName) {
    super( aConfig, aName );
    subsectionName = aSubsName;
  }

  /************** get ************************/
  ConfEntry get( int i ) {
    return (ConfEntry) list.get( i );
  }


  /************** getFirstActive ************************/
  ConfEntry getFirstActive() {
    for (int i = 0 ; i < list.size(); i++) {
      if ( ((ConfEntry) list.get(i)).active ) {
         return ((ConfEntry) list.get(i));
      }
    }
  return null;
  }


  /************** printIt ************************/
  void printIt() {
    println(">> Group :" + subsectionName + "/" + name + ": (" + list.size() + ")" );
    for (int i = 0 ; i < list.size(); i++) {
      print( "  " );
      ((ConfEntry) list.get(i)).printIt();
    }
  }


  /************** getName ************************/
  String getDisplayName() {
      String longName = name;
      if ( subsectionName.length() > 0 ) {
        longName += "(" + subsectionName + ")";
      }
      return longName;
  }

  /************** getName ************************/
  String getSubsectionName() {
      return subsectionName;
  }

  /************** getDisplayNames ************************/
  String[] getStatusTexts() {
    String[] texts;
    
    texts = new String[ list.size() ];
    for (int i = 0 ; i < list.size(); i++) {
      texts[i] = ((ConfEntry) list.get(i)).getStatusText();
    }
    return texts;
  }

  /************** getLineComments ************************/
  String[] getLineComments() {

    String[] texts;
    
    texts = new String[ list.size() ];
    for (int i = 0 ; i < list.size(); i++) {
      texts[i] = ((ConfEntry) list.get(i)).getLineComment();
    }
    return texts;
  }

  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    for (int i = 0 ; i < list.size(); i++) {
      ((ConfEntry) list.get(i)).appendOutput( al, doMinimal );
    }
  }
}  


/***********************************************/
/****************  ConfSection            *******/
class ConfSection  extends ConfObject {
  /************** Constructor ************************/
  ConfSection( Config aConfig, String aName) {
    super( aConfig, aName);
  }
  
  /************** get ************************/
  ConfGroup get( int i ) {
    return (ConfGroup) list.get( i );
  }

  /************** printIt ************************/
  void printIt() {
    println();
    println("*** SECTION :" + name + ": (" + list.size() + ")");
    println();

    for (int i = 0 ; i < list.size(); i++) {
      ((ConfGroup) list.get(i)).printIt();
    }
    println();

  }

  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    String lastSub = "";
    
    for (int i = 0 ; i < list.size(); i++) {
      ConfGroup cg = (ConfGroup) list.get(i);

      if ( ! doMinimal ) {
        String text;
        int len;

        // First subsection
        if ( ( cg.getSubsectionName().length() > 0 ) && ( ! ( lastSub.equals( cg.getSubsectionName() ) ) ) ) {
          al.add( "" );
          al.add( "  " + COMMENT_SUBSTARLINE );
          
          text = " " + cg.getSubsectionName() + " ";
          len = COMMENT_SUBSTARLINE.length() - ( text.length()+COMMENT_SUBSTAR_LEN+1+COMMENT_SUBSTAR_LEN );
          
          text =  COMMENT_SUBSTARLINE.substring( 0, COMMENT_SUBSTAR_LEN+ 1 ) + text;
          if ( len > 0 ) {
            text += createString(len, ' ' ); 
            text += COMMENT_SUBSTARLINE.substring( text.length() );
          } else {
            text += "**/";
          }
          al.add( "  " + text );
          al.add( "  " + COMMENT_SUBSTARLINE );
          lastSub = cg.getSubsectionName();
          al.add( "" );
        }
        
        // second Group           
        text =  COMMENT_SUBSTARLINE.substring( 0, COMMENT_SUBSTAR_LEN+ 1 ) + " " + cg.getName() + " " + COMMENT_SUBSTARLINE.substring( COMMENT_SUBSTARLINE.length() - COMMENT_SUBSTAR_LEN );
        al.add( "" );
        al.add( "    " + text );
        
        if ( hasComments() ) {
          al.add( "    " + comments );
        }
      }
      cg.appendOutput( al, doMinimal );
    }
  }

}  





/****************  Config            *******/
class Config extends ConfObject {
  ArrayList sortedNames;
  String[] lines;

  /************** Constructor ************************/
  Config(String aFilename) {
    super( null, aFilename );
    sortedNames = new ArrayList();
  }
  
  /************** get ************************/
  ConfSection get( int i ) {
    return (ConfSection) list.get( i );
  }

  /************** printIt ************************/
  void printIt() {
    println();
    println("===== CONFIG (" + list.size() + ") :" + name + ": =====");
    for (int i = 0 ; i < list.size(); i++) {
      ((ConfSection) list.get(i)).printIt();
    }
    println("=========================================================");
    println();

  }

  /************** rebuild ************************/
  void rebuild() {
    sortedNames.clear();
    
    for (int i = 0 ; i < list.size(); i++) {
      // Section
      ConfObject cs = get(i);
      for (int j = 0 ; j < cs.list.size(); j++) {
        // ConfGroup
        ConfObject cg = cs.get(j);
        if ( cg.haveSameName ) {
          // Add only one entry for haveSameName groups
          if ( cg.size() > 0 ) {
            addSorted( (ConfEntry) cg.get(0), false );
          }
        } else {
          for (int k = 0 ; k < cg.list.size(); k++) {
            addSorted( (ConfEntry) cg.get(k), cg.isMixed );
          }
        }
      }
    }
    
  }

  /************** addSorted ************************/
  void addSorted(ConfEntry ce, boolean acceptDuplicate) {
    String aName = ce.getName();
    int i = 0;

    while ( ( i < sortedNames.size() ) && ( aName.compareTo( ((ConfEntry) sortedNames.get(i)).getName() ) > 0 ) ) {
      i++;
    }
    if ( ! ( i < sortedNames.size() ) ) {
      // append at the end if nothing smaller found
      sortedNames.add( ce );
    } else if ( aName.equals( ((ConfEntry) sortedNames.get(i)).getName() ) ) {
      if ( ! acceptDuplicate ) {
        println("!!Error!! Duplicate entry name :" +  aName );
        exit();
      }
    } else {
      // insert at the index of the first entry larger 
      sortedNames.add( i, ce );
    }
  }  


  /************** addSorted ************************/
  ConfEntry getEntryByName(String aName) {
    ConfEntry ce;
    
    int i = 0;
    int compRes;
    while ( i < sortedNames.size() ) {
      compRes = aName.compareTo( ((ConfEntry) sortedNames.get(i)).getName() );
      if ( compRes  == 0 ) {
        return ((ConfEntry) sortedNames.get(i));
      } else if ( compRes < 0 ) {
        return null;
      } else {
        i++;
      }
    } 
    return null;
  }

  
  
    /************** getOutputText ************************/
  ArrayList  getOutputText(boolean doMinimal) {
    // Minimal - Only active settings with section
    // Normal - All configs including comments
    ArrayList al = new ArrayList();
    
    for (int i = 0 ; i < list.size(); i++) {
      ConfSection cs = (ConfSection) list.get(i);

      if ( doMinimal ) {
        al.add("/************** Section : " + String.valueOf( i ) + " - " + cs.getName() + "  ****/" );
      } else {
        al.add( "" );
        al.add( "" );
        al.add( COMMENT_STARLINE );
        al.add( COMMENT_STAR2LINE );
        
        String text = " SECTION " + String.valueOf( i ) + " - " + cs.getName() + " ";
        int len = COMMENT_STARLINE.length() - ( text.length()+COMMENT_STAR_LEN+1+COMMENT_STAR_LEN );
        
        text =  COMMENT_STARLINE.substring( 0, COMMENT_STAR_LEN+ 1 ) + text;
        if ( len > 0 ) {
          text += createString(len, ' ' ); 
          text += COMMENT_STARLINE.substring( text.length() );
        } else {
          text += "**/";
        }
        al.add( text );
        
        al.add( COMMENT_STAR2LINE );
        al.add( COMMENT_STARLINE );
     }
      cs.appendOutput( al, doMinimal );
    }
    return al;
  }
    
  /************** getOriginalText ************************/
  ArrayList  getOriginalText() {
    ArrayList al = new ArrayList();
    
    for (int i = 0 ; i < list.size(); i++) {
      ((ConfSection) list.get(i)).appendOriginalText( al );
    }
 
    if ( blockStart != -1 ) {
      int j = blockStart;
      while ( j <= blockEnd ) {
        al.add( lines[j] );
        j++;
      }
    }
 
    return al;
  }
    
}
