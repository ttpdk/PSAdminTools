<#
    .SYNOPSIS 
    IPAddressConversion tools

    Various Powershell-functions for handling ipaddresses. Conversion from binary to decimal address. Calculation of number of subnet bits with more to come.

    Thomas Petersen
    ps-git@ttp.dk
    http://ttp.dk

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

    Version 1.0.1, Narch 17, 2018

    .LINK
    http://ttp.dk

    Revision History
    ----------------------------------------------------------------------------------------------
    1.0.0	Initial release
    1.0.1   Comments updated


    .DESCRIPTION
    The functions are listed below.

    - Get-SubnetNumberOfBits               Returns number of bits for the supokied subnet
    - Convert-IPAdderessBinaryToDecimal    Converts binary ipaddress (32bit) to decimail ipaddress

    .EXAMPLES
    Get-SubnetNumberOfBits 255.255.248.0
      # Returns number of bits for the supokied subnet.

    Convert-IPAdderessBinaryToDecimal '11111111111111111111111000001100'
      # Converts binary ipaddress (32bit) to decimail ipaddress

#>
function Get-SubnetNumberOfBits {
    # Usage: Get-SubnetNumberOfBits 255.255.255.0
    # Returns 24

    Param(
        [Parameter(Mandatory = $true)]
        [array] $Subnet
    )

    $Octets = $Subnet -split "\."
    $SubnetInBinary = @()
    foreach ($Octet in $Octets) {
        #convert to binary
        $OctetInBinary = [convert]::ToString($Octet, 2)

        #get length of binary string add leading zeros to make octet
        $OctetInBinary = ("0" * (8 - ($OctetInBinary).Length) + $OctetInBinary)

        $SubnetInBinary = $SubnetInBinary + $OctetInBinary
    }
    $SubnetInBinary = $SubnetInBinary -join ""
    $SubnetBits=$SubnetInBinary.trim('0')
    if ($SubnetBits -NotLike '*0*') {
        $SubnetInBinary.trim('0').length
        #return $SubnetInBinary.trim('0').length
    }
    else {
        write-host "Invalid subnet"
        return $null
    }
}

function Convert-IPAdderessBinaryToDecimal {
    # Usage: Convert-IPAdderessBinaryToDecimal '11111111111111111111111000001100'
    # Returns 255.255.254.12

    Param(
        [Parameter(Mandatory = $true)]
        [ValidateLength(32, 32)]
        [String]$IPAdderessBinary
    )
    $IP = @()
    For ($x = 1 ; $x -le 4 ; $x++) {
        #Work out start character position
        $StartCharNumber = ($x-1)*8
        #Get octet in binary
        $IPOctetInBinary = $IPAdderessBinary.Substring($StartCharNumber, 8)
        #Convert octet into decimal
        $IPOctetInDecimal = [convert]::ToInt32($IPOctetInBinary, 2)
        #Add octet to IP
        $IP += $IPOctetInDecimal
        # $IP -join "."

    }


    #Separate by .
    $IPAdderessInDecimal = $IP -join "."
    Return $IPAdderessInDecimal
}

Export-ModuleMember -Function 'Get-SubnetNumberOfBits'
Export-ModuleMember -Function 'Convert-IPAdderessBinaryToDecimal'
