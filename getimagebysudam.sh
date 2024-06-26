#!/bin/bash
#To colour the outputs and error messages
    blue='\033[0;34m'  #To colour the Image Name header, | and the Size (Bytes)
    green='\033[0;32m' #To colour the image file type, count of the downloaded images and the downloaded directory name.
    red='\033[0;31m'   #To colour the error messages and count of the duplicated image files.
    reset='\033[0m' #To reset the colour  

#Check whether the -z option has been provided. If it has proceed to creata a zip archive
zip_flag=false

#Error message output by getopts command if invalid option passed at command line.
OPTERR="\033[0;31mInvalid option:- Only -z for zip images is valid - exiting.\033[0m" #Module 02 page 28- The echo command

#Process command line options 
if [[ $# -gt 0 ]]; then 
    while getopts "z" opt; do #Only the z option is valid 
        case $opt in 
            z)
                zip_flag=true
                ;; #if z option passed, set variable for later use
            *)
                echo -e "$OPTERR" && 
                exit 1
                ;;
        esac
    done
fi

#After processing options, check for any unexpected non-option arguments
shift $((OPTIND - 1)) #Adjust the position of arguments after getopts has processed the options.
if [ $# -gt 0 ]; then 
    echo -e "\033[0;31mInvalid argument(s) provided. Only -z for zip images is valid - exiting.\033[0m" #echo the error message #Module 02 page 28- The echo command
    exit 1
fi

#Function to remove temporary files on script termination
function cleanup {  
    rm -f temp.html temp_links.txt temp_unique_links.txt #Use rm with -f flag to remove files without prompting confirmations. Removing these files - temp.html temp_links.txt temp_unique_links.txt. #Module 02 page 25- rm command
}

#Prompt user to enter a URL and a image type
read -p "Enter a URL and Image file type-> e.g. jpg, jpeg, gif, png. (e.g. http://somedomain.com jpg): " url img_type #Module 03 page 06- The read command/options, Module 03 page 09- Using read -p for input

#Check user entered URL is valid or not
if [[ ! "$url" =~ ^http[s]?:// ]]; then 
    echo -e "\033[0;31mInvalid URL format entered. Exiting....\033[0m" #Module 02 page 28- The echo command. #Module 03 page 12- Escape Sequences.
    exit 1
fi

#Check user entered image type is valid or not
if [[ ! "$img_type" =~ ^(jpg|jpeg|gif|png)$ ]]; then 
    echo -e "\033[0;31mUnsupported image file type entered. Exiting....\033[0m" #Module 02 page 28- The echo command. Use -e to recognize certain escape sequences. ex- \033[ for ANSI color codes
    exit 1
fi

#Download HTML content
wget -q -O temp.html "$url" || echo -e "Failed to download content." #Module 07 wget page 23.

#Extract unique image links and remove duplicates
grep -o 'http[s]*://[^"]*.'"$img_type" temp.html | sort | uniq > temp_unique_links.txt

echo -e "Scanning for $img_type files at $url ....................."
total_links=$(grep -c 'http[s]*://[^"]*.'"$img_type" temp.html)
unique_links=$(wc -l < temp_unique_links.txt)
echo -e "$total_links \033[0;32m$img_type\033[0m files detected at URL, which includes \033[0;31m$((total_links-unique_links))\033[0m duplicate(s)" #Module 02 page 28- The echo command. #Module 03 page 12- Escape Sequences. Use -e to recognize certain escape sequences. ex- \033[ for ANSI color codes
echo -e "Downloading unique $img_type files ............................................................" #Module 02 page 28- The echo command. #Module 03 page 12- Escape Sequences.

#Create directory for images
dir_name=""$img_type"_$(date +"%Y_%m_%d_%H_%M_%S")"
mkdir "$dir_name" || echo -e "Failed to create directory." 

#To download images
while read -r img_link; do 
    wget -q -P "$dir_name" "$img_link"
done < temp_unique_links.txt #Specify the file name

#Count downloaded images
num_files_downloaded=$(find "$dir_name" -type f | wc -l)
echo -e "\n\033[0;32m$num_files_downloaded\033[0m $img_type file(s) downloaded successfully to the directory \033[0;32m$dir_name\033[0m." #Module 03 page 12- Escape Sequences. #Module 02 page 28- The echo command- Shows count of the downloaded images and the downloaded folder name.

#Summarize downloads in a table format
echo -e "\n\033[0;34mImage Name\t\t\t\t\t   |\tSize (Bytes)\033[0m" #Module 02 page 28- The echo command. #Module 03 page 12- Escape Sequences. Use -e to recognize certain escape sequences. ex- \t for a tab
for img_file in "$dir_name"/*."$img_type"; do 
    if [ -s "$img_file" ]; then 
        file_size=$(du -h "$img_file" | cut -f1)
        printf "%-50s | %8s\n" "$(basename "$img_file")" "$file_size"
    fi
done

#Create a ZIP archive if the -z flag was set
if [ $zip_flag ]; then 
    zip -q -r $dir_name.zip $dir_name #Zip the match file
    echo -e "\n\033[0;32m$unique_links\033[0m $img_type files archived to \033[0;32m$dir_name.zip\033[0m in the \033[0;32m$dir_name\033[0m directory." #Module 03 page 12- Escape Sequences. #Module 02 page 28- The echo command - Shows count of the archived files and zip file name and where the zip file is in.
fi


#Run cleanup function
cleanup

exit 0