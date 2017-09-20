require 'ostruct'

FactoryGirl.define do
  factory :movie, class: OpenStruct do
    title FFaker::Movie.title
  end
end
