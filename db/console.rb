require("pry")
require_relative("../models/album")
require_relative("../models/artist")

Album.delete_all
Artist.delete_all



artist1 = Artist.new({'name' => 'Madonna'})
artist1.save

artist2 = Artist.new({'name' => 'GunsNRoses'})
artist2.save

album1 = Album.new({'title' => 'True Blue', 'genre' => 'Pop', 'artist_id' => artist1.id})
album1.save

album2 = Album.new({'title' => 'Appetite for Destruction', 'genre' => 'Hard rock', 'artist_id' => artist2.id})
album2.save

artist1.name = "Cindy"
artist1.update

binding.pry
nil
