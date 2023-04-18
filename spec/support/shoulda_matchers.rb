require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library        :rails
  end
end

module Shoulda
  module Matchers
    module ActionController
      class RouteParams
        protected

        def normalize_values(hash)
          hash
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActiveModel, type: :form
end
