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
    $parsed = $iprange -split "-"
    $startip = $parsed[0]
    $endip = $parsed[1]
    $a = iptoint($startip)
    $b = iptoint($endip)
    $b ++
    For ($i = $a; $i -lt $b; $i ++){
        $ipval = inttoip($i)
        addToList($ipval)
    }
}

function getCidr {
    param($cidrstr)
    $parsed = $cidrstr -split "/"
    $startip = $parsed[0]
    $cidr = $parsed[1]
    $a = 32 - [int]($cidr)
    $b = [Math]::Pow(2,$a)
    $c = iptoint($startip)
    For ($i = 0; $i -lt $b; $i ++) {
        $num = $c + $i
        $ipval = inttoip($num)
        addToList($ipval)1
    }
}

$iprange = Read-Host -Prompt 'Enter the IP range to sweep: '
if ($iprange -match "-") {
    #range
    getRange($iprange)
} else {
    #cidr
    getCidr($iprange)
}

"Scanning"
foreach($ip in Get-Content .\"iplist.txt") {
    $con = Test-Connection $ip -Quiet -Count 1
    if ($con) {
        $upstr = [string]$ip + " is up"
        Write-Output($upstr)
    }
}

Remove-Item -Path .\"iplist.txt"