require "test_helper"

describe ProductsController do
  let(:product) { Product.first }

  it "can get the index page" do
    get products_path

    must_respond_with :ok
  end

  describe "show" do
    it "can get the page for a product that exists" do
      get product_path(product.id)

      must_respond_with :ok
    end

    it "will redirect when given a bad product id" do
      get product_path(555555)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "logged in users" do
    before do
      @merchant = perform_login
    end

    describe "new" do
      it "can get the new page" do
        get new_product_path

        must_respond_with :ok
      end
    end

    describe "create" do
      it "can create a new product with good data" do
        product_params = {product: {
          description: "Wow",
          name: "You'll never believe it",
          price: 100,
          stock: 3,
          img_url: "wow.com/wow_wow_wow",
        }}

        expect {
          post products_path, params: product_params
        }.must_change "Product.count", +1

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "won't create a new product with bad data and will redirect" do
        product_params = {product: {
          price: 100,
          img_url: "wow.com/wow_wow_wow",
        }}

        expect { post products_path, params: product_params }.wont_change "Product.count"

        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "edit" do
      it "can get the edit page for an existing project" do
        get edit_product_path(product)

        must_respond_with :ok
      end

      it "will redirect when given a bad product ID" do
        get edit_product_path(-1)

        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "update" do
      it "will edit an existing product" do
        test_product = Product.create!(name: "You'll never believe it",
                                       price: 100,
                                       stock: 3,
                                       img_url: "wow.com/wow_wow_wow",
                                       merchant_id: Merchant.first.id)

        product_params = {product: {
          name: "new name",
        }}

        patch product_path(test_product), params: product_params
        test_product.reload

        expect(test_product.name).must_equal product_params[:product][:name]
      end
    end
  end
end
