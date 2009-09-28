require 'rubygems'
require 'spec'
require './subtitle'

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
  end

end

