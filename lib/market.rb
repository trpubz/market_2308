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
end
