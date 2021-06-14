@{
	# Script module or binary module file associated with this manifest
	RootModule = 'McasExtension.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.1'
	
	# ID used to uniquely identify this module
	GUID = '85e85cde-db6c-448a-9837-bb46387c927d'
	
	# Author of this module
	Author = 'Friedrich Weinmann'
	
	# Company or vendor of this module
	CompanyName = 'Microsoft'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) Friedrich Weinmann'
	
	# Description of the functionality provided by this module
	Description = 'Additional tools for interacting with Microsoft CloudApp Security built on top of the MCAS module'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName = 'PSFramework'; ModuleVersion = '1.6.201' }
		@{ ModuleName = 'MCAS'; ModuleVersion = '3.3.8' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\McasExtension.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\McasExtension.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\McasExtension.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'Convert-McasExAlert'
		'Get-McasExAlert'
		'Get-McasExMalwareFileActivity'
	)
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Mcas')
			
			# A URL to the license for this module.
			LicenseUri = 'https://github.com/FriedrichWeinmann/McasExtension/blob/master/LICENSE'
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/FriedrichWeinmann/McasExtension'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}