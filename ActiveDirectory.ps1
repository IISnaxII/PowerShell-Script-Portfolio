#Title: ActiveDirectory.ps1
#Author: Joshua Wildgrube
#Date: March 29, 2025
#Synopsis: A script that deploys Active Directory

#Variables

#Variable that allows user to enter domain name
$_DomainName = Read-Host "Enter the name of your domain"

#Variable that allows user to enter NetBIOS name
$_NetBiosName = Read-Host "Enter the NetBIOS name for the domain"

##Variable that allows user to enter password for domain
$_SafeModePassword = Read-Host "Enter Password for domain" 
$_SafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

#Sintalls the Aactive Directory Services feature
Install-WindowsFeature -Name ad-domain-services -IncludeManagementTools
Import-Module ADDSDeployment

#Installs a AD Forest allowing the user to set the domain name, NetBios name, and password.
Install-ADDSForest `
-DomainName "$_DomainName" `
-DomainNetbiosName "$_NetBiosName" `
-SafeModeAdministratorPassword $_SafeModePassword `
#Installs DNS (user doesn't have to do anything)
-InstallDns:$true `
#Once the forest and DNS is installed, the computer will restart
-NoRebootOnCompletion:$false `
-Force:$true
