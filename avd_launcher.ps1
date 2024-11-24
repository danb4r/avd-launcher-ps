# Script to Launch an Android Virtual Device (AVD)

# Automatically get the username
$username = [Environment]::UserName

# Path to Android tools directory, using the username
$emulatorPath = "C:\Users\$username\AppData\Local\Android\Sdk\emulator"
$emulatorExecutable = "emulator.exe"
$avdmanager = "C:\Users\$username\AppData\Local\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat"

# Function to list and select AVDs
function Choose-AVD {
    # Get all AVDs
    $avds = & $avdmanager list avd | Select-String -Pattern "\s*Name:\s+(\S+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    
    if ($avds.Count -eq 0) {
        Write-Host "No AVDs found."
        exit
    }

    # Display AVDs with numeric indices
    Write-Host "Choose an AVD:"
    for ($i = 0; $i -lt $avds.Count; $i++) {
        Write-Host "[$($i+1)] - $($avds[$i])"
    }

    # Get user input and validate it
    $choice = Read-Host "Enter the number corresponding to the AVD"
    $choiceIndex = [int]$choice - 1

    if ($choiceIndex -lt 0 -or $choiceIndex -ge $avds.Count) {
        Write-Host "Invalid selection."
        exit
    }

    return $avds[$choiceIndex]
}

# Select AVD
$selectedAVD = Choose-AVD

# Change directory to where the emulator is located
Set-Location $emulatorPath

# Start the AVD
Start-Process -FilePath $emulatorExecutable -ArgumentList "@$selectedAVD"

# Optionally, you can add a message or wait for the emulator to fully start
Write-Host "Launching AVD: $selectedAVD. Please wait..."
