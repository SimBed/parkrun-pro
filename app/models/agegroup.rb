class Agegroup < ApplicationRecord
  DATA = [
    { name: "SM18-19", position: 1, category: "senior", gender: "male", average_age: 18.5, active: true },
    { name: "SM20-24", position: 2, category: "senior", gender: "male", average_age: 22, active: true },
    { name: "SM25-29", position: 3, category: "senior", gender: "male", average_age: 27, active: true },
    { name: "SM30-34", position: 4, category: "senior", gender: "male", average_age: 32, active: true },
    { name: "VM35-39", position: 5, category: "veteran", gender: "male", average_age: 37, active: true },
    { name: "VM40-44", position: 6, category: "veteran", gender: "male", average_age: 42, active: true },
    { name: "VM45-49", position: 7, category: "veteran", gender: "male", average_age: 47, active: true },
    { name: "VM50-54", position: 8, category: "veteran", gender: "male", average_age: 52, active: true },
    { name: "VM55-59", position: 9, category: "veteran", gender: "male", average_age: 57, active: true },
    { name: "VM60-64", position: 10, category: "veteran", gender: "male", average_age: 62, active: true },
    { name: "VM65-69", position: 11, category: "veteran", gender: "male", average_age: 67, active: true },
    { name: "VM70-74", position: 12, category: "veteran", gender: "male", average_age: 72, active: true },
    { name: "VM75-79", position: 13, category: "veteran", gender: "male", average_age: 77, active: true },
    { name: "VM80-84", position: 14, category: "veteran", gender: "male", average_age: 82, active: true },
    { name: "VM85-89", position: 15, category: "veteran", gender: "male", average_age: 87, active: true },
    { name: "VM90-94", position: 16, category: "veteran", gender: "male", average_age: 92, active: true },
    { name: "VM95-99", position: 17, category: "veteran", gender: "male", average_age: 97, active: true },
    { name: "SM---", position: 18, category: "senior", gender: "male", average_age: nil, active: true },
    { name: "SW18-19", position: 19, category: "senior", gender: "female", average_age: 18.5, active: true },
    { name: "SW20-24", position: 20, category: "senior", gender: "female", average_age: 22, active: true },
    { name: "SW25-29", position: 21, category: "senior", gender: "female", average_age: 27, active: true },
    { name: "SW30-34", position: 22, category: "senior", gender: "female", average_age: 32, active: true },
    { name: "VW35-39", position: 23, category: "veteran", gender: "female", average_age: 37, active: true },
    { name: "VW40-44", position: 24, category: "veteran", gender: "female", average_age: 42, active: true },
    { name: "VW45-49", position: 25, category: "veteran", gender: "female", average_age: 47, active: true },
    { name: "VW50-54", position: 26, category: "veteran", gender: "female", average_age: 52, active: true },
    { name: "VW55-59", position: 27, category: "veteran", gender: "female", average_age: 57, active: true },
    { name: "VW60-64", position: 28, category: "veteran", gender: "female", average_age: 62, active: true },
    { name: "VW65-69", position: 29, category: "veteran", gender: "female", average_age: 67, active: true },
    { name: "VW70-74", position: 30, category: "veteran", gender: "female", average_age: 72, active: true },
    { name: "VW75-79", position: 31, category: "veteran", gender: "female", average_age: 77, active: true },
    { name: "VW80-84", position: 32, category: "veteran", gender: "female", average_age: 82, active: true },
    { name: "VW85-89", position: 33, category: "veteran", gender: "female", average_age: 87, active: true },
    { name: "VW90-94", position: 34, category: "veteran", gender: "female", average_age: 92, active: true },
    { name: "VW95-99", position: 35, category: "veteran", gender: "female", average_age: 97, active: true },
    { name: "SW---", position: 36, category: "senior", gender: "female", average_age: nil, active: true },
    { name: "JM10", position: 37, category: "junior", gender: "male", average_age: 10, active: true },
    { name: "JM11-14", position: 38, category: "junior", gender: "male", average_age: 12.5, active: true },
    { name: "JM15-17", position: 39, category: "junior", gender: "male", average_age: 16, active: true },
    { name: "JW10", position: 40, category: "junior", gender: "female", average_age: 10, active: true },
    { name: "JW11-14", position: 41, category: "junior", gender: "female", average_age: 12.5, active: true },
    { name: "JW15-17", position: 42, category: "junior", gender: "female", average_age: 16, active: true },
    { name: "MWC", position: 43, category: "wheelchair", gender: "male", average_age: nil, active: true },
    { name: "WWC", position: 44, category: "wheelchair", gender: "female", average_age: nil, active: true },
    { name: "", position: 45, category: nil, gender: nil, average_age: nil, active: false }
  ].freeze

  def self.categorized
    { junior:,
      men:,
      women:,
      wheelchair:
    }
  end

  private

  def self.junior
    where(category: "junior").order(:position).pluck(:name)
  end

  def self.senior_men
    where(category: "senior", gender: "male").order(:position).pluck(:name)
  end

  def self.senior_women
    where(category: "senior", gender: "female").order(:position).pluck(:name)
  end

  def self.veteran_men
    where(category: "veteran", gender: "male").order(:position).pluck(:name)
  end

  def self.veteran_women
    where(category: "veteran", gender: "female").order(:position).pluck(:name)
  end

  def self.wheelchair
    where(category: "wheelchair").order(:position).pluck(:name)
  end

  def self.men
    where(category: [ "senior", "veteran" ], gender: "male").order(:position).pluck(:name)
  end

  def self.women
    where(category: [ "senior", "veteran" ], gender: "female").order(:position).pluck(:name)
  end
end
