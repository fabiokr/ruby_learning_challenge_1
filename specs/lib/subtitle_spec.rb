require 'rubygems'
require 'spec'
require '././lib/subtitle'

describe Subtitle do

  it "should load the srt data" do
    srt = Subtitle.new('specs/sample.srt')

    srt.size.should == 2

    srt[0].line.should == '645'
    srt[0].start_time.should == '01:31:51,210'
    srt[0].end_time.should == '01:31:54,893'
    srt[0].text.should == "the government is implementing a new policy...\n"

    srt[1].line.should == '646'
    srt[1].start_time.should == '01:31:54,928'
    srt[1].end_time.should == '01:31:57,664'
    srt[1].text.should == "In connection with a dramatic increase\nin crime in certain neighbourhoods,\n"
  end

  it "should add miliseconds" do
    srt = Subtitle.new('specs/sample.srt')
    srt.add('2,500')
    srt[0].start_time.should == '01:31:53,710'
    srt[0].end_time.should == '01:31:57,393'
    srt[1].start_time.should == '01:31:57,428'
    srt[1].end_time.should == '01:32:00,164'
  end

  it "should convert seconds to miliseconds" do
    Subtitle.convert_to_seconds('12:12:12,100').should == 43932.1
    Subtitle.convert_to_seconds('1,2').should == 1.2
    Subtitle.convert_to_seconds('1,21').should == 1.21
    Subtitle.convert_to_seconds('1,212').should == 1.212
  end

end

