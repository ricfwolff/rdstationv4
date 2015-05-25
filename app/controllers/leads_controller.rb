class LeadsController < ApplicationController
  before_action :authenticate
  before_action :initialize_client

  def index
    @leads = @client.query("select Id, FirstName, LastName, Email, Company, Title, Phone, Website from Lead")
  end

  def new
  	@lead = @client.new("Lead")
  end

  def create
  	@leadId = @client.create("Lead", lead_params)

    @lead = @client.find("Lead", @leadId)

    if @lead
      redirect_to @lead
    else
      render 'new'
    end
  end

  def edit
  	@lead = @client.find("Lead", params[:Id])
  end

  def show
  	@lead = @client.find("Lead", params[:Id])
  end

  def update
  	@lead = @client.find("Lead", params[:Id])
    if @lead.update(lead_params)
      redirect_to @lead
    else
      render 'edit'
    end
  end

  def destroy
  	@client.destroy("Lead", params[:Id])
 
    redirect_to leads_path
  end
	
  private
  def lead_params
    params.require(:lead).permit(:FirstName, :LastName, :Email, :Company, :Title, :Phone, :Website)
  end


  private

  def authenticate
    if current_user
    else
      redirect_to "/auth/salesforce"
    end
  end

  def initialize_client
    @client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url  => current_user.instance_url,
        :client_id     => Rails.application.config.salesforce_app_id,
        :client_secret => Rails.application.config.salesforce_app_secret
  end

end
