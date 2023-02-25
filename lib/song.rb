class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

# create the table
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
    # DB[:conn].execute("PRAGMA table_info(songs)"
  end 

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO songs (name, album)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.album)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    end
  end

  def self.create (name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end 

  def update
    sql = "UPDATE songs SET name = ?, album = ? WHERE name = ?"
    DB[:conn].execute(sql, self.name, self.album, self.name, self.id)
  end

end
