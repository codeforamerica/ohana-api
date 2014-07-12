class Admin
  module FormHelper
    def link_to_add_fields(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render("admin/locations/forms/#{association.to_s.singularize}_fields", f: builder)
      end
      link_to(name, '#', class: 'add_fields btn btn-primary', data: { id: id, fields: fields.gsub('\n', '') })
    end

    def link_to_add_array_fields(name, model, field)
      id = ''.object_id
      fields = render("admin/#{model}/forms/#{field}_fields")
      link_to(name, '#', class: 'add_array_fields btn btn-primary', data: { id: id, fields: fields.gsub('\n', '') })
    end
  end
end
