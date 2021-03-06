class Api::V1::TopicsController < Api::V1::BaseController
  include JSONAPI::Filtering
  include JSONAPI::Pagination
  
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_topic, only: %i[update destroy]

  def show
    respond_to do |format|
      format.json do
        @topic = Topic.find_by_id(params[:id]) || Topic.find_by_url(params[:url])

        if @topic
          render json: TopicSerializer.new(@topic) 
        else
          render status: :not_found, body: nil
        end
      end
    end
  end

  def index
    allowed = [:id, :publication_date, :title]

    respond_to do |format|
      format.json do
        if [:topics_ids, :tags, :title_query].any? {|field| params[field].present?}
          @topics = Topic.search(
            :topics_ids   => params[:topics_ids],
            :tags         => params[:tags],
            :title_query  => params[:title_query]
          )
        else
          @topics = Topic.all
        end

        if @topics
          jsonapi_filter(@topics, allowed) do |filtered|
            jsonapi_paginate(filtered.result) do |paginated|
              render jsonapi: paginated
            end
          end
        else
          render status: :not_found, body: nil
        end
      end
    end
  end

  def create
    respond_to do |format|
      format.json {
        @topic = Topic.new(topic_params)

        if @topic.save
          render json: TopicSerializer.new(@topic), status: :created
        else
          render json: ErrorSerializer.serialize(@topic.errors), status: :unprocessable_entity
        end
      }
    end
  end

  def update
    respond_to do |format|
      format.json {
        if @topic.update(topic_params)
          render json: TopicSerializer.new(@topic)
        else
          render json: ErrorSerializer.serialize(@topic.errors), status: :unprocessable_entity
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        render json: @topic.destroy
      end
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :url, :publication_date, :image_link, :annonce, :body, tag_list: [])
  end
end