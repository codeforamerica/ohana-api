class Admin
  module FormHelper
    def link_to_add_fields(name, form, association)
      new_object = form.object.class.reflect_on_association(association).klass.new
      id = new_object.object_id
      fields = form.fields_for(association, new_object, child_index: id) do |builder|
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

    def error_class_for(model, attribute, field)
      return if model.errors[attribute].blank?

      'field_with_errors' if field_contains_errors?(model, attribute, field)
    end

    def field_contains_errors?(model, attribute, field)
      model.errors[attribute].select { |error| error.include?(field) }.present?
    end

    # rubocop:disable Metrics/MethodLength
    def org_autocomplete_field_for(form, admin)
      if admin.super_admin?
        form.hidden_field(
          :organization_id,
          id: 'org-name',
          class: 'form-control',
          data: { 'ajax-url' => admin_organizations_url,
                  'placeholder' => t('.placeholder') }
        )
      else
        form.select(
          :organization_id,
          policy_scope(Organization).map { |org| [org.second, org.first] },
          {}, class: 'form-control'
        )
      end
    end
    # rubocop:enable Metrics/MethodLength

    def program_autocomplete_field_for(form, location)
      form.select(
        :program_id, location.organization.programs.pluck(:name, :id),
        { include_blank: t('.include_blank') },
        class: 'form-control'
      )
    end

    WEEKDAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

    def weekday_select_field
      WEEKDAYS.each_with_index.map { |day, i| [day, i + 1] }
    end
  end
end
