libkoca
=======

Small library for shell scripting.
Including :
- cleanOnExit : remove a file upon script exiting (those who use mktemp will appreciate)
- getColor : assign color code to a variable (for sexy logs messages).
- lockMe : provide a lock mechanism to your script, preventing it for being launched more than once.
- getConfValue : read a key and return a value from a file .properties-like. Useful to provide a configuration file to your script.
- dieIfNotRoot : exit if the script is not run as root.

And some others, useful but less often : check that a string is an IPadress, convert seconds to day:hours:minutes:seconds and vice versa, return the path where the scripts is run from, clone a function to an other name, ...

Featuring 
- TU, with shunit2
- Dynamic building : if a function do not pass the tests, it is not included in the final file.
- Executable library : 'sh libkoca.sh' display helps. 'sh libkoca.sh listi' display the lists of functions
- You only want the lockMe function ? do 'eval "$(libkoca.sh lockMe)"' and you'll have only this function in the name space of your script.
