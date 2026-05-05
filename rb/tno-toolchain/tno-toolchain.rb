require "highline"
require "paru/filter"
require "paru/pandoc"

class Toolchain
  def self.read_file
    cli = HighLine.new

    if ARGV.size == 1
      @f = ARGV[0]
    else
    # prompt for path if not given as arg
      @f = cli.ask "path: "
    end

    fname = @f.split(".")[0]
    fext = @f.split(".")[-1]

    case fext
    when "md"
      inputformat = "markdown"
    when "odt"
      inputformat = "odt"
    else
      puts "unknown format"
    # when "rtf"
    # todo: rtf
    #   inputformat = "rtf"
    end

    self.convert_to_html(fname, fext, inputformat)
  end

  def self.convert_to_html(fname, fext, inputformat)
    converter = Paru::Pandoc.new

    Paru::Filter.run do
      # puts "hi"
    end

    converter.configure do
        from inputformat
        to "html"
        # lua_filter "headertotitle.lua"
        # filter "get-title.rb"
        template "template.html"
        output "#{fname}.html"
    end

    converter.convert_file(@f)
  end

  self.read_file
end
