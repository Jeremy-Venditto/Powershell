<#
 ____        _                _        _   _      _
/ ___| _   _| |__  _ __   ___| |_     | | | | ___| |_ __   ___ _ __
\___ \| | | | '_ \| '_ \ / _ \ __|____| |_| |/ _ \ | '_ \ / _ \ '__|
 ___) | |_| | |_) | | | |  __/ ||_____|  _  |  __/ | |_) |  __/ |
|____/ \__,_|_.__/|_| |_|\___|\__|    |_| |_|\___|_| .__/ \___|_|
                                                   |_|

     __                         _   __            ___ __  __
 __ / /__ _______ __ _  __ __  | | / /__ ___  ___/ (_) /_/ /____
/ // / -_) __/ -_)  ' \/ // /  | |/ / -_) _ \/ _  / / __/ __/ _ \
\___/\__/_/  \__/_/_/_/\_, /   |___/\__/_//_/\_,_/_/\__/\__/\___/
                      /___/

###############################  Information  ###############################

    This program lets you View / Udate the arp cache for Deans subnets

    Useful for finding the IP Address for specific MAC address on DHCP networks
    
    This program has a feature to save the results to the desktop in a .txt File.

#>

###############################   Variables   ###############################

$SUBNET1 = "10.72.11"
$SUBNET2 = "10.72.12"
$SUBNET3 = "10.72.13"
$SUBNET4 = "10.72.15"
$SUBNET5 = "10.72.29"
$SUBNET6 = "10.72.31"
$SUBNET7 = "10.72.40"
$SUBNET8 = "10.72.255"

$SUBNET_1_TYPE = "(DHCP)"
$SUBNET_2_TYPE = "(DHCP)"
$SUBNET_3_TYPE = "(DHCP)"
$SUBNET_4_TYPE = "(Cameras)"
$SUBNET_5_TYPE = "(Printers)"
$SUBNET_6_TYPE = "(Servers and Network)"
$SUBNET_7_TYPE = "(Access Points)"
$SUBNET_8_TYPE = "(VPN Users)"



