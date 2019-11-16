# frozen_string_literal: true

require 'yaml'
require 'json'

class Products
  PRODUCTS_YML_FILE = ENV['PRODUCTS_FILE'] || 'products.yml'

  class << self
    def find_by_name(name)
      data.find { |product| product[:name] == name }
    end

    private

    def data
      @data ||= JSON.parse(json_data_from_yml, symbolize_names: true)
    end

    def json_data_from_yml
      puts PRODUCTS_YML_FILE
      YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), PRODUCTS_YML_FILE)).to_json
    end
  end
end
