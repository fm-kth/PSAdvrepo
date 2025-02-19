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
<# Using code from the `AddUser.ps1` file Create a function named `Add-CourseUser` that:
    # Has five parameters
        # DatabaseFile (Default value `$PSScriptRoot\MyLabFile.csv`)
        # Name (type [string], mandatory)
        # Age (type [int], mandatory)
        # Color (has a validateset 'red', 'green', 'blue', 'yellow', mandatory)
        # UserID (If none is given - generate one automatically)
    # Adds the given user to the database file
#>
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



#################
<#
 Using code from the `GetUser.ps1` file Create a function named `Remove-CourseUser` that:
  - Has parameter `DatabaseFile` with a default value of `$PSScriptRoot\MyLabFile.csv`
  - Using `SupportsShouldProcess` and `ConfirmImpact` Asks the user for confirmation, and based on the answer
    - Deletes the user
    - Outputs "Did not remove user $($RemoveUser.Name)"

#>
function Remove-CourseUser {
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param (
        $DatabaseFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv"
    )
    
    $MyUserList = Get-Content -Path $DatabaseFile | ConvertFrom-Csv
    $RemoveUser = $MyUserList | Out-GridView -OutputMode Single #-PassThru 
    $RemoveUser
    

    if ($PSCmdlet.ShouldProcess($RemoveUser.name))
    {
        Write-Output "$RemoveUser true"
        $MyUserList = $MyUserList | Where-Object {
            -not (
                $_.Name -eq $RemoveUser.Name -and
                $_.Age -eq $RemoveUser.Age -and
                $_.Color -eq $RemoveUser.Color -and
                $_.Id -eq $RemoveUser.Id
            )
        }
        Set-Content -Value $($MyUserList | ConvertTo-Csv -notypeInformation) -Path $MyUserListFile
    }
    else
    {
        Write-Output "$RemoveUser false"
        "Did not remove user $($RemoveUser.Name)"
        # Code that should be processed if doing a WhatIf operation
        # Must NOT change anything outside of the function / script
    }
    Get-Content -Path $DatabaseFile
    }

   <#
    [flags()] enum mybitflagenum {

        red = 1
        blue = 2
        green = 4
        yellow = 8
    }

    [mybitflagenum]5
    
    #>

<#- Create an Enum called `ColorEnum` with the values `red`, `green`, `blue`, `yellow`.
  - Remove the ValidateSet on the `Color` parameter, in the `Add-CourseUser` function
  - Cast the parameter `Color` as type `ColorEnum`
  - Verify that tab completion still behaves as expected.
#>

    enum ColorEnum {
    red 
    green
    blue
    yellow

    }

    function Add-CourseUser {
        [CmdletBinding()]
        Param (
            $DatabaseFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv",
    
            [Parameter(Mandatory)]
            [string]$Name,
    
            [Parameter(Mandatory)]
            [Int]$Age,
    
            [Parameter(Mandatory)]
            [ColorEnum]$Color,
            #[ValidateSet('red', 'green', 'blue', 'yellow')]
            #[string]$Color,
    
            $UserID = (Get-Random -Minimum 10 -Maximum 100000)
        )
        
        $MyCsvUser = "$Name,$Age,$Color,$UserId"
        
        $NewCSv = Get-Content $DatabaseFile -Raw
        $NewCSv += $MyCsvUser
    
        Set-Content -Value $NewCSv -Path $DatabaseFile
        # läs den nya filen
        Get-Content -Path $DatabaseFile
        # compare-object -ReferenceObject $DatabaseFile -DifferenceObject  $MyCsvUser
    } 

 