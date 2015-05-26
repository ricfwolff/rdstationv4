class LeadsController < ApplicationController
  before_action :authenticate
  before_action :initialize_client
  before_action :clear_messages

  def index
    @leads = Lead.all

    if current_user
      #@leadsSF = @client.query("select Id, FirstName, LastName, Email, Company, Title, Phone, Website from Lead")

      @leads.each do |l|
        if l.salesforceid
          if l.salesforceid.length == 18
            @counter = @client.query('select count() from Lead where Lead.Id in (\'' + l.salesforceid + '\')')
            if @counter == 0
              l.salesforceid = nil
            end
          else
            l.salesforceid = nil
          end
        end
      end
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
    if @lead.salesforceid
      if @lead.salesforceid.length == 18
        @counter = @client.query("select count() from Lead where Id in ('" + @lead.salesforceid + "')")
        if @counter == 0
          @lead.salesforceid = nil
        end
      else
        @lead.salesforceid = nil
      end
    end
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

      @counter = 0

      if @lead.salesforceid
        puts "sfid: " + @lead.salesforceid

        if @lead.salesforceid.length == 18
          @counter = @client.query('select count() from Lead where Lead.Id in (\'' + @lead.salesforceid + '\')')
        else
          @counter = 0
        end
      end

      if @counter == 0
        @newSFLead = { "FirstName" => @lead.name, "LastName" => @lead.last_name,
                      "Email" => @lead.email, "Company" => @lead.company,
                      "Title" => @lead.job_title, "Phone" => @lead.phone,
                      "Website" => @lead.website
                   }

        @leadId = @client.create!("Lead", @newSFLead)
      else
        puts "sfid2: " + @lead.salesforceid

        @newSFLead = { "FirstName" => @lead.name, "LastName" => @lead.last_name,
                      "Email" => @lead.email, "Company" => @lead.company,
                      "Title" => @lead.job_title, "Phone" => @lead.phone,
                      "Website" => @lead.website, "Id" => @lead.salesforceid
                   }

        @client.update!("Lead", @newSFLead)
        @leadId = @lead.salesforceid
      end
      if @leadId
        puts @leadId

        @lead.salesforceid = @leadId

        @lead.save

        redirect_to @lead, :flash => { :messages => "Sent to SalesForce with success! (Id: " + @leadId + ")" }
      else
        @lead.errors.push("Could not save to SalesForce. Check your fields")
        redirect_to @lead
      end
    else
      redirect_to "/auth/salesforce"
    end
  end

  def export_destroy
    if current_user
      @lead = Lead.find(params[:id])

      if @lead.salesforceid
        puts "sfid: " + @lead.salesforceid

        if @lead.salesforceid.length == 18
          @counter = @client.query('select count() from Lead where Lead.Id in (\'' + @lead.salesforceid + '\')')
        else
          @counter = 0
        end
        
        if @counter == 0
          puts "not found to destroy"
        else
          puts "destroy: " + @lead.salesforceid

          @client.destroy!("Lead", @lead.salesforceid)
        end

        @lead.salesforceid = nil
        @lead.save
      end
      
      redirect_to @lead, :flash => { :messages => "Deleted from SalesForce with success!" }
    else
      redirect_to "/auth/salesforce"
    end
  end

  def import
    if current_user
      @lead = Lead.find(params[:id])

      if @lead.salesforceid
        puts "sfid: " + @lead.salesforceid

        if @lead.salesforceid.length == 18
          @counter = @client.query('select count() from Lead where Lead.Id in (\'' + @lead.salesforceid + '\')')
        else
          @counter = 0
        end

        if @counter == 0
          puts "nothing found to import"
        else
          @leadSF = @client.find("Lead", @lead.salesforceid)

          puts "import: " + @lead.salesforceid

          @lead.name = @leadSF.FirstName
          @lead.last_name = @leadSF.LastName
          @lead.email = @leadSF.Email
          @lead.company = @leadSF.Company
          @lead.phone = @leadSF.Phone
          @lead.website = @leadSF.Website
          @lead.job_title = @leadSF.Title
          @lead.save          
          redirect_to @lead, :flash => { :messages => "Imported from SalesForce with success!" }
        end

      end
      
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

  def clear_messages
    @messages = false
    if flash[:messages]
      @messages = flash[:messages]
      flash[:messages] = false
    end
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
