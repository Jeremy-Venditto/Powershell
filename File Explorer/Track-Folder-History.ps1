# Track-Folder-History.ps1
# Jeremy Venditto

###############################  Information  ###############################

# Script to Save file explorer state in case of a crash ( Windows 11 Issue )
# Or you can use this for quick access to closed folders
# Script will loop forever and overwrite a temporary file.

###############################   Functions   ###############################

function Main { # Begin Main Function

    # Define Date
    $DATEFORMAT = (Get-Date -Format "MM-dd-yy")

    # Local Appdata Folder
    $Folder = "C:\users\$env:username\appdata\local\File_Explorer\$DATEFORMAT"

        # Create Paths if they do not exist
        if ((Test-Path "$Folder")) { "" } else { New-Item -Path $Folder -ItemType "directory" }
        if ((Test-Path "$Folder\history.txt")) { "" } else { New-Item -Path $Folder\history.txt -ItemType "File" }
        if ((Test-Path "$Folder\history.txt")) { "" } else { New-Item -Path $Folder\last-session.txt -ItemType "File" }

    # All open File Explorer Paths
    $PATHS = (New-Object -ComObject 'Shell.Application').Windows() | ForEach-Object { $_.Document.Folder.Self.Path }

    # Copy Active File Explorer Paths to last-session.txt
    if ($PATHS -ne $nul) { $PATHS > $Folder\last-session.txt }
	
    # Query Contents of last-session.txt
    $LS = get-childitem $folder -Recurse -Include last-session.txt | Get-Content
	
    # Query Contents of history.txt
    $HIS = get-childitem $folder -Recurse -Include history.txt | Get-Content

    # Query Differences between History.txt and Last-session.txt
    $objects = if ($his -ne $nul){(diff $ls $his)}
	
    # Select differences only in $LS ( this side <= )
    $Directories_To_Add = foreach ($object in $objects) { if ($object.sideindicator -eq "<=") { echo $object } }
	
    # Only Directory Names
    $Dir_Names = ($Directories_To_Add).inputobject
	
        # If the history folder is empty ( a new day ) copy all objects from $LS to $HIS
        if ($HIS -eq $nul) { #  Begin First If Statement
            $LS >> "$folder\history.txt"
        } else {  # If it is not empty, add the files to History.txt
            $Dir_Names >> $folder\history.txt

			# If there are no Directories to add, Write 'No Entries Added'
            if ($Dir_Names -eq $nul ) { # Begin 2nd If Statement
		    Write-Host "No Entries Added"
            } Else { # If there are, list the contents that were added to History.txt
		    Write-Host "$Dir_Names was added to history"
            } # End 2nd If Statement
        } # End First If Statement
} # End Main Function

###############################  SCRIPT  ################################

	# Infinite loop every 30 seconds
    while(1)
{
   Main
   start-sleep -seconds 30
}
