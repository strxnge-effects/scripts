require "highline"
require "paru/pandoc"

class Toolchain
  def self.read_file
    cli = HighLine.new

    if ARGV.size != 1
    # prompt for path if not given as arg
      @f = cli.ask "path: "
    else
      @f = ARGV[0]
    end

    fname = @f.split(".")[0]
    fext = @f.split(".")[-1]

    case fext
    when "md"
      inputformat = "markdown-auto_identifiers"
    when "odt"
      inputformat = "odt"
    # when "rtf"
    # todo: rtf
    #   inputformat = "rtf"
    else
      puts "unknown format"
    end

    self.convert_to_html(fname, fext, inputformat)
  end

  def self.convert_to_html(fname, fext, inputformat)
    converter = Paru::Pandoc.new

    converter.configure do
        from inputformat
        to "html"
        filter "get-title.rb"
        template "template.html"
        output "#{fname}.html"
    end

    converter.convert_file(@f)
    puts "output to #{fname}.html"
  end

  self.read_file
end
