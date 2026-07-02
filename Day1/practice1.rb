products = [
  {
    sku: "A101",
    name: "Keyboard",
    price: 50,
    stock: 10,
    category: "Electronics"
  },
  {
    sku: "A102",
    name: "Mouse",
    price: 20,
    stock: 0,
    category: "Electronics"
  },
  {
    sku: "B201",
    name: "Chair",
    price: 120,
    stock: 5,
    category: "Furniture"
  }
]

def available_products(products)
  products.select{|product| product[:stock]>0} 
end

def unavailable_products(products)
  products.select{|product| product[:stock]==0}
end

def inventory_value(products)
  products.reduce(0) {|sum, product| sum + (product[:price] * product[:stock])}
end

def group_by_category(products)
  products.group_by{|product| product[:category]}
end

def find_product_by_sku(products, sku)
  products.find{|product| product[:sku] == sku}
end

def expensive_products(products, threshold)
  products.select{|product| product[:price] > threshold}
end

def product_names(products)
  products.map{|product| product[:name]}
end

def total_stock_value_by_category(products)
  products.reduce(Hash.new(0)) do |totals, product|
    totals[product[:category]] += product[:price] * product[:stock]
    totals
  end
end

def sku_to_product(products)
  products.each_with_object({}) do |product, lookup|
    lookup[product[:sku]] = product
  end
end