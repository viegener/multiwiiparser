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
/****************  Conf* classes and other data classes                                    *******/
/*****************                                                                 ***************/
/*************************************************************************************************/

/*************************************************************************************************/
/**************** GLOBALS                                                                  *******/
/*************************************************************************************************/

  /************** areEntriesEqual ************************/
  boolean areEntriesEqual( ConfEntry aLeft, ConfEntry aRight ) {
    boolean equal = false;
    
    if ( ( aLeft == null ) || ( aRight == null ) ) {
      return( aLeft == aRight );
    }

    if ( aLeft.getName().equals( aRight.getName() ) ) {
      if ( aLeft.isActive() == aRight.isActive() ) {
        if ( aLeft.getValue().equals( aRight.getValue() )  ) {
          equal = true;
        }
      }
    }

    return equal;
  }
  
/*************************************************************************************************/
/**************** ConfObject                                                               *******/
/*************************************************************************************************/
class ConfObject {
  protected String mName;
  protected ArrayList mList;
  protected String mComments = "";
  protected Config mRootConfig;
  protected ConfObject mParentConfObject = null;

  protected int mBlockStart = -1;
  protected int mBlockEnd = -1;

  protected boolean mIsModified = false;

  protected boolean mHaveSameName = false;
  protected boolean mIsMixed = false;
  protected boolean mHaveNoValue = true;

  /************** ConfObject ************************/
  ConfObject( Config aConfig, String aName ) {
    mRootConfig = aConfig;
    mName = aName;
    mList = new ArrayList();
  }

  /************** add ************************/
  void add( ConfObject aCE ) {
    // check on addition if a value is in
    if ( mHaveNoValue ) {
      mHaveNoValue = ! aCE.hasValue();
    }
    
    // when adding a second entry clarify if all entries are equal or all the same or error
    if ( mList.size() == 1 ) {
        mHaveSameName = ( ((ConfObject) mList.get(0)).getName().equals( aCE.getName() ) );
    } else if ( mHaveSameName ) {
        if ( ! ((ConfObject) mList.get(0)).getName().equals( aCE.getName() ) ) {
          mHaveSameName = false;
          mIsMixed = true;
        }
    } else  {
      for (int i = 0 ; i < mList.size(); i++) {
        if ( ((ConfObject) mList.get(i)).getName().equals( aCE.getName() ) ) {   
          mIsMixed = true;
        }
      }
    }   

    mList.add( aCE );
    aCE.mParentConfObject = this;
  }

  /************** remove ************************/
  ConfObject remove( int i ) {

    // check valid i
    if ( ( i < 0 ) || ( i >= mList.size() ) ) {
      return null;
    } 

    println( "remove Object " + i );
    return (ConfObject) mList.remove(i);
  }

  /************** setBlock ************************/
  void setBlock(int aStart, int aEnd) {
    mBlockStart = aStart;
    mBlockEnd = aEnd;
  }
  
  /************** getParent ************************/
  ConfObject getParent() {
    return mParentConfObject;
  }

  /************** getRoot ************************/
  Config getRoot() {
    return mRootConfig;
  }

  /************** size ************************/
  int size() {
    return mList.size();
  }
  
  /************** get ************************/
  ConfObject get( int i ) {
    return (ConfObject) mList.get(i);
  }
  
    /************** getName ************************/
  String getName() {
    return mName;
  }

    /************** getName ************************/
  void setName(String aName) {
    mName = aName;
  }

  /************** getDisplayName ************************/
  String getDisplayName() {
    return mName;
  }

  boolean isMixed() {
    return mIsMixed;
  }

  boolean isModified() {
    return mIsModified;
  }

  void setModified(boolean aIsModified) {
    mIsModified = aIsModified;
  }

  boolean haveSameName() {
    return mHaveSameName;
  }

  boolean haveNoValue() {
    return mHaveNoValue;
  }

  void setHaveNoValue(boolean haveNoValue) {
    mHaveNoValue = haveNoValue;
  }


  /************** hasValue ************************/
  boolean hasValue() {
    return false;
  }

  /************** addComment ************************/
  void addComment( String aComment ) {
    if ( mComments.length() > 0 ) {
      mComments += char(10);
    }
    mComments += aComment;
  }

  /************** addComment ************************/
  String getComments() {
    return mComments;
  }

  /************** hasComments ************************/
  boolean hasComments() {
    return (mComments.length() > 0);
  }

