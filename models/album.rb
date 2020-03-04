
require_relative('../db/sql_runner')
require_relative('artist.rb')

class Album

attr_accessor :title, :genre, :artist_id
attr_reader :id

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
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def update
  sql = "UPDATE albums SET (
    title,
    genre,
    artist_id,
  ) =
  (
    $1, $2, $3
  )
  WHERE id = $4"
  values = [@title, @genre, @artist_id, @id]
  result = SqlRunner.run(sql, values)
  end

  def Album.find(id)
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "SELECT * FROM albums WHERE id = $1"
    values = [id]
    db.prepare("find", sql)
    results_array = db.exec_prepared("find", values)
    db.close()
    return nil if results_array.first() == nil
    album_hash = results_array[0]
    found_album = Album.new(album_hash)
    return found_album
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
  end
end
