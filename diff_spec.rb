require 'rspec'

require './diff.rb'

describe 'Diff implementation' do

  it 'should get common lines' do
    diff = Diff::Implementation.new
    diff.load_from_file('file1.txt', 'file2.txt')

    expect(diff.send(:get_common_lines)).to eq({
        2 => 1,
        3 => 2,
    })
  end

  it 'should construct diff' do
    extend Diff #not working? :(

    diff = Diff::Implementation.new
    diff.load_from_file('file1.txt', 'file2.txt')

    expect(diff.get_diff).to eq([
        Diff::Line.new(Diff::MODIFIED, 'Some', 'Another'),
        Diff::Line.new(Diff::REMOVED, 'Simple'),
        Diff::Line.new(Diff::COMMON, 'Text'),
        Diff::Line.new(Diff::COMMON, 'File'),
        Diff::Line.new(Diff::ADDED, 'With'),
        Diff::Line.new(Diff::ADDED, 'Additional'),
        Diff::Line.new(Diff::ADDED, 'Lines'),
                                ])
  end
end