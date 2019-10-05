function iptoint () { 
    param ($ip) 
   
    $oc = $ip.split(".")
    $firstoc =  [int64]$oc[0]*16777216
    $secoc = [int64]$oc[1]*65536
    $thiroc = [int64]$oc[2]*256
    $frthoc = [int64]$oc[3]
    $fin = [int64]($firstoc + $secoc + $thiroc + $frthoc)
    return $fin 
  } 
   
function inttoip() { 
    param ([int64]$int) 
  
    return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
} 

function addToList() {
    param ($ip)
    Add-Content "iplist.txt" $ip
}

function getRange {
    param($iprange)
    $iprange
    $parsed = $iprange -split "-"
    $startip = $parsed[0]
    $endip = $parsed[1]
    $startip
    $endip
    $a = iptoint($startip)
    $b = iptoint($endip)
    $b ++
    For ($i = $a; $i -lt $b; $i ++){
        $ipval = inttoip($i)
        addToList($ipval)
    }
}

$iprange = Read-Host -Prompt 'Enter the IP range to sweep: '
if ($iprange -match "-") {
    #range
    Write-Output("range")
    getRange($iprange)
} else {
    #cidr
    Write-Output("CIDR")
}

