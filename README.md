# Invoice
This is a invoice generating system for fruit orders

## How to Run

```bash
# install gems
bundle install

# test
# coverage/index.html shows test coverage details
bundle exec rspec

# code format
bundle exec rubocop

# local playground
irb
$LOAD_PATH.unshift('./lib')
require 'order'

order = Order.new
order.add_product('10 Watermelons')
order.add_product('14 Pineapples')
order.add_product('13 Rockmelons')
# return calculated invoice
order.invoice

```