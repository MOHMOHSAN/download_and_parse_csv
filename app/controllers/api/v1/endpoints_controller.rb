class Api::V1::EndpointsController < ApplicationController
	def download_and_parse_docs
		file_path = "https://catrina-staging.s3-ap-southeast-1.amazonaws.com/uploads/data.csv"
		process_and_parse_docs = DownloadAndParseCsvFile.new(file_path)
		if process_and_parse_docs.check_file_exist
			CustomerProductRelationship.delete_all
			Product.delete_all
			Customer.delete_all
			process_and_parse_docs.process

			payload = {
			  success: file_path+" is loaded successfully. Go back to root page to view extracted data",
			  status: "Success"
			}
			render :json => payload, :status => :ok

		else
			payload = {
			  error: "No such file;check the url is correct or file exists.Previous data existed in database is maintained.Go back to root page to view  data",
			  status: 400
			}
			render :json => payload, :status => :bad_request
		end
		# render json: {}
		# DownloadAndParseCsvFile('https://catrina-staging.s3-ap-southeast-1.amazonaws.com/uploads/data.csv')
		# render json: {}, status: :ok, filename: 'file_not_found', content_type: 'application/octet-stream'
	end
end

