require "test_helper"

describe CategoriesController do
  let(:category) { categories(:government) }

  describe "index" do 
    it "can get the categories index page" do 
      get categories_path

      must_respond_with :ok
    end

    it "will render even with no categories" do 
      Category.destroy_all

      get categories_path

      must_respond_with :ok
    end
  end

  describe "new" do 
    it "loads the new categories form only for logged in merchants" do
      perform_login
      get new_category_path

      must_respond_with :ok
    end

    it "will respond with redirect if not logged in" do 
    end
  end

  describe "create" do 
    it "allows merchant to create a new category" do
      perform_login

      new_category = {
        category: {
          name: "Wikileak"
        }
      }

      expect {
        post categories_path, params: new_category
    }.must_change "Category.count", +1
      
      must_respond_with :redirect
    end 
  end

  describe "show" do
    it "lists all categories" do
      get category_path(category)
      
    end 
  end
end
