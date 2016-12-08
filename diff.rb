module Diff

  class Implementation

    def get_diff
      common_lines = get_common_lines
      construct_diff(common_lines)
    end

    def load_from_array(arr1, arr2)
      @file1 = arr1
      @file2 = arr2
      self
    end

    def load_from_string(str1, str2)
      load_from_array(str1.split("\n"), str2.split("\n"))
      self
    end

    def load_from_file(file1, file2)
      load_from_string(File.read(file1), File.read(file2))
      self
    end

    private

    # Returns lines mapping (key - line in the first file, value - in the second one)
    def get_common_lines
      file2 = @file2.dup
      common_lines = {}

      acc = 0
      @file1.each_with_index { |str, i|
        line = file2.index(str)
        unless line.nil?
          common_lines[i] = acc + line
          acc += line + 1
          file2 = file2.drop(line + 1)
        end
      }

      common_lines
    end

    def construct_diff(common_lines)
      diff = []
      last_line1 = -1
      last_line2 = -1
      buf = 0

      write_diff_lines = lambda do |line1, line2|
        # Put modified strings into diff
        ([line1 - last_line1 - 1, line2 - last_line2 - 1].min).times { |i|
          diff.push(Line.new(MODIFIED, @file2[last_line2 + i + 1], @file1[last_line1 + i + 1]))
        }

        # Put added/removed strings into diff
        diff_lines = line1 + buf - line2
        buf -= diff_lines
        if diff_lines < 0
          mod = ADDED
          file = @file2
          line = line2 - diff_lines.abs
        elsif diff_lines > 0
          mod = REMOVED
          file = @file1
          line = line1 - diff_lines.abs
        end

        diff_lines.abs.times { |i|
          diff.push(Line.new(mod, file[line + i]))
        }

        # Remember the previous lines for further iterations
        last_line1 = line1
        last_line2 = line2
      end

      common_lines.each { |line1, line2|
        write_diff_lines.call(line1, line2)
        diff.push(Line.new(COMMON, @file1[line1]))
      }

      write_diff_lines.call(@file1.length, @file2.length)

      diff
    end
  end

  class Line
    attr_reader :mod, :content

    def initialize(mod, new_content, old_content = '')
      @mod = mod
      if mod == MODIFIED
        @content = "#{old_content}|#{new_content}"
      else
        @content = new_content
      end
    end

    def ==(other_object)
      @mod == other_object.mod && @content == other_object.content
    end
  end

  ADDED = 1
  REMOVED = 2
  MODIFIED = 4
  COMMON = 8

end
