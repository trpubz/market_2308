class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
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
end
