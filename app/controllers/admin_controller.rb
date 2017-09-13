class AdminController < ApplicationController
	before_action :check_cookie
	def index
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	    else
	      @current_user = nil
	    end

		render :layout => false
	end

	def index_ajax
		start =  (params[:start]).to_i
		length = (params[:length]).to_i
		all_data = MyPayment.select('my_payments.*,users.first_name as first_name,users.last_name as last_name').joins(:user).all
		all_count = MyPayment.all.count
		if not params[:search]['value'].blank?
			puts "in search"
			searchText = ((params[:search]['value'].to_s).downcase).strip
			print searchText

			all_data = MyPayment.select('my_payments.*,users.first_name as first_name,users.last_name as last_name').joins(:user).where("my_payments.id LIKE :search or lower(users.first_name) LIKE :search or lower(users.last_name) LIKE :search or lower(total) LIKE :search or lower(date) LIKE :search or lower(payment_id) LIKE :search or lower(freight) LIKE :search or lower(cc_amount) LIKE :search" , :search => "%"+searchText+"%")
			# all_data = all_data.where("lower(comment) LIKE :search or rating::text LIKE :search or lower(first_name) LIKE :search or lower(last_name) LIKE :search or lower(wineries.name) LIKE :search " , :search => "%"+searchText+"%")

		end

		result = all_data
		filer_count = result.length

		if params[:order]['0']['column'] == "0"
			puts "============"
			if  params[:order]['0']['dir'] == "asc"
				puts "=========acs==="
				result = all_data.order('id asc').limit(length).offset(start)
				puts result.inspect
			else
				puts "=========dcs==="
				result = all_data.order('id desc').limit(length).offset(start)
				puts result.inspect
			end
		elsif params[:order]['0']['column'] == "1"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('first_name asc').limit(length).offset(start)
			else
				result = all_data.order('first_name desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "2"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('payment_id asc').limit(length).offset(start)
			else
				result = all_data.order('payment_id desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "3"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('payment_id asc').limit(length).offset(start)
			else
				result = all_data.order('payment_id desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "4"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('date asc').limit(length).offset(start)
			else
				result = all_data.order('date desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "5"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('total asc').limit(length).offset(start)
			else
				result = all_data.order('total desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "6"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('freight asc').limit(length).offset(start)
			else
				result = all_data.order('freight desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "7"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('cc_amount asc').limit(length).offset(start)
			else
				result = all_data.order('cc_amount desc').limit(length).offset(start)
			end
		else
		 	result = all_data.limit(length).offset(start)
		end

		data=[]
		for i in result
			data1=[]
			data1.append(i.id)
			data1.append(i.user.first_name+" "+i.user.last_name)
			if not i.payment_id.blank?
				data1.append('Paypal')
				data1.append(i.payment_id)
			else
				data1.append('Invoice')
				data1.append('N/A')
			end
			data1.append(i.date)
			data1.append("AUD "+i.total.to_s)
			data1.append("AUD "+i.freight.to_s)
			data1.append("AUD "+i.cc_amount.to_s)

			data1.append('<a href="/admin/transaction/show/'+i['id'].to_s+'">
				<button class="btn btn-primary" type="button">
					View
				</button>
			</a>')
			data.append(data1)
		end
		msg = {'data': data,'draw': params[:draw],'recordsTotal': all_count,'recordsFiltered': filer_count}

		respond_to do |format|
	      format.json { render json: msg }
	    end
	end



	def user_list
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	    else
	      @current_user = nil
	    end
	end


	def user_ajax
		start =  (params[:start]).to_i
		length = (params[:length]).to_i
		all_data = User.all
		all_count = User.all.count
		if not params[:search]['value'].blank?
			puts "in search"
			searchText = ((params[:search]['value'].to_s).downcase).strip
			print searchText

			all_data = all_data.where("lower(first_name) LIKE :search or lower(phone) LIKE :search or lower(last_name) LIKE :search or lower(email) LIKE :search or lower(active) LIKE :search or lower(address) LIKE :search" , :search => "%"+searchText+"%")
			# all_data = all_data.where("lower(comment) LIKE :search or rating::text LIKE :search or lower(first_name) LIKE :search or lower(last_name) LIKE :search or lower(wineries.name) LIKE :search " , :search => "%"+searchText+"%")

		end

		result = all_data
		filer_count = result.length

		if params[:order]['0']['column'] == "0"
			puts "============"
			if  params[:order]['0']['dir'] == "asc"
				puts "=========acs==="
				result = all_data.order('id asc').limit(length).offset(start)
				puts result.inspect
			else
				puts "=========dcs==="
				result = all_data.order('id desc').limit(length).offset(start)
				puts result.inspect
			end
		elsif params[:order]['0']['column'] == "1"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('first_name asc').limit(length).offset(start)
			else
				result = all_data.order('first_name desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "2"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('email asc').limit(length).offset(start)
			else
				result = all_data.order('email desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "3"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('active asc').limit(length).offset(start)
			else
				result = all_data.order('active desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "4"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('phone asc').limit(length).offset(start)
			else
				result = all_data.order('phone desc').limit(length).offset(start)
			end
		elsif params[:order]['0']['column'] == "5"
			if params[:order]['0']['dir'] == "asc"
				result = all_data.order('address asc').limit(length).offset(start)
			else
				result = all_data.order('address desc').limit(length).offset(start)
			end

		else
		 	result = all_data.limit(length).offset(start)
		end

		data=[]
		for i in result
			data1=[]
			data1.append(i.id)
			data1.append(i.first_name+" "+i.last_name)
			data1.append(i.email)

			if i.active == true
				data1.append('Active')
			else
				data1.append('Inactive')
			end
			data1.append(i.phone)
			data1.append(i.address)
			data1.append('<a href="/admin/user/show/'+i['id'].to_s+'">
				<button class="btn btn-primary" type="button">
					View
				</button>
			</a> <a href="/admin/user/edit/'+i['id'].to_s+'">
				<button class="btn btn-warning" type="button">
					Edit
				</button>
			</a>')
			data.append(data1)
		end
		msg = {'data': data,'draw': params[:draw],'recordsTotal': all_count,'recordsFiltered': filer_count}

		respond_to do |format|
	      format.json { render json: msg }
	    end

	end



	def transaction_detail
		@user = MyPayment.find(params[:my_payment_id]).user
		items = MyOrder.where(:my_payment_id => params[:my_payment_id])
      	@my_order = []
      	for i in items
          data1 = {}
          if i.item == 'event'
            event = Event.find(i.item_id)
            data1['item_type'] = 'Event'
            data1['name'] = event.name+", "+i.item_cat_code
            data1['amount'] = i.rate
            data1['quantity'] = i.quantity
            data1['event_date'] = event.date.strftime("%d %b %y")
          end
          @my_order.push(data1)
        end
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	    else
	      @current_user = nil
	    end
		render :layout => false
	end


	def user_show
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	    else
	      @current_user = nil
	    end
		@user = User.find(params[:id])
	end


	def edit_user
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	    else
	      @current_user = nil
	    end
		@user = User.find(params[:id])
	end

	def update_user
		if session[:user_id]
	      @current_user = User.find(session["user_id"])
	   else
	      @current_user = nil
	  end
		@user = User.find(params[:id])
		if @user.update(:first_name => params[:first_name], :last_name => params[:last_name],:email => params[:email] ,:phone => params[:phone], :address => params[:address], :city => params[:city], :state => params[:state], :post_code => params[:post_code], :country => params[:country], :middle_name => params[:middle_name], :active => params[:active] )
      @user.save
      redirect_to '/admin/user_list', :flash => {:success => "User info updated"}
      # reset_session
    else
      redirect_to '/admin/user_list', :flash => {:error => "User profile cannot be updated"}
    end

	end

end
