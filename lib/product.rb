# frozen_string_literal: true

require 'yaml'
require 'json'
require 'order_error'
require 'item'
require 'pack'

class Product
  PRODUCTS_YML_FILE = ENV['PRODUCTS_FILE'] || 'products.yml'

  class << self
    def find_by_name(name)
      data.select { |product| product[:name] == name }.first
    end

    def new_item(name, quantity)
      product = find_by_name(name)
      raise OrderError.new(OrderError::PARAMETER_INVALID, 'no such item') unless product

      Item.new(product[:name], quantity, new_packs(product[:packs]))
    end

    private

    def new_packs(packs)
      packs.map { |pack| Pack.new(pack[:name], pack[:specification], pack[:price]) }
    end

    def data
      @data ||= JSON.parse(json_data_from_yml, symbolize_names: true)
    end

    def json_data_from_yml
      YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), PRODUCTS_YML_FILE)).to_json
    end
  end
end
