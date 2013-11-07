ActiveAdmin.register ContactType do

  controller do
    def permitted_params
      params.permit(:contact_type => [:descriptor])
    end
  end

end
