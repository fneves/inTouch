class ContactsController < ApplicationController
   before_action :load_user
   before_action :load_contact, only: [:update, :destroy, :show, :edit]

  def index
    @contacts = Contact.where(:user_id => @user.id)
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:success] = 'Successfully created contact'
      redirect_to :index
    else
      render :new
    end
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def show
    redirect_to :edit
  end

  def update
    if @contact.update(contact_params)
      flash[:success] = 'Successfully updated contact'
      redirect_to :index
    else
      render :edit
    end
  end

  def destroy
    unless @contact.destroy
      flash[:error] = "Could not delete contact #{contact}"
    end
    redirect_to :index
  end

  private

  def contact_params
    params.require(:contact).permit(:v_address, :contact_type)
  end

  def load_user
    @user = current_user
  end

  def load_contact
    Contact.find(params[:id])
  end

end
