require 'sqlite3'
require 'date'

db = SQLite3::Database.new("info.db")
db.results_as_hash = true

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
#
def create_new_info(db, name, age, birthday, preferences= "N/A")
	db.execute("INSERT INTO birthdayInfo(name, age, birthday, preferences) VALUES (?, ?, ?, ?)", [name, age, birthday, preferences])
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

puts "Welcome to the Reminderinator, where we remember your friends' birthdays so you don't have to!"
puts "What would you like to do today?"
