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
/*  These use cases are running, for the roadmap please have a look at the Todo-List
=====================================================================================

* USECASE 1 - Select a config file and show it
    -- Select config file
    -- show alphabetically all setting
    -- show the settings grouped
    -- Show one group in a Listbox with the details
    -- Show only active settings
    -- Select output file
    -- write minimal settings to a config.
    -- write a mostly complete config file

* USECASE 2 - Select a config file and edit it 
    Plus USECASE 1
    -- Add EDIT/CANCEL Button for unlock entry
    -- Add create/remove button
    -- Set a configuration active/non-active
    -- Edit a config value
    -- remove a config value
    -- add a config value
    -- Check activation is not creating incompleteness
    -- If entries are changed and cancel / new selection ==> Ask for Save or Cancel
    
* USECASE 3 - Open two different config.h and show the differences
    -- Show the delta
    -- Show only different ones that are active
    
* USECASE 4 - Handle a persistent catalog for config files
    -- Show current filename
    -- Show last filenames used or favories
    -- Assign a comment for a filename

  
-------------------------------------
/*************************************************************************************************/



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

boolean isDebug( ) {
  return ( debug > 0 );
}


   
/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  SETUP AND DRAW main routines                                            *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


void setup(){

  println();
  println(MULTIWII_PARSER_TITLE_REV);
  println(MULTIWII_PARSER_COPYRIGHT);
  
  println();
  println("This program comes with ABSOLUTELY NO WARRANTY;");
  println("This is free software, and you are welcome to redistribute it under certain conditions;");
  println();
    
  Config aConfig = null;
 
  if ( CONFIG_START_WITH_FILESELECTION )
    aConfig = readAConfig(null);

  g_config = null;

  initializeGUI();

  println();
  println(MULTIWII_PARSER_TITLE_REV);
  println(MULTIWII_PARSER_COPYRIGHT);
  println();

  g_Favorites.loadFavorites();
  updateConfig( aConfig );
  updateFavorites( null );

  if ( isDebug() )  println("Ende Setup");
} // end void setup


void draw() {
  // dark background
  background(0xff022020);
} // end void draw


void mousePressed() {
  // this is needed to detect doubleclicks in other event routines inside ControlP5 
  isCurrentlyDoubleClick = (mouseEvent.getClickCount()%2 == 0);
} // end void mousePressed




