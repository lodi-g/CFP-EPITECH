const express    = require("express");
const bodyParser = require("body-parser");
const mongo      = require("mongodb").MongoClient;

const app = express();
let db;

app.set("view engine", "pug");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get("/", (req, res) => {
  return res.render("index", { error: false });
})

app.post("/", (req, res) => {
  const obj = {
    username: req.body.username, // Here is the big security issue
    password: req.body.password
  }

  db.collection("users").findOne(obj, (err, user) => {
    if (user === null)
      return res.status(500).render("index", { error: true });

    res.render("loggedin", { name: user.username });
  });
})


const loadFixtures = () =>
  db.collection("users").insertMany([
    {
      username: "admin",
      password: "admin",
    },
    {
      username: "user",
      password: "password",
    },
  ]);

const wait = time =>
    new Promise(resolve => setTimeout(resolve, time))

const connectToDb = async () => {
  try {
    db = await mongo.connect("mongodb://mongo:27017/foo");
  } catch (error) {
    console.error(error.message)
    await wait(1000)
    return await connectToDb()
  }

  await loadFixtures();
}

connectToDb()
  .then(() => {
    app.listen(3000, err => {
      if (err)
        throw new Error(`Couldn't start server: ${err}`);

      console.log("Successfully started server on port 3000!");
    })
  })
  .catch(console.error);
