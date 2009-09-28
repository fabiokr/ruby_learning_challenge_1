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

  def add(value)
    time = Subtitle.convert_to_seconds(value)
    @data.each {|block| add_miliseconds(block, time)}
  end

  private

  COMPLETE_TIME = '00:00:00,000'
  ZERO_POINT = 60*60*3 #missing seconds from Wed Dec 31 21:00:00 -0300 1969 to Thu Jan 01 00:00:00 -0300 1970

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

  def self.convert_to_seconds(value)
    #fills value with the missing parts (ex. '12,500' becomes 00:00:12,500)
    complete = COMPLETE_TIME[0...(COMPLETE_TIME.size-value.size)] + value.to_s
    hour, minutes, seconds, miliseconds = complete[0..1].to_i*60*60, complete[3..4].to_i*60, complete[6..7].to_i, complete[9..11].to_i
    (hour+minutes+seconds)+("0.#{miliseconds}").to_f
  end

  def add_miliseconds(block, value)
    start_time = Time.at(ZERO_POINT+Subtitle.convert_to_seconds(block.start_time) + value)
    end_time = Time.at(ZERO_POINT+Subtitle.convert_to_seconds(block.end_time) + value)
    block.start_time = "#{start_time.strftime('%H:%M:%S')},#{start_time.usec/1000}"
    block.end_time = "#{end_time.strftime('%H:%M:%S')},#{end_time.usec/1000}"
  end
end

class Block
  attr_accessor :line, :start_time, :end_time, :text
end