  /************** getDisplayNames ************************/
  String[] getDisplayNames() {
    String[] names;
    
    names = new String[ mList.size() ];
    for (int i = 0 ; i < mList.size(); i++) {
      names[i] = ((ConfObject) mList.get(i)).getDisplayName();
    }
    return names;
  }

  /************** appendOriginalText ************************/
  void  appendOriginalText(ArrayList al) {
    if ( mBlockStart != -1 ) {
      int j = mBlockStart;
      if ( mIsModified ) {
        while ( j <= (mBlockEnd-1) ) {
          al.add( mRootConfig.mRawLines[j] );
          j++;
        }
        ConfEntry ce = (ConfEntry) this;
        al.add( ce.getEntryLine(false) );
      } else {
        while ( j <= mBlockEnd ) {
          al.add( mRootConfig.mRawLines[j] );
          j++;
        }
      }
    }
    
    for (int i = 0 ; i < mList.size(); i++) {
      ConfObject co = (ConfObject) mList.get(i);
      co.appendOriginalText( al );
    }
  }
}


/*************************************************************************************************/
/**************** ConfEntry                                                                *******/
/*************************************************************************************************/
class ConfEntry extends ConfObject {
  protected String mValue;
  protected String mRawText;

  protected boolean mHasValue;
  protected boolean mIsActive;
  protected boolean mIsInEEPROM;
  protected int mIdxComment;

  
  /************** ConfEntry ************************/
  ConfEntry( Config aConfig, String aLine ) {
    super( aConfig, "" );

    int addIdx = 0;

    mRawText = aLine;

    // set COnfEntry from line
    String baseline = mRawText.trim();
    
    mIsActive = ! startsWith( baseline, "//" );    
    if (  ! mIsActive ) {
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
    mName = baseline.substring(0, idx);

    // remove name
    addIdx += baseline.length();
    baseline = baseline.substring( idx ).trim();
    addIdx -= baseline.length();

    if ( isDebug( DEBUG_PARSER_DETAIL ) ) 
      println("3 :" + baseline + ":" );
    
    stripCommentsToValue(baseline, addIdx);
    mHasValue = mValue.length() > 0 ;
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
      mIdxComment = 0;            
    } else {
       mIdxComment = limit + addIdx;
    }   
    
    mValue = aLine.substring(0, limit ).trim();
    
    mIsInEEPROM = (aLine.substring( limit ).indexOf("(*)") != -1);

  }
  
  /************** Active ************************/
  boolean isActive() {
    return mIsActive;
  }

  void setActive(boolean active) {
    mIsActive = active;
  }


  void setActiveWithValidation(boolean newActive) {
    if ( ( newActive ) && ( getParent() != null ) ) {
      ConfGroup cg = (ConfGroup) getParent();
      if ( cg.haveSameName() ) {
        for (int i = 0 ; i < cg.size(); i++) {
          ((ConfEntry) cg.get(i)).setActive( false );
        }
      }
    }
    setActive( newActive );
  }



  /************** printIt ************************/
  void printIt() {
    print(">> Entry");
    if ( mIsActive ) 
      print(" A ");
    else
      print(" - ");

    print(":" + mName + ":");
   
    if ( mHasValue ) 
      print(" = :" + mValue + ":" );
    println();
  }

  /************** getDisplayName ************************/
  String getDisplayName() {
    String text = "";
    if ( mIsActive )
      text = "* ";
      
    text += mName; 

    if ( mHasValue ) 
      text += " = `" + mValue + "´" ;
    return text;
  }

  /************** getSortName ************************/
  String getSortName() {
    String text = mName;
      
    if ( mHasValue ) 
      text += mValue;
    return text;
  }

  /************** Value ************************/
  boolean hasValue() {
    return (mValue.length() > 0);
  }

  String getValue() {
    return mValue;
  }
  
  void setValue(String aValue) {
    mValue  = aValue;
  }
  
  boolean setValueWithValidation(String aValue) {
    if ( getParent() != null ) {
      if ( ( getParent().haveNoValue() ) && ( aValue.length() > 0 ) ) {
        JOptionPane.showMessageDialog(null,
            "No values allowed in this group (HaveNoValue)", "Entry validation failed", 
            JOptionPane.ERROR_MESSAGE);
        return false;
      }
    }
    setValue( aValue );
    return true;
  }



