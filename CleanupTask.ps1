<# Original script from http://foxdeploy.com/2015/01/11/automatically-delete-old-iis-logs-w-powershell/  #>

#==============================================================================================================================
# Variables to populate
#==============================================================================================================================
    $LogPath = "C:\Windows\System32\Logs\"	        		# Enter log file location
    $RecursiveScan = $false					                # Change to "$true" to scan sub-folders and "$false" to skip them
    $FileType = "*.log"						                # File type to target for cleanup
    $MaxDaysToKeep = -120 				                	# Enter negative number of days to target
    $OutputPath = "C:\CleanupTask\Cleanup_Old_logs.log"		# CleanupTask log file location
#==============================================================================================================================

# Check for old log files
If ($RecursiveScan -eq $true) {
    $ItemsToDelete = dir $LogPath -Recurse -File $FileType | Where LastWriteTime -lt ((get-date).AddDays($MaxDaysToKeep))
} Else {
	$ItemsToDelete = dir $LogPath -File $FileType | Where LastWriteTime -lt ((get-date).AddDays($MaxDaysToKeep))
}

If ($ItemsToDelete.Count -gt 0) {
	"$(get-date) - Starting Cleanup" | Add-Content $OutputPath
    ForEach ($Item in $ItemsToDelete) {
        "$($Item.FullName) is older than $MaxDaysToKeep days = $((get-date).AddDays($MaxDaysToKeep)) and will be deleted" | Add-Content $OutputPath
        Get-Item $Item.FullName | Remove-Item -Verbose
    }
} Else {
    "No items to be deleted today $($(Get-Date).DateTime)" | Add-Content $OutputPath
}

Write-Output "Cleanup of log files older than $((Get-Date).AddDays($MaxDaysToKeep)) completed."
Start-sleep -Seconds 10
