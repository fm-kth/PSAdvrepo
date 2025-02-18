# Labb 02 functions
$MyUserListFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv"
Get-Content -Path $MyUserListFile | ConvertFrom-Csv


function GetUserData {
$MyUserListFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv"
$MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
$MyUserList
}

#added snippet cmdlet ctrl+shift+p
function Get-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Name,
        
        [Parameter()]
        [int]$OlderThan
        #$OlderThan =  '65'
    )
    
        $Result = GetUserData
 
        
        if (-not [string]::IsNullOrEmpty($Name)) {
            $Result = $Result | Where-Object -Property Name -Like "*$Name*"
        }
        
        if ($OlderThan) {
            $Result = $Result | Where-Object -Property Age -ge $OlderThan
       
    
        $Result
        
    }
}