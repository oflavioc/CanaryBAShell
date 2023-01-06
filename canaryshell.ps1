## Version 1
# This script creates a file called "canary.txt" in the temp directory, 
# and then enters an infinite loop that checks for the presence of the file every 60 seconds. 
# If the file is present, it writes a message to the output indicating that the canary file has been detected. 
# If the file is not present, it writes a message to the output indicating that the canary file has not been detected.

# You can customize this script to suit your needs, such as changing the file path, 
# the file name, or the frequency at which the file is checked. Let me know if you have any questions!

# Set the path to the temp directory
$temp_path = "$env:temp\canary.txt"

# Create the canary file
New-Item -ItemType File -Path $temp_path -Force

# Check for the canary file every 60 seconds
while ($true) {
  if (Test-Path $temp_path) {
    Write-Output "Canary file detected: $temp_path"
  } else {
    Write-Output "Canary file not detected: $temp_path"
  }
  Start-Sleep -Seconds 60
}

_____________________________________________________________________________________________________________________________________________________

# Here is an updated version of the script that includes a function to detect 
# network communications that might be attempting to exfiltrate the canary file:


# Set the path to the temp directory
$temp_path = "$env:temp\canary.txt"

# Create the canary file
New-Item -ItemType File -Path $temp_path -Force

# Check for the canary file every 60 seconds
while ($true) {
  if (Test-Path $temp_path) {
    Write-Output "Canary file detected: $temp_path"
  } else {
    Write-Output "Canary file not detected: $temp_path"
  }

  # Check for network communications that might be exfiltrating the canary file
  if (Check-NetworkActivity -Path $temp_path) {
    Write-Output "Detected network activity involving canary file: $temp_path"
  }

  Start-Sleep -Seconds 60
}

# Function to check for network activity involving a specific file
function Check-NetworkActivity {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )

  # Get a list of network connections
  $connections = Get-NetTCPConnection

  # Filter the list of connections to only include ones that involve the specified file
  $filtered_connections = $connections | Where-Object {$_.LocalAddress -like "*$Path*"}

  # Return $true if there are any matching connections, $false otherwise
  if ($filtered_connections) {
    return $true
  } else {
    return $false
  }
}


# This script includes a function called Check-NetworkActivity that takes a file path 
# as a parameter and returns $true if there are any network connections that involve that file, 
# and $false otherwise. 

# This function uses the Get-NetTCPConnection cmdlet to get a list of all network connections, 
# and then filters the list to include only connections that involve the specified file by checking 
# the LocalAddress property of each connection.

# In the main loop of the script, this function is called with the path to the canary file as a parameter, 
# and if it returns $true, a message is written to the output indicating that network activity involving the canary file has been detected.

_____________________________________________________________________________________________________________________________________________________

# Here is an updated version of the script that includes a function to detect any modifications to the canary file:

# Set the path to the temp directory
$temp_path = "$env:temp\canary.txt"

# Create the canary file
New-Item -ItemType File -Path $temp_path -Force

# Get the initial hash of the canary file
$initial_hash = (Get-FileHash $temp_path).Hash

# Check for the canary file and for changes to it every 60 seconds
while ($true) {
  if (Test-Path $temp_path) {
    Write-Output "Canary file detected: $temp_path"

    # Check for modifications to the canary file
    if (Check-FileModification -Path $temp_path -InitialHash $initial_hash) {
      Write-Output "Detected modification to canary file: $temp_path"
    }
  } else {
    Write-Output "Canary file not detected: $temp_path"
  }

  # Check for network communications that might be exfiltrating the canary file
  if (Check-NetworkActivity -Path $temp_path) {
    Write-Output "Detected network activity involving canary file: $temp_path"
  }

  Start-Sleep -Seconds 60
}

# Function to check for network activity involving a specific file
function Check-NetworkActivity {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )

  # Get a list of network connections
  $connections = Get-NetTCPConnection

  # Filter the list of connections to only include ones that involve the specified file
  $filtered_connections = $connections | Where-Object {$_.LocalAddress -like "*$Path*"}

  # Return $true if there are any matching connections, $false otherwise
  if ($filtered_connections) {
    return $true
  } else {
    return $false
  }
}

# Function to check for modifications to a specific file
function Check-FileModification {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [Parameter(Mandatory=$true)]
    [string]$InitialHash
  )

  # Get the current hash of the file
  $current_hash = (Get-FileHash $Path).Hash

  # Compare the current hash to the initial hash
  if ($current_hash -ne $InitialHash) {
    return $true
  } else {
    return $false
  }
}

# This script includes a function called Check-FileModification that 
# takes a file path and an initial hash of the file as parameters, 
# and returns $true if the file has been modified since the initial hash was taken, 
# and $false otherwise. 

# This function uses the Get-FileHash cmdlet to get the current hash of the file, 
# and then compares it to the initial hash that was passed as a parameter.

# In the main loop of the script, this function is called with the path 
# to the canary file and the initial hash of the file as parameters, 
# and if it returns $true, a message is written to the output indicating that the canary file has been modified.
