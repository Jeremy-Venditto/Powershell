<#
 ___ _ _   __    ___ _         _
/ _ \ | | /  \  | __(_)_ _  __| |___ _ _
\_, /_  _| () | | _|| | ' \/ _` / -_) '_|
 /_/  |_| \__/  |_| |_|_||_\__,_\___|_|

     __                         _   __            ___ __  __
 __ / /__ _______ __ _  __ __  | | / /__ ___  ___/ (_) /_/ /____
/ // / -_) __/ -_)  ' \/ // /  | |/ / -_) _ \/ _  / / __/ __/ _ \
\___/\__/_/  \__/_/_/_/\_, /   |___/\__/_//_/\_,_/_/\__/\__/\___/
                      /___/


###############################  Information  ###############################
    
    Prompts for customer and reference number(s)
    Creates a new folder with todays date in Specified Folder
    Queries Agent Ransack, writes to a text file
    Script runs through the text file, grabbing filenames, and then copies files into the new folder

#>

########################  User Defined Parameters   #########################

    # Select Directory to place copied files

$COPY_FILES_HERE = "I:\Jeremy's Work\Archive\order_edits"

    # Copy Flat File to folder

$GET_FLAT_FILE = 'True'

    # Copy CSV File to folder

$GET_CSV_FILE = 'True'

    # Search files created in the last "X" number of days

$SEARCH_DAYS = '3' 

    # Open FTP Folder at the end of script

$OPEN_FTP_FOLDER = 'False'

    # Open IE Folder at the end of script

$OPEN_IE_FOLDER = 'False'

    # Open Directory with newly copied files

$OPEN_EDIT_FOLDER = 'True'

###############################   Functions   ###############################

