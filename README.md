# SQL Injections with MongoDB

*When the code is ugly, it is probably exploitable.*

## Introduction

The code you are about to see *is ugly*. It was written as a demonstration to express how using Node.JS along with MongoDB is NO MORE secured than PHP if you don't care about securing it.
Obviously, avoiding these security holes is very easy. See below for details.

## Summary
1. [How](#how)
2. [Why](#why)
3. [Fix](#fix)

## How (to use it)?
The repository is composed of three main parts: the `JS` folder, the `PHP` folder and the `exploit.sh` file.

#### Setup the Node server
* Dependencies: MongoDB (really!)
* Start the mongo daemon and import the `database.caca` file.
* Go to the JS directory, `npm install` and `node server.js`.
* Done!

#### Setup the PHP webpage
* Dependancies: an HTTP server (nginx master race), the pdo_mysql addon.
* Import the `database.sql` file.
* Move the `index.php` file wherever your HTTP server tells you to move it.
* Done!

#### Start injecting
* `./inject.sh`
* Look closely at the HTML retrieved by cURL for each request sent.
* Done ;)

## Why (does it work)?

#### PHP
* Although if you're here you probably already knows how it works, a quick reminder can't hurt.
* The query used in the PHP file is `SELECT * FROM users WHERE username = '$name' AND password = '$pwd'`, where `$name` and `$pwd` are both direct `$_POST` variables.
* Using as a name `'OR 1=1-- -'` renders the query as `SELECT * FROM users WHERE username = ''OR 1=1-- -'' AND password = '$pwd'`, thus the condition is always valid (1 = 1, right?).
* If you're wondering more about this, check out a MySQL documentation.

#### Node.JS / MongoDB
* Instead of sending form-like data to the page (`application/x-www-form-url-encoded`), we specify in cURL that the data we send is JSON (`application/json`).
* The query used looks like `users.findOne({username: req.body.username, password: req.body.password}, [...]);`

Thus, if we supply a JSON document as the input to the application, we perform the exact same bypass as PHP.
The exact object we send to bypass the login form is
```json
{
  "username": { "$gt": "" },
  "password": { "$gt": "" }
}```

When querying it, MongoDB will retrieve the first document (findOne() method) in the database. Why? The `$gt` operator specifies anything that is *greater than* an empty string. So basically... anything.

## Fix (these security holes)!

So how would one go about fixing these ugly security holes? One simple principle: Do not trust user input.

One could use PDO's prepared statements or could parse and verify user input before sending it to the database.
