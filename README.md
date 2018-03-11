## CLI Productivity Config

### A series of functions to improve the shell experience



### INTRODUCTION:

Designed for Bash and fish for the Linux shell, CLI Productivity Config (CLIPC) is a collection of scripts to, as said above, allow the end user to be more productive.

Inspired by a friend who runs DOS to this day - he has over a thousand batch files to improve (and simplify) his command line experience.  Although many are situational (based on his personal directory structure, for example), it has and will give me inspiration for something similar in Linux.

More info can be found on [my home page](http://www.chebucto.ns.ca/~bb782/proj-clipc.html) or [XDA](http://forum.xda-developers.com/showthread.php?t=3693743)



### SYSTEM REQUIREMENTS:

- GNU Bash (I am using 4.4, but the requirements are probably way lower) and/or
- fish, version 2.4.0 (quickly found myself upgrading to Debian Stretch for this)
- BSDMainUtils, version 9.0.7 (this version ignores escape sequences) or higher
- git (any version will do - as long as it has `add` and `status` - so yeah, any)
- GNU time, version 1.7 (although the real requirement may be much older)


### INSTALLATION:

Run the INSTALL script (in terminal), follow the interactive choices, and (based on your selections) the new files will be copied in place.  Then, restart any open terminals to take advantage of the changes.

Note: If there were specific additions/changes to the .bashrc file, the Bash install will overwrite that (with the old version renamed to .bashrc-bak).  To easily maintain these between CLIPC updates, place the changes in ~/.bash_extras (no header in file needed) and Bash will automatically include that file (the CLIPC install script will never overwrite the .bash_extras file).

That's all there is to it!



### SUPPORT:

I will be checking this git on occasion.  So if you have a bug, open an issue.  If you have a contribution, feel free to fork, add to, and submit a pull request.  Feature requests can be helpful too (via an issue), as long as they are backed up with a concept of the idea.  Asking for "puppies and rainbows" are not helpful.  

I am sharing these to help benefit others, so please link, redistribute, and do what you want with them (within the confines of the GPL of course).
