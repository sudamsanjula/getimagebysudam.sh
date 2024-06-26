I made a script that downloads and reports on all of the user-specified image types, e.g., png, jpg, jpeg, and gif, at a user-provided URL.The script's primary purpose is to fetch and organize image files (.jpg, .jpeg, .gif, .png) from a given URL. It handles input validation, manages downloads, provides a summary of downloaded images, and optionally creates a zip archive of downloaded images.

**Script Functionality.**
•	Prompt the user once for a URL and an image file type (e.g., jpg, jpeg, gif, png).
•	Scan and download only images of types .jpg, .jpeg, .gif, and .png from the specified URL.
•	Ensure that duplicate images, which may appear multiple times within the HTML content of the URL, are neither downloaded nor included in final statistics or summaries.
•	Handle scenarios where no allowed image files (.jpg, .jpeg, .gif, .png) are found at the URL. Inform the user with an appropriate message and gracefully exit the script.
•	Create a directory with a unique name based on the current timestamp to store downloaded images. Ensure this directory naming and creation are handled by the script.
•	Once images are downloaded (if any), display:
o	Total count of unique image files downloaded (excluding duplicates).
o	Name of the directory where images are stored.
o	Tabulated summary listing each image file's name and size on disk in bytes, kilobytes, or megabytes as applicable.
•	Implement an optional -z flag using getopts to allow the user to create a zip archive of downloaded images.
•	After creating the zip archive, inform the user of its successful creation and its location as part of the final summary output.
•	Ensure full input validation:
   o	Validate command line options to handle only -z as a valid flag.
   o	Validate the image file type input against a predefined list (.jpg, .jpeg, .gif, .png).
   o	Provide appropriate error messages and exit codes for invalid inputs to maintain script integrity.
•	Terminate the script gracefully with appropriate exit codes in case of errors or invalid inputs to maintain user experience and script reliability.

**Use Case Example:**
Imagine a scenario where a user wants to download all jpg images from a photography website. They would run your script, enter the URL of the website along with the image type (jpg), and optionally include the -z flag to create a zip archive of the downloaded images. The script would then fetch the HTML content, identify and download unique jpg images, store them in a timestamped directory, and provide a summary of the downloaded images including their names and sizes.

**Summary:**
In summary, this script automates the process of fetching, filtering, downloading, and archiving images from a specified URL. It handles user input validation, provides clear feedback and reporting, and offers the convenience of creating a zip archive for downloaded images. This makes it useful for tasks requiring batch image retrieval and organization from web sources. With its structured approach and error handling, the script ensures a reliable execution while maintaining user transparency through detailed output and color-coded messages.
