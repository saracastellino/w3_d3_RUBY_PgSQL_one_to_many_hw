require('pg')
require_relative('../db/sql_runner')
require_relative('album.rb')

class Artist

attr_reader :name, :id

  def initialize( options )
      @id = options['id'].to_i if options['id']
      @name = options['name']
      @artist_id = options['artist_id'].to_i
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
    # db = PG.connect({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
    # db.prepare("delete_all", sql)
    # db.exec_prepared("delete_all")
    # db.close
  end

  def self.all
    sql = "SELECT * FROM artists"
    artists = SqlRunner.run(sql)
    return artists.map {|artist| Artist.new(artist)}
  end

  def update()
    sql = "
    UPDATE artists SET (
      name,
      artist_id
    ) =
    (
      $1,$2
    )
    WHERE id = $3"
    values = [@name, @artist_id, @id]
    SqlRunner.run(sql, values)
  end

  def album
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    album = SqlRunner.run(sql, values)
    return album.map {|album| Album.new(album)}
  end

end
