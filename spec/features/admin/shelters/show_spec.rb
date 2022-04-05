require 'rails_helper'

RSpec.describe 'the admin shelter show' do

  it 'displays the average age of pets adoptable at this shelter' do 
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
 
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Adoptable Pets Average Age: 4")
  end

  it 'displays the count of pets adoptable at this shelter' do 
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
 
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Adoptable Pets Count: 2")
  end



  it 'displays the count of adopted pets at this shelter' do 
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
 
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    application_1 = Application.create!(name: "Kim G", street_address:"2000 Something Blvd", city: "Denver", state: "CO", zipcode: 80124)
    application_2 = Application.create!(name: "Kim G2", street_address:"2000 Something Blvd", city: "Denver", state: "CO", zipcode: 80124)
    application_pet1 = ApplicationPet.create!(application: application_1, pet: pet_1)
    application_pet2 = ApplicationPet.create!(application: application_2, pet: pet_2)
    application_1.status = "Approved"
    application_1.save
    application_2.status = "Approved"
    application_2.save

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Number of Adopted Pets: 2")
  end

  it 'displays the count of adopted pets at this shelter and a link to its application' do 
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
 
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    application_1 = Application.create!(name: "Kim G", street_address:"2000 Something Blvd", city: "Denver", state: "CO", zipcode: 80124)
    application_2 = Application.create!(name: "Kim G2", street_address:"2000 Something Blvd", city: "Denver", state: "CO", zipcode: 80124)
    application_pet1 = ApplicationPet.create!(application: application_1, pet: pet_1)
    application_pet2 = ApplicationPet.create!(application: application_2, pet: pet_2)

    visit "/admin/shelters/#{shelter_1.id}"

    within("#action_required") do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)
    end

    visit "/admin/shelters/#{shelter_1.id}" 

    within("#action_required") do 
      click_on "Application for #{pet_1.name}"
      expect(current_path).to eq("/admin/applications/#{application_1.id}")
    end

    visit "/admin/shelters/#{shelter_1.id}" 

    within("#action_required") do 
      click_on "Application for #{pet_1.name}"
      expect(current_path).to eq("/admin/applications/#{application_1.id}")
    end
  end
end