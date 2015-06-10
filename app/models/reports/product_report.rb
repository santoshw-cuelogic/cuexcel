class Reports::ProductReport

  def initialize(price)
    @price = price
  end

  def present
    get_product_details
  end

  def get_product_details
    header = ["Name", "Description", "Price"]
    products = Product.where("price >= ? ", @price.to_f)
    product_details = []
    if products.present?
      products.each do |product|
        data = [product.name, product.description, product.price]
        product_details << data
      end
    end

    [header, product_details]
  end


end