require "test_helper"

describe Category do
  let(:category) { categories(:government) }

  describe "validations" do 
    it "must be valid" do
      value(category).must_be :valid?
    end

    it "doesn't allow repeat names" do 
      category.save
      used_name = category.name
      new_categ = Category.new(name: used_name)

      expect(new_categ.valid?).must_equal false
    end
  end

  describe "relationships" do 
    it "can have many products" do 

      expect(category).must_respond_to :products
      expect(category.products.count).must_equal 2
    end
  end

  describe "custom methods" do 
    it "makes all input names downcase" do 
      upcase_name = "TACO CAT"
      lowercase = upcase_name.downcase
      new_category = Category.new(name: upcase_name)
      new_category.save

      expect(new_category.name).must_equal lowercase
    end
  end
end
