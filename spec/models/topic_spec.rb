require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topics)        { create_list(:topic, 5) }
  let(:topics_ids)    { nil }
  let(:tags)          { nil }
  let(:title_query)   { nil }
  let(:params)        {{  :topics_ids   => topics_ids,
                          :tags         => tags,
                          :title_query  => title_query
                      }}
  
  describe ".search" do
    subject { Topic.search(params) }
    
    context "topics_ids" do
      let(:topics_ids) { [topics.first.id, topics.last.id] }

      it "returns selected records" do
        expect(subject).to match_array([topics.first, topics.last])
      end
    end

    context "title_query" do
      let(:title_query) { "#{topics.last.title}" }

      it "returns selected records" do
        expect(subject).to match_array([topics.last])
      end
    end

    context "title_query" do
      let(:tag_1) { create(:tag, name: "cool", slug: "/cool") }
      let(:tag_2) { create(:tag, name: "awesome", slug: "/awesome") }
      let(:tags)  { ["awesome"] }

      before do
        topics.first.tag_list.add("cool")
        topics.first.tag_list.add("awesome")
        topics.first.save!
        topics.last.tag_list.add("awesome")
        topics.last.save!
      end

      it "returns selected records" do
        expect(subject).to match_array([topics.first, topics.last])
      end
    end

    context "several params" do
      let(:topics_ids) { [topics.first.id, topics.last.id] }
      let(:title_query) { "#{topics.last.title}" }
      let(:tag_1) { create(:tag, name: "cool", slug: "/cool") }
      let(:tag_2) { create(:tag, name: "awesome", slug: "/awesome") }
      let(:tags)  { ["awesome"] }

      before do
        topics.first.tag_list.add("cool")
        topics.first.tag_list.add("awesome")
        topics.first.save!
        topics.last.tag_list.add("awesome")
        topics.last.save!
      end

      it "returns selected records" do
        expect(subject).to match_array([topics.last])
      end
    end

    context "no selection" do
      let(:title_query) { "not_found" }

      it "returns nothing" do
        expect(subject).to be_empty
      end
    end
  end
end
