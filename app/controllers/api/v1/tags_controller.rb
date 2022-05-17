class Api::V1::TagsController < Api::V1::BaseController
  before_action :set_tag, only: %i[show update destroy]

  def show
    respond_to do |format|
      format.json do
        if @tag
          render json: TagSerializer.new(@tag) 
        else
          render status: :not_found, body: nil
        end
      end
    end
  end

  def index
    respond_to do |format|
      format.json do
        @tags = Tag.all

        if @tags
          render json: TagSerializer.new(@tags)
        else
          render status: :not_found, body: nil
        end
      end
    end
  end

  def create
    respond_to do |format|
      format.json {
        @tag = Tag.new(tag_params)

        if @tag.save
          render json: TagSerializer.new(@tag), status: :created
        else
          render json: ErrorSerializer.serialize(@tag.errors), status: :unprocessable_entity
        end
      }
    end
  end

  def update
    respond_to do |format|
      format.json {
        if @tag.update(tag_params)
          render json: TagSerializer.new(@tag)
        else
          render json: ErrorSerializer.serialize(@tag.errors), status: :unprocessable_entity
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        render json: @tag.destroy
      end
    end
  end

  private

  def set_tag
    @tag = Tag.find_by_id(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :slug)
  end
end