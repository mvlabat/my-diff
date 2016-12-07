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

  it 'should get complex common lines' do
    diff = Diff::Implementation.new
    diff.load_from_file('file_complex1.txt', 'file_complex2.txt')

    expect(diff.send(:get_common_lines)).to eq({
                                                   1 => 3,
                                                   3 => 5,
                                                   8 => 6,
                                               })
  end

  it 'should construct diff' do
    extend Diff #not working? :(

    diff = Diff::Implementation.new
    diff.load_from_file('file1.txt', 'file2.txt')

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::MODIFIED, 'Another', 'Some'),
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
                                    Diff::Line.new(Diff::MODIFIED, 'Some', 'Another'),
                                    Diff::Line.new(Diff::ADDED, 'Simple'),
                                    Diff::Line.new(Diff::COMMON, 'Text'),
                                    Diff::Line.new(Diff::COMMON, 'File'),
                                    Diff::Line.new(Diff::REMOVED, 'With'),
                                    Diff::Line.new(Diff::REMOVED, 'Additional'),
                                    Diff::Line.new(Diff::REMOVED, 'Lines'),
                                ])
  end

  it 'should construct more complex diff' do
    diff = Diff::Implementation.new
    diff.load_from_file('file_complex1.txt', 'file_complex2.txt')

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::MODIFIED, 'b1', 'a1'),
                                    Diff::Line.new(Diff::ADDED, 'b2'),
                                    Diff::Line.new(Diff::ADDED, 'b3'),
                                    Diff::Line.new(Diff::COMMON, 'c1'),
                                    Diff::Line.new(Diff::MODIFIED, 'b4', 'a2'),
                                    Diff::Line.new(Diff::COMMON, 'c2'),
                                    Diff::Line.new(Diff::REMOVED, 'a3'),
                                    Diff::Line.new(Diff::REMOVED, 'a4'),
                                    Diff::Line.new(Diff::REMOVED, 'a5'),
                                    Diff::Line.new(Diff::REMOVED, 'a6'),
                                    Diff::Line.new(Diff::COMMON, 'c3'),
                                    Diff::Line.new(Diff::ADDED, 'b5'),
                                ])
  end

  it 'should work without common lines 1' do
    diff = Diff::Implementation.new
    diff.load_from_array(['a1', 'a2'], ['b1', 'b2'])

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::MODIFIED, 'b1', 'a1'),
                                    Diff::Line.new(Diff::MODIFIED, 'b2', 'a2'),
                                ])
  end

  it 'should work without common lines 2' do
    diff = Diff::Implementation.new
    diff.load_from_array(['a1', 'a2'], ['b1', 'b2', 'b3'])

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::MODIFIED, 'b1', 'a1'),
                                    Diff::Line.new(Diff::MODIFIED, 'b2', 'a2'),
                                    Diff::Line.new(Diff::ADDED, 'b3'),
                                ])
  end



  it 'should work with common lines only' do
    diff = Diff::Implementation.new
    diff.load_from_array(['c1', 'c2'], ['c1', 'c2'])

    expect(diff.get_diff).to eq([
                                    Diff::Line.new(Diff::COMMON, 'c1'),
                                    Diff::Line.new(Diff::COMMON, 'c2'),
                                ])
  end

  it 'should work with no input' do
    diff = Diff::Implementation.new
    diff.load_from_array([], [])

    expect(diff.get_diff).to eq([])
  end
end
