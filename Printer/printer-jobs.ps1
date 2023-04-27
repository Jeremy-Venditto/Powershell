$computername = ($env:computername | Select-Object)
$username = ($env:UserName)
$PrinterNames = gwmi Win32_Printer | % { $_.Name }
$numberofprinters = $PrinterNames.length
echo "There are $numberofprinters printers connected to $computername :"
echo " "
$PrinterNames
echo " " 
echo "Print Jobs:"
foreach( $printer in $printernames ) { get-printjob -computername $computername -printername $printer}
Read-Host