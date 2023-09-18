class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = {}
  end

  def stock(item, qty)
    check_stock(item)  # => initialize key if not yet present
    inventory[item] += qty
  end

  def check_stock(item)
    if inventory.has_key?(item)
      inventory[item]
    else
      inventory[item] = 0
    end
  end

  def potential_revenue
    @inventory.reduce(0) do |tot, inv_item|
      tot + inv_item[1] * inv_item[0].price
    end
  end
end
