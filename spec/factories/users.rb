# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Example' }
    email { 'sample@example.com' }
    password { 'password' }
    password_confirmation { 'password' }

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
