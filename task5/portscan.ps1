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

$iprange = Read-Host -Prompt 'Enter the IP(s) to scan: '
$ports = Read-Host -Prompt 'Enter port(s) to scan: '

$portlist = @()

if ($ports -match "-") {
    $splitports = $ports -split "-"
    $sp = [int]$splitports[0]
    $ep = [int]$splitports[1] + 1
    For ($i = $sp; $i -lt $ep; $i ++) {
        $portlist += $i
    }
} elseif ($ports -match ",") {
    $splitports = $ports -split ","
    foreach ($p in $splitports) {
        $portlist += [int]$p
    }    
} else {
    $portlist += [int]$ports
}

if ($iprange -match "-") {
    #range
    getRange($iprange)
} elseif ($iprange -match "/") {
    #cidr
    getCidr($iprange)
} else{
    Add-Content "iplist.txt" $iprange
}

"Scanning " + $iprange + ": port(s) " + $ports
foreach($ip in Get-Content .\"iplist.txt") {
    foreach ($p in $portlist){
        $con = (new-object net.sockets.tcpclient);

        try { $con.BeginConnect($ip, $p, $null, $null) >$null 2>&1} catch {}
        Start-Sleep -milli 1250

        if ( $con.Connected -eq "True") {
            $ostr = $ip + ":" + $p + " OPEN"
            Write-Output($ostr)
            $con.Dispose();
        }
    }
}

Remove-Item -Path .\"iplist.txt"