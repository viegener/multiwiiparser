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
/****************  TODO (and Done LIST)  --> No real code in h                             *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


static final String MWP_VERSION = "0.4";
static final String MWP_REVISION = "2013/04/18"; 

static final String MULTIWII_PARSER_TITLE_REV = "MultiWiiParser V" + MWP_VERSION + " - " + MWP_REVISION; 

static final String MULTIWII_PARSER_COPYRIGHT = "Copyright (C) 2013 by Johannes Viegener";

/***************** TODO **********************************************************
- USABILITY: Fields aligned and better distributed 

* USECASE 6 - Apply configurations and load to MultiWii
    -- TODO: Define and display a multiwii directory
    -- TODO: Apply a filename into a multiwii directory
    -- TODO: Start arduino software for multiwii
    -- TODO: Validate also if Board and COM-Port can be changed beforehand
    
--------------------------------

- Add help tab showing a document that gives some help
- Add javadoc
- USABILITY: Scrollbars in dropdown are not as expected (they should be only taking the invisible part into account) --> problem this is cp5, fixed length slides

---- NICE TO HAVE / IDEAS ------
- DELTA: Allow selection of single section for comparision
- DELTA: Show colors for changes (green added / red removed)
- Allow search for entries
- handle complex defines better ( parametereized values)
- Allow resorting of entries in a group
- show count of entries in label for droplist
- Background of drop down should be blanked and not shine through
- cleanup debug handling: e.g. - event output bound to debug setting
- DELTA: Show filename

=======================================================================================
DONE:

18.4.2013 - V0.4
- DEFECT: Field colors not fully reset from edit in File (when changing tabs)
- DEFECT: Emtpy favorites list still allows Load favorites and edit --> exception --> Solution: Dummy entry
- Added documentation (word / html)
- add page down/up cursor up and down to tabs scrolling lists down
- add Shift pos1/end to scrolling lists to the beginning / end
- DEFECT: Sorting of entries with same name corrected


16.4.2013
- On Write of config the filename needs to be adapted in file tab (possible check for same filename in compare?)
- prepopulate file selection on save
- Save last open files --> restore files button
- DELTA: Show also group and subsection name for entry to simplify search
- Ask for confirmation on remove of entry
- Copy Entry --> only when both entries there and different
- DELTA: Add remove entry
- Add all same name values even inactive ones to all lists
- Defect: After changing delta the list shows the beginning of the list although scrollbar is showing last position 
- DELTA: Allow alignment of values
- DELTA: Allow de-/activation of entries
- DELTA: Add write/Write minimal also on comp screen
- DELTA: Make sure that modified is set on comp changes
- ALIGN: Buttons for active, value, complete align und add/del shown in Comp when appropriate
- USABILITY: Color coding --> Blue is interactive / grey is showing data / Red is focus for edit (Background ?)
- DEFECT: Selection in Delta tab is not kept after tab change (back and forth)
- Add text to show that double click will open favorite
- Let doubleclick also start edit on entry
- Add button for selection of favorite
- aligned controls on all tabs
- Color for active checkbox grey if not active
- colors will be completely reset after edit


08.4.2013
- Add Header for Copyright and License to source
- Add license.txt

------------------
06.04.2013 - 0.3 finalized
- DEFECT: Compare for entries with multiple values is not reliable --> improved (active entries have precedence)
- Mark WRITE/MINIMAL red if g_config is changed but not saved
- DEFECT: List in Favorites should not be changed
- DEFECT: Switch of tabs needs to be disabled if Editor is active
- FILE: allow comment editing (use edit fields)
- DELTA: More details on change
- FILE: start empty --> configurable
- FILE: Auto save of Favorites --> configurable
- DEFECT: Past button did not work
----
- FILE: remove favorite
- FILE: Save/Load favorites
- FILE: show comment and file in details
- FILE: select file from fav list onto next available file slot
- FILE: allow clearance of files (new buttons)
- FILE: Add to favorites list
- Add favorites lists (Path / file / comment)
- add keys to textfield --> Posi, End, Ctrl-C, Ctrl-V (Copy past allow copying pasting full current field)
--    needed to completely rebuild LTextField due to visibility issues in TextField
- DELTA: Show only different
- DELTA: Show only different ones that are active
- DELTA: SHow Section and update based on selection 
- DELTA: no selection in section dropdown


03.4.2013
- Colors in Dropdown adapted / better visible
- File selection in Default tab
- New tab for compare
- Prepared compare with lists and additional file selecction
- DELTA: Select entry (either left or right)
- DELTA: Show details (either left or right)


31.3.2013
- Go from textField to LTextfield (Labels not needed anymore)
- Extend Toggles to Show text inside / and have labels not only in Uppercase letters (allow configuration of label position)
- Move from Toggle to InToggle
- In dropdownlistbox active entry should be marked and rest of th elist should be grey (as in List)
- DEFECT: DropDown texts might be too long and need to be cutted
- minimal config can also be reloaded
- minimal config has normal sections
- added tabs for file and details
- start with 0.3
------------------

29.3.2013
- remove a config value
- Validate name to avoid duplicates
- Rename from ParseConfig to MultiWiiParser
- Debug entry (FIXED_FILE) for fixed file
- code.google - GIT - MultiWiiParser
- Allow editing of name only if this is not a toggle group (HaveSameName)
- Allow editing of active only if no other active entries present
- create an entry and store it in current group
- added mouseWheelListeneer according to example from ControlP5 (only works in ListBox but without adapting scrollbar)
- Adapt lengths of dropBox
- DEFECT: In ShowAll mode still access to grouplist is done while refreshing screen leading to index-exceptions
- DEFECT: in Position 0,0 seems to be some output of an unknown control -> Coming from grpSelector name
- Cleanup of member variables in classes and visibility / no outside access to member (although proteced does not prevent this)
- 0.2
- DEFECT: After creation of new entry is ListBox not shown as active
- haveNoValue and haveSameName should be shown as toggles next to Group list
- haveNoValue to be overwritten by user 

28.3.2013
- MOdify colors for Edit fields when inactive --> Grey
- Only allow editing for Value if a value was already there before
- File cleanup (classes to ConfClasses / SelectListBox separated)
- UI blocked is modified during edit / cleanup edit on nono-modified
- Ask for discard on Cancel of Edit when modified
- ConfirmationDialog added
- DEFECT: isMOdifed wrongly identified comments
- DEFECT: On filesave cancel button does not work
- Edit an Entry

28.3.2013
- Add original text in ConfObject
- WriteOriginal using references to lines in config
- Comment fields are shown in backgroundcolor

27.3.2013
- Add EDIT/SAVE/CANCEL Button for unlock entry


25.3.2013
- Check COnfigGroup for only defines without value
- Defect: labels are not cut iff too long for list/popup etc
- SHow Active Status
- locked detail fields

24.3.2013
- Improve event and update handling
- detailed fields for name/value/comment
- Defecz: hascomment in lstStatus is wrng
- Defecz: Comment text is wrong

23.3.2013
- select output file
- write minimal settings to a config.
- write a mostly complete config file
- added write through getOutput/appendOutput

22.3.2013
- Toggles to influence UI for All entries / only active entries (either all or a full section)
- Condense UI (Y pos) --> bigger listboxes / small / 
- Show All entries in sorted form
- Find an object based on selection --> actCEList
- Start with All/Active set to false

21.3.2013
- scrollbar connected to both listboxes
- active value also connected to both listboxes
- add comment listbox for group-entries
- add toggles: All entries, only active entries (either all or a full section)

20.3.2013
- Select a config file
- Listbox does not show active value only mouseOver

19.3.2013
- Add all entries in the Config global ( sort alphabetically by name)
    Handle also multiple entries with same name
    Error if multiple with same name in different groups
- Handle flags on groups for --> Multiple with same name / separate entities / mixture (!)
- switch from G4P to ControlP5
- Parser debug --> handling missing groupname but subsection is named / correction on parsing comments-groups

18.3.2013
- parse (*) in comment for entry
- First tests with ControlP5 instead of G4P
- Classes in separate file
- Add generic base class for Config
- handle comments on any element
- show comments


/*********************************************************************************/


