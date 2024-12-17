# = notes
# for now: limited to 2 selected files
# ideally: being able to run as a batch thing (2 folders)
# manually(-ish) sort for duplicate files, then run batch based on file names?
# i assume / hope there's an easy way to find duplicates, or else... the
# program itself searches for the duplicate, and if it doesn't find one, it
# moves on to the next file?


# = class MergeNotes
class MergeNotes
  # == method read_files
  def self.read_files
    # f1: original file | f2: appended file
    @f1 = File.readlines(ARGV[0])
    @f2 = File.readlines(ARGV[1])

    # array containing 2 arrays containing the respective lines of each file.
    # zamn
    @file_lines = Array[@f1, @f2]
  end

  # == method get_sections
  def self.get_sections
    # first check for metadata
    if @f1[0] == "---\n"
      self.get_yaml(@f1)
    elsif @f2[0] == "---\n"
      self.get_yaml(@f2)
    else
      print("No YAML metadata found. Output file will not include any metadata.\n")
    end

    # go thru f1's lines, then f2
    @file_lines.each_with_index {|f, i1|
      currheadings = {}

      # go thru each line
      f.each_with_index {|line, i2|
        # === creating key value pairs of "heading: line #"
        # specifically checking for 2nd level headings (timestamps)
        # "(m)" denotes which headings come from the 2nd file
        if line[0..2] == "## " and i1 == 1
          currheadings["#{line.strip} (m)\n"] = i2
        elsif line[0..2] == "## "
          currheadings["#{line}"] = i2
        end
      }

      currheadings.each_with_index {|heading, i2|
        # getting line number of the next heading
        next_head_line = currheadings.values[i2 + 1]
        first_line = heading[1] + 1

        # if it's the last heading, it'll include the rest of the array in the
        # section (i.e., the rest of the file). otherwise it uses the next
        # heading to mark the end of the section.
        if next_head_line
          last_line = next_head_line - 1
          @allsections = Array(@allsections) << f[first_line..last_line].unshift(heading[0])
        else
          here_lines = f[heading[1]..-1]
          lastlast_line = here_lines[-1]
          fixed_line = lastlast_line + "\n\n"

          here_lines.pop
          here_lines.push(fixed_line)
          @allsections = Array(@allsections) << f[first_line..last_line].unshift(heading[0])
        end
      }
    }
  end

  # == method get_yaml
  def self.get_yaml(f)
    yamllines = []

    # check first 10 lines of given file for yaml metadata.
    # having more than that seems kinda excessive but if the need ever arises,
    # just change the number ¯\_(ツ)_/¯
    f[..10].each_with_index {|line, i|
      if line == "---\n"
        yamllines = Array(yamllines) << i
        break if yamllines.length == 2
      end
    }

    @frontmatter = f[yamllines[0]..yamllines[1]]
  end

  # == method remove_trailing_whitespace
  def self.remove_trailing_whitespace
    @sorted_sections = @allsections.sort
    last_section = @sorted_sections[-1]

    # remove pre-existing whitespace at end of line
    for line in last_section.reverse
      temparray = Array(temparray) << line.rstrip
    end

    blank_lines = 0

    # get # of blank lines are at end of array (or beginning, since it's
    # reversed). if there aren't any(more), then stop.
    temparray.each_with_index {|line, i|
      if line.empty?
        blank_lines = blank_lines + 1
      end
      break unless line.empty?
    }

    # delete blank lines
    blank_lines.times do
      temparray.delete_at(0)
    end

    # add "\n" back to the end of each line, except for the last. (no extra
    # line at end of file)
    for line in temparray
      unless line == temparray.first
        fixed_line = line + "\n"
        @newarray = Array(@newarray) << fixed_line
      else
        @newarray = Array(@newarray) << line
      end
    end

    # replace last_section with stripped version
    @sorted_sections.pop
    @sorted_sections.push(@newarray.reverse)
  end

  # == method write_to_file
  def self.write_to_file
    # uses same name as 1st argument
    foutput = File.new("output/#{ARGV[0]}", "w")

    if @frontmatter
      # adds frontmatter to beginning of data, if found
      @sorted_sections.insert(0, @frontmatter)
    end

    for section in @sorted_sections
      for line in section
        foutput.write(line)
      end
    end

    foutput.close

    print("File created at output/#{ARGV[0]}.")
  end
end

# and then all the functions in order. :)
MergeNotes.read_files
MergeNotes.get_sections
MergeNotes.remove_trailing_whitespace
MergeNotes.write_to_file