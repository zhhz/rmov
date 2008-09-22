require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Quicktime::Movie do
  describe "example.mov" do
    before(:each) do
      @movie = Quicktime::Movie.open(File.dirname(__FILE__) + '/../fixtures/example.mov')
    end
    
    it "duration should be 3.1 seconds" do
      @movie.duration.should == 3.1
    end
    
    it "bounds should be a hash of top, left, bottom, and right points" do
      @movie.bounds.should == { :top => 0, :left => 0, :bottom => 50, :right => 60 }
    end
    
    it "width should be 60" do
      @movie.width.should == 60
    end
    
    it "height should be 50" do
      @movie.height.should == 50
    end
    
    it "should have 2 tracks" do
      @movie.tracks.map { |t| t.class }.should == [Quicktime::Track, Quicktime::Track]
      @movie.tracks.map { |t| t.id }.should == [1, 2]
    end
    
    it "should be able to export into separate file" do
      path = File.dirname(__FILE__) + '/../output/exported_example.mov'
      File.delete(path) rescue nil
      @movie.export(path)
      exported_movie = Quicktime::Movie.open(path)
      exported_movie.duration.should == @movie.duration
      exported_movie.tracks.size == @movie.tracks.size
    end
    
    it "should have one audio track" do
      @movie.audio_tracks.should have(1).record
    end
    
    it "should have one video track" do
      @movie.video_tracks.should have(1).record
    end
    
    it "composite should add another movie's tracks at a given location" do
      m2 = Quicktime::Movie.open(File.dirname(__FILE__) + '/../fixtures/example.mov')
      @movie.composite_movie(m2, 2)
      @movie.duration.should == 5.1
    end
    
    it "insert should insert another movie's tracks at a given location" do
      m2 = Quicktime::Movie.open(File.dirname(__FILE__) + '/../fixtures/example.mov')
      @movie.insert_movie(m2, 2)
      @movie.duration.should == 6.2
    end
    
    it "delete_section should remove a section from a movie" do
      @movie.delete_section(1, 0.6)
      @movie.duration.should == 2.5
    end
    
    it "clone_section should make a new movie from given section and leave existing movie intact" do
      mov = @movie.clone_section(1, 0.6)
      mov.duration.should == 0.6
      @movie.duration.should == 3.1
    end
    
    it "clip_section should make a new movie from given section and remove it form existing movie" do
      mov = @movie.clip_section(1, 0.6)
      mov.duration.should == 0.6
      @movie.duration.should == 2.5
    end
  end
end
