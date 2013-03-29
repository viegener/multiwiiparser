


static final String MWP_VERSION = "0.1";
static final String MWP_REVISION = "2013/03/29"; 

static final String MULTIWII_PARSER_TITLE_REV = "MultiWiiParser V" + MWP_VERSION + " - " + MWP_REVISION; 


/***************** TODO **********************************************************
- DEFECT: DropDown texts might be too long and need to be cutted

- haveNoValue and haveSameName should be shown as toggles next to Group list
- haveNoValue and haveSameName to be overwritten by user 
- In dropdownlistbox active entry should be marked and rest of th elist should be grey (as in List)

* USECASE 3 - Open two different config.h and show the differences
    -- TODO: Show the delta
  
* USECASE 4 - Open a config.h (as a template) and apply another config to it
    -- TODO: Apply changes to a config.h including check fo compliance

* USECASE 5 - Handle a persistent catalog for config files
    -- TODO: Show current filename
    -- TODO: Show last filenames used
    -- TODO: Assign a name for a filename
    -- TODO: Apply a filename into a multiwii directory
    -- TODO: Start arduino software for multiwii
    -- TODO: Validate also if Board and COM-Port can be changed beforehand
    
--------------------------------

- TextField should allow Pos1/End
- TextField should allow Copy/Paste
- event output bound to debug setting
- Add javadoc
- Allow search for entries
- Cleanup visibility in Conf* Classes 


---- NICE TO HAVE ------
- handle complex defines ( parametereized values)
- Allow resorting of entries in a group
- show count of entries in label for droplist
- Background of drop down should be blanked and not shine through

=======================================================================================
DONE:
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

================================================================================

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
    
-------------------------------------







/*********************************************************************************/

