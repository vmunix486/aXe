# Use INI files instead of X resource files

- STATUS: OPEN
- PRIORITY: 70
- TAGS: Modernization,Bug

Right now, if you try to run aXe in any context, it will not work since it can't load settings due to X Resource File shenanangens. The fix for this could be an INI file located in the user's home directory, so for me it would probably be something like `/home/vmunix/.axe`. If it is not found, then it will write a basic version to said file, and continue on.

I think instead of making anything from the ground-up, I think we should use `inih`, which is used by `tiny386`, and is included in my Lua fork `blua`. It is written in ANSI C, and is very small, being only around 500 lines of code.
