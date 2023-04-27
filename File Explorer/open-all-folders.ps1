# Restores File Explorer session after a crash.

# Pin this shortcut to the desktop.. The other script overwrites the temp file every 30 seconds.
# If you have to open file explorer to access this script, the temp file will probably be overwritten by then

$DATEFORMAT = (Get-Date -Format "MM-dd-yy")
	# Local Appdata Folder
$TempFile = (gc "C:\users\$env:username\appdata\local\File_Explorer\$DATEFORMAT\last-session.txt")
foreach ($folder in $TempFile) { explorer $folder }

	# Read Contents of Temp File
#$TempFile= (gc 'C:\Users\Jerem\OneDrive\Documents\scripts\Powershell\File Explorer\restore-location-after-crash\tempfile.txt')
#$TempFile = (gc "$env:temp\last-folder.tmp")
#	# Open File Explorer Windows for each path
#foreach ($folder in $TempFile) { explorer $folder }