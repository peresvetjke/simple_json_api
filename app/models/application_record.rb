class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def jsonapi_meta(resources)
    pagination = jsonapi_pagination_meta(resources)

    { pagination: pagination } if pagination.present?
  end
end
