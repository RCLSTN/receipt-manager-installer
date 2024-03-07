import os
import requests

# GitHub raw content URL for the file
github_raw_url = 'https://raw.githubusercontent.com/RCLSTN/python-escpos/master/src/escpos/printer.py'

# Path to copy the file to
destination_path = os.path.dirname(__import__('escpos').__file__)

# Extract the file name from the URL
file_name = os.path.basename(github_raw_url)

# Download the file from GitHub
response = requests.get(github_raw_url)
if response.status_code == 200:
    # Path to the destination file
    destination_file_path = os.path.join(destination_path, file_name)

    # Write the content directly to the destination file
    with open(destination_file_path, 'wb') as file:
        file.write(response.content)

    print(f"File '{file_name}' overwritten in '{destination_path}'")

else:
    print(f"Failed to download the file from '{github_raw_url}'. Status code: {response.status_code}")
