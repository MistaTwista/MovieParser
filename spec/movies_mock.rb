require 'movie_builder'

module MoviesMock
  ANCIENT_MOVIE = {url: "http://imdb.com/title/tt0034583/?ref_=chttp_tt_32", title: "Casablanca", year: "1942", country: "USA", date: "1943-01-23", genre: "Drama,Romance,War", length: "102 min", rate: "8.6", director: "Michael Curtiz", actors: "Humphrey Bogart,Ingrid Bergman,Paul Henreid"}
  CLASSIC_MOVIE = {url: "http://imdb.com/title/tt0050083/?ref_=chttp_tt_5", title: "12 Angry Men", year: "1957", country: "USA", date: "1957-04", genre: "Crime,Drama", length: "96 min", rate: "8.9", director: "Sidney Lumet", actors: "Henry Fonda,Lee J. Cobb,Martin Balsam"}
  MODERN_MOVIE = {url: "http://imdb.com/title/tt0111161/?ref_=chttp_tt_1", title: "The Shawshank Redemption", year: "1994", country: "USA", date: "1994-10-14", genre: "Crime,Drama", length: "142 min", rate: "9.3", director: "Frank Darabont", actors: "Tim Robbins,Morgan Freeman,Bob Gunton"}
  NEW_MOVIE = {url: "http://imdb.com/title/tt0468569/?ref_=chttp_tt_4", title: "The Dark Knight", year: "2008", country: "USA", date: "2008-07-18", genre: "Action,Crime,Drama", length: "152 min", rate: "9.0", director: "Christopher Nolan", actors: "Christian Bale,Heath Ledger,Aaron Eckhart"}
  UNKNOWN_MOVIE = {url: "http://imdb.com/title/tt0468569/?ref_=chttp_tt_4", title: "The Dark Knight", year: "2100", country: "USA", date: "2008-07-18", genre: "Action,Crime,Drama", length: "152 min", rate: "9.0", director: "Christopher Nolan", actors: "Christian Bale,Heath Ledger,Aaron Eckhart"}
end
