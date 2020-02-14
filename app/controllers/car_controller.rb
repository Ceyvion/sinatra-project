class CarController < ApplicationController
  get '/:id/create_car' do
    if logged_in?
      erb :'car/create'
    else
      erb :failure
    end
    
  end
  post '/create_car' do

    if create_errors?
      erb :'car/create' 
    else
      car = Car.new(params)
      car.save
      car.user = User.find_by(id: session[:user_id])
      User.find_by(id: session[:user_id]).cars << car
      redirect("/user/#{session[:user_id]}")
    end
    
  end

  get '/:id/all_cars' do

    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'car/view_all'

    else
      erb :failure
    end
  end

  get '/:id/delete' do
    if logged_in?
      erb :'car/delete'
      
    else
      erb :failure
    end
  end

  delete '/:id/delete' do 
    # binding.pry   
    if logged_in?
      if params[:cars]
        params[:cars].each do |ids|
          car = Car.find_by(id: ids)
          car.destroy
        end
          redirect("#{session[:user_id]}/delete") 
      else  
        session[:error_message] = "Please make a selection or return home"
        erb :'car/delete'
      end          
    else
      erb :failure
    end
  end
  
  get '/:id/edit' do
    if logged_in?
      erb :'car/select'
    else
      erb :failure
    end
  end

  get '/:id/:car/modify' do

    @car = Car.find_by(id: params[:car])
    if logged_in?
      erb :'car/edit'
    else
      erb :failure
    end
    
  end
  patch '/:car/edit' do
    params.delete(:_method)

    @car = Car.find_by(id: params[:car])
    if update_errors?
      erb :'car/edit'
    else
      redirect("/user/#{session[:user_id]}")
    end
    
  end
end