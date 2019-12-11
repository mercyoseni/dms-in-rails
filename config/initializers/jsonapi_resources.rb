JSONAPI.configure do |config|
  config.resource_cache = Rails.cache

  # Options are :none, :offset, :paged, or a custom paginator name
  config.default_paginator = :paged # default is :none

  config.default_page_size = 15
  config.maximum_page_size = 25
end
