class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_by_name_alpha_reverse
    Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name DESC;")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def adoptable_pets_average_age
    adoptable_pets.average(:age).to_i
  end

  def adopted_pets_count
    pets.joins(:applications).where("applications.status = 'Approved'").count
  end

  def pending_pets_for_review
    pets.joins(:application_pets).where("application_pets.status IS NULL")
  end

  def pending_applications_for_pet(pet_id)
    Application.joins(:pets).where("pets.id = #{pet_id}")
  end

  def self.shelter_with_pending_app
    Shelter.joins(pets: :applications).where("applications.status = 'Pending'").order(:name)
  end

end
