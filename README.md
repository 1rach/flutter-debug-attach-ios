# flutter-debug-attach-ios : How to avoid the famous iOS bug "mDNS lookup failed, attempting fallback to reading device log.Waiting for observatory port to be available..."

I encountered this very annoying bug (impossible to attach my debugger on vscode or Android Studio) on a real IOS device.

This bug appears with IOS > 13.3.1 when working on MacOS.

I decided to find a solution, that's why i created 2 scripts, some vscode tasks, and adapted my launch.json. 

With this solution you can just launch one task in vscode (<CTRL>+<SHIFT>+P by default), and your debugger is launched attaching to your device automaticlly and without bug.

For information, I'm working with last tools : 

* Catalina 10.15.4 with 
* IOS 13.4.1 running on Ipad 7 cellular plug
* Flutter stable 1.12.13+hotfix.9

This solution works fine with or without hotspot enabled, firewall enabled on MacOS. 

## The solution which works in 100% of cases : 
I created two scripts : 
- The first (geturldebug.sh) runs in the background, waiting and scanning in realtime a log file wich is generated by the second script.  When a url is found, a file (observatoryUri.txt) is created containing the ObservatoryUri url (Yes!) which we can use to attach the debugger. 
The script has a default timeout (300 seconds), edit the script to adapt this value with the speed of your Mac (this value must be > time to compile the app by the second script ).

- The second script (buildiosdebug.sh) builds the app in debug mode, and generates a log file which is analyzed by the first script dynamically. The second script must be launched just after the first script.

RESULT : **0% error mDNS lookup failure on iOS, iPhone or iPad, all versions**   !!! YEAH !

## AUTOMATISATION IN VSCODE
I created some tasks in visual studio code to automate all this stuff. Objective: press a key to launch the debugger and attach it to the correct url automatically.
You can find these tasks in my tasks.json here.

I also adapted the launch.json file to launch the debugger in attached mode by providing it with the correct url.

I also used the extension "Tasks: Shell input" because it is not possible without extension to launch shell scripts from attach section configuration in the file launch.json without extensions (am I wrong?).

## How does it works ? 
1 - Lauch the main task by pressing <CTRL> + <SHIFT>+P 
2 - Choose the task "1 - FLUTTER IOS DEBUG (getting observatoryUri first)"
3 - Wait few seconds ;) :  
 
The debugger will be launched automaticlly.

NOTE : Don't forget to set correct PATH of your app, and the timeout value (if necessary, default = 300 seconds)

Happy debugging !

