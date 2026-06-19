#!/usr/bin/env ruby
require "highline"
require "htmlbeautifier"
require "nokogiri"
require "paru/pandoc"

class Toolchain
  def self.convert_to_html(fname, fext, inputformat)
    converter = Paru::Pandoc.new

    # configure tha converter
    converter.configure do
        from inputformat
        to "html5"
        filter "get-title.rb"
        template "template.html"
        wrap "none"
        # todo: writing template
        output "#{fname}.html"
    end

    begin
      converter.convert_file(@f)
    rescue => exception
      warn exception.message
      raise
    end
  end

  def self.add_para_breaks(fname)
    doc = File.open("#{fname}.html", "r") { |f| Nokogiri::HTML(f) }

    doc.search("hr").each do |hr|
      # except for start and end hrs, set class on all hrs to pbr (paragraph
      # break)
      unless hr.attr("id")
        hr["class"] = "pbr"
      end
    end

    beautiful = HtmlBeautifier.beautify(doc)

    File.open("#{fname}.html", "w") { |file| file.write(beautiful) }
    puts "output to #{fname}.html"
  end


  # prompt for path
  cli = HighLine.new
  @f = cli.ask "path: "

  # get name, directory, and extension of input file
  path = Pathname.new(@f.delete('"'))
  fname = path.to_s.split(".")[0] # remove extension
  fdir  = path.dirname
  fext  = path.extname.delete(".")

  case fext
  when "md", "txt"
    # use markdown format when converting plain text files
    # auto_identifiers is the extension that automatically adds the id attr to
    # headings :(
    self.convert_to_html(fname, fext, "markdown-auto_identifiers")
    self.add_para_breaks(fname)
  when "fodt", "rtf"
    `soffice --headless --convert-to html --outdir "#{fdir}" #{@f}`
    self.add_para_breaks(fname)
  when "html"
    warn "file is already in html format"
  else
    self.convert_to_html(fname, fext, fext)
    self.add_para_breaks(fname)
  end
end
