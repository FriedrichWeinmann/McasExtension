function Get-McasExAlert
{
<#
	.SYNOPSIS
		Search for alerts in MCAS.
	
	.DESCRIPTION
		Search for alerts in MCAS.
		Wrapper around Get-McasAlert with automatic paging.
	
	.PARAMETER Identity
		Specific event ID to search for, rather than specifying a filter condition.
	
	.PARAMETER SortBy
		How should the results be sorted (server side ordering)
	
	.PARAMETER SortDirection
		In which direction should results be sorted.
	
	.PARAMETER ResultSetSize
		This parameter is ignored.
	
	.PARAMETER Skip
		How many items should initially be skipped?
	
	.PARAMETER PeriodicWriteToFile
		Periodically writes the activities returned in JSON format to a specified file. Useful for large queries. (Example: -PeriodicWriteToFile "C:\path\to\file.txt").
	
	.PARAMETER Severity
		Limits the results by severity. Possible Values: 'High','Medium','Low'.
	
	.PARAMETER ResolutionStatus
		Limits the results to items with a specific resolution status. Possible Values: 'Open','Dismissed','Resolved'.
	
	.PARAMETER UserName
		Limits the results to items related to the specified user/users, such as 'alice@contoso.com','bob@contoso.com'.
	
	.PARAMETER AppId
		Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
	
	.PARAMETER AppName
		Limits the results to items related to the specified service names, such as 'Office_365' and 'Google_Apps'.
	
	.PARAMETER AppIdNot
		Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).
	
	.PARAMETER AppNameNot
		Limits the results to items not related to the specified service names, such as 'Office_365' and 'Google_Apps'.
	
	.PARAMETER Policy
		Limits the results to items related to the specified policy ID, such as 57595d0ba6b5d8cd76d6be8c.
	
	.PARAMETER Risk
		Limits the results to items with a specific risk score. The valid range is 1-10.
	
	.PARAMETER Source
		Limits the results to items from a specific source.
	
	.PARAMETER Read
		Limits the results to read items.
	
	.PARAMETER Unread
		Limits the results to unread items.
	
	.PARAMETER Limit
		Only return alerts that happened after this timestamp.
		Supports time-relative notations, such as "-3d" to get the last 3 days.
	
	.PARAMETER Credential
		Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
	
	.EXAMPLE
		PS C:\>Get-MCASExAlert -Identity 572caf4588011e452ec18ef0

		Retrieve a single alert record using the GUID.
	
	.EXAMPLE
		PS C:\> Get-MCASExAlert -ResolutionStatus Open -Severity High | Convert-McasExAlert
	
		Retrieve all severity "High" alerts that are still open, then convert them into a more accessible format.
#>
	[CmdletBinding(DefaultParameterSetName = 'filter')]
	param (
		[Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'identity')]
		[string]
		$Identity,
		
		[Parameter(ParameterSetName = 'filter')]
		[string]
		$SortBy,
		
		[Parameter(ParameterSetName = 'filter')]
		[ValidateSet('Ascending','Descending')]
		[string]
		$SortDirection,
		
		[Parameter(ParameterSetName = 'filter')]
		[int]
		$ResultSetSize,
		
		[Parameter(ParameterSetName = 'filter')]
		[int]
		$Skip,
		
		[Parameter(ParameterSetName = 'filter')]
		[string]
		$PeriodicWriteToFile,
		
		[Parameter(ParameterSetName = 'filter')]
		[ValidateSet('High', 'Low', 'Medium')]
		[string[]]
		$Severity,
		
		[Parameter(ParameterSetName = 'filter')]
		[ValidateSet('Dismissed', 'Open', 'Resolved')]
		[string[]]
		$ResolutionStatus,
		
		[Parameter(ParameterSetName = 'filter')]
		[string[]]
		$UserName,
		
		[Parameter(ParameterSetName = 'filter')]
		[int[]]
		$AppId,
		
		[Parameter(ParameterSetName = 'filter')]
		[string[]]
		$AppName,
		
		[Parameter(ParameterSetName = 'filter')]
		[int[]]
		$AppIdNot,
		
		[Parameter(ParameterSetName = 'filter')]
		[string[]]
		$AppNameNot,
		
		[Parameter(ParameterSetName = 'filter')]
		[string[]]
		$Policy,
		
		[Parameter(ParameterSetName = 'filter')]
		[int[]]
		$Risk,
		
		[Parameter(ParameterSetName = 'filter')]
		[string]
		$Source,
		
		[Parameter(ParameterSetName = 'filter')]
		[switch]
		$Read,
		
		[Parameter(ParameterSetName = 'filter')]
		[switch]
		$Unread,
		
		[Parameter(ParameterSetName = 'filter')]
		[PSFDateTime]
		$Limit,
		
		[PSCredential]
		$Credential
	)
	
	begin {
		$skip = 0
		$parameters = $PSBoundParameters | ConvertTo-PSFHashtable -Exclude Identity, ResultSetSize, Skip
	}
	
	process {
		$currentParameters = $parameters
		if ($Identity) { $currentParameters = $PSBoundParameters | ConvertTo-PSFHashtable -Include Credential, Identity }
		
		do {
			$alerts = Get-MCASAlert @currentParameters -ResultSetSize 100 -Skip $skip
			if (-not $alerts) { return }
			
			$last = ConvertFrom-MCASTimestamp $alerts[-1].Timestamp
			
			if ($Limit -and $last -lt $Limit) {
				$alerts | Where-Object { (ConvertFrom-MCASTimestamp $_.Timestamp) -gt $Limit }
				return
			}
			$alerts
			$skip = $skip + 100
		}
		while ($true)
	}
}