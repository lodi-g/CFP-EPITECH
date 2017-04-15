const express    = require("express");
const bodyParser = require("body-parser");
const mongo      = require("mongodb").MongoClient;

const app = express();
var db;

app.set("view engine", "pug");
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.get("/", (req, res) => {
  return res.render("index", { error: false });
})

app.post("/", (req, res) => {
  var obj = {
    username: req.body.username,
    password: req.body.password
  }

  db.collection("users").findOne(obj, (err, user) => {

    if (user === null)
      return res.render("index", { error: true });

    res.render("loggedin", { name: user.username });
  });
})



let dsn = "mongodb://localhost:27017/foo";
mongo.connect(dsn, (err, database) => {
  if (err)
    throw new Error(`Couldn't connect to the database: ${err}`);

  db = database;

  app.listen(3000, (err) => {
    if (err)
      throw new Error(`Couldn't start server: ${err}`);

    console.log("Successfully started server on port 3000!");
  })
})
