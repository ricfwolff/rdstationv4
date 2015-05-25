class LeadsController < ApplicationController
  def index
    if current_user
      client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url  => current_user.instance_url,
        :client_id     => Rails.application.config.salesforce_app_id,
        :client_secret => Rails.application.config.salesforce_app_secret

      leads = client.query("select FirstName name, LastName last_name, Email email, Company company, Title job_title, Phone phone, Website website from Lead")
      @leads = leads.all
    else
      @leads = Lead.all      
    end
  end

  def new
  	@lead = Lead.new()
  end

  def create
  	@lead = Lead.new(lead_params)

    if @lead.save
      redirect_to @lead
    else
      render 'new'
    end
  end

  def edit
  	@lead = Lead.find(params[:id])
  end

  def show
  	@lead = Lead.find(params[:id])
  end

  def update
  	@lead = Lead.find(params[:id])
    if @lead.update(lead_params)
      redirect_to @lead
    else
      render 'edit'
    end
  end

  def destroy
  	@lead = Lead.find(params[:id])
    @lead.destroy
 
    redirect_to leads_path
  end
	
  private
  def lead_params
    params.require(:lead).permit(:name, :last_name, :email, :company, :job_title, :phone, :website)
  end
end
