# This script creates a file called "canary.txt" in the temp directory,
# and then enters an infinite loop that checks for the presence of the file every 60 seconds.
# If the file is present, it prints a message to the console indicating that the canary file has been detected. 

# It also calculates the hash of the file using the sha256sum command, 
# and compares it to the initial hash that was calculated when the file was first created. 
# If the hashes do not match, it prints a message to the console indicating that the canary file has been modified. 
# If the file is not present, it prints a message to the console indicating that the canary file has not been detected.


# Set the path to the temp directory
temp_path="/tmp/canary.txt"

# Create the canary file
touch "$temp_path"

# Get the initial hash of the canary file
initial_hash=$(sha256sum "$temp_path" | awk '{print $1}')

# Check for the canary file and for changes to it every 60 seconds
while true; do
  # Check for the canary file
  if [ -f "$temp_path" ]; then
    echo "Canary file detected: $temp_path"

    # Check for modifications to the canary file
    current_hash=$(sha256sum "$temp_path" | awk '{print $1}')
    if [ "$current_hash" != "$initial_hash" ]; then
      echo "Detected modification to canary file: $temp_path"
    fi
  else
    echo "Canary file not detected: $temp_path"
  fi

  # Sleep for 60 seconds before checking again
  sleep 60
done
