//
//  SimilarMovieResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/08.
//

import Foundation

struct SimilarMovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let dates: Date
    let total_pages: Int
    let total_results: Int
}

#if DEBUG
extension SimilarMovieResponse {
    static let json = #"""
    {
      "page": 1,
      "results": [
        {
          "poster_path": "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg",
          "adult": false,
          "overview": "A lighthouse keeper and his wife living off the coast of Western Australia raise a baby they rescue from an adrift rowboat.",
          "release_date": "2016-09-02",
          "genre_ids": [
            18
          ],
          "id": 283552,
          "original_title": "The Light Between Oceans",
          "original_language": "en",
          "title": "The Light Between Oceans",
          "backdrop_path": "/2Ah63TIvVmZM3hzUwR5hXFg2LEk.jpg",
          "popularity": 4.546151,
          "vote_count": 11,
          "video": false,
          "vote_average": 4.41
        },
        {
          "poster_path": "/udU6t5xPNDLlRTxhjXqgWFFYlvO.jpg",
          "adult": false,
          "overview": "Friends hatch a plot to retrieve a stolen cat by posing as drug dealers for a street gang.",
          "release_date": "2016-09-14",
          "genre_ids": [
            28,
            35
          ],
          "id": 342521,
          "original_title": "Keanu",
          "original_language": "en",
          "title": "Keanu",
          "backdrop_path": "/scM6zcBTXvUByKxQnyM11qWJbtX.jpg",
          "popularity": 3.51555,
          "vote_count": 97,
          "video": false,
          "vote_average": 6.04
        },
        {
          "poster_path": "/1BdD1kMK1phbANQHmddADzoeKgr.jpg",
          "adult": false,
          "overview": "On January 15, 2009, the world witnessed the \"Miracle on the Hudson\" when Captain \"Sully\" Sullenberger glided his disabled plane onto the frigid waters of the Hudson River, saving the lives of all 155 aboard. However, even as Sully was being heralded by the public and the media for his unprecedented feat of aviation skill, an investigation was unfolding that threatened to destroy his reputation and his career.",
          "release_date": "2016-09-08",
          "genre_ids": [
            36,
            18
          ],
          "id": 363676,
          "original_title": "Sully",
          "original_language": "en",
          "title": "Sully",
          "backdrop_path": "/nfj8iBvOjlb7ArbThO764HCQw5H.jpg",
          "popularity": 3.254896,
          "vote_count": 8,
          "video": false,
          "vote_average": 4.88
        },
        {
          "poster_path": "/2gd30NS4RD6XOnDlxp7nXYiCtT1.jpg",
          "adult": false,
          "overview": "The fates of Henry - an American correspondent - and Teresa, one of the Republic's censors during the Spanish Civil War.",
          "release_date": "2016-09-09",
          "genre_ids": [
            18,
            10752,
            10749
          ],
          "id": 363841,
          "original_title": "Guernika",
          "original_language": "en",
          "title": "Guernica",
          "backdrop_path": "/abuvTNGs7d05C3OdYdmPqZLEFpY.jpg",
          "popularity": 3.218451,
          "vote_count": 9,
          "video": false,
          "vote_average": 4.61
        },
        {
          "poster_path": "/ag6NsqD8tpDGgAcs4CnfdI3miSD.jpg",
          "adult": false,
          "overview": "Louis, a terminally ill writer, returns home after a long absence to tell his family that he is dying.",
          "release_date": "2016-09-01",
          "genre_ids": [
            18
          ],
          "id": 338189,
          "original_title": "Juste la fin du monde",
          "original_language": "fr",
          "title": "It's Only the End of the World",
          "backdrop_path": "/ngCkX82tbmMXQ2DhP9vqZbtSume.jpg",
          "popularity": 2.995961,
          "vote_count": 11,
          "video": false,
          "vote_average": 5.23
        },
        {
          "poster_path": "/kqmGs9q5WZkxKub60K6pU37GdvU.jpg",
          "adult": false,
          "overview": "A college student ventures with a group of friends into the Black Hills Forest in Maryland to uncover the mystery surrounding the disappearance of his sister years earlier, which many believe is connected to the legend of the Blair Witch. At first the group is hopeful, especially when a pair of locals offer to act as guides through the dark and winding woods, but as the endless night wears on, the group is visited by a menacing presence. Slowly, they begin to realize the legend is all too real and more sinister than they could have imagined.",
          "release_date": "2016-09-16",
          "genre_ids": [
            27,
            53
          ],
          "id": 351211,
          "original_title": "Blair Witch",
          "original_language": "en",
          "title": "Blair Witch",
          "backdrop_path": "/njj4Zk1ZEMNVvSO68BHHRHgqkcv.jpg",
          "popularity": 2.877025,
          "vote_count": 5,
          "video": false,
          "vote_average": 1.9
        },
        {
          "poster_path": "/zn3mchTeqXrSCJBpHsbS68HozWZ.jpg",
          "adult": false,
          "overview": "A big screen remake of John Sturges' classic western The Magnificent Seven, itself a remake of Akira Kurosawa's Seven Samurai. Seven gun men in the old west gradually come together to help a poor village against savage thieves.",
          "release_date": "2016-09-22",
          "genre_ids": [
            37,
            28
          ],
          "id": 333484,
          "original_title": "The Magnificent Seven",
          "original_language": "en",
          "title": "The Magnificent Seven",
          "backdrop_path": "/g54J9MnNLe7WJYVIvdWTeTIygAH.jpg",
          "popularity": 2.652445,
          "vote_count": 8,
          "video": false,
          "vote_average": 3.94
        },
        {
          "poster_path": "/a4qrfP2fVWqasbUUdKCwjDGCTTM.jpg",
          "adult": false,
          "overview": "Breaking up with Mark Darcy leaves Bridget Jones over 40 and single again. Feeling that she has everything under control, Jones decides to focus on her career as a top news producer. Suddenly, her love life comes back from the dead when she meets a dashing and handsome American named Jack. Things couldn't be better, until Bridget discovers that she is pregnant. Now, the befuddled mom-to-be must figure out if the proud papa is Mark or Jack.",
          "release_date": "2016-09-15",
          "genre_ids": [
            35,
            10749
          ],
          "id": 95610,
          "original_title": "Bridget Jones's Baby",
          "original_language": "en",
          "title": "Bridget Jones's Baby",
          "backdrop_path": "/u81y11sFzOIHdduSrrajeHOaCbU.jpg",
          "popularity": 2.56718,
          "vote_count": 8,
          "video": false,
          "vote_average": 4.81
        },
        {
          "poster_path": "/39ia8d9HPZlnYuEX5w2Gk25Tpgs.jpg",
          "adult": false,
          "overview": "Morgan is about a corporate risk-management consultant who has to decide and determine whether or not to terminate an artificial being's life that was made in a laboratory environment.",
          "release_date": "2016-09-02",
          "genre_ids": [
            53,
            878
          ],
          "id": 377264,
          "original_title": "Morgan",
          "original_language": "en",
          "title": "Morgan",
          "backdrop_path": "/j8h0zfecahJlamSle54UP3AP2k3.jpg",
          "popularity": 2.351093,
          "vote_count": 6,
          "video": false,
          "vote_average": 6.75
        },
        {
          "poster_path": "/jMRRPpUlDrCGWlMWJ1cuSANcgTP.jpg",
          "adult": false,
          "overview": "A psychologist who begins working with a young boy who has suffered a near-fatal fall finds himself drawn into a mystery that tests the boundaries of fantasy and reality.",
          "release_date": "2016-09-01",
          "genre_ids": [
            53,
            9648
          ],
          "id": 294795,
          "original_title": "The 9th Life of Louis Drax",
          "original_language": "en",
          "title": "The 9th Life of Louis Drax",
          "backdrop_path": "/yoHlRFkgcP5AbaFpyanmEhe21Dn.jpg",
          "popularity": 2.260147,
          "vote_count": 2,
          "video": false,
          "vote_average": 1
        },
        {
          "poster_path": "/a1rgwkG8tmnCStnpxsYaoaoyyFE.jpg",
          "adult": false,
          "overview": "In PUPPET MASTER XI - AXIS TERMINATION, the final chapter of the AXIS Saga, we find our heroic band of lethal puppets-BLADE, PINHEAD, TUNNELER, JESTER, SIX SHOOTER, and LEECH WOMAN, joining forces with a secret team of Allied Operatives, all masters of psychic powers, as they face off together against a new bunch of evil Nazi adversaries and their collection of vicious Axis Puppets in a showdown that will decide the future of the free world.",
          "release_date": "2016-09-01",
          "genre_ids": [
            10752,
            27,
            14
          ],
          "id": 384978,
          "original_title": "Puppet Master: Axis Termination",
          "original_language": "en",
          "title": "Puppet Master: Axis Termination",
          "backdrop_path": null,
          "popularity": 2.084518,
          "vote_count": 1,
          "video": false,
          "vote_average": 0.5
        },
        {
          "poster_path": "/2bispHSt2EGcnQdd5qZEZlJesvz.jpg",
          "adult": false,
          "overview": "Living in her family's secluded mansion, Audrina is kept alone and out of sight and is haunted by nightmares of her older sister, First Audrina, who was left for dead in the woods after an attack. As she begins to question her past and her disturbing dreams, the grim truth is slowly revealed.",
          "release_date": "2016-09-01",
          "genre_ids": [
            18
          ],
          "id": 377186,
          "original_title": "My Sweet Audrina",
          "original_language": "en",
          "title": "My Sweet Audrina",
          "backdrop_path": "/7tfLi2dhNVjXQTzCvSveuwuGI9r.jpg",
          "popularity": 2.009281,
          "vote_count": 1,
          "video": false,
          "vote_average": 6
        },
        {
          "poster_path": "/nhFfXtrWmWkv3C3wO8Js4MuOmMk.jpg",
          "adult": false,
          "overview": "CIA employee Edward Snowden leaks thousands of classified documents to the press.",
          "release_date": "2016-09-16",
          "genre_ids": [
            18,
            53
          ],
          "id": 302401,
          "original_title": "Snowden",
          "original_language": "en",
          "title": "Snowden",
          "backdrop_path": "/gtVH1gIhcgba26kPqFfYul7RuPA.jpg",
          "popularity": 1.975744,
          "vote_count": 17,
          "video": false,
          "vote_average": 5.38
        },
        {
          "poster_path": "/troGmWMITCiQzH7sZOhCirryx0u.jpg",
          "adult": false,
          "overview": "It is the 1960s. Two Maori families, the Mahanas and the Poatas, make a living shearing sheep on the east coast of New Zealand. The two clans, who are bitter enemies, face each other as rivals at the annual sheep shearing competitions. Simeon is a 14-year-old scion of the Mahana clan. A courageous schoolboy, he rebels against his authoritarian grandfather Tamihana and his traditional ways of thinking and begins to unravel the reasons for the long-standing feud between the two families. Before long, the hierarchies and established structures of the community are in disarray because Tamihana, who is as stubborn as he is proud, is not prepared to acquiesce and pursue new paths.",
          "release_date": "2016-09-01",
          "genre_ids": [
            18
          ],
          "id": 371647,
          "original_title": "Mahana",
          "original_language": "en",
          "title": "Mahana",
          "backdrop_path": "/6HHpnlFsKNxPCEg8Ey0qIP6ag84.jpg",
          "popularity": 1.938685,
          "vote_count": 1,
          "video": false,
          "vote_average": 6
        },
        {
          "poster_path": "/9Qzt2ywgaoQCIA3WtQSqRccCJaL.jpg",
          "adult": false,
          "overview": "Akira (English: Graceful Strength) is an upcoming Hindi action drama film directed and produced by AR Murugadoss. It is the remake of Tamil film Mouna Guru (2011) and features Sonakshi Sinha in lead role.",
          "release_date": "2016-09-02",
          "genre_ids": [
            80,
            18,
            53
          ],
          "id": 404579,
          "original_title": "Akira",
          "original_language": "hi",
          "title": "Akira",
          "backdrop_path": null,
          "popularity": 1.921411,
          "vote_count": 3,
          "video": false,
          "vote_average": 9.33
        },
        {
          "poster_path": "/yVHF2J5J0DRr0X4kSgzvxJLJuKa.jpg",
          "adult": false,
          "overview": "Three inept night watchmen, aided by a young rookie and a fearless tabloid journalist, fight an epic battle to save their lives. A mistaken warehouse delivery unleashes a horde of hungry vampires, and these unlikely heroes must not only save themselves but also stop the scourge that threatens to take over the city of Baltimore.",
          "release_date": "2016-09-01",
          "genre_ids": [
            35,
            27
          ],
          "id": 398798,
          "original_title": "The Night Watchmen",
          "original_language": "en",
          "title": "The Night Watchmen",
          "backdrop_path": "/hb2f9Ru1hoYT9Mfxm44bxdDYcZ7.jpg",
          "popularity": 1.919426,
          "vote_count": 0,
          "video": false,
          "vote_average": 0
        },
        {
          "poster_path": "/60WOPoQnDOQrA7FpT3a176QE4BU.jpg",
          "adult": false,
          "overview": "Politics is the Puerto Rican national sport, and in this sport anything is possible. Fate brings Pepo González, an ordinary, unemployed citizen, before an unscrupulous former political adviser. Her plan: to select a total stranger, without qualities or political lineage, and take the Capitol during one of the most important elections in the history of Puerto Rico. Will she be able to get Pepo a seat in the Senate?",
          "release_date": "2016-09-01",
          "genre_ids": [
            35
          ],
          "id": 398351,
          "original_title": "Pepo Pa'l Senado",
          "original_language": "es",
          "title": "Pepo Pa'l Senado",
          "backdrop_path": null,
          "popularity": 1.899033,
          "vote_count": 1,
          "video": false,
          "vote_average": 10
        },
        {
          "poster_path": "/sKSyI4Ebw0gZOH4a1B6FLQQwvex.jpg",
          "adult": false,
          "overview": "An art student named Gwang-ho gets dumped by his girlfriend because she was only his source of comfort, and that he's a Mama's boy and a premature ejaculator. He tries to avoid seeing her by going to a different academy and that's when his mother introduces him to her friend Soo-yeon, a sophisticated and intelligent looking woman. Gwang-ho falls for her. Gwang-ho's mother suddenly leaves for Australia because his father is sick and Gwang-ho gets to stay in Soo-yeon's house for a few days. Looking at her, he thinks of all the things he would like to do with her and Soo-yeon's niece Ha-kyeong stimulates him to do something about his feelings.",
          "release_date": "2016-09-01",
          "genre_ids": [],
          "id": 412092,
          "original_title": "Mom's Friend 2",
          "original_language": "en",
          "title": "Mom's Friend 2",
          "backdrop_path": null,
          "popularity": 1.832246,
          "vote_count": 0,
          "video": false,
          "vote_average": 0
        },
        {
          "poster_path": "/dEn82uit9cE3jisE94JlFLxZBF3.jpg",
          "adult": false,
          "overview": "A musical drama inspired by the 1956 classic, Tiga Dara.",
          "release_date": "2016-09-01",
          "genre_ids": [
            18,
            10402
          ],
          "id": 406593,
          "original_title": "Ini Kisah Tiga Dara",
          "original_language": "id",
          "title": "Three Sassy Sisters",
          "backdrop_path": null,
          "popularity": 1.810012,
          "vote_count": 0,
          "video": false,
          "vote_average": 0
        },
        {
          "poster_path": "/vMZ7SejN1NITX1LhcSJ5vAe63lf.jpg",
          "adult": false,
          "overview": "Janatha Garage is an upcoming 2016 Indian bilingual action film made in Telugu and Malayalam languages. The film is written and directed by Koratala Siva and produced by Naveen Yerneni, Y. Ravi Shankar, and C. V. Mohan under their banner Mythri Movie Makers in association with Eros International.",
          "release_date": "2016-09-01",
          "genre_ids": [
            18,
            28
          ],
          "id": 405924,
          "original_title": "జనతా గ్యారేజ్",
          "original_language": "te",
          "title": "Janatha Garage",
          "backdrop_path": "/hup1MpyXuemlaHPslMzVhrex3mZ.jpg",
          "popularity": 1.803778,
          "vote_count": 0,
          "video": false,
          "vote_average": 0
        }
      ],
      "dates": {
        "maximum": "2016-09-22",
        "minimum": "2016-09-01"
      },
      "total_pages": 12,
      "total_results": 222
    }
    """#
}
#endif

