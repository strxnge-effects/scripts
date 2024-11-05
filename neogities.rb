# please create a backup of your site before running the script <3

# place this file in the same folder as .git, then change extension to .rb and
# run from cmd line
# only works *before* doing git commit or push

require "open3"
require "neocities"

configpath = File.join(Neocities::CLI.app_config_path("neocities"), "config.json")

begin # fetch api key
  file = File.read configpath
  data = JSON.load file

  if data
    yourkey = data["API_KEY"].strip
  end
rescue Errno::ENOENT
  yourkey = nil
  print "please login usig the neocities module :("
end

neogities = Neocities::Client.new(api_key: yourkey) # create new instance

stdout, stdeerr, status = Open3.capture3("git status --porcelain")

for line in stdout.split("\n")
  splitted = Array(splitted) << line.split(" ", 2) # should allow for spaces in file names
end

for line in splitted
  if (line[0] == "M" || line[0] == "A") # modified / added
    neogities.upload(line[1], line[1], true)
    print "uploading: " + line[1] + "\n"
  elsif line[0] == "D" # deleted
    neogities.delete(line[1])
    print "deleting: " + line[1] + "\n"
  elsif line[0] == "R" # renamed
    split2 = line[1].split
    
    neogities.delete(split2[0]) # top 10 reasons to create a backup
    neogities.upload(split2[2], split2[2], true)
    print("renaming: " + split2[0] + " to " + split2[2] + "\n")
  else # anything else idc
    print "completely ignoring: " + line[1] + "\n"
  end
end
