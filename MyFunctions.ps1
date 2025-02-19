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


    <#
  - Create a class, `User`, with the same properties as your database user
  - Add a constructor to set the properties directly when instantiating the class
  - Add an override of the ToString() Method to output the user as csv, matching the contents of `MyLabFile.csv`
  - Replace the `$MyCsvUser = "$Name,$Age,{0},{1}" -f $Color, $UserId` line in the `Add-CourseUser` function with the newly created class and ToString() method

# Expected outcome
#>
 
<# taken enum from above
enum ColorEnum {
    red 
    green
    blue
    yellow

    }
#>

# class
    class User {
        [string] $Name
        [int] $Age
        [ColorEnum] $Color 
        [int] $Id
    
        # constructor 
        Participant([String]$Name, [int]$Age, [ColorEnum]$Color, [int]$Id) {
            $This.Name = $Name
            $This.Age = $Age
            $This.Color = $Color
            $This.Id = $Id
        }
        
        # string
        [string] ToString() {
            Return '{0},{1},{2},{3}' -f $This.Name, $This.Age, $This.Color, $This.Id
            #Return $This.Name, $This.Age, $This.Color, $This.Id
        }
    }
  
    <#    
    $MyNewUser = [Participant]::new($Name, $Age, $Color, $UserId)
    $MyCsvUser = $MyNewUser.ToString() 
    
    $NewCSv = Get-Content $DatabaseFile -Raw
    $NewCSv += $MyCsvUser

    Set-Content -Value $NewCSv -Path $DatabaseFile#>

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
        
        $MyNewUser = [User]::new($Name, $Age, $Color, $UserId)
        #$MyNewUser = [User]::new($Name, $Age, $Color)
        $MyCsvUser = $MyNewUser.ToString() 
        Write-Output $MyCsvUser  
       # $MyCsvUser = "$Name,$Age,$Color,$UserId"
        
        $NewCSv = Get-Content $DatabaseFile -Raw
        $NewCSv += $MyCsvUser
    
        Set-Content -Value $NewCSv -Path $DatabaseFile
        # läs den nya filen
        Get-Content -Path $DatabaseFile
        # compare-object -ReferenceObject $DatabaseFile -DifferenceObject  $MyCsvUser
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
    
            $UserID = (Get-Random -Minimum 10 -Maximum 100000)
        )
        
        $MyNewUser = [Participant]::new($Name, $Age, $Color, $UserId)
        $MyCsvUser = $MyNewUser.ToString() 
        
        $NewCSv = Get-Content $DatabaseFile -Raw
        $NewCSv += $MyCsvUser
    
        Set-Content -Value $NewCSv -Path $DatabaseFile
    }
    

    #04 regex
    # KOlla efter regex i ps untitled
    # '\p{L}' # Latin1

    $pattern = 'error'
    $logpath = 'C:\Users\fm\AppData\Local\Microsoft_Corporation\'
    Get-ChildItem -Path $logpath -Recurse | Select-String -Pattern $pattern -AllMatches

   # -match # boolean eller -cmatch
   #    [regex]::Match() case sensitive!!!
   # [regex]::Matches()

   [regex] | get-member

   [regex]::Escape(
    #skyddar tecken o match
   )

   function get-stuff {
    [CmdletBinding()]
    param (
        [ValidatePattern] # errormessage = 'information use a-z')
        [string]$Name
    )
   }
   
   <#Open the file in your repo named `MyFunctions.ps1` in VSCode.

- In the function `Add-CourseUser`, Add regex parameter validation for the parameter `Name` to make sure:
  - Name starts with a capital letter
  - Name consists of only word characters, hyphens, and spaces
    - [Read why this is a generally bad, yet very common practice](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
  - Has a good error message for erroneous input.

- Create a new function called `Confirm-CourseID` that reads the user database using the `GetUserData` function, and validates all ID's consists of numbers only.
  - Make it output any users with erroneous ID.

# Expected outcome
 
An example of the outcome from these labs may be found in the file `MyFunctions.ps1` in this folder, in the `Add-CourseUser` and `Confirm-CourseID` functions.#>

   function Add-CourseUser {
    [CmdletBinding()]
    Param (
        $DatabaseFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv",

        [Parameter(Mandatory)]
        #[ValidatePattern({'^[A-Z][\w\-\s]*$'}, ErrorMessage = 'Name format is bad!')]
        #[ValidatePattern({'^[A-Z][\p{L}]$'}, ErrorMessage = 'Name format is bad!')]
        #[ValidatePattern({'^[A-Z][\w\-\s]*$'}, ErrorMessage = 'Name is in an incorrect format')]

        [ValidatePattern("^[A-z0-9 ]*$",ErrorMessage = 'Name format is bad!')]
        [string]$Name,

        [Parameter(Mandatory)]
        [Int]$Age,

        [Parameter(Mandatory)]
        [ColorEnum]$Color,

        $UserID = (Get-Random -Minimum 10 -Maximum 100000)
    )
    
    $MyNewUser = [Participant]::new($Name, $Age, $Color, $UserId)
    $MyCsvUser = $MyNewUser.ToString() 
    
    $NewCSv = Get-Content $DatabaseFile -Raw
    $NewCSv += $MyCsvUser

    Set-Content -Value $NewCSv -Path $DatabaseFile
}

<#Create a new function called `Confirm-CourseID` that reads the user database using the `GetUserData` function, and validates all ID's consists of numbers only.
  - Make it output any users with erroneous ID.

# Expected outcome
 
An example of the outcome from these labs may be found in the file `MyFunctions.ps1` in this folder, in the `Add-CourseUser` and `Confirm-CourseID` functions.
#>

function GetUserData {
    $MyUserListFile = "C:\Users\fm\PSAdvrepo\Labfiles\MyLabFile.csv"
    $MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
    $MyUserList
    }

function Confirm-CourseID {
    Param()

    $AllUsers = GetUserData

    foreach ($User in $AllUsers) {
        if ($User.Id -notmatch '^\d+$') {
            Write-Output "User $($User.Name) has mismatching id: $($User.Id)"
        }
    }
}
