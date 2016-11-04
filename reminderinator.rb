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

def update_age(db, newPref, id)
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

def display_names(db)
 count = 1
 info = db.execute("SELECT * FROM birthdayInfo")
 info.each do |inf|
    puts "#{count}. inf['name']"
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