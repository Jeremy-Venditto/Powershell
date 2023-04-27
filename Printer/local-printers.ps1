# This Script Finds Installed via USB

$AA = get-itemproperty "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USBPRINT\*\*"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~~~~~~~~~~~~~ Printers Connected Via USB   ~~~~~~~~~~~~~~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
$AA.devicedesc
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Read-Host "Press 'Enter' for more information or 'Control-C' to exit"
$AA
Read-Host