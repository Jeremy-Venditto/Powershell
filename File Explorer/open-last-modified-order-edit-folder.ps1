$Folder = "I:\Jeremy's Work\Archive\order_edits"
$FULL_NAMES = (Get-ChildItem -Path $Folder -Directory -Recurse | ?{ $_.PSIsContainer } | Select-Object FullName | ft -HideTableHeaders)
$full_names > "I:\Jeremy's Work\Archive\null\script-tempfolder\foldername.txt"
$LAST_Folder = (Get-ChildItem $Folder -Directory -Recurse | Sort-Object LastWriteTime -Descending| Select-Object -First 1)
$last_folder_name = $last_folder.name
$FULL_PATH_LAST_ACCESSED_FOLDER = (get-content "I:\Jeremy's Work\Archive\null\script-tempfolder\foldername.txt" | select-string "$last_folder_name").tostring()
explorer.exe "$FULL_PATH_LAST_ACCESSED_FOLDER"