  /************** getStatusText ************************/
  String getStatusText() {
    String text = " ";
    
    if ( mIsActive ) 
      text += "Act  ";
    else
      text += "         ";
      
    if ( mIsInEEPROM ) 
      text += "EE  ";
    else
      text += "       ";
      
    if ( mHasValue ) 
      text += "Val  ";
    else
      text += "         ";
      
    if ( mIdxComment > 0 ) 
      text += "//  ";
    else
      text += "    ";
      
    return text;
  }


  /************** getLineComment ************************/
  String getLineComment() {
    if ( mIdxComment > 0 ) { 
      return mRawText.substring( mIdxComment );
    }
    return "";
  }


  /************** getLineComment ************************/
  void setLineComment(String strComment) {
    if ( mIdxComment > 0 ) {
      mRawText = mRawText.substring(0,mIdxComment);
      mIdxComment = 0;
    }

    if ( strComment.length() > 0 ) {
      mIdxComment = mRawText.length();
      mRawText += strComment;
    } 
  }


  /************** appendOutput ************************/
  String getEntryLine(boolean doMinimal) {
    String text = "  ";
    if ( ! doMinimal ) {
      text += "  ";
    }  
    if ( !mIsActive ) {
      text += "//";
    }
    text += "#define "+mName + " ";
    if ( mHasValue ) { 
      text += mValue;
    }
    if ( ! doMinimal ) {
      text += " " + getLineComment();
    }  
    return text;
  }


  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    if ( ( ! doMinimal ) || ( mIsActive ) ) {
      al.add( getEntryLine(doMinimal) );
      if ( ! doMinimal ) {
        if ( hasComments() ) {
          al.add( "    " + mComments );
        }
      }

    }
  }
}  
  
/*************************************************************************************************/
/**************** ConfGroup                                                                *******/
/*************************************************************************************************/
class ConfGroup  extends ConfObject {
  protected String mSubsectionName;
    
  /************** Constructor ************************/
  ConfGroup( Config aConfig, String aSubsName, String aName) {
    super( aConfig, aName );
    mSubsectionName = aSubsName;
  }

  /************** get ************************/
  ConfEntry get( int i ) {
    return (ConfEntry) mList.get( i );
  }


  /************** createEntry --> Attention will not be added ************************/
  ConfEntry createEntry() {
    // create in haveNoValue --> Means: Can not be active if another active entry is existing / no value
    boolean blnWithActive = true;
  
    if ( haveNoValue() ) {
      ConfEntry activeCE = getFirstActive();
      if ( activeCE != null )
        blnWithActive = false;
    }
  
    String dummyLine = "    ";
    if ( ! blnWithActive ) {
      dummyLine += "//";
    }
    dummyLine += SL_SETTING;
    if ( ( haveSameName() ) && ( size() > 0 ) ) {
      dummyLine += get(0).getName();
    } else {
      dummyLine += DUMMY_NAME;
    }
    
    return new ConfEntry(getRoot(), dummyLine);
  }



  /************** getFirstActive ************************/
  ConfEntry getFirstActive() {
    for (int i = 0 ; i < mList.size(); i++) {
      if ( ((ConfEntry) mList.get(i)).isActive() ) {
         return ((ConfEntry) mList.get(i));
      }
    }
    return null;
  }


  /************** printIt ************************/
  void printIt() {
    println(">> Group :" + mSubsectionName + "/" + mName + ": (" + mList.size() + ")" );
    for (int i = 0 ; i < mList.size(); i++) {
      print( "  " );
      ((ConfEntry) mList.get(i)).printIt();
    }
  }


  /************** getName ************************/
  String getDisplayName() {
      String longName = mName;
      if ( mSubsectionName.length() > 0 ) {
        longName += "(" + mSubsectionName + ")";
      }
      return longName;
  }

  /************** getName ************************/
  String getSubsectionName() {
      return mSubsectionName;
  }

  /************** getDisplayNames ************************/
  String[] getStatusTexts() {
    String[] texts;
    
    texts = new String[ mList.size() ];
    for (int i = 0 ; i < mList.size(); i++) {
      texts[i] = ((ConfEntry) mList.get(i)).getStatusText();
    }
    return texts;
  }

  /************** getLineComments ************************/
  String[] getLineComments() {

    String[] texts;
    
    texts = new String[ mList.size() ];
    for (int i = 0 ; i < mList.size(); i++) {
      texts[i] = ((ConfEntry) mList.get(i)).getLineComment();
    }
    return texts;
  }

  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    for (int i = 0 ; i < mList.size(); i++) {
      ((ConfEntry) mList.get(i)).appendOutput( al, doMinimal );
    }
  }
}  


