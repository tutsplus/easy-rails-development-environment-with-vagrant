class GenerateSampleContactsJob < ActiveJob::Base
  queue_as :default

  def perform(samples: 5)
    samples.times do
      Contact.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        street_address: Faker::Address.street_address,
        zip_code: Faker::Address.zip_code,
        city: Faker::Address.city,
        country_code: Faker::Address.country_code,
        email: Faker::Internet.safe_email,
        phone_number: Faker::PhoneNumber.phone_number,
        twitter: Faker::Internet.user_name(1..15, %w(_)),
        avatar_url: Faker::Avatar.image(nil, '80x80')
      )
    end
  end
end
