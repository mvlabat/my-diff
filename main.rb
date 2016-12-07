require './diff.rb'

def format_line(i, line)
  def format_mod(mod)
    case mod
      when Diff::ADDED
        '+'

      when Diff::REMOVED
        '-'

      when Diff::MODIFIED
        '*'

      else
        ''

    end
  end

  "#{i}\t#{format_mod(line.mod)}\t#{line.content}"
end

Diff::Implementation.new
    .load_from_file('file1.txt', 'file2.txt')
    .get_diff
    .each_with_index{ |line, i|

  puts format_line(i, line)
}
