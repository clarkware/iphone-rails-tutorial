# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user = User.create(:username => 'test', 
                   :email    => 'test@saveup.com',
                   :password => "testing",
                   :password_confirmation => "testing")
                

ipad = Goal.new(:name => "iPad", :amount => 500.00)
ipad.credits << Credit.new(:name => "Cancel subscription", :amount => 25.00)
ipad.credits << Credit.new(:name => "Popcorn at movie",    :amount => 9.00)
ipad.credits << Credit.new(:name => "Coupon at store",     :amount => 15.00)
user.goals << ipad

donation = Goal.new(:name => "Charitable Donation", :amount => 100.00)
donation.credits << Credit.new(:name => "Skipped dessert",     :amount => 6.50)
donation.credits << Credit.new(:name => "Economy vs. luxury",  :amount => 8.00)
donation.credits << Credit.new(:name => "Only two beers",      :amount => 10.00)
donation.credits << Credit.new(:name => "New shoes",           :amount => 50.00)
donation.credits << Credit.new(:name => "Lawn mowing",         :amount => 25.50)
donation.save
user.goals << donation

gift = Goal.new(:name => "Birthday Gift", :amount => 25.00)
gift.credits << Credit.new(:name => "Latte", :amount => 5.00)
gift.save
user.goals << gift

concert = Goal.new(:name => "Concert Tickets", :amount => 150.00)
concert.save
user.goals << concert

vacation = Goal.new(:name => "Tropical Vacation", :amount => 2500.00)
vacation.credits << Credit.new(:name => "Regular vs. premium", :amount => 2.00)
vacation.credits << Credit.new(:name => "Skipped dessert",     :amount => 6.50)
vacation.credits << Credit.new(:name => "Windows Mobile Conference",  :amount => 1500.00)
vacation.save
user.goals << vacation

