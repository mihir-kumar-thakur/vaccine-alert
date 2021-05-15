class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :vaccine_data

  def index
  end

  def terms
  end

  def privacy
  end

  def vaccine_data
    begin
      centers = params[:data][:users][:data][:centers]
      SlotCheck.run(centers)
    rescue Exception => e
      byebug
    end

    head :ok
  end
end
