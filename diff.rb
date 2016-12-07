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

      last_taken_line = -1
      @file1.each_with_index { |str, i|
        line = file2.index(str)
        if !line.nil? && line > last_taken_line
          common_lines[i] = line
          last_taken_line = line
        end
      }

      common_lines
    end

    def construct_diff(common_lines)
      diff = []
      last_line1 = 0
      last_line2 = 0
      buf = 0

      write_diff_lines = lambda do |line1, line2|
        mod = COMMON
        diff_lines = (line1 + buf - line2).abs
        if line1 < line2
          mod = ADDED
          file = @file2
          buf += diff_lines
        elsif line1 > line2
          mod = REMOVED
          file = @file1
          buf -= diff_lines
        end

        min = [line1, line2].min
        (last_line1...min).each { |i|
          diff.push(Line.new(MODIFIED, @file1[i], @file2[last_line2 + i]))
        }
        last_line1 = line1
        last_line2 = line2

        (min...(min + diff_lines)).each { |i|
          diff.push(Line.new(mod, file[i]))
        }
      end

      common_lines.each { |line1, line2|
        write_diff_lines.call(line1, line2)
        diff.push(Line.new(COMMON, @file2[line2]))
      }

      write_diff_lines.call(@file1.length - 1, @file2.length - 1)

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
