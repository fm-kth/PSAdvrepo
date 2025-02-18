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
        [int]$OlderThan = '65'
        #$OlderThan default  '65'
    )
    
        $Result = GetUserData
 
        
        # if (-not [string]::IsNullOrEmpty($Name)) {
         if (($Name)::IsNullOrEmpty) {
            $Result = $Result | Where-Object -Property Name -Like "*$Name*"
        }
        
        if ($OlderThan) {
            $Result = $Result | Where-Object -Property Age -ge $OlderThan
       
    
        $Result
        
    }
}



###################


function Add-CourseUser {
    [CmdletBinding()]
    Param (
        $DatabaseFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv",

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [Int]$Age,

        [Parameter(Mandatory)]
        [ValidateSet('red', 'green', 'blue', 'yellow')]
        [string]$Color,

        $UserID = (Get-Random -Minimum 10 -Maximum 100000)
    )
    
    $MyCsvUser = "$Name,$Age,$Color,$UserId"
    
    $NewCSv = Get-Content $DatabaseFile -Raw
    $NewCSv += $MyCsvUser

    Set-Content -Value $NewCSv -Path $DatabaseFile
    # läs den nya filen
    Get-Content -Path $DatabaseFile
    #     compare-object -ReferenceObject $DatabaseFile -DifferenceObject  $MyCsvUser
} 