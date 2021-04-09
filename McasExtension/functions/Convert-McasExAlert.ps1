function Convert-McasExAlert {
<#
	.SYNOPSIS
		Converts / Processes an alert object for greater convenience.
	
	.DESCRIPTION
		Converts / Processes an alert object for greater convenience.
		Expects the output of Get-MCASAlert or Get-McasExAlert.
	
		Resolves timestamps, flattens out the data structure and resolves files if present.
	
	.PARAMETER Alert
		The alert object to process.
	
	.EXAMPLE
		PS C:\> Get-McasExAlert -Limit '-2d' | Convert-McasExAlert
	
		Retrieve the alerts of the last two days and convert them into something readable.
#>
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true)]
		$Alert
	)
	
	process {
		foreach ($alertObject in $Alert) {
			$app = ($alertObject.entities | Where-Object type -eq 'service').label
			$file = ($alertObject.entities | Where-Object type -eq 'file').id
			
			$fileDetails = $null
			if ($file) { $fileDetails = Get-MCASFile -Identity $file }
			
			[pscustomobject]@{
				PSTypeName = 'Mcas.Alert'
				ID		   = $alertObject._id
				Timestamp  = ConvertFrom-MCASTimestamp $alertObject.timestamp
				Title	   = $alertObject.title
				PolicyName = $alertObject.Policy.Label
				PolicyType = $alertObject.Policy.PolicyType
				
				Status	   = $alertObject.statusValue
				Severity   = $alertObject.severityValue
				ThreatScore = $alertObject.ThreatScore
				Url	       = $alertObject.URL
				
				Proxy	   = ($alertObject.Entities | Where-Object type -eq discovery_stream).Label
				Service    = ($alertObject.Entities | Where-Object type -eq service).Label
				Accounts   = ($alertObject.Entities | Where-Object type -eq account).Label
				AccountMail = ($alertObject.Entities | Where-Object type -eq account).em
				IP		   = ($alertObject.Entities | Where-Object type -eq ip).Label
				Country    = ($alertObject.Entities | Where-Object type -eq country).Label
				DiscoveryService = ($alertObject.Entities | Where-Object type -eq discovery_service).Label
				DiscoveryIP = ($alertObject.Entities | Where-Object type -eq discovery_ip).Label
				DiscoveryUser = ($alertObject.Entities | Where-Object type -eq discovery_user).Label
				DiscoveryStream = ($alertObject.Entities | Where-Object type -eq discovery_stream).Label
				
				FileName   = $fileDetails.name
				FilePath   = $fileDetails.alternateLink
				FileOwner  = $fileDetails.ownerAddress
				FileCreatedDate = $(if ($file) { ConvertFrom-MCASTimestamp $fileDetails.createdDate })
				FileModifiedDate = $(if ($file) { ConvertFrom-MCASTimestamp $fileDetails.modifiedDate })
				FileStatus = $(if ($file) { $fileDetails.fileStatus[1] })
				FileAccessLevel = $(if ($file) { $fileDetails.fileAccessLevel[1] })
			}
		}
	}
}