###############################   Functions   ###############################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Arp Subnet ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function ARP_SUBNET {

    # These variables needs to be here so it can be updated each time the function is called
    $DATE = (Get-Date -Format "MM-dd_HH-mm-ss")
    $SAVEFILE="$env:USERPROFILE\Desktop\SUBNET_$SUBNET.x_$DATE.txt"
    $SAVEFILE_TEMP="$env:USERPROFILE\Desktop\SUBNET_$SUBNET.x_$DATE-temp.txt"

    # Save to Desktop Prompt
    Write-Host " "
    $SAVE = Read-Host "Save to Desktop? (y/n)"
    Write-Host " "
    Write-Host "Checking the Arp Cache, please be patient..." -ForegroundColor Red
    Write-Host " "

        # If 'y' save to desktop, if not, display on screen
        if ($SAVE -eq 'y') {foreach ($i in 1..255) { arp -a "$SUBNET.$i" >> $SAVEFILE_TEMP }} else { foreach ($i in 1..255) { arp -a "$SUBNET.$i" }}

        # Remove "No Arp Entries Found."
        if (($SAVE -eq 'y') -and ($SAVEFILE_temp -ne $nul)) { (gc $SAVEFILE_temp | select-string -notmatch "No ARP Entries Found." ) >> $SAVEFILE }

        # If there are no entries, add text					
        if ($SAVEFILE -eq $nul) { echo "No Arp Entries for this subnet" }

        # Remove $SAVEFILE_TEMP
        if (Test-Path $SAVEFILE_TEMP) {Remove-Item "$SAVEFILE_TEMP"}

        # Remove $SAVEFILE if it is empty
        if ($SAVEFILE -eq $nul) { Remove-Item "$SAVEFILE"}

        # If $SAVE = 'y', open the file
        if ($SAVE -eq 'y') { 
           Write-Host "Processing complete" -ForegroundColor Yellow
           Write-Host " "
           Write-Host "Opening file '$SAVEFILE'" -ForegroundColor Blue
           Start-Process Notepad.exe "$SAVEFILE" 
        } # End If

    # Back to Main Prompt
    PROMPT_MAIN

} # End function ARP_SUBNET

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Ping Subnet ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function PING_SUBNET {

    # Ping the entire subnet to update the arp cache
    # Creates 255 new powershell processes with hidden windows
    # The reason for this is that ping is slow, especially when it does not find a device.
    # Breaking these up into ~50 IP's per loop to save page file memory

    # Command to pass into start-process
    $command1 = "ping -n 1 $SUBNET."

    Write-Host " "
    Write-Host "Pinging the entire subnet, this will take some time."
    Write-Host " " 

    # Ping 1-50
    foreach ($IP in 1..50) { Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden }
    start-sleep 35  # Sleep to let ping finish
    Write-Host "$SUBNET.1 - $SUBNET.50 Complete" -ForegroundColor Green

    # Ping 51-100
    foreach ($IP in 51..100) { Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden }
    start-sleep 35 
    Write-Host "$SUBNET.51 - $SUBNET.100 Complete" -ForegroundColor Green
    
    # Ping 101-150
    foreach ($IP in 101..151) { Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden }
    start-sleep 35
    Write-Host "$SUBNET.101 - $SUBNET.150 Complete" -ForegroundColor Green

    # Ping 151-200
    foreach ($IP in 151..200) { Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden }
    start-sleep 35
    Write-Host "$SUBNET.151 - $SUBNET.200 Complete" -ForegroundColor Green

    # Ping 200-255
    foreach ($IP in 200..255) { Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden }
    start-sleep 35
    Write-Host "$SUBNET.201 - $SUBNET.255 Complete" -ForegroundColor Green

    #Loop to ARP_SUBNET
    ARP_SUBNET

} # End function PING_SUBNET

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Selection Prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function PROMPT_SELECTION {

    Write-Host " "
    Write-Host "(b) Back to Subnet Selection"
    Write-Host "(u) Update Arp Cache"
    Write-Host "(v) View current Arp Cache"
    Write-Host "(q) Quit Program"
    Write-Host " "
    $SELECTED_VALUE = Read-Host "Please enter a selection"

        if ($SELECTED_VALUE -eq 'b') { Write-Host " "; PROMPT_MAIN }
        if ($SELECTED_VALUE -eq 'u') { PING_SUBNET }
        if ($SELECTED_VALUE -eq 'v') { ARP_SUBNET }
        #if ($SELECTED_VALUE -eq 'q') { exit } # Moved after the While Loop was added

} # End function PROMPT_SELECTION

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main Prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function PROMPT_MAIN {

    Write-Host " "
    Write-Host "Subnet Helper" -ForegroundColor Red
    Write-Host " "
    Write-Host "1 = 10.72.11.x $SUBNET_1_TYPE"
    Write-Host "2 = 10.72.12.x $SUBNET_2_TYPE"
    Write-Host "3 = 10.72.13.x $SUBNET_3_TYPE"
    Write-Host "4 = 10.72.15.x $SUBNET_4_TYPE"
    Write-Host "5 = 10.72.29.x $SUBNET_5_TYPE"
    Write-Host "6 = 10.72.31.x $SUBNET_6_TYPE"
    Write-Host "7 = 10.72.40.x $SUBNET_7_TYPE"
    Write-Host "8 = 10.72.255.x $SUBNET_8_TYPE"
    Write-Host "q: Quit"
    Write-Host " "

        While ($true)  {
            $SUBNET = Read-Host "Please Select a Subnet"

                if ($SUBNET -eq "q") {Exit}
                if (($SUBNET  -gt 0) -and ($SUBNET  -lt 9)) {
                    break
                } else {
                    Write-Host " "
                    Write-Host "Invalid ID, You selected '$SUBNET'" -ForegroundColor Yellow
                    PROMPT_MAIN
                } # End IF
        } # End While Loop

        if ($SUBNET -eq 1) { $SUBNET = $SUBNET1; $SUBNET_TYPE = $SUBNET_1_TYPE }
        if ($SUBNET -eq 2) { $SUBNET = $SUBNET2; $SUBNET_TYPE = $SUBNET_2_TYPE }
        if ($SUBNET -eq 3) { $SUBNET = $SUBNET3; $SUBNET_TYPE = $SUBNET_3_TYPE }
        if ($SUBNET -eq 4) { $SUBNET = $SUBNET4; $SUBNET_TYPE = $SUBNET_4_TYPE }
        if ($SUBNET -eq 5) { $SUBNET = $SUBNET5; $SUBNET_TYPE = $SUBNET_5_TYPE }
        if ($SUBNET -eq 6) { $SUBNET = $SUBNET6; $SUBNET_TYPE = $SUBNET_6_TYPE }
        if ($SUBNET -eq 7) { $SUBNET = $SUBNET7; $SUBNET_TYPE = $SUBNET_7_TYPE }
        if ($SUBNET -eq 8) { $SUBNET = $SUBNET8; $SUBNET_TYPE = $SUBNET_8_TYPE }
        if ($SUBNET -eq 'q') { exit }

    Write-Host " "
    Write-Host "The Subnet you have chosen is $SUBNET.x $SUBNET_TYPE" -ForegroundColor Red

    PROMPT_SELECTION

} # End function PROMPT_MAIN

################################## SCRIPT ########################################

PROMPT_MAIN

