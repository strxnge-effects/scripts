import cmd
import os
import configparser

# read args from settings.ini
configparsed = configparser.ConfigParser(allow_no_value=True)
configparsed.read("settings.ini")

defaultargs = []
customargs = []

# = autofallback
# was thinking i could include some sort of fallback for the custom settings --
# if an option doesn't exist / is blank, then ask whether to use the value for
# default. or maybe that could even be a setting you toggle, what to do in that
# case.
def getargs(section, argstr):
    # make respective lists of arguments
    templi = ""

    for key in configparsed[section]:
        if configparsed[section][key]:
            # if key has a value then uhhhh. use it
            templi += key + " " + configparsed[section][key] + " "

    argstr.append(templi)

getargs("default", defaultargs)
getargs("custom", customargs)


# = CLI functions
class md_dl(cmd.Cmd):
    # intro = "lil script thing for mangadex-downloader\ntype 'help' for a list of commands"
    prompt = "mangadex-util>>"

    # == do_dl
    def do_dl(self, line):
        # input a URL to download from
        "syntax: dl url [--custom]"

        line = line.split()
        url = line[0]

        thecommand = "mangadex-dl " + '"' + url + '" '

        try:
            # check for custom arguments. there HAS to be a better way than this!
            if line[1] == "-c" or "--custom":
                print("using custom arguments...")
                thecommand += " ".join(customargs)
        except IndexError:
            print("using default arguments...")
            thecommand += " ".join(defaultargs)

        # execute command in terminal
        os.system(thecommand)


    def do_exit(self, line):
        "exits the program"
    
        # exits the program
        return True


# run the CLI
if __name__ == "__main__":
     md_dl().cmdloop()
