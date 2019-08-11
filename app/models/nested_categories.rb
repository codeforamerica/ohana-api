class NestedCategories
  include ActionView::Helpers

  def initialize(taxonomy_ids:, view:, categories: Category.arrange(order: :taxonomy_id))
    @taxonomy_ids = taxonomy_ids
    @view = view
    @categories = categories
  end

  delegate :concat, :content_tag, :checkbox_tag, :label_tag, to: :view

  def call
    safe_join(cats_and_subcats.map do |category, sub_categories|
      content_tag(:ul) do
        concat(content_tag(:li, class: class_name_for(category)) do
          concat(checkbox_tag_for(category))
          concat(label_tag_for(category))
          concat(run_recursion(sub_categories))
        end)
      end
    end)
  end

  private

  attr_reader :taxonomy_ids, :view, :categories

  def cats_and_subcats
    categories.each_with_object([]) do |array, result|
      result << [array.first, array.second]
    end
  end

  def class_name_for(category)
    depth = category.depth
    return 'depth0 checkbox' if depth.zero?

    "hide depth#{depth} checkbox"
  end

  def checkbox_tag_for(category)
    taxonomy_id = category.taxonomy_id
    check_box_tag(
      'service[category_ids][]',
      category.id,
      taxonomy_ids.include?(taxonomy_id),
      id: "category_#{taxonomy_id}"
    )
  end

  def label_tag_for(category)
    label_tag "category_#{category.taxonomy_id}", category.name
  end

  def run_recursion(categories)
    self.class.new(taxonomy_ids: taxonomy_ids, view: view, categories: categories).call
  end
end
