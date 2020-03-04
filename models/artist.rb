
require_relative('../db/sql_runner')
require_relative('album.rb')

class Artist

attr_accessor :id, :name

  def initialize( options )
      @id = options['id'].to_i if options['id']
      @name = options['name']
  end

  def save
    sql = "INSERT INTO artists
          (name)
          VALUES
            ($1)
            RETURNING id"
    values = [@name]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM artists"
    artists = SqlRunner.run(sql)
    return artists.map {|artist| Artist.new(artist)}
  end

  def update
    sql = "UPDATE artists SET (
      name
    ) =
    (
      $1
    )
    WHERE id = $2"
    values = [@name, @id]
    result = SqlRunner.run(sql, values)
  end

  def Artist.find(id) 
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    db.prepare("find", sql)
    results_array = db.exec_prepared("find", values)
    db.close()
    return nil if results_array.first() == nil
    artist_hash = results_array[0]
    found_artist = Artist.new(artist_hash)
    return found_artist
  end

  def album
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    album = SqlRunner.run(sql, values)
    return album.map {|album| Album.new(album)}
  end

end
