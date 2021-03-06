require "spec_helper"

describe "Model with money fields" do
  context "for cents and currency" do
    before do
      @product = Product.new :price => Money.new(1000, "EUR"),
        :name => "Ruby T-shirt"
    end
    subject { @product }

    its(:money_price) { should == 1000 }
    its(:currency_price) { should eq("EUR") }
    its(:price) { should == Money.new(1000, "EUR") }
  end

  context "for negative amounts" do
    before do
      @product = Product.create! :price => "-1000",
        :name => "C/C++ T-shirt"
    end
    subject {@product}

    its(:money_price) {should eq(-100000)}
  end

  context "only for cents" do
    before do
      @product = Product.create! :price_in_usd => Money.new(1000),
        :name => "Ruby T-shirt"
    end
    subject { @product }

    it "doesn't have a stored currency" do
      @product.respond_to?(:currency_price_in_usd).should be_false
    end

    its(:money_price_in_usd) { should == 1000 }
    its(:price_in_usd) { should == Money.new(1000, "USD") }
  end

  context "with a nil values" do
    before do
      @product = Product.create! :price => nil, :price_in_usd => nil
    end
    subject {@product}

    its(:money_price){ should be_nil }
    its(:currency_price){ should be_nil }
    its(:money_price_in_usd) { should be_nil }
  end

  context "with price combining text and numbers" do
    before do
      @product = Product.create! :price => "$1000 + VAT"
    end
    subject {@product}

    its(:money_price){ should == 100000 }
    its(:currency_price){ should == "USD" }
  end

  context "with price with commas" do
    before do
      @product = Product.create! :price => "$1000,50 + VAT"
    end
    subject {@product}

    its(:money_price){ should == 100050 }
    its(:currency_price){ should == "USD" }
  end

  context "with price with periods" do
    before do
      @product = Product.create! :price => "$1000.50 + VAT"
    end
    subject {@product}

    its(:money_price){ should == 100050 }
    its(:currency_price){ should == "USD" }
  end

  context "some test which includes periods" do
    before do
      @product = Product.create! :price => "$1000.50 INCL."
    end
    subject {@product}

    its(:money_price){ should == 100050 }
    its(:currency_price){ should == "USD" }
  end


  context "with number only prices" do
    before do
      @product = Product.create! :price => 1000
    end
    subject {@product}

    its(:money_price){ should == 100000 }
  end

  context "with validations" do
    before do
      Product.class_eval do
        validates :price, :presence => true
      end

      @product = Product.new :price => ""
    end

    it "is invalid" do
      pending "Validation isn't working yet"
      @product.save.should be_false
    end
  end
end
