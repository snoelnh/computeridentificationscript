# SIG Computer Identification Script
# SNOEL 11/18/20
# This script is used to identify a machine for support technicians
# The script should be pre-loaded on all SIG machines and will display the following info:
# Domain, Username, Hostname, Manufacturer, Model, IP Address(es), Serial number, and windows version
# jacob was here

# create a temp folder and temp file
mkdir c:\temp
echo 'This window contains useful info for your support technician.' > c:\temp\sigit.txt

# get domain, username, and hostname
# echo $env:userdomain, $env:username, $env:computername >> c:\temp\sigit.txt

# get serial number and bios version
get-ciminstance win32_bios | fl serialnumber, smbiosbiosversion >> c:\temp\sigit.txt
get-ciminstance win32_computersystem | fl domain, name, username, manufacturer, model, version >> c:\temp\sigit.txt

# get windows version
# systeminfo /fo csv | ConvertFrom-Csv | select OS*, System* | Format-List
# echo "Windows version ; "(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
Get-ComputerInfo | select WindowsProductName, WindowsVersion >> c:\temp\sigit.txt

# get ip addresses
Get-NetIPAddress -addressfamily ipv4  | sort-object -property ipaddress | ft interfacealias, ipaddress >> c:\temp\sigit.txt


# now display all the collected Info
# first, add the presentation framework for dialog MessageBox
Add-Type -AssemblyName PresentationFramework 

# now use that dialog box capability to show the info
# Sample1: [System.Windows.MessageBox]::Show('Would  you like to play a game?','Game input','YesNoCancel','Error')
# Sample2: [System.Windows.Messagebox]::Show('SIG Computer Identification Script','SIG SAUER IT')
$ButtonType = [System.Windows.MessageBoxButton]::'OK'
$MessageIcon = [System.Windows.MessageBoxImage]::'Information'
$MessageBody = Get-Content -Path "c:\temp\sigit.txt" | Out-String
$MessageTitle = '[ SIG IT - SUPPORT IDENTIFICATION SCRIPT ]'
$MessageBody 
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)



# Future enhancement? Offer the ability to email the info to the support technician

# end of script
