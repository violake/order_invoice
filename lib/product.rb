# frozen_string_literal: true

require 'yaml'
require 'json'

class Product
  PRODUCTS_YML_FILE = 'products.yml'

  class << self
    def all
      data
    end

    def find_by_name(name)
      data.select { |product| product[:name] == name }.first
    end

    def exist(name)
      data.any? { |product| product[:name] == name }
    end

    private

    def data
      @data ||= JSON.parse(json_data_from_yml, symbolize_names: true)
    end

    def json_data_from_yml
      YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), PRODUCTS_YML_FILE)).to_json
    end
  end
end
