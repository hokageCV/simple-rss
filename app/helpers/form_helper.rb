module FormHelper
  def input_field(form, field, options = {})
    field_type =
      if field.to_s.include?("password")
        :password_field
      elsif field.to_s.include?("email")
        :email_field
      else
        :text_field
      end

    form.public_send(field_type, field, options)
  end
end
