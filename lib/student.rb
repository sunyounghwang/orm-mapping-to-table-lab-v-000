class Student
  attr_accessor :name, :grade
  attr_reader :id

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    student = new(name, grade)
    student.tap { student.save }
  end

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
  end
end
