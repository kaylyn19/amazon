class User < ApplicationRecord
    has_secure_password
    has_many :products, dependent: :nullify
    has_many :reviews, dependent: :nullify

    scope(:search, -> (search_term) {where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")})


    # Write a scope that takes a parameter and return all users created after given date...
    scope(:created_after, -> (period) {where("created_at >= '#{period}'")}) #timestamp needs to be smaller than 'created at'
    


    scope(:notYou, -> (name) {where('first_name != ? AND last_name != ?', "%#{name}%", "%#{name}%")})
    # def self.notJohn
    #     where('first_name != ? AND last_name != ?', 'John', 'John')
    #     # where (not "first_name ILIKE 'john'" and not "last_name ILIKE 'john'")
    # end

    # Find all the users that were created after date1 and before date2
    scope(:users_between_dates, -> (date1, date2) {where(["created_at BETWEEN ? AND ?", date1, date2])})
    # scope(:find_users, -> (date1, date2) {where ("created_at >= ? AND created_at <= ?", date1, date2)})
    # worked in the console: User.where(created_at: "2015-10-26".."2015-11-28")

    def full_name
        "#{first_name} #{last_name}"
    end
end
