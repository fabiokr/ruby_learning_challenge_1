class Subtitle

  def initialize(path)
    load_file_data(path)
  end

  def size
    @data.size
  end

  def [](index)
    @data[index]
  end

  private

  def load_file_data(file)
    @data = separate_into_blocks(IO.readlines(file))
  end

  def separate_into_blocks(file_data)
    blocks, block = [], nil
    file_data.each do |line|
      case line
        when /^\d+$/
          block = Block.new
          block.line = line.chomp
          block.text = ''
          blocks << block
        when /^\d{2}:\d{2}:\d{2},\d{3}\s-->\s\d{2}:\d{2}:\d{2},\d{3}$/
          times = line.chomp.split(' --> ')
          block.start_time = times[0]
          block.end_time = times[1]
        when /^.*$/
          block.text << line
      end
    end
    blocks.each_index {|i| blocks[i].text.chomp!}
    blocks
  end
end

class Block
  attr_accessor :line, :start_time, :end_time, :text
end

