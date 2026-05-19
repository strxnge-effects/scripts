#!/usr/bin/env ruby
require "highline"
require "paru/pandoc"

class Toolchain
  def self.convert_to_html(fname, fext, inputformat)
    converter = Paru::Pandoc.new

    converter.configure do
        from inputformat
        to "html"
        filter "get-title.rb"
        template "template.html"
        # todo: writing template
        output "#{fname}.html"
    end

    converter.convert_file(@f)
    puts "output to #{fname}.html"
  end


  cli = HighLine.new

  if ARGV.size != 1
  # prompt for path if not given as arg
    @f = cli.ask "path: "
  else
    @f = ARGV[0]
  end

  fname = @f.split(".")[0].delete('"')
  fext = @f.split(".")[-1].delete('"')

  case fext
  when "md", "txt"
    self.convert_to_html(fname, fext, "markdown-auto_identifiers")
  when "fodt", "rtf"
    warn "unsupported file type: #{fext}"
  else
    self.convert_to_html(fname, fext, fext)
  end
end
