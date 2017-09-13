class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'uri'
  require 'net/http'

  $country = Country.all


  def check_cookie
    # if cookies[:ip_address].present?
    if session[:ip_address].present?
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
      # puts cookies[:ip_address]
      # cookies[:cart_details] = { value: {comment: 1, data: 15}.to_yaml}
      puts session[:cart_details]
      session[:cart_count] = session[:cart_details].count
      # if cookies[:cart_details][:quantity].empty?
      # #   cookies[:cart_details] = {value: {quantity: [], id: [], uid: [], cat_code: [], type: []} }
      # else
      #   puts cookies[:cart_details]
      # end
       #JSON.generate([comment: 1, data: 15])
       if not session[:cart_details].blank?
        #  puts JSON.parse(cookies[:cart_details])
        #  cookies[:cart_count] = JSON.parse(cookies[:cart_details])['id'].count

        puts "PPPPPPPPPPPPPPPPPPPPPP"
       else
         puts "empty"
       end


    else
      puts "|||||||||||||||\\"
      puts "here"
      Thread.new do
        `ping -c 1 #{request.ip}`
        sleep(3)
        arptable = `arp -a`
        entries = arptable.split("\n")


        entries.each do |variable|
          if variable.include?request.ip
            puts variable.split(" ").fourth
            session[:mac_address] = variable.split(" ").fourth
          end
        end
      end
      # cookies[:ip_address] = request.ip
      # cookies[:cart_details] = {value: [] }
      # cookies[:cart_count] = 0
      # puts cookies[:cart_details]
      session[:ip_address] = request.ip
      session[:cart_details] ||= []
      session[:cart_count] = 0
      puts session[:ip_address]
      puts session[:mac_address]

      # {quantity: [] , id: [], uid: [], cat_code: [], type: []}
    end
  end



  def kingdomsg_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request1 = Net::HTTP::Get.new(url)
    request1["apikey"] = 'wmQ87NZhMvWx5ZvrrStJPr9FG9WQ0wOSGVXxbUKDbjAuZC6k42M3x9GOzFt2umSQhRGylMwmBmlcU'
    request1["appusername"] = 'aaa@aaa.com'
    request1["apppassword"] = 'aaa@aaa.com'
    request1["content-type"] = 'application/json'

    response = http.request(request1)
    # puts response.read_body
    data = JSON.parse(response.body)
    return data
  end

  def get_function(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request1 = Net::HTTP::Get.new(url)
    request1["apikey"] = 'wmQ87NZhMvWx5ZvrrStJPr9FG9WQ0wOSGVXxbUKDbjAuZC6k42M3x9GOzFt2umSQhRGylMwmBmlcU'
    request1["appusername"] = 'aaa@aaa.com'
    request1["apppassword"] = 'aaa@aaa.com'
    request1["content-type"] = 'application/json'

    response = http.request(request1)
    # puts response.read_body
    data = JSON.parse(response.body)
    return data
  end

  def package_booking_api(url,data,booking_total)
    user  = User.find(session[:user_id])
    payload = {}
    payload["ContactComponentSubmission"]={}
    payload["ContactComponentSubmission"]["LastName"] = user.last_name
    payload["ContactComponentSubmission"]["FirstName"] = user.first_name
    payload["ContactComponentSubmission"]["Title"] = ""
    payload["ContactComponentSubmission"]["Organization"] = ""
    payload["ContactComponentSubmission"]["EmailAddress"] = user.email
    payload["ContactComponentSubmission"]["OfficeNumber"] = ""
    payload["ContactComponentSubmission"]["FaxNumber"] = ""
    payload["ContactComponentSubmission"]["MobileNumber"] = user.phone
    payload["ContactComponentSubmission"]["UserDefinedFieldOne"] = ""
    payload["ContactComponentSubmission"]["AddressLineOne"] = user.address
    payload["ContactComponentSubmission"]["AddressLineTwo"] = ""
    payload["ContactComponentSubmission"]["AddressCity"] = user.city
    payload["ContactComponentSubmission"]["AddressState"] = user.state
    payload["ContactComponentSubmission"]["AddressPostcode"] = user.post_code.to_s
    payload["ContactComponentSubmission"]["Privacy"] = "None"
    payload["ContactComponentSubmission"]["RedirectUrl"] =  "https://www.kingdomsg.com/kingdomsg2018/response/#{ user.id }/"

    payload['Package'] = {}
    payload['Package']['Name'] = data['package_name']
    payload['Package']['PackageAmount'] = data['amount']
    payload['Package']['PackagePayCode'] = 'Purchase'
    payload['Package']['UniquePackageCode'] = data['unique_package_code']
    payload['Package']['Registrations'] = []
    main_load = {}
    main_load['Accommodations'] = []
    for i in data['Hotel_Room']
      temp1 = {}
      temp1['RoomType'] = i['Room_name']
      temp1['CheckIn'] = i['Check_in_date']
      temp1['CheckOut'] = i['Check_out_date']
      main_load['Accommodations'].push(temp1)
    end

    main_load['Functions'] = []
    for i in data['Functions']
      temp2={}
      temp2['UniqueFunctionCode'] = i['Function_code']
      temp2['FunctionPaycode'] = 'No Charge'
      temp2['NoTickets'] =
      main_load['Functions'].push(temp1)
    end
    payload['Package']['Registrations'].push(main_load)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request1 = Net::HTTP::Get.new(url)
    request1["apikey"] = 'wmQ87NZhMvWx5ZvrrStJPr9FG9WQ0wOSGVXxbUKDbjAuZC6k42M3x9GOzFt2umSQhRGylMwmBmlcU'
    request1["appusername"] = 'aaa@aaa.com'
    request1["apppassword"] = 'aaa@aaa.com'
    request1["content-type"] = 'application/json'
    puts data.to_json
    request1.body= payload.to_json

    response = http.request(request1)
    data = response.body
    return data

  end



  def kingdomsg_booking_api(url,data,booking_total,freight,cc_amount)
    user = User.find(session[:user_id])

    payload = {}
    payload["ContactComponentSubmission"]={}
    payload["ContactComponentSubmission"]["LastName"] = user.last_name
    payload["ContactComponentSubmission"]["FirstName"] = user.first_name
    payload["ContactComponentSubmission"]["Title"] = ""
    payload["ContactComponentSubmission"]["Organization"] = ""
    payload["ContactComponentSubmission"]["EmailAddress"] = user.email
    payload["ContactComponentSubmission"]["OfficeNumber"] = ""
    payload["ContactComponentSubmission"]["FaxNumber"] = ""
    payload["ContactComponentSubmission"]["MobileNumber"] = user.phone
    payload["ContactComponentSubmission"]["UserDefinedFieldOne"] = ""
    payload["ContactComponentSubmission"]["AddressLineOne"] = user.address
    payload["ContactComponentSubmission"]["AddressLineTwo"] = ""
    payload["ContactComponentSubmission"]["AddressCity"] = user.city
    payload["ContactComponentSubmission"]["AddressState"] = user.state
    payload["ContactComponentSubmission"]["AddressPostcode"] = user.post_code.to_s
    payload["ContactComponentSubmission"]["Privacy"] = "None"
    payload["ContactComponentSubmission"]["RedirectUrl"] =  "https://www.kingdomsg.com/kingdomsg2018/response/#{ user.id }/"
    # payload["ContactComponentSubmission"]["RedirectUrl"] =  "http://dev2.infiny.in:3333/response/#{ user.id }/"

    payload["Functions"] = []
    puts "thisa is data"
    puts data
    for i in data
      puts "this is it mofo"
      puts i.inspect
      data1 = {}
      # puts i.errors.full_messages
      puts "+++++++++++++++++++++++++"
      puts i['code']
      data1["UniqueFunctionCode"] = i["code"]
      data1["FunctionPaycode"] = "No Charge"
      data1["NoTickets"] = i["quantity"].to_s
      payload["Functions"].push(data1)
    end
    if freight.to_i > 0
      data1 ={}
      data1["UniqueFunctionCode"] = "FREIGHT"
      data1["FunctionPaycode"] = "Purchase"
      data1["NoTickets"] = "1"
      payload["Functions"].push(data1)
    end
    payload["Payment"]= {}
    payload["Payment"]["BookingAmount"]= booking_total.to_f
    payload["Payment"]["FreightAmount"]= freight
    payload["Payment"]["CCFeeAmount"]= cc_amount.to_f

    puts "====================="
    puts payload.to_json
    puts "====================="
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request1 = Net::HTTP::Get.new(url)
    request1["apikey"] = 'wmQ87NZhMvWx5ZvrrStJPr9FG9WQ0wOSGVXxbUKDbjAuZC6k42M3x9GOzFt2umSQhRGylMwmBmlcU'
    request1["appusername"] = 'aaa@aaa.com'
    request1["apppassword"] = 'aaa@aaa.com'
    request1["content-type"] = 'application/json'
    puts data.to_json
    request1.body= payload.to_json

    response = http.request(request1)
    data = response.body
    return data
  end

  def helpers
    ActionController::Base.helpers
  end

end
