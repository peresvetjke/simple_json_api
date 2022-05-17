class Topic < ApplicationRecord
  acts_as_taggable_on :tags

  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true

  scope :by_ids,     -> (topics_ids)  { where(id: topics_ids) }
  scope :title_like, -> (title_query) { where("title LIKE ?", "%#{title_query}%") }
  scope :by_tags,    -> (tags)        { joins(:tags).where('tags.name IN (?)', tags) }

  def self.search(params)
    topics = Topic.all
    topics = topics.by_ids(params[:topics_ids])      if params[:topics_ids].present?
    topics = topics.title_like(params[:title_query]) if params[:title_query].present?
    topics = topics.by_tags(params[:tags])           if params[:tags].present?
    topics
  end
end
