<?php

if (empty($_POST["name"])) {
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Login</title>
</head>
<body>
<fieldset>
<legend>Login</legend>

<?php
if (isset($_GET) && isset($_GET["e"]))
echo "<span style='color: red'>Wrong username / password</span>";
?>

<form method="post">
<input type="text" name="name" placeholder="name" autocomplete="off">
<input type="password" name="pwd" placeholder="password" autocomplete="off">
<br><br>
<input type="submit">
</form>


</fieldset>
</body>
</html>

<?php
}
else {

$dsn = "mysql:dbname=foo;host=localhost";
$name = "root";
$pwd = "root";

try {
  $db = new PDO($dsn, $name, $pwd);
}
catch (PDOException $e) {
  echo $e->getMessage();
  die("Connection failed.\n");
}

$name = $_POST["name"];
$pwd = $_POST["pwd"];

$req = "SELECT * FROM users WHERE username = '$name' AND password = '$pwd'";

$res = $db->query($req);
$data = $res->fetch();

if (!$data)
  header("Location: index.php?e");

?>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Welcome</title>
</head>
<body>
<h1>Welcome <?= $data["username"] ?>!</h1>
</body>
</html>

<?php
}
?>
