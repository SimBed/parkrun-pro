class RunQuery
  SIMPLE_SCOPES = %i[
  ].freeze

  ARGUMENT_SCOPES = %i[
    any_agegroup_of
  ].freeze

  def initialize(filters, records, controller)
    @filters = filters
    @records = records
    @controller = controller
  end

  def call
    scoped_items
  end

  private

  def scoped_items
    relation = @records

    SIMPLE_SCOPES.each do |key|
      relation = relation.public_send(key) if filter_present?(key, @controller)
    end

    ARGUMENT_SCOPES.each do |key|
      relation = relation.public_send(key, filter_value(key, @controller)) if filter_present?(key, @controller)
    end

    relation
  end

  def filter_present?(key, controller)
    @filters.dig(controller, key).present?
    # @session["#{controller}_filter_#{key}"].present?
  end

  def filter_value(key, controller)
    @filters.dig(controller, key)
    # @session["#{controller}_filter_#{key}"]
  end
end
