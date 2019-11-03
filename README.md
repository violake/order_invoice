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

# usage
order = Order.new
order.add_item('10 Watermelons')
order.add_item('14 Pineapples')
order.add_item('13 Rockmelons')
# return calculated invoice
order.invoice

```