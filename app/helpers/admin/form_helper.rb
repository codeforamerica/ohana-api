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

    def nested_categories(categories)
      cats = []
      categories.each do |array|
        cats.push([array.first, array.second])
      end

      cats.map do |category, sub_categories|
        class_name = category.depth == 0 ? 'depth0' : "hide depth#{category.depth}"

        content_tag(:ul) do
          concat(content_tag(:li, class: class_name) do
            concat(check_box_tag 'service[category_ids][]', category.id, @oe_ids.include?(category.oe_id), id: "category_#{category.oe_id}")
            concat(label_tag dom_id(category), category.name)
            concat(nested_categories(sub_categories))
          end)
        end
      end.join.html_safe
    end
  end
end
