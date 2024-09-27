# PrinterCSRTool
PowerShell script which forces Client-Side Rendering for networked printers that require authentication


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
