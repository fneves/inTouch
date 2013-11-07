ActiveAdmin.register User do


  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
    end

    f.actions
  end


  controller do
    def permitted_params
      params.permit(:user => [:email, :password, :password_confirmation])
    end
  end

end
