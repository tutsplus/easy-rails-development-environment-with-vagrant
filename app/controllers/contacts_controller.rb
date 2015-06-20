class ContactsController < ApplicationController
  def index
    @contacts = Contact.order(:first_name, :last_name)
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to contacts_path, notice: 'Your contact has been created.'
    else
      render :new
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])

    if @contact.update(contact_params)
      redirect_to contacts_path, notice: 'Your contact has been updated.'
    else
      render :edit
    end
  end

  def destroy
    @contact = Contact.find(params[:id])

    if @contact.destroy
      redirect_to contacts_path, notice: 'Your contact has been deleted.'
    else
      redirect_to contacts_path, alert: 'Your contact couldn\'t be deleted.'
    end
  end

  def generate
    if GenerateSampleContactsJob.perform_later(samples: 5)
      redirect_to contacts_path, notice: 'Your request to create sample contacts has been dispatched.'
    else
      redirect_to contacts_path, alert: 'Your request to create sample contacts has failed to dispatch.'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :first_name, :last_name, :street_address, :zip_code, :city, :country_code, :email, :phone_number, :twitter, :avatar_url
    )
  end
end
