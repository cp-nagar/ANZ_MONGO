-- Ref Documentation: 
-- https://www.mongodb.com/docs/v4.4/reference/operator/query/

use movieData

-- returns first document to understand file structure
db.movies.findOne();

-- returns cursor
db.movies.find().pretty()

db.movies.find({name: "The Last Ship"}).pretty()

---------------------------------

db.movies.findOne({runtime: 60})
db.movies.find({runtime: 60}).count()


db.movies.find(
    {
        runtime: {
            $eq: 60
        } 
    }
)

db.movies.find(
    {
        runtime: {
            $eq: 60
        } 
    }
).count()

$lt
$lte
$gt
$gte
$ne


-- Embedded data 

db.movies.find({"rating.average": {$gt : 7}}).

db.movies.find({"rating.average": { $gt: 7 }}).pretty()

---

db.movies.find({genres: "drama"}).pretty()

"Drama"

db.movies.find({genres: "Drama"}).pretty()

-- Exact match
db.movies.find({genres: ["Drama"]}).pretty()

-------------
db.movies.find({
    runtime: {
        $in: [30, 42]
    } 
}).pretty()

db.movies.find({
    runtime: {
        $nin: [30, 42]
    } 
}).pretty()
---------------------

db.movies.find({"rating.average": { $gt: 9 }}).count()
> db.movies.find({"rating.average": { $gt: 9 }}).count()
7
> db.movies.find({"rating.average": { $gt: 9.5 }}).count()
0
> db.movies.find({"rating.average": { $gt: 9.4 }}).count()
0
> db.movies.find({"rating.average": { $gt: 9.3 }}).count()


-- $or operator

db.movies.find(
    {
        $or: [
            {"rating.average": { $lt:5 }},
            {"rating.average": { $gt: 9.3 }}
        ]
    }
).pretty()

> db.movies.find().count()
240
> db.movies.find(
     {
         $or: [
             {"rating.average": { $lt:5 }},
             {"rating.average": { $gt: 9.3 }}
         ]
     }
 ).count()
4
> db.movies.find(
     {
         $nor: [
             {"rating.average": { $lt:5 }},
             {"rating.average": { $gt: 9.3 }}
         ]
     }
 ).count()
236
>

-- $and operator

db.movies.find({
    $and : [
        {"rating.average": { $gt:9 }},
        {genres: "Drama" }
    ]
}).count()

db.movies.find(
    {
        "rating.average": { $gt:9 },
        genres: "Drama"
    }
).count()

db.movies.find(
    {
        genres: "Horror",
        genres: "Drama"
    }
).count()

> db.movies.find(
     {
         genres: "Horror",
         genres: "Drama"
     }
 ).count()
153

> db.movies.find({ genres: "Drama", genres: "Horror"} ).count()
23

db.movies.find( 
    {
        $and: [
            {genres: "Drama"}, 
            {genres: "Horror"}
        ]
    }
 ).count()

---------------------

 use user 

 db.users.insertMany([
     { 
         name: "venkat",
         hobbies: [
             {title: "Sports", frequency: 3},
             {title: "cooking", frequency: 6}
         ],
        phone: 8080808098
     },
     { 
         name: "snuti",
         hobbies: [
             {title: "cooking", frequency: 5},
             {title: "cars", frequency: 2}
         ],
        phone: "989939898",
        age: 27
     }
 ])

db.users.find(
    {
        age: {
            $exists: true,
            $gt: 27
        }
    }
).pretty()


db.users.find(
    {
        age: {
            $exists: true,
            $gte: 27
        }
    }
).pretty()

db.users.insertOne({name: "hamsika", hobbies: [
    {title: "Sports", frequency: 2},
    {title: "Yoga", frequency: 3}
],
phone: "37683658",
age: null
})


db.users.find(
    {
        age: {
            $exists: false
        }
    }
).pretty()

db.users.find(
    {
        age: {
            $exists: true,
            $ne: null
        }
    }
).pretty()

db.users.find(
    {
        phone: {
            $type: "number"
        }
    }
).pretty()

db.users.find(
    {
        phone: {
            $type: "double"
        }
    }
).pretty()


db.users.find(
    {
        phone: {
            $type: ["double", "string"]
        }
    }
).pretty()

---------------------

use movieData

-- no data
db.movies.find(
    {
        summary: "musical"
    }
).pretty()

--- with regex
db.movies.find(
    {
        summary: /musical/
    }
).pretty()


--------------------------------------------

use financialData

db.sales.insertMany(
    [
        {
            volume: 100,
            target: 120
        },
        {
            volume: 89,
            target: 80
        },
        {
            volume: 200,
            target: 177
        },
    ]
)

