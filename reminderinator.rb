require 'sqlite3'
require 'date'

db = SQLite3::Database.new("info.db")
db.results_as_hash = true

today = DateTime.now

create_table_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS birthdayInfo (
  	id INTEGER PRIMARY KEY,
  	name VARCHAR(255),
  	age INTEGER,
  	birthday VARCHAR(255),
  	preferences VARCHAR(255)
  	)
SQL


db.execute(create_table_cmd)

#Helper methods. Aim is to:
#Add a new person to the birthday list when required
#Update any aspect of a person's info in the database
#Delete any person to the list when desired
#IF you view a person's info and their birthday is today, you will get a snarky notification
def create_new_info(db, name, age, birthday, preferences= "N/A")
	db.execute("INSERT INTO birthdayInfo(name, age, birthday, preferences) VALUES (?, ?, ?, ?)", [name, age, birthday, preferences])
  db.execute("SELECT * FROM birthdayInfo")
end

def update_age(db, newAge, id)
	db.execute("UPDATE birthdayInfo SET age = ? WHERE id = ?", [newAge, id])
end

def update_birthday(db, newDate, id)
	db.execute("UPDATE birthdayInfo SET birthday = ? WHERE id = ?", [newDate, id])
end

def update_name(db, newName, id)
	db.execute("UPDATE birthdayInfo SET name = ? WHERE id = ?", [newName, id])
end

def update_preferences(db, newPref, id)
	db.execute("UPDATE birthdayInfo SET preferences = ? WHERE id = ?", [newPref, id])
end

def delete_info(db, id)
  db.execute("DELETE FROM birthdayInfo WHERE id = ?", [id])
end

def view_info(db, id)
  db.execute("SELECT * FROM birthdayInfo WHERE id = ?"[id])
end

def view_all(db)
  db.execute("SELECT * FROM birthdayInfo")
  end
end

def list_choices
  puts "What would you like to do today? Please select from one of these options (Input the number of the option):"
  puts "1. Look at Birthday List"
  puts "2. Add to List"
  puts "3. Delete from List"
  puts "4. Check for birthdays"
  puts "5. Update Values"
  puts "6. Exit Program"
end

def list_value_choices
  puts "1. Name"
  puts "2. Age"
  puts "3. Birthday"
  puts "4. Preferences"
end

def display_names(db)
 info = db.execute("SELECT * FROM birthdayInfo")
 info.each do |inf|
    puts "#{inf[id]}. #{inf['name']}"
    count += 1
 end
end

def check_birthdays(db)
  info = db.execute("SELECT * FROM birthdayInfo")
  info.each do |inf|
    birthdayString = inf['birthday'].split("/")
    if(today.month.to_i == birthdayString[0].to_i && today.day.to_i == birthdayString[1].to_i)
      puts "#{inf['name']}\'s birthday is today! Did you remember?"
    end
  end
end

puts "Welcome to the Reminderinator, where we remember your friends' birthdays so you don't have to!"
puts "What would you like to do today? Please select from one of these options (Input the number of the option):"
list_choices
while input = gets.chomp
  case input
  when "1"
    puts "Here's all the people in the database so far:"
    view_all(db)
    puts "Anything else you'd like to do?"
    list_choices
  when "2"
    puts "Please input the new person's information as follows: "
    puts "Name: "
    name = gets.chomp
    puts "Age: "
    age = gets.chomp.to_i
    puts "Birthday Date (Input in MM/DD/YYYY style): "
    birthday = gets.chomp
    puts "Gift preferences (if none, type N/A): "
    preferences = gets.chomp
    create_new_info(name, age, birthday, preferences)
    puts "Great! That person has been registered! Anything else?"
    list_choices
  when "3"
    puts "Whose information would you like to delete? Please input the selected person's ID number."
    display_names
    begin
      chosen_id = gets.chomp
      chosen_id = Integer(chosen_id)
    rescue
      print "Please enter an integer number."
      retry
    end
    numPeople = db.execute("SELECT Count(*) FROM birthdayInfo").to_i
    unless chosen_id > numPeople
      delete_info(db, chosen_id)
    else
      print "Sorry, that input is invalid. Try again!"
    end
    puts "Is there anything else you'd like to do?"
    list_choices
  when "4"
    check_birthdays(db)
    puts "Is there anything else you'd like to do?"
    list_choices
  when "5"
    puts "Whose information would you like to update? Please input the selected person's ID number."
    display_names
    begin
      chosen_id = gets.chomp
      chosen_id = Integer(chosen_id)
    rescue
      print "Please enter an integer number."
      retry
    end
    numPeople = db.execute("SELECT Count(*) FROM birthdayInfo").to_i
    unless chosen_id > numPeople
      puts "Which aspect of their info would you like to change? Please select the number of your choice."
      list_value_choices
      begin
        chosen_value = gets.chomp
        chosen_value = Integer(chosen_value)
      rescue
        print "Please input an integer number."
        retry
      end
      case chosen_value.to_i
      when 1
        puts "What would you like their new name value to be?"
        new_name = gets.chomp
        update_name(db, new_name, chosen_id)
      when 2
        puts "What would you like their new age to be?"
        new_age = gets.chomp.to_i
        update_age(db, new_age, chosen_id)
      when 3
        puts "What would you like their new birthday date to be?"
        new_date = gets.chomp
        update_birthday(db, new_date, chosen_id)
      when 4
        puts "What are their new preferences?"
        new_pref = gets.chomp
        update_preferences(db, new_pref, chosen_id)
      else
        puts "That's not a valid input."
      end
    end
    puts "Anything else you'd like to do?"
    list_choices
  when "6"
    puts "Thank you for using the Reminderinator!"
    break
  else
    puts "That's not a valid input! Try again!"
  end
end
