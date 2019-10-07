# auditlab3
Network enumeration scripts for CSEC 465 - lab #3

## Usage Instructions

### Task2  
The filename argument is the path to a file containing a (newline separated) list of IP addresses  
Usage:  
```
$./dnsLookup.sh <filename>
```

### Task3  
Usage:   
```
PS C:\\> .\pingsweep.ps1     
Enter the IP range to sweep: 10.1.1.0/24  
```  

### Task4 
Usage:  
```
$./os_classification.sh <file>  
```

### Task5  
The port input can be any of the following:  
 - a comma-separated list, ex: 10, 11, 12  
 - a range (inclusive), ex: 10-12  
 - a single value, ex: 11  
Usage:  
``` 
PS C:\> .\portscan.ps1   
Enter the IP(s) to scan: 10.1.1.0/24
Enter port(s) to scan: <port input>
```  

### Task6  
The depth arg specifies the level depth to call (optional, integer).  
The scope arg allows the user to limit the scope to a specific domain (optional, string).  
Usage:  
``` 
$ python3 email_scraper.py [-h] [-d DEPTH] [-s SCOPE] url 
```
