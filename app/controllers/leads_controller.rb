class LeadsController < ApplicationController
  before_action :authenticate
  before_action :initialize_client

  def index
    @leads = Lead.all

    if current_user
      @leadsSF = @client.query("select Id, FirstName, LastName, Email, Company, Title, Phone, Website from Lead")
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
  
  def export
    if current_user
      @lead = Lead.find(params[:id])
      @externalId = 'rdstation_' + @lead.id.to_s

      puts "Hello, logs!"

      puts @externalId


      @newSFLead = { "FirstName" => @lead.name, "LastName" => @lead.last_name,
                      "Email" => @lead.email, "Company" => @lead.company,
                      "Title" => @lead.job_title, "Phone" => @lead.phone,
                      "Website" => @lead.website, "ExternalId" => @externalId
                   }

      @leadId = @client.create("Lead", @newSFLead)

      @lead.salesforceid = @leadId

      @lead.save

      redirect_to @lead
    else
      redirect_to "/auth/salesforce"
    end
  end


  private

  def lead_params
    params.require(:lead).permit(:name, :last_name, :email, :company, :job_title, :phone, :website)
  end

  def lead_sf_params
    params.require(:lead).permit(:Id, :FirstName, :LastName, :Email, :Company, :Title, :Phone, :Website)
  end

  def new_lead_sf_params
    params.require(:lead).permit(:FirstName, :LastName, :Email, :Company, :Title, :Phone, :Website)
  end

  
  def authenticate
#    if current_user
#    else
#      redirect_to "/auth/salesforce"
#    end
  end

  def initialize_client
    if current_user
      @client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url  => current_user.instance_url,
        :client_id     => Rails.application.config.salesforce_app_id,
        :client_secret => Rails.application.config.salesforce_app_secret
      end
  end

  # def index
  #   @leads = @client.query("select Id, FirstName, LastName, Email, Company, Title, Phone, Website from Lead")
  # end

  # def new
  # 	@lead = @client.describe("Lead")
  # end

  # def create
  # 	@leadId = @client.create("Lead", new_lead_params)

  #   @lead = @client.find("Lead", @leadId)

  #   if @lead
  #     redirect_to @lead
  #   else
  #     render 'new'
  #   end
  # end

  # def edit
  # 	@lead = @client.find("Lead", params[:id])
  # end

  # def show
  # 	@lead = @client.find("Lead", params[:id])
  # end

  # def update
  #   if @client.update("Lead", lead_params)
  #     redirect_to leads_path
  #   else
  #     render 'edit'
  #   end
  # end

  # def destroy
  # 	@client.destroy("Lead", params[:id])
 
  #   redirect_to leads_path
  # end
	

end
