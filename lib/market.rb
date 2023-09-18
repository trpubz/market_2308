require "date"

class Market
  attr_reader :name, :vendors, :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime('%d/%m/%Y')
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.flat_map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.filter { |vendor| vendor.inventory.include?(item) }
  end

  def total_inventory
    uniq_items = @vendors.flat_map { |vendor| vendor.inventory.keys }.uniq

    inventory = Hash.new({})
    uniq_items.each { |item| inventory[item] = {} }
    inventory.each do |item, qty_hash|
      qty_hash[:quantity] = @vendors.reduce(0) do |tot, vendor|
        tot + vendor.check_stock(item)
      end
      qty_hash[:vendors] = @vendors.filter { |vendor| vendor.inventory[item] > 0 }
      # require "byebug"; byebug
      inventory[item] = qty_hash
    end

    inventory
  end

  def overstocked_items
    overstocked = []
    total_inventory.each do |item, qty_hash|
      if qty_hash[:quantity] > 50 && qty_hash[:vendors].size > 1
        overstocked << item
      end
    end

    overstocked
  end

  def sorted_item_list
    total_inventory.keys.map(&:name).sort
  end

  def sell(item, qty)
    item_inventory = total_inventory[item]
    if item_inventory[:quantity] >= qty
      sold = 0
      item_inventory[:vendors].each do |vendor|
        in_stock = vendor.check_stock(item)
        if in_stock <= qty - sold
          sold += in_stock
          vendor.stock(item, -in_stock)
        else
          selling = qty - sold
          sold += selling
          vendor.stock(item, -selling)
          break
        end
      end
      true
    else
      false
    end
  end
end
