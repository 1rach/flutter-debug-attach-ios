#!/bin/zsh



#########################################################################################################################
# FOR INFO
# Observatory is listening on http://127.0.0.1xxxxxxxxx:
# This script will find this url. This url can then be used by flutter attach.
# 
# /!\ This script need to be run before launching the script buildiosdebug.sh /!\
#########################################################################################################################
# Default file will contain the url  "observatoryUri" that will be use by flutter attach in launch.json

# /!\ IMPORTANT /!\
# AJUST TIMEOUT (in seconds) AS YOUR CONVENANCE, BUT TIMEOUT MUST BE LIKE THIS : TIMEOUT > YOUR COMILATION DURATION

# AFTER THIS DURATION, IF THE URL CAN'T BE FOUND, THE SCRIPT STOP.
TIMEOUT=300; #This value must be > time to compile your app in debug mode
#contains the ObservatoryUri url
URL=""; 

# Default file that will contain the url  "observatoryUri" that will be use by flutter attach in launch.json, if not set,  "observatoryUri.txt"
FILE=observatoryUri.txt

FILETOPARSE=~/AndroidStudioProjects/PROD/custom_painter/logtee.txt
#FILETOPARSE=./logtee.txt


STRINGTOSEARCH="Observatory listening on http://127.0.0.1:";
SEARCH=$(grep "$STRINGTOSEARCH" $FILETOPARSE | cut -d ' ' -f 8);







  #HELP
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then 
    echo "";
    echo "COMMAND : geturldebug.sh <filename>";
    echo "";
    echo "ARGUMENTS";
    echo " \033[1;36mfilename\033[0m - name of the file that will contain the url (default filename \033[1;36mobservatoryUri.txt\033[0m will be used if empty).";    
    echo "";
    echo "DESCRIPTION";
    echo "     This script extracts the \033[1;36mObservatoryUri url\033[0m from a log file created by the script \033[1;36mbuildiosdebug.sh\033[0m running in the background. At the end of the script, 
    the \033[1;36mObservatoryUri url\033[0m will be available in the file \033[1;36mfilename\033[0m or in the default file named \033[1;36mobservatoryUri.txt\033[0m. 
    This script has a default timeout (120 seconds) to prevent infinite loop. You can modify this value with the variable \033[1;36mTIMEOUT\033[0m.";
    echo "";
    echo "USAGE";
    echo " 1 - Run this script \033[1;36mgeturldebug.sh\033[0m in one terminal, this script will execute as long as the url is not found or the TIMEOUT is exceeded.";
    echo " 2 - Open a new terminal and run the script \033[1;36mbuildiosdebug.sh\033[0m, this second script will build your flutter app in debug mode (generating a log file wich is analysed by the first script)";
    echo " 3 - Wait ;) , after your app has been built for debug, the \033[1;36mObservatoryUri url\033[0m will be displayed "
    echo " 4 - Attach your favorite debugger to the \033[1;36mObservatoryUri url\033[0m has been found"
    echo "";
    exit 0;
    fi



#############################################################################################################################
#  Check if the script $SCRIPT_BUILDER_DEBUG_APP is not running, $SCRIPT_BUILDER_DEBUG_APP must be launched AFTER this script
#############################################################################################################################
SCRIPT_BUILDER_DEBUG_APP=buildiosdebug.sh

pkill -f ios-deploy;

#Check if the first script has been  launched
#STATUS_OF_SCRIPT_BUILDER=$(pgrep -f $SCRIPT_BUILDER_DEBUG_APP | wc -l);

#if [ "$STATUS_OF_SCRIPT_BUILDER" -gt 0 ]; 
#then 
#    echo "";
#    echo "  \033[0;31m--------------------------------------------- /!\ ERROR ! /!\ ---------------------------------------------------\033[0m";    
#    echo "  The script \033[1;36m$SCRIPT_BUILDER_DEBUG_APP\033[0m is running... STOP IT before continue.";
#    echo ""  
#    echo "  /!\ This script \033[1;36m$0\033[0m must be launched first /!\\ \033[0m";
    
    
    
    ### on kill la sceance debug en cours.... demander une conf ?
#    echo ""
#    echo "  $SCRIPT_BUILDER_DEBUG_APP is running...killing $SCRIPT_BUILDER_DEBUG_APP... "
 
#    pkill -f $SCRIPT_BUILDER_DEBUG_APP
#    while [ "$STATUS_OF_SCRIPT_BUILDER" -gt 0 ]; do 
#    STATUS_OF_SCRIPT_BUILDER=$(pgrep -f $SCRIPT_BUILDER_DEBUG_APP | wc -l);
#        echo -ne "  killing $SCRIPT_BUILDER_DEBUG_APP... - "\\r;
#        sleep 1; 
#        echo -ne "  killing $SCRIPT_BUILDER_DEBUG_APP... \ "\\r;
#        sleep 1; 
#        echo -ne "  killing $SCRIPT_BUILDER_DEBUG_APP... | "\\r;
#        sleep 1; 
#        echo -ne "  killing $SCRIPT_BUILDER_DEBUG_APP... / "\\r;
#        sleep 1; 
#    done
#   echo ""
#   echo "  $SCRIPT_BUILDER_DEBUG_APP is not running, everything OK, LAUNCHING THE WATCHER..."
#   echo ""
    
    ## ET ON NE SORT PAS EN ERREUR !!!!    
    #exit 1;

#else
#    echo "";
#    echo "everything OK, continue..."    
#    sleep 2
#    echo ""
     
#fi



######################################################################################################################################## 
#                                Show parameters
########################################################################################################################################
if [ "$1" != "" ]; then
    FILE="$1";
    echo ""
    echo " FILE (file will contain the debug url)....................[ $FILE ] "
else
    FILE=observatoryUri.txt
    echo ""
    echo " /!\ No filename specified, default filename will be used /!\\";
    echo ""
    echo " FILE (file will contain the debug url)....................[ $FILE ] "
fi
    echo " STRINGTOSEARCH (used to match the debug url)..............[ $STRINGTOSEARCH ]"
    echo " FILETOPARSE (file to scan)................................[ $FILETOPARSE ] "


echo "\n\n"

######################################################################################################################################## 
#                                Delete old files
########################################################################################################################################
# An old file $FILE will be deleted each time this script is launched 
if [ -f "$FILE" ]; then
    echo "/!\ old file found ($FILE) : deleting this file...";
    rm "$FILE";
    echo ">   File $FILE........deleted !";
    echo ""
fi




if [ -f "$FILETOPARSE" ]; then
    echo "/!\ old file found ($FILETOPARSE) : deleting this file...";
    rm "$FILETOPARSE";
    echo ">   File $FILETOPARSE........deleted !";
    echo ""
fi

echo "" > $FILETOPARSE

#scanFileToParse

######################################################################################################################################## 
#                                Recherche et creation de l'url de debug
########################################################################################################################################


n=0; 
isTimeOut="FALSE";


while true; 
do 
   
    #SEARCH=$(grep "$STRINGTOSEARCH" $FILETOPARSE | cut -d ' ' -f 8);
    #echo $SEARCH > $FILE;
    #echo -ne "url trouvee ?? : $SEARCH";

    if grep -q "$STRINGTOSEARCH" $FILETOPARSE; then


    URLDEBUG=${$(grep "$STRINGTOSEARCH" $FILETOPARSE | cut -d ' ' -f 8)} #$FILE
    echo $URLDEBUG > $FILE;

    #URLDEBUG=$(cat $FILE)
    #echo "url trouvee : $URLDEBUG\n\n"; 
        
        break;
    
    
    fi
               
               
               
                echo -ne "  \033[1;36m   Searching port Observatory listening on... - \033[0m"\\r;
                sleep 1; 
                n=$(( $n + 1 ))
                
                echo -ne "  \033[1;36m   Searching port Observatory listening on... \ \033[0m"\\r;
                sleep 1; 
                 n=$(( $n + 1 ))                
                echo -ne "  \033[1;36m   Searching port Observatory listening on... | \033[0m"\\r;
                sleep 1; 
                 n=$(( $n + 1 ))
                echo -ne "  \033[1;36m   Searching port Observatory listening on... / \033[0m"\\r;
                sleep 1; 
                 n=$(( $n + 1 ))



               

   
   if (($n > $TIMEOUT)) 
    then 
    echo "\033[0m";
    echo "n= $n timeou=$TIMEOUT isTimeOut : $isTimeOut"
    isTimeOut="TRUE";
    break; 
    fi

done   


  if [[ $isTimeOut == "TRUE" ]]
    then 
        echo "";
        echo "";
        
        
        
        echo "  \033[0;31m--------------------------------------------- /!\ TIME OUT ERROR ! /!\ ---------------------------------------------------\033[0m";
        echo "  0 - Check if your device is locked"
        echo "  1 - Check if the the app has been created in debug Mode by the script buildiosdebug.sh (did you launched the script buildiosdebug.sh just after launching this script (geturldebug.sh) ? cf. buildiosdebug.sh";
        echo "  2 - Check if the file $FILETOPARSE has been created and contains \\n     the observatoryUri url (see the end of the file)";
        echo "  3 - Check if the file $FILE has been created and contains the observatoryUri url or is empty (this file must \\n     contains the observatoryUri url to debug)";
        echo "  4 - If the these files doesn't contain the url, try to kill these process : lldb* ans ios-deploy and rerun";
        echo "";
        echo "  For help run geturldebug -h";
        echo "  ---------------------------------------------------------------------------------------------------------------------------";
        
        echo "";
        exit 1;
    else

        echo "";
        echo "";
        echo "------------------------\033[0;32m Found debug url ! \033[0m-----------------------------";
         echo "";
        echo "              ObservatoryUri :    \033[1;36m$URLDEBUG\033[0m";
        echo "              Available in file : $FILE";
        echo "              Execution time : $n s";
        echo "";
        echo "          (tips : to quit lldb, press 'q' then 'y' in the terminal running lldb) ";
        echo "-----------------------------------------------------------------------------------------";
        echo "";
        echo "";
        echo "              LAUNCHING DART DEBUGGER IN ATTACH MODE..."
        echo "";
        exit 0;

    fi




