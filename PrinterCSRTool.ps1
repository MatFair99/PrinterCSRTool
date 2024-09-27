<# 
ABOUT:

	This script resolves an issue where sending an XPS2GDI print job (ie MS Photos or Edge)
	to a printer with authentication enabled causes a spooling error, jamming the queue.
	While this can be manually enabled on print servers, mobile devices (like laptops) will ignore 
	to save battery, unless enabled via PowerShell script.
	
	This script does not require elevation, but does require that the user has authorization
	to connect to the print server.
	
	Thanks to Jonathan Black for assistance in debugging.
	
	Author: Mat Fairchild
	
	Version: 1.0.2
	
	CHANGELOG:
	- Switched Write-Host to Read-Host to pause the script so user can actually read confirmation messages
	- Included more detailed comment explaining the use of the printers variable
	- Comments broadened for use by other orgs
	- Included experimental exception catch for "Access Denied" (untested) ln 59, 63-64 

#>


$server = "" # Set this to your print server's name

# add your printers' share name here, wrapped in ""
# like so: $printers = @("example-printer-01", "example-printer-02")
$printers = @()

# or let this pick everything that has "KMB" in it (assumes your printers are Konica Minolta)
# "KMB" can be replaced with any string that is common to your printer sharenames
# such as "*HP*", "*Xerox*", etc. Be sure to leave wrapped in "quotes" and *asterisks*
if (-not $printers) {
	try {
   $printers = Get-Printer -ComputerName $server |
               Where-Object { $_.Name -like "*KMB*" } |
               Select-Object -ExpandProperty Name
}
	catch {
	Write-Warning "Match not Found. Please check $server spelled correctly."
	Read-Host "Press 'Enter' to exit"
	exit
	}
}

# debug
#Write-Host $printers


		
# Enable Client Side Rendering
# Does not currently catch "Access Denied" errors
foreach($printer in $printers) {
	try{
		Invoke-Command -ComputerName $server -ScriptBlock {
		Set-Printer -Name $using:printer -RenderingMode CSR -ErrorAction Stop
		}
		Write-Host "$printer enabled CSR"
	}
	catch [System.UnauthorizedAccessException] {
		Write-Error "User does not have authorization for $server."
		Write-Warning "Printer $printer did not enable CSR."
	}
}

Read-Host "Press 'Enter' to exit"