db.sales.find().pretty()

db.sales.find({
    $expr: {
        $gt: ["volume", "target"]
    }
}).pretty()

db.sales.find({
    $expr: {
        $gt: ["$volume", "$target"]
    }
}).pretty()


db.sales.find({
    $expr: {
        $gt: [ {
            $cond: {
                if: {
                    $gte: ["$volume", 190]
                },
                then: {
                    $subtract : ["$volume", 10]
                },
                else: "$volume"
            }
        } , "$target"]
    }
}).pretty()

-------------
use user

db.users.find().pretty()

db.users.find({
    hobbies: "Sports"
}).pretty()

db.users.find({
    hobbies:  {title: "Sports", frequency: 2 }
}).pretty()


db.users.find({
    "hobbies.title":  "Sports"
}).pretty()

db.users.insertOne({
    name: "Chris",
    hobbies: ["Sports", "cooking", "Hiking"]
})

db.users.find({hobbies: { $size: 3} })

------------------------------

use boxOffice

db.moviestat.insertMany([
    {
        title: "The Last Student Returns",
        meta: {
            rating: 9.5,
            aired: 2018,
            runtime: 100
        },
        visitors: 1300000,
        expectedVisitors: 1550000,
        genres: [
            "thriller",
            "drama",
            "action"
        ]
    },
    {
        title: "Teach me if you can",
        meta: {
            rating: 8.5,
            aired: 2014,
            runtime: 90
        },
        visitors: 590378,
        expectedVisitors: 500000,
        genres: [
            "action",
            "thriller"
        ]
    }
])

db.moviestat.insertMany([
    {
        title: "Supercharged Teaching",
        meta: {
            rating: 9.3,
            aired: 2016,
            runtime: 60
        },
        visitors: 370000,
        expectedVisitors: 1000000,
        genres: [
            "thriller",
            "action"
        ]
    }
])


db.moviestat.find({ genres: ["action", "thriller"] }).pretty()
db.moviestat.find({ genres: { $all: ["action", "thriller"]} }).pretty()

-------------------------------------
use user 

db.users.find().pretty()

db.users.find({
    $and: [
        {"hobbies.title": "Sports"},
        {"hobbies.frequency": {
            $gte: 2
        }}
    ]
}).pretty()

db.users.find({
    hobbies: {
        $elemMatch: {
            title: "Sports",
            frequency: {
                $gte: 3
            }
        }
    }
}).pretty()

------------------------------------

-- cursor

db.movies.find().count()
240

db.movies.find().pretty()

-- cursor it 

-- it 
-- it 
-- it 


db.movies.find().next()

const dataCursor = db.movies.find()

dataCursor.next()

dataCursor.forEach( doc => { printjson(doc) } )

dataCursor.next();
dataCursor.hasNext();
-------------------------

db.movies.find().sort({ "rating.average": 1 }).pretty()

db.movies.find().sort({ "rating.average": 1, runtime: -1 }).pretty()

db.movies.find().sort({ "rating.average": 1, runtime: -1 }).sort({"rating.average": 1}).pretty()

db.movies.find()
    .sort({ "rating.average": 1, runtime: -1 })
    .sort({"rating.average": 1})
    .skip(100).pretty()


db.movies.find()
    .sort({ "rating.average": 1, runtime: -1 })
    .sort({"rating.average": 1})
    .skip(100)
    .count()


-- Include specific fields
db.movies.find({}, {name: 1, runtime: 1} ).pretty()
db.movies.find({}, {name: 1, runtime: 1, _id:0} ).pretty()

db.movies.find({}, {name: 1, genres: 1, runtime: 1, "rating.average": 1,  "schedule.time": 1, _id:0} ).pretty()

db.movies.find({genres: "Drama"}).pretty()

db.movies.find({genres: "Drama"}, {"genres.$": 1} ).pretty()

db.movies.find( 
    {
        genres: {
            $all: ["Drama", "Horror"]
        } 
    },
    {"genres.$": 1}
).pretty()

db.movies.find(
    {genres: "Drama"},
    {
        genres: {
            $elemMatch: {
                $eq: "Horror"
            }
        }
    }
).pretty()

-------------------------------------


db.movies.find(
    {"rating.average": { $gt: 9}},
    { genres: {$slice: 2}, name: 1 }
).pretty()


-------------------

-- Multiple operators 

db.persons.find({
  $and: [
    { name: "John" },
    {
      $or: [
        { age: { $gte: 30 } },
        { city: "New York" }
      ]
    }
  ]
})




























