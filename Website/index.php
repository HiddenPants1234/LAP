<html>
<head>
    <link href=".\resources\styles\index.css" rel="stylesheet" type="text/css">
    <meta http-equiv="content-type" content="text/html" charset="UTF-8">
</head>
<body>
<?php
$username = "root";
$password = "";
$database = "terms";
$conn = new mysqli("localhost", $username, $password, $database);
$query = "Select * from category";

echo '<table border = "0" cellspacing="2" cellpadding="2">
    <tr>
        <th><marquee>Categories</marquee></th>
    </tr>';

if($result = $conn->query($query)){
    while($row = $result->fetch_assoc()){
        $field1 = $row["name"];

        echo '<tr>
                <td><marquee><a href="'.$field1.'.php">'.$field1.'</a></marquee></td>
              </tr>';
    }
    $result->free();
}
$conn->close();
?>
<div class="aside">
    <aside>
        <b><a href="create.php">Click here to create a new entry</a></b>
    </aside><br><br>
    <aside>
        <b><a href="search.php">Click here to search for an entry</a></b>
    </aside><br><br>
    <aside>
        <b><a href="random.php">Click here to get a random entry</a></b>
    </aside>
</div>
</body>
</html>