#Title: IPConfiguration.ps1
#Author: Joshua Wildgrube
#Date: April 2, 2025
#Synopsis: A script that configures static IP, and DNS on a chosen network adapter. 

#This will get info on ALL net adapaters. This will be helpful to see which adapter you would like to configure as well as the index of each.
Get-NetAdapter

#Variables

$_InterfaceAdapter = Read-Host "Enter the Interface Adapater"
$_IntfaceIndex = Read-Host "Enter the Interface Index (This can found in the Get-NetAdapater table above)"
$_IPadd = Read-Host "Enter the IP address (e.g., 172.16.0.1)"
$_PrefixLength = Read-Host "Enter the Prefix Length (e.g., 24 for a subnet mask of 255.255.255.0)"
$_DGadd = Read-Host "Enter the Default Gateway (e.g., 172.16.0.254)"
$DNSInput = Read-Host "Enter DNS servers separated by commas (e.g., 172.16.0.1,172.16.0.2,8.8.4.4)"
#This just allows the user to enter multiple DNS addresses
$_DNSadd = $DNSInput.Split(",") 



#Removes any/old IP configuration. Windows throws a fit sometimes if you try to add a new IP address/route without removing the old one.
Remove-NetIPAddress -InterfaceAlias $_InterfaceAdapter -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceAlias $_InterfaceAdapter  -ErrorAction SilentlyContinue

#inputs what the user entered for the satic IP addresses
New-NetIPAddress -InterfaceAlias $_InterfaceAdapter `
    -IPAddress $_IPadd `
    -PrefixLength $_PrefixLength `
    -DefaultGateway $_DGadd

#sets the DNS addresses 
Set-DnsClientServerAddress -InterfaceAlias $_InterfaceAdapter `
    -ServerAddresses $_DNSadd
