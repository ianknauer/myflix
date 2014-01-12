require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  
  describe "#recent_videos" do
    it "returns that videos in the reverse chronological order by created at" do 
      comedies = Category.create(name: "comedies")
      community = Video.create(name: "community", description: "funnies", category: comedies, created_at: 1.day.ago)
      fg = Video.create(name: "Family guy", description: "also funnies", category: comedies)
      expect(comedies.recent_videos).to eq([fg,community])
    end
    it "returns all the videos if there are less than 6 videos" do
      comedies = Category.create(name: "comedies")
      community = Video.create(name: "community", description: "funnies", category: comedies, created_at: 1.day.ago)
      fg = Video.create(name: "Family guy", description: "also funnies", category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end
    it "returns 6 videos if there are more than 6 videos" do
       comedies = Category.create(name: "comedies")
       7.times { Video.create(name: "foo", description: "test", category: comedies)}
       expect(comedies.recent_videos.count).to eq(6)
    end
    it "returns the most recent 6 videos" do
      comedies = Category.create(name: "comedies")
      6.times { Video.create(name: "foo", description: "test", category: comedies)}
      tonightsshow = Video.create(name: "tester", description: "mctesterson", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(tonightsshow)
    end
    it "returns an empty array if the category does not have any videos" do
      comedies = Category.create(name: "comedies")
      expect(comedies.recent_videos).to eq([])
    en
  end
end