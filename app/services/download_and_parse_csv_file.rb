require 'csv'
require 'net/http'
# require 'activerecord-import'

class DownloadAndParseCsvFile    
  def initialize(csv_url)
    @csv_url = csv_url
  end

  def check_file_exist
    uri = URI(@csv_url)
    request = Net::HTTP.get(uri)

    request = Net::HTTP.new uri.host
    response= request.request_head uri.path
    return response.code.to_i == 200
  end

  def process
    uri = URI(@csv_url)
    request = Net::HTTP.get(uri)

    csv = CSV.parse(request, headers: true)

    product_record_quantity = 1;
    if csv.headers.include?("product_id")
      product_record_quantity = csv["product_id"].map(&:to_i).max
    end

    product_values = []
    product_record_quantity.times.each do |index|
      product_obj =  { 
        id: index+1,
        product_name: "Product_#{index+1}"
      };
      product_values << product_obj
    end


    Product.upsert_all(product_values,returning: %w[id product_name],unique_by: %i[product_name])
    # Product.import product_values, validate_uniqueness: true
    puts Product.count


    customer_values = []
    hash_tables = {}
    if csv.headers.include?("first_name") and csv.headers.include?("last_name") and csv.headers.include?("email")
      
      csv.each_with_index do |row,index|
        email_value = csv["email"][index]
        first_name = csv["first_name"][index]
        last_name = csv["last_name"][index]
        product_id = csv["product_id"][index]
        quantity = csv["quantity"][index]
 
        customer_product_obj = {
            id: index+1,
            quantity: quantity,
            product_id: product_id,
            customer_id: 0
        }

        if hash_tables[email_value]
          hash_tables[email_value].push(customer_product_obj)
        else
          customer_obj = {
            first_name: first_name,
            last_name: last_name,
            email: email_value
          };
          customer_values << customer_obj
          hash_tables[email_value]= [customer_product_obj]
        end 
      end

      # puts hash_tables

      Customer.upsert_all(customer_values,returning: %w[first_name last_name email],unique_by: %i[email])
      # puts Customer.count
      # puts Customer.first.inspect

      # puts hash_tables["monique@ziemann.co.uk"]
      # puts hash_tables.keys

      email_id_pairs =  Customer.where(email: hash_tables.keys).pluck(:email,:id).to_h
      # puts output
      # puts email_id_pairs[0]

      customer_product_values = []
      hash_tables.each do |key,value|
        customer_id = email_id_pairs[key]
        value.each do |v|
          v[:customer_id] = customer_id
          customer_product_values << v
        end
      end

      # puts customer_product_values

      CustomerProductRelationship.upsert_all(customer_product_values,returning: %w[id quantity product_id customer_id])
    end
  end

  def insertProductTable(product_total_count)
  end 
end