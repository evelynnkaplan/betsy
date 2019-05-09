require "test_helper"

describe CategoriesController do
  let(:category) { categories(:government) }
  let(:new_category_data) { {category: {name: "Wikileak"}} }

  describe "index" do
    it "can get the categories index page" do
      # Arrange & Act
      get categories_path

      # Assert
      must_respond_with :ok
    end

    it "will render even with no categories" do
      # Arrange
      Category.destroy_all

      # Act
      get categories_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "new" do
    it "loads the new categories form only for logged in merchants" do
      # Arrange
      perform_login

      # Act
      get new_category_path

      # Assert
      check_flash
      must_respond_with :ok
    end

    it "will respond with redirect if not logged in" do
      # Arrange & Act
      get new_category_path

      # Assert
      must_respond_with :redirect
      check_flash(:error)
    end
  end

  describe "create" do
    it "allows merchant to create a new category" do
      # Arrange is in let block

      # Act & Assert
      expect {
        post categories_path, params: new_category_data
      }.must_change "Category.count", +1

      check_flash
      must_respond_with :redirect
      must_redirect_to categories_path
    end

    it "will not add a new category to the list without a name" do
      # Arrange
      new_category_data[:category][:name] = " "

      # Act
      expect {
        post categories_path, params: new_category_data
      }.wont_change "Category.count"

      # Assert
      check_flash(:error)
      must_respond_with :bad_request
    end
  end
end
