# please create a backup of your site before running the script <3

# place this file in the same folder as .git and run from cmd line
# only works *before* committing changes
require "open3"
require "neocities"

class Neogities
  # = neocities gem setup
  configpath = File.join(Neocities::CLI.app_config_path("neocities"), "config.json")

  begin # fetch api key
    file = File.read configpath
    data = JSON.load file

    if data
      yourkey = data["API_KEY"].strip
    end
  rescue Errno::ENOENT
    yourkey = nil
    print "API key not found, please login usig the neocities module :("
  end

  @neogities = Neocities::Client.new(api_key: yourkey) # create new instance

  # = uploading n things
  def self.upload_file(path)
    print "uploading file: " + path + "..."
    resp = @neogities.upload(path, path)
    self.display_response(resp)
  end

  def self.delete_file(path)
    print "deleting file: " + path + "..."
    resp = @neogities.delete(path)
    self.display_response(resp)
  end

  def self.rename_file(line)
    split2 = line.split
    print("renaming file: " + split2[0] + " to " + split2[2] + "n") + "..."
    resp = self.upload_file(split2[0]), self.delete_file(split2[0])
    self.display_response(resp)
  end

  def self.display_response(resp) # copied this from the gem lol
    if resp[:result] == 'success'
      print "SUCCESS\n"
    elsif resp[:result] == 'error' && resp[:error_type] == 'file_exists'
      out = "EXISTS: " + resp[:message]
      out += " (#{resp[:error_type]})" if resp[:error_type]
      print out + "\n"
    else
      out = "ERROR: " + resp[:message]
      out += " (#{resp[:error_type]})" if resp[:error_type]
      print out + "\n"
    end
  end

  print "adding file contents to index :P\n"
  system "git add ."

  stdout = Open3.capture3("git status --porcelain")[0]

  for line in stdout.split("\n")
    splitted = Array(splitted) << line.split(" ", 2) # nvm spaces will NOT work.. idk why.
  end

  # = do the thing
  for line in splitted
    if (line[0] == "M" || line[0] == "A") # modified / added
      self.upload_file(line[1])
    elsif line[0] == "D" # deleted
      self.delete_file(line[1])
    elsif line[0] == "R" # renamed
      self.rename_file(line)
    else # anything else idc
      print "completely ignoring: " + line[1] + "\n"
    end
  end
end