function _UPDATE_VARIABLES_ {

    # Check if $COPY_FILES_HERE ends in a "\" ... if it does, remove it

        if ($COPY_FILES_HERE.substring($COPY_FILES_HERE.length -1) -eq "\") { $COPY_FILES_HERE = $COPY_FILES_HERE.substring(0, $COPY_FILES_HERE.length -1)}

    $COPY_FILES_HERE = "$COPY_FILES_HERE\$CUSTOMER"

    $NUMBER_OF_REFERENCES = $REFERENCE_NUMBER.split(" ").length
    $REFERENCES = $REFERENCE_NUMBER.split(" ")

    # ~~~~~~~~~~~~~~~~~ Set Directories ~~~~~~~~~~~~~~~~~~~~~~~~

    $Directory1 = "\\10.72.31.218\c$\Synapse\prod\ImportExport\$CUSTOMER\"
    $Directory2 = "\\10.72.31.247\ftp\$CUSTOMER"
    $DIRECTORY3 = "$COPY_FILES_HERE"

    # ~~~~~~~~~~~~~~~~~~~~ Create Folder ~~~~~~~~~~~~~~~~~~~~~~~~

    $DATEFORMAT_FOLDER = (Get-Date -Format "MM-dd-yy")
    $NEW_EDIT_FOLDER = "$DIRECTORY3\$DATEFORMAT_FOLDER"
        if (Test-Path -Path $NEW_EDIT_FOLDER) {
            "Path exists!"
        } else {
            New-Item -Path $NEW_EDIT_FOLDER -ItemType "directory"
        }

    # ~~~~~~~~~~~ Set Customer Paths ~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    if ($CUSTOMER -eq "CUSTOMER1") { 
        $ARCHIVE_DIRECTORY_IE = "\\10.72.31.218\c$\Synapse\prod\ImportExport\CUSTOMER1\Import\OutboundOrders\Processed" 
        $ARCHIVE_DIRECTORY_FTP = "\\10.72.31.247\ftp\CUSTOMER1\ARCHIVE\"
    }

    if ($CUSTOMER -eq "CUSTOMER2") { 
        ARCHIVE_DIRECTORY_IE = "\\10.72.31.218\c$\Synapse\prod\ImportExport\CUSTOMER2\Import\OutboundOrders\Processed"
    }

    if ($CUSTOMER -eq "CUSTOMER3") {
        $ARCHIVE_DIRECTORY_IE = "\\10.72.31.218\c$\Synapse\prod\ImportExport\CUSTOMER3\Import\OutboundOrders\Processed"
    }

    if ($CUSTOMER -eq "CUSTOMER4") {
        $ARCHIVE_DIRECTORY_IE = "\\10.48.31.218\c$\Synapse\prod\ImportExport\CUSTOMER4\Import\940_OutboundOrders\Processed"
    }

    # ~~~~~~~~~~~ Build Agent Ransack Query ~~~~~~~~~~~~~~~~~~~~~~

	# Date to search is set by user defined variable $SEARCH_DAYS

    $DATE_FORMAT_AGENT_RANSACK = ((Get-Date).AddDays(-$SEARCH_DAYS) | Get-Date -UFormat "%m/%d/%Y")
    $AGENT_RANSACK_TEMP_2 = foreach ($REF in $REFERENCES -ne $null) {write-output "$REF OR "}
    $AGENT_RANSACK_TEMP_3 = -join $AGENT_RANSACK_TEMP_2
    $AGENT_RANSACK_TEMP_4 = $AGENT_RANSACK_TEMP_3.length -3 
    $AGENT_RANSACK_QUERY_TEMP = $AGENT_RANSACK_TEMP_3.substring(0,$AGENT_RANSACK_TEMP_4)
    $AGENT_RANSACK_OUTPUT_TXT = "$NEW_EDIT_FOLDER\agent-ransack-output.txt"
    $AGENT_RANSACK_OUTPUT_TXT_QUOTES = "`"$AGENT_RANSACK_OUTPUT_TXT`""
    $AGENT_RANSACK_ARCHIVE_FTP = "`"$ARCHIVE_DIRECTORY_FTP`""
    $AGENT_RANSACK_ARCHIVE_IE = "`"$ARCHIVE_DIRECTORY_IE`""
    $AGENT_RANSACK_ARCHIVE_DIRS = "`"$ARCHIVE_DIRECTORY_IE;$ARCHIVE_DIRECTORY_FTP`""
    $AGENT_RANSACK_QUERY = "`"$AGENT_RANSACK_QUERY_TEMP`""
	
    # ~~~~~~~~~~~ Execute Agent Ransack Command ~~~~~~~~~~~~~~~~~~

    & "C:\Program Files\Mythicsoft\Agent Ransack\Agentransack.exe" -o $AGENT_RANSACK_OUTPUT_TXT_QUOTES -d $AGENT_RANSACK_ARCHIVE_DIRS -ceb -cf -c $AGENT_RANSACK_QUERY -ma $DATE_FORMAT_AGENT_RANSACK

    start-sleep 4

    # ~~~~~~~~ Find and Copy IE Files to $NEW_EDIT_FOLDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Find IE Filenames

    $IE_START = Select-String "$AGENT_RANSACK_OUTPUT_TXT" -Pattern '\\10.72.31.218' | Select -ExpandProperty Line
    $IE_FILENAMES_NO_DIR = $ie_start.substring($archive_directory_ie.length +1)  -replace '^([^ ]+ ).+$','$1'
    $IE_FILENAMES = foreach ($filename in $IE_FILENAMES_NO_DIR) {$ARCHIVE_DIRECTORY_IE + "\" + $filename}

    # Copy IE Files

        if ($GET_FLAT_FILE = 'True') { foreach ($IE_FILE in $IE_FILENAMES) {copy-item $IE_FILE $NEW_EDIT_FOLDER} }


    # ~~~~~~~~ Find and Copy FTP Files (if they exist) to $NEW_EDIT_FOLDER ~~~~~~~

    # Find FTP Filenames

    $FTP_START = Select-String "$AGENT_RANSACK_OUTPUT_TXT" -Pattern '\\10.72.31.247' | Select -ExpandProperty Line

        if ($FTP_START -ne $nul) {
            $FTP_REMAINING_FIELDS = $ftp_start.substring($archive_directory_FTP.length)
            $FTP_FILENAMES = foreach ($FIELD_FTP in $FTP_REMAINING_FIELDS) { $ARCHIVE_DIRECTORY_FTP + $FIELD_FTP.substring(0, $FIELD_FTP.lastindexof('.')) + ".csv"}
        }

        # Copy FTP Files
        if (($GET_CSV_FILE = 'True') -and ($FTP_START -ne $nul)) {foreach ($FTP_FILE in $FTP_FILENAMES) {copy-item $FTP_FILE $NEW_EDIT_FOLDER }}

    # ~~~~~~~~~~~ Open File Explorer ~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Get IE Full path	
    # CUSTOMER4 is the only IE customer folder that is different

        if ($CUSTOMER -eq 'CRIM') {
            $IE_FULL_PATH = $DIRECTORY1 + "940_OutboundOrders"
        } else {
            $IE_FULL_PATH = $DIRECTORY1 + "Import\OutboundOrders"
        }

    # Remove Agent Ransack Output file
    Remove-Item $AGENT_RANSACK_OUTPUT_TXT

    # As specified by User Defined Parameters

        if ($OPEN_FTP_FOLDER -eq 'True') {Explorer.exe $DIRECTORY2}
        if ($OPEN_IE_FOLDER -eq 'True') {Explorer.exe $IE_FULL_PATH}
        if ($OPEN_EDIT_FOLDER = 'True') {Explorer.exe $NEW_EDIT_FOLDER}

} # END _UPDATE_VARIABLES_

function _MAIN_ {

    # Enter Customer
    $CUSTOMER = Read-Host "Enter Customer (SQL Format)"

    # Enter Reference numbers, separated by spaces
    @(((($REFERENCE_NUMBER = Read-host -Prompt 'Enter Reference Numbers, Separated by Spaces').Split(" ")).Trim()) | ForEach-Object { write-host $_ } )

    _UPDATE_VARIABLES_

} #END function _MAIN_


###############################  SCRIPT  ################################

_MAIN_