/*************************************************************************************************/
/**************** ConfSection                                                              *******/
/*************************************************************************************************/
class ConfSection  extends ConfObject {
  /************** Constructor ************************/
  ConfSection( Config aConfig, String aName) {
    super( aConfig, aName);
  }
  
  /************** get ************************/
  ConfGroup get( int i ) {
    return (ConfGroup) mList.get( i );
  }

  /************** printIt ************************/
  void printIt() {
    println();
    println("*** SECTION :" + mName + ": (" + mList.size() + ")");
    println();

    for (int i = 0 ; i < mList.size(); i++) {
      ((ConfGroup) mList.get(i)).printIt();
    }
    println();

  }

  /************** appendOutput ************************/
  void  appendOutput(ArrayList al, boolean doMinimal) {
    String lastSub = "";
    
    for (int i = 0 ; i < mList.size(); i++) {
      ConfGroup cg = (ConfGroup) mList.get(i);

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
          al.add( "    " + mComments );
        }
      }
      cg.appendOutput( al, doMinimal );
    }
  }

}  


/*************************************************************************************************/
/**************** Config                                                                   *******/
/*************************************************************************************************/
class Config extends ConfObject {
  protected ArrayList mSortedNames;
  protected String[] mRawLines;

  /************** Constructor ************************/
  Config(String aFilename) {
    super( null, aFilename );
    mSortedNames = new ArrayList();
  }
  
  /************** SortedNames ************************/
  ConfObject getSortedNamesByIndex( int anIndex ) {
    return (ConfObject) mSortedNames.get( anIndex );
  }
  
  /************** mRawLines ************************/
  void setRawLines( String[] lines ) {
    mRawLines = lines;
  }

  String getRawLine( int i ) {
    return mRawLines[i];
  }
  
  int getRawLineLength() {
    return mRawLines.length;
  }
  
  /************** SortedNames ************************/
  int getSortedNamesSize( ) {
    return  mSortedNames.size();
  }
  
  /************** get ************************/
  ConfSection get( int i ) {
    return (ConfSection) mList.get( i );
  }

  /************** printIt ************************/
  void printIt() {
    println();
    println("===== CONFIG (" + mList.size() + ") :" + mName + ": =====");
    for (int i = 0 ; i < mList.size(); i++) {
      ((ConfSection) mList.get(i)).printIt();
    }
    println("=========================================================");
    println();

  }

  /************** rebuild ************************/
  void rebuild() {
    mSortedNames.clear();
    
    for (int i = 0 ; i < mList.size(); i++) {
      // Section
      ConfObject cs = get(i);
      for (int j = 0 ; j < cs.mList.size(); j++) {
        // ConfGroup
        ConfObject cg = cs.get(j);
        if ( cg.mHaveSameName ) {
          // Add only one entry for mHaveSameName groups --> not anymore!!
          for (int k = 0 ; k < cg.mList.size(); k++) {
            addSorted( (ConfEntry) cg.get(k), true );
          }
        } else {
          for (int k = 0 ; k < cg.mList.size(); k++) {
            addSorted( (ConfEntry) cg.get(k), cg.mIsMixed );
          }
        }
      }
    }
    
  }

  /************** addSorted ************************/
  void addSorted(ConfEntry ce, boolean acceptDuplicate) {
    String aName = ce.getName();
    String aSortName = ce.getSortName();
    int i = 0;

    while ( ( i < mSortedNames.size() ) && ( aName.compareTo( ((ConfEntry) mSortedNames.get(i)).getName() ) > 0 ) ) {
      i++;
    }
    if ( i >= mSortedNames.size() ) {
      // append at the end if nothing smaller found
      mSortedNames.add( ce );
    } else if ( aName.equals( ((ConfEntry) mSortedNames.get(i)).getName() ) ) {

      // name equal --> so check for duplicates first
      if ( ! acceptDuplicate ) {
        println("!!Error!! Duplicate entry name :" +  aName );
        exit();
      }

      // scroll through all with same name and check for duplicates find correct position
      int pos = -1;
      int start = i;
      while ( ( i < mSortedNames.size() ) && ( aName.compareTo( ((ConfEntry) mSortedNames.get(i)).getName() ) == 0 ) ) {
        if ( aSortName.compareTo( ((ConfEntry) mSortedNames.get(i)).getSortName() ) < 0 ) {
          pos = i;
        }
        i++;
      }

      if ( pos != -1 ) {
        mSortedNames.add( pos, ce );
      } if ( i < mSortedNames.size() ) {
        mSortedNames.set( i, ce );
      } else {
        mSortedNames.add( ce );
      }

    } else {
      // insert at the index of the first entry larger 
      mSortedNames.add( i, ce );
    }
  }  


