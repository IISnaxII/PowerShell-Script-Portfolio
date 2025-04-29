#GetHardWareInfo.ps1
#Joshua Wildgrube
#Created April 2, 2025

#Synopsis
#This script uses CIMInstance to gather hardware information about a local computer.

#Source for converting Bytes to GB
#https://stackoverflow.com/questions/17466586/how-to-convert-a-size-variable-from-bytes-into-gb-in-powershell
#https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ee692684(v=technet.10)?redirectedfrom=MSDN

#Gets info about the computer system
Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_ComputerSystem | Format-List Name,PrimaryOwnerName,Domain,Model

#Gets info about the the processor
Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_Processor | Format-List Name,MaxClockSpeed,Manufacturer,NumberOfCores

#Gets info about the disk drives
Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_DiskDrive | Select-Object DeviceID, Partitions,
@{Name='Size(GB)'; Expression = { [math]::Round($_.Size / 1GB) }}, Model | Format-List

#Gets info about the GPU
Get-CimInstance -Namespace root/CIMV2 Win32_VideoController | Select-Object Description,CurrentRefreshRate,
@{Name='AdapterRAM(GB)';Expression = { [math]::Round($_.AdapterRAM / 1GB) }},DriverVersion | Format-List

#Gets info about the logical disks including total size and available size
Get-CimInstance -Namespace root/CIMV2 CIM_LogicalDisk | Select-Object DeviceID,
@{Name='Size(GB)';Expression = { [math]::Round($_.Size / 1GB) }},
@{Name='FreeSapce(GB)';Expression = { [math]::Round($_.FreeSpace / 1GB) }}