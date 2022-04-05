require 'rails_helper'

RSpec.describe 'the admin shelter show' do

  it 'displays the average age of pets adoptable at this shelter' do 
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
 
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Adoptable Pets Average Age: 4")
  end

end