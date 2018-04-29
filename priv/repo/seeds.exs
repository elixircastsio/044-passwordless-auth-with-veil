# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Teacher.Repo.insert!(%Teacher.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Teacher.Repo
alias Teacher.Records.Album

Repo.insert!(%Album{
  title: "Blonde on Blonde",
  artist: "Bob Dylan",
  summary: "Blonde on Blonde is the seventh studio album by American singer-songwriter Bob Dylan, released in mid 1966, on Columbia Records. Recording sessions began in New York in October 1965 with numerous backing musicians, including members of Dylan's live backing band, the Hawks.",
  year: "1966",
  price: 1200
})

Repo.insert!(%Album{
  title: "The Wild, The Innocent & The E Street Shuffle",
  artist: "Bruce Springsteen",
  summary: "The Wild, the Innocent & the E Street Shuffle is the second studio album by American rock singer-songwriter Bruce Springsteen. It was recorded by Springsteen with the E Street Band at 914 Sound Studios in Blauvelt, New York; and released on September 11, 1973, by Columbia Records.",
  year: "1973",
  price: 900
})

Repo.insert!(%Album{
  title: "Abbey Road",
  artist: "The Beatles",
  summary: "Abbey Road is the eleventh album by English rock band the Beatles, released on 26 September 1969 by Apple Records. The recording sessions for the album were the last in which all four Beatles participated. Although Let It Be was the final album that the Beatles completed before the band's dissolution in April 1970",
  year: "1969",
  price: 1100
})

Repo.insert!(%Album{
  title: "Untitled",
  artist: "Led Zeppelin",
  summary: "English rock band Led Zeppelin's untitled fourth album, commonly known as Led Zeppelin IV, was released on 8 November 1971 by Atlantic Records. Produced by guitarist Jimmy Page, it was recorded between November 1970 and January 1971 at several locations, most prominently the Victorian house Headley Grange.",
  year: "1971",
  price: 1100
})

Repo.insert!(%Album{
  title: "Highway 61 Revisited",
  artist: "Bob Dylan",
  summary: "Highway 61 Revisited is the sixth studio album by the American singer-songwriter Bob Dylan. It was released on August 30, 1965, by Columbia Records. Having until then recorded mostly acoustic music, Dylan used rock musicians as his backing band on every track of the album, except for the closing 11-minute ballad, 'Desolation Row'.",
  year: "1965",
  price: 1200
})

Repo.insert!(%Album{
  title: "Kind Of Blue",
  artist: "Miles Davis",
  summary: "Kind of Blue is a studio album by American jazz trumpeter Miles Davis. It is regarded by many critics as jazz's greatest record, Davis's masterpiece, and one of the best albums of all time. Its influence on music, including jazz, rock, and classical genres, has led writers to also deem it one of the most influential albums ever recorded.",
  year: "1959",
  price: 1000
})
