module SpreePayuIntegration
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def add_initializer
        copy_file "openpayu.rb", "config/initializers/openpayu.rb"
      end
    end
  end
end
