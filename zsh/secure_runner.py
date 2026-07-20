#!/bin/sh
# -*- coding: utf-8 -*-
""":"
# -----------------------------------------------------------------------------
# Shell Script Section
# Find the available Python executable and re-execute this script with it.
# -----------------------------------------------------------------------------
if command -v python3 >/dev/null 2>&1; then
    exec python3 "$0" "$@"
elif command -v python >/dev/null 2>&1; then
    exec python "$0" "$@"
elif command -v python2 >/dev/null 2>&1; then
    exec python2 "$0" "$@"
else
    echo "Error: No Python executable (python3, python, or python2) found!" >&2
    exit 1
fi
"""

# =============================================================================
# Python Script Section
# =============================================================================

import os
import sys
import stat
import hashlib
import subprocess
import tempfile

# Handle library differences between Python 3 and Python 2
try:
    # Python 3
    from urllib.request import Request, urlopen
except ImportError:
    # Python 2
    from urllib2 import Request, urlopen

def download_verify_and_execute(url, expected_sha256):
    # Create a secure temporary file to store the downloaded content
    fd, temp_path = tempfile.mkstemp()
    os.close(fd) 

    print("Downloading from: " + url)
    
    # Download the file with a standard User-Agent to prevent basic blocking
    try:
        req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        response = urlopen(req)
        with open(temp_path, 'wb') as f:
            f.write(response.read())
    except Exception as e:
        print("Download failed: " + str(e))
        sys.exit(1)

    # Calculate SHA256 checksum using a memory-efficient chunked approach
    print("Calculating SHA256 checksum...")
    sha256_hash = hashlib.sha256()
    with open(temp_path, "rb") as f:
        # Read the file in 4KB blocks
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    
    calculated_hash = sha256_hash.hexdigest()
    print("Calculated hash: " + calculated_hash)
    
    # Verify if the calculated hash matches the expected one
    if calculated_hash.lower() != expected_sha256.lower():
        print("Error: SHA256 checksum mismatch! Aborting execution.")
        print("Expected: " + expected_sha256)
        os.remove(temp_path) # Clean up the potentially malicious file
        sys.exit(1)
        
    print("Checksum verified successfully. Preparing to execute...\n")
    
    # Grant execution permissions (chmod +x) to the downloaded file
    st = os.stat(temp_path)
    os.chmod(temp_path, st.st_mode | stat.S_IEXEC)
    
    # Execute the file
    print("-" * 40)
    try:
        # subprocess.call will wait for the execution to finish
        subprocess.call([temp_path])
    except Exception as e:
        print("Execution failed: " + str(e))
    finally:
        # Always clean up the temporary file regardless of execution success
        print("-" * 40)
        print("Cleaning up temporary file...")
        if os.path.exists(temp_path):
            os.remove(temp_path)

if __name__ == "__main__":
    # Ensure correct arguments are provided via CLI
    if len(sys.argv) != 3:
        print("Usage: python " + sys.argv[0] + " <URL> <EXPECTED_SHA256>")
        sys.exit(1)
        
    target_url = sys.argv[1]
    target_hash = sys.argv[2]
    
    download_verify_and_execute(target_url, target_hash)