  /************** addSorted ************************/
  ConfEntry getEntryByName(String aName) {
    ConfEntry ce;
    
    int i = 0;
    int compRes;
    while ( i < mSortedNames.size() ) {
      compRes = aName.compareTo( ((ConfEntry) mSortedNames.get(i)).getName() );
      if ( compRes  == 0 ) {
        return ((ConfEntry) mSortedNames.get(i));
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
    
    for (int i = 0 ; i < mList.size(); i++) {
      ConfSection cs = (ConfSection) mList.get(i);

//      if ( doMinimal ) {
//        al.add("/************** Section : " + String.valueOf( i ) + " - " + cs.getName() + "  ****/" );
//      } else {
        al.add( "" );
        al.add( "" );
        al.add( COMMENT_STARLINE );
        al.add( COMMENT_STAR2LINE );
        
        String text = "  " + cs.getName() + " ";
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
        al.add( "" );
//     }
      cs.appendOutput( al, doMinimal );
    }
    return al;
  }
    
  /************** getOriginalText ************************/
  ArrayList  getOriginalText() {
    ArrayList al = new ArrayList();
    
    for (int i = 0 ; i < mList.size(); i++) {
      ((ConfSection) mList.get(i)).appendOriginalText( al );
    }
 
    if ( mBlockStart != -1 ) {
      int j = mBlockStart;
      while ( j <= mBlockEnd ) {
        al.add( mRawLines[j] );
        j++;
      }
    }
 
    return al;
  }
}




/*************************************************************************************************/
/**************** DeltaEntry                                                               *******/
/*************************************************************************************************/
class DeltaEntry {
  protected String mName;
  protected ConfEntry mLCE, mRCE;
  protected boolean mBoth = false;
  protected boolean mEquals = false;
  
    /************** ConfObject ************************/
  DeltaEntry( ConfEntry aLeft, ConfEntry aRight ) {
    mLCE = aLeft;
    mRCE = aRight;

    if (( mLCE != null ) && ( mRCE != null) ) {
      mBoth = true;
    }
    
    // Compare equal
    if ( mBoth ) {
      mEquals = areEntriesEqual( mLCE, mRCE );
    }

    // get Name
    if ( mLCE != null ) {
      mName = mLCE.getName(); 
    } else if ( mRCE != null ) {
      mName = mRCE.getName(); 
    } else {
      mName = "---"; 
    }
    
  }
  


  /************** getName ************************/
  String getName() {
    return mName;
  }

  /************** hasBoth ************************/
  boolean isEqual() {
    return ( mEquals );
  }

  /************** hasBoth ************************/
  boolean hasBoth() {
    return ( mBoth );
  }

  /************** hasLeft ************************/
  boolean hasLeft() {
    return ( mLCE != null );
  }

  /************** getLeft ************************/
  ConfEntry getLeft() {
    return mLCE;
  }

  /************** getDNameLeft ************************/
  String getDNameLeft() {
    return mLCE.getDisplayName();
  }

  /************** hasLeft ************************/
  boolean hasRight() {
    return ( mRCE != null );
  }

  /************** getDNameRight ************************/
  String getDNameRight() {
    return mRCE.getDisplayName();
  }

  /************** getRight ************************/
  ConfEntry getRight() {
    return mRCE;
  }

  /************** getDNameRight ************************/
  String getDifference() {

    if ( hasBoth() ) {
      if ( isEqual() ) {
        return " = ";
      } else {
        String diff = "";
        if ( mLCE.isActive() == mRCE.isActive() ) {  
           diff += "    ";
        } else if ( mLCE.isActive() ) {
           diff += "-A ";
        } else if ( mRCE.isActive() ) {
           diff += "+A ";
        }
        if ( ( ! mLCE.hasValue() ) && ( ! mRCE.hasValue() ) ) {
          diff += "    ";
        } else if ( mLCE.getValue().equals( mRCE.getValue() )  ) {
          diff += "     ";
        } else if ( ! mLCE.hasValue() ) {
          diff += "+V ";
        } else if ( ! mRCE.hasValue() ) {
          diff += "-V ";
        } else {
          diff += "!V ";
        }
        return diff;
      }
    } else if ( hasRight() ) {
       return " ++ ";
    } else {
       return " -- ";
    }

  }

}



