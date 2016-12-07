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

  it 'should get reversed common lines' do
    diff = Diff::Implementation.new
    diff.load_from_file('file2.txt', 'file1.txt')

    expect(diff.send(:get_common_lines)).to eq({
                                                   1 => 2,
                                                   2 => 3,
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

  it 'should construct reversed diff' do
    extend Diff #not working? :(

    diff = Diff::Implementation.new
    diff.load_from_file('file2.txt', 'file1.txt')

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::MODIFIED, 'Another', 'Some'),
                                    Diff::Line.new(Diff::ADDED, 'Simple'),
                                    Diff::Line.new(Diff::COMMON, 'Text'),
                                    Diff::Line.new(Diff::COMMON, 'File'),
                                    Diff::Line.new(Diff::REMOVED, 'With'),
                                    Diff::Line.new(Diff::REMOVED, 'Additional'),
                                    Diff::Line.new(Diff::REMOVED, 'Lines'),
                                ])
  end
end
