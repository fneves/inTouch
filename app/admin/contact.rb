ActiveAdmin.register Contact do

  controller do
    def permitted_params
      params.permit(:contact => [:user_id, :contact_type_id, :v_address])
    end
  end

end
