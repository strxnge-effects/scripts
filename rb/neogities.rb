# forewarning: this script is janky af, use at your own risk. please create a
# backup of your site before running it <3

# place this file in the same folder as .git and run from cmd line
# only works *before* committing changes
require "neocities"
require "open3"
require "tty-prompt"

class Neogities
  # > neocities gem setup
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

  # > uploading n things
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
    split2 = line[1].split
    print "renaming file: " + split2[0] + " to " + split2[2] + "\n" + "..."
    resp = @neogities.upload(split2[2], split2[2])
    self.delete_file(split2[0])
    self.display_response(resp)
  end

  def self.display_response(resp) # copied this from the gem lol
    if resp[:result] == 'success'
      puts "SUCCESS"
    elsif resp[:result] == 'error' && resp[:error_type] == 'file_exists'
      out = "EXISTS: " + resp[:message]
      out += " (#{resp[:error_type]})" if resp[:error_type]
      puts out
    else
      out = "ERROR: " + resp[:message]
      out += " (#{resp[:error_type]})" if resp[:error_type]
      puts out
    end
  end

  puts "adding file contents to index :p"
  system "git add ."

  stdout = Open3.capture3("git status --porcelain")[0]

  for line in stdout.split("\n")
    splitted = Array(splitted) << line.split(" ", 2) # nvm spaces will NOT work.. idk why.
  end

  # > do the thing
  for line in splitted
    if (line[0] == "M" || line[0] == "A") # modified / added
      self.upload_file(line[1])
    elsif line[0] == "D" # deleted
      self.delete_file(line[1])
    elsif line[0] == "R" # renamed
      self.rename_file(line)
    else # anything else idc
      puts "completely ignoring: #{line[1]}"
    end
  end


  # > quick commit
  if (ARGV[0] == "-c" || ARGV[0] == "--commit")
    prompt = TTY::Prompt.new

    result = prompt.collect do
      key(:title).ask("\ncommit message title:", required: true)
      key(:body).ask("commit message body:")
    end

    unless result[:body] == nil
      system 'git commit -m "' + result[:title] + '" -m "' + result[:body] + '"'
    else
      system 'git commit -m "' + result[:title] + '"'
    end
  end
end
