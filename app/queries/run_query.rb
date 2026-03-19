class RunQuery
  SIMPLE_SCOPES = %i[
  ].freeze

  ARGUMENT_SCOPES = %i[
    any_agegroup_of
  ].freeze

  def initialize(session, records)
    @session = session
    @records = records
  end

  def call
    scoped_items
  end

  private

  def scoped_items
    relation = @records

    SIMPLE_SCOPES.each do |key|
      relation = relation.public_send(key) if filter_present?(key)
    end

    ARGUMENT_SCOPES.each do |key|
      relation = relation.public_send(key, filter_value(key)) if filter_present?(key)
    end

    relation
  end

  def filter_present?(key)
    @session["filter_#{key}"].present?
  end

  def filter_value(key)
    @session["filter_#{key}"]
  end
end
