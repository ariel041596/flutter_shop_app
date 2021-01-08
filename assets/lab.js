db
use MongoLab1
db.employees.insertMany([
    {
        "id": 1,
        "Name": "Steve Badiola",
        "Salary": 16099.55,
        "Position": "President",
        "Rank": 1,
        "Reporting": null,
    },
    {
        "id": 2,
        "Name": "Jamir Garcia",
        "Salary": 14567.12,
        "Position": "Vice-President",
        "Rank": 2,
        "Reporting": ["President"],
    },
    {
        "id": 3,
        "Name": "Reg Rubio",
        "Salary": 13891.22,
        "Position": "Secretary",
        "Rank": 3,
        "Reporting": ["Vice-President"],
    },
    {
        "id": 4,
        "Name": "Ian Tamayo",
        "Salary": 13000,
        "Position": "Treasurer",
        "Rank": 4,
        "Reporting": ["President", "Vice-President"],
    }
])

db.employees.update(
    { "Reporting": "" },
    { $unset: { Reporting: ""} }
)


db.employees.update(
    { "id": 1 },
    { $inc: { Salary: 5000} }
 )
db.employees.update(
    { "id": 2 },
    { $inc: { Salary: 5000} }
 )
db.employees.update(
    { "id": 3 },
    { $inc: { Salary: 5000} }
 )
db.employees.update(
    { "id": 4 },
    { $inc: { Salary: 5000} }
 )

db.employees.update(
    {"Name": "Reg Rubio"},
    { $push: { "Reporting": "President" } }
)
db.employees.update(
    {"Name": "Ian Tamayo"},
    { $push: { "Reporting": "President" } }
)

db.employees.find( { Salary: { $gt: 21000 } } ).pretty()

db.employees.find(
    { Name: { $in: [/^S/, /^R/] } },
 ).pretty()

 db.employees.update(
    {"id": 1},
    { 
        $set: {
            "contact": {
                "email" : "steve.badiola.gov.ph",
                "phone": "+1 1234567"
            }
        }
    }
)
 db.employees.update(
    {"id": 2},
    { 
        $set: {
            "contact": {
                "email" : "jamir.garcia.gov.ph",
                "phone": "+2 1234567"
            }
        }
    }
)
 db.employees.update(
    {"id": 3},
    { 
        $set: {
            "contact": {
                "email" : "reg.rubio.gov.ph",
                "phone": "+3 1234567"
            }
        }
    }
)
 db.employees.update(
    {"id": 4},
    { 
        $set: {
            "contact": {
                "email" : "ian.tamayo.gov.ph",
                "phone": "+4 1234567"
            }
        }
    }
)

show dbs
use MongoLab2


// Embeded
db.emb_customer.insert(
   {
    "_id": 1,
    "customername": "Smith",
    "address": {
        "country":"Philippines",
        "province":"Rizal",
        "municipality":"Taytay",
        "brgy":"Dolores",
        "street":"286-A, Costalina",
    }
   },
)
// Reference
db.ref_customer.insert(
    {
     "_id": 1,
     "customername": "Smith",
    },
 )


// Embeded
//One to many
db.emb_student.insert(
   {
    "_id": 1,
    "stud_name": "Leo",
    "school":"OrCa",
    "schedules": [
        {
            "subject":"Math",
            "teacher":"Marcel",
            "schedule":"Monday",
        },
        {
            "subject":"English",
            "teacher":"Elinor",
            "schedule":"Tuesday",
        },
        {
            "subject":"Science",
            "teacher":"Maritess",
            "schedule":"Wednesday",
        },
     ]
   }, 
)
// Reference
db.ref_student.insert(
    {
        "_id": 1,
        "stud_name": "Leo",
        "school":"OrCa",
    },
)
//Parent
db.items.insert(
    {
        "_id" : 1,
        "item_category" : "Bag"
    },
)
db.items.insert(
    {
        "_id" : 2,
        "item_category" : "Mobile Phones"
    }
)
//Child
db.inventory.insertMany([
    {
        "_id" : 101,
        "Brand" : "Samsung",
        "Model" : "Note10",
        "item_id" : 2
    },
    {
        "_id" : 102,
        "Brand" : "HawkBag",
        "Model" : "HK2",
        "item_id" : 1
    },
])

db.items.aggregate([
    {
      $lookup:
        {
          from: "inventory",
          localField: "_id",
          foreignField: "item_id",
          as: "stocks"
        }
   },
   { $match : { item_category : "Mobile Phones" } }
]).pretty()
db.items.aggregate([
    {
      $lookup:
        {
          from: "inventory",
          localField: "_id",
          foreignField: "item_id",
          as: "stocks"
        }
   },
   { $match : { item_category : "Bag" } }
]).pretty()


