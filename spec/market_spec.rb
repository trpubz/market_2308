require "spec_helper"

RSpec.describe Market do
  before(:each) do
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor2.stock(@item3, 25)
    @vendor2.stock(@item4, 50)
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @vendor3.stock(@item1, 65)
  end

  describe "#init" do
    it "exists" do
      expect(@market.name).to eq "South Pearl Street Farmers Market"
      expect(@market.vendors).to eq []
    end
  end

  describe "#add_vendors" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "add vendors" do
      expect(@market.vendors).to eq [@vendor1, @vendor2, @vendor3]
    end
  end

  describe "#vendor_names" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "returns vendor names from objects" do
      expect(@market.vendor_names).to eq ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"]
    end
  end

  describe "#vendors_that_sell" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "returns vendor objects that sell item" do
      expect(@market.vendors_that_sell(@item1)).to eq [@vendor1, @vendor3]
      expect(@market.vendors_that_sell(@item4)).to eq [@vendor2]
    end
  end

  describe "#total_inventory" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "returns {items => {qty => [vendors]}}" do
      expect(@market.total_inventory).to be_a Hash
      # expect(@market.total_inventory).to eq({@item1 =>
      #                                          {
      #                                            quantity: 100,
      #                                            vendors: [@vendor1, @vendor3]
      #                                          },
      #                                       @item2 =>
      #                                          {
      #                                            quantity: 7,
      #                                            vendors: [@vendor1]
      #                                          },
      #                                       @item3 =>
      #                                          {
      #                                            quantity: 25,
      #                                            vendors: [@vendor3]
      #                                          },
      #                                       @item4 =>
      #                                          {
      #                                            quantity: 50,
      #                                            vendors: [@vendor3]
      #                                          }})
    end
  end

  describe "#overstocked_items" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "returns Array of [Items] that are overstocked" do
      # item is overstocked if it is sold by more than 1 vendor AND the total quantity is greater than 50.
      expect(@market.overstocked_items).to eq [@item1]
    end
  end

  describe "#sorted_item_list" do
    before do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "returns [Items.names] alphabetically" do
      expect(@market.sorted_item_list).to eq ["Banana Nice Cream",
        "Peach",
        "Peach-Raspberry Nice Cream",
        "Tomato"]
    end
  end
end
