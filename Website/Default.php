<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link href=".\resources\styles\terms.css" rel="stylesheet" type="text/css">
</head>
<body>
<?php
$username = "root";
$password = "";
$database = "terms";
$conn = new mysqli("localhost", $username, $password, $database);
$query = "Select * from term where category_id = 1 and name<>'Default'";

if($result = $conn->query($query)){
    while($row = $result->fetch_assoc()){
        $name = $row["name"];
        $description = $row["description"];

        echo '<div class="container">
                <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#'.$name.'">'.$name.'</button>
                <div id="'.$name.'" class="collapse">'.$description.'</div>
            </div>';
    }
    $result->free();
}
$conn->close();
?>
<div class="aside">
    <aside>
        <b><a href="index.php">Back home</a></b>
    </aside>
</div>
</body>
</html>
