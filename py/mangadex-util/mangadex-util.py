import cmd
import os
import yaml

with open("settings.yaml", "r") as file:
    settings = yaml.safe_load(file)

defaultargs = []
customargs = []

def getargs(section, argstr):
    # fetch respective lists of arguments
    templi = ""

    for key in settings[section]:
        if settings[section][key]:
            templi += key + " " + str(settings[section][key]) + " "

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
