# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Example' }
    sequence(:email) { |n| "sample_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end

    trait :archer do
      name { 'Sterling Archer' }
      email { 'duchess@example.gov' }
    end

    trait :lana do
      name { 'Lana Kane' }
      email { 'hands@example.gov' }
    end

    trait :malory do
      name { 'Malory Archer' }
      email { 'boss@example.gov' }
    end
  end
end
