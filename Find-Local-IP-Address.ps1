<#
 _                 _    ___ ___
| |   ___  __ __ _| |__|_ _| _ \
| |__/ _ \/ _/ _` | |___| ||  _/
|____\___/\__\__,_|_|  |___|_|

     __                         _   __            ___ __  __
 __ / /__ _______ __ _  __ __  | | / /__ ___  ___/ (_) /_/ /____
/ // / -_) __/ -_)  ' \/ // /  | |/ / -_) _ \/ _  / / __/ __/ _ \
\___/\__/_/  \__/_/_/_/\_, /   |___/\__/_//_/\_,_/_/\__/\__/\___/
                      /___/



###############################  Information  ###############################

    Searches for a Specific MAC Address

    Checks the Arp Cache for MAC 0c-38-3e-09-1e-e4

    If it can't find it, it will ping the subnet in 25 IP intervals (Faster and Saves Page File Memory).
    It will then recheck for a match
    If a match is found, it will display on screen and prompt to open in a web browser
    If no match is found, a message will display "Guard Shack IP not found. Check Internet Connectivity"

#>

###############################   Variables   ###############################

$SUBNET = "10.72.15"
$MAC = "0c-38-3e-09-1e-e4"
$command1 = "ping -n 1 $SUBNET."

###############################   Functions   ###############################

#~~~~~~~~~~~~~~~~~~~~~~~ Display IP Address Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~#


function _DISPLAY_IP_ {
        if ($DESIRED_IP -ne $nul) {
            Write-Host " "
            Write-Host "Local IP Address: "
            Write-Host " "
            Write-Host "$DESIRED_IP" -ForegroundColor Yellow
            Write-Host " "
            $BROWSER = Read-Host "Open in web browser? (y/n)"
                if ($BROWSER -eq "y") {
                    Start-Process chrome.exe "$DESIRED_IP"
                }
            Exit 
        }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~ Recheck Arp Cache Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function _ARP_CACHE_ {

    # Look for MAC in the arp cache
    $_ARP_CACHE_ = (arp /a | select-string "$MAC")

    # Check for IP
        if ($_ARP_CACHE_ -ne $nul) {$DESIRED_IP = ($_ARP_CACHE_.tostring().substring(2,13))}

        if ($DESIRED_IP -ne $nul) { _DISPLAY_IP_ }

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Search Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

function _SEARCH_FUNCTION_ {

    # Ping the entire subnet to update the arp cache
    # Creates 255 new powershell processes with hidden windows
    # The reason for this is that ping is slow, especially when it does not find a device.
    # Breaking these up into ~25 IP's per loop to save page file memory.
    # It is also faster to recheck the arp cache after every loop in case it has found a match.

    Write-Host " "
    Write-Host "Pinging the subnet until a match is found, this will take some time."
    Write-Host " " 

    # Ping 1-25
    foreach ($IP in 1..25) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17  # Sleep to let ping finish
    Write-Host "$SUBNET.1 - $SUBNET.25 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 26-50
    foreach ($IP in 26..50) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17  # Sleep to let ping finish
    Write-Host "$SUBNET.26 - $SUBNET.50 Complete" -ForegroundColor Green

    # Recheck Arp Cache   
    _ARP_CACHE_

    # Ping 51-75
    foreach ($IP in 51..75) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17 
    Write-Host "$SUBNET.51 - $SUBNET.75 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 76-100
    foreach ($IP in 76..100) {
    Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17 
    Write-Host "$SUBNET.76 - $SUBNET.100 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 101-125
    foreach ($IP in 101..125) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.101 - $SUBNET.125 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 126-150
    foreach ($IP in 126..150) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.126 - $SUBNET.150 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 151-175
    foreach ($IP in 151..175) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.151 - $SUBNET.175 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 176-200
    foreach ($IP in 176..200) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.176 - $SUBNET.200 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 201-225
    foreach ($IP in 201..225) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.201 - $SUBNET.225 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_

    # Ping 226-255
    foreach ($IP in 226..255) {
        Start-Process powershell -ArgumentList ("$command1$IP") -windowstyle hidden
    } # End Foreach

    start-sleep 17
    Write-Host "$SUBNET.226 - $SUBNET.255 Complete" -ForegroundColor Green

    # Recheck Arp Cache
    _ARP_CACHE_
    
    # No IP Found. Check Internet Connectivity
        if ($DESIRED_IP -eq $nul) {
            Write-Host "Guard Shack IP not found. Check Internet Connectivity" -ForegroundColor Red
            Read-Host "Press Enter to Exit"
            Exit
        } # End IF

} # End _SEARCH_FUNCTION_

#~~~~~~~~~~~~~~~~~~~~~~~~~ Display IP or Search Function ~~~~~~~~~~~~~~~~~~~~~~~~#

function _MAIN_ {

    _ARP_CACHE_
        if ($DESIRED_IP -ne $nul) {
            _DISPLAY_IP_
        } else { 
            Write-Host "No Entries found in the Arp Cache." -ForegroundColor Red
            _SEARCH_FUNCTION_
        } # End IF
} # End _MAIN_
 
################################## SCRIPT ########################################

    # Start by checking the arp cache

_MAIN_