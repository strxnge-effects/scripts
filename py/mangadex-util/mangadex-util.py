import cmd
import os
import yaml


# > yaml settings
with open("settings.yaml", "r") as file:
    settings = yaml.safe_load(file)

defaultargs = []
customargs = []

def getargs(section, argstr):
    # fetch respective lists of arguments
    templi = ""

    for key in settings[section]:
        if settings[section][key]:
            if "~" in str(settings[section][key]):
            # expand user path
                templi += key + " " + os.path.expanduser(str(settings[section][key])) + " "
            else:
                templi += key + " " + str(settings[section][key]) + " "

    argstr.append(templi)

getargs("default", defaultargs)
getargs("custom", customargs)


# > CLI functions
class md_dl(cmd.Cmd):
    prompt = "mangadex-util>>"

    # >> do_dl
    def do_dl(self, line):
        # input a URL to download from
        "syntax: dl url [--custom]"

        args = line.split()
        url = args[0]

        thecommand = "mangadex-dl " + '"' + url + '" '

        try:
            if "--custom" in args:
                print("using custom arguments...")
                thecommand += " ".join(customargs)
            else:
                print("using default arguments...")
                thecommand += " ".join(defaultargs)

            os.system(thecommand)
        except Exception as e:
            print(e)
            return


    def do_exit(self, line):
        "exits the program"

        return True


# run the CLI
if __name__ == "__main__":
     md_dl().cmdloop()
