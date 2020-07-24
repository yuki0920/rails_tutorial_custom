# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Example' }
    sequence(:email) { |n| "sample_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }
    nickname { 'example' }

    trait :admin do
      admin { true }
    end

    trait :archer do
      name { 'Sterling Archer' }
      email { 'duchess@example.gov' }
      nickname { 'archer' }
    end

    trait :lana do
      name { 'Lana Kane' }
      email { 'hands@example.gov' }
      nickname { 'lana' }
    end

    trait :malory do
      name { 'Malory Archer' }
      email { 'boss@example.gov' }
      nickname { 'malory' }
    end
  end
end
