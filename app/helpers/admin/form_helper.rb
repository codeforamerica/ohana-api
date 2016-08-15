class Admin
  module FormHelper
    def link_to_add_fields(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render("admin/locations/forms/#{association.to_s.singularize}_fields", f: builder)
      end
      link_to(
        name,
        '#',
        class: 'add-fields btn btn-primary', data: { id: id, fields: fields.gsub('\n', '') }
      )
    end

    def link_to_add_array_fields(name, model, field)
      id = ''.object_id
      fields = render("admin/#{model}/forms/#{field}_fields")
      link_to(
        name,
        '#',
        class: 'add-array-fields btn btn-primary', data: { id: id, fields: fields.gsub('\n', '') }
      )
    end

    def nested_categories(categories)
      safe_join(cats_and_subcats(categories).map do |category, sub_categories|
        content_tag(:ul) do
          concat(content_tag(:li, class: class_name_for(category)) do
            concat(checkbox_tag_for(category))
            concat(label_tag_for(category))
            concat(nested_categories(sub_categories))
          end)
        end
      end)
    end

    def cats_and_subcats(categories)
      cats = []
      categories.each do |array|
        cats.push([array.first, array.second])
      end
      cats
    end

    def class_name_for(category)
      return 'depth0 checkbox' if category.depth.zero?
      "hide depth#{category.depth} checkbox"
    end

    def checkbox_tag_for(category)
      check_box_tag(
        'service[category_ids][]',
        category.id,
        @taxonomy_ids.include?(category.taxonomy_id),
        id: "category_#{category.taxonomy_id}"
      )
    end

    def label_tag_for(category)
      label_tag "category_#{category.taxonomy_id}", category.name
    end

    def error_class_for(model, attribute, field)
      return if model.errors[attribute].blank?
      'field_with_errors' if field_contains_errors?(model, attribute, field)
    end

    def field_contains_errors?(model, attribute, field)
      model.errors[attribute].select { |error| error.include?(field) }.present?
    end

    # rubocop:disable Metrics/MethodLength
    def org_autocomplete_field_for(f, admin)
      if admin.super_admin?
        f.hidden_field(
          :organization_id,
          id: 'org-name',
          class: 'form-control',
          data: { 'ajax-url' => admin_organizations_url,
                  'placeholder' => 'Choose an organization' }
        )
      else
        f.select(
          :organization_id,
          policy_scope(Organization).map { |org| [org.second, org.first] },
          {}, class: 'form-control'
        )
      end
    end
    # rubocop:enable Metrics/MethodLength

    def program_autocomplete_field_for(f)
      f.select(
        :program_id, @location.organization.programs.pluck(:name, :id),
        { include_blank: 'This service is not part of any program' },
        class: 'form-control'
      )
    end

    WEEKDAYS = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday).freeze

    def weekday_select_field
      WEEKDAYS.each_with_index.map { |day, i| [day, i + 1] }
    end
  end
end
