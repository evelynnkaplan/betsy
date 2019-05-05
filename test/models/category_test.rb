require "test_helper"

describe Category do
  let(:category) { Category.new(name: "Taco Cat") }

  describe "validations" do 
    it "must be valid" do
      value(category).must_be :valid?
    end

    it "doesn't allow repeat names" do 
      category.save
      new_categ = Category.new(name: "Taco Cat")

      expect(new_categ.valid?).must_equal false
    end
  end
end
