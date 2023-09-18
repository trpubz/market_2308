require "spec_helper"

RSpec.describe Vendor do
  before(:each) do
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
  end

  describe "#init" do
    it "exists" do
      expect(@vendor.name).to eq "Rocky Mountain Fresh"
      expect(@vendor.inventory).to eq({})
    end
  end

  describe "#check_stock" do
    it "checks stock of items" do
      expect(@vendor.check_stock(@item1)).to eq 0
    end
  end

  describe "#stock" do
    it "stocks items" do
      @vendor.stock(@item1, 30)
      expect(@vendor.check_stock(@item1)).to eq 30
      @vendor.stock(@item1, 25)
      expect(@vendor.check_stock(@item1)).to eq 55
      @vendor.stock(@item2, 12)
      expect(@vendor.inventory).to eq({@item1 => 55, @item2 => 12})
    end
  end
end
