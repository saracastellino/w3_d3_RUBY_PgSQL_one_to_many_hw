require('pg')
require_relative('../db/sql_runner')
require_relative('artist.rb')

class Album

attr_reader :title, :genre, :id

  def initialize( options )
      @title = options['title']
      @genre = options['genre']
      @id = options['id'].to_i if options['id']
      @artist_id = options['artist_id'].to_i
  end

  def save
    sql = "INSERT INTO albums
          (title,
          genre,
          artist_id)
          VALUES
            ($1, $2, $3)
            RETURNING id"
    values = [@title, @genre, @artist_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def self.delete_all
    # db = PG.connect({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
    # db.prepare("delete_all", sql)
    # db.exec_prepared("delete_all")
    # db.close
  end


  def self.all
    sql = "SELECT * FROM albums"
    albums = SqlRunner.run(sql)
    return albums.map {|album| Album.new(album)}
  end

  def artist
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    artist = SqlRunner.run(sql, values)[0]
    return Artist.new(artist)
  end #WORKS!!!
end
