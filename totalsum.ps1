$input = Get-Content C:\work\1.txt
$array = @()
$input | foreach-object {
    $writeobj = $false
    $obj = New-Object System.Object
    If ($_ -match 'CustomerId*') {
        $CustomerId = ($_ -split 'CustomerId:' -split 'downloaded')[1]
    }
    If ($_ -match 'Size*') {
        $Size = ($_ -split 'Blah Size:' -split 'bytes')[1]
        $Size=[Double] $Size
        $writeobj = $true
    }
    If ($writeobj){
        $obj | Add-Member -type NoteProperty -name CustomerId -value $CustomerId
        $obj | Add-Member -type NoteProperty -name Total_bytes -value $Size 
        $array += $obj
    }
    $array1=$array | Group-Object CustomerId | %{
    New-Object psobject -Property @{
        CustomerId = $_.Name
        Total_bytes = ($_.Group | Measure-Object Total_bytes -Sum).Sum
        
    }
}}

$array1
