<?php
$username = "root";
$password = "";
$database = "terms";
$conn = new mysqli("localhost", $username, $password, $database);
$query = "Select * From category";
?>
<!DOCTYPE html>
<html>
<head>
    <link href=".\resources\styles\terms.css" rel="stylesheet" type="text/css">
</head>
<body>
    <form id="create" action=".\resources\scripts\createToSql.php" method="post" enctype="multipart/form-data">
        <label for="category">Category:</label>
        <select id="category" name="category">
            <?php
            if($result = $conn->query($query)){
                while($row = $result->fetch_assoc()){
                    $field1 = $row["name"];
                    $field2 = $row["id"];

                    echo '<option value="'.$field2.'">'.$field1.'</option>';
                }
            }
            ?>
        </select><br>
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" placeholder="Enter name"><br>
        <label for="description">Description:</label>
        <input type="text" id="description" name="description" placeholder="Enter description"><br>
        <label for="link">Link:</label>
        <input type="url" id="link" name="link" placeholder="Enter link"><br>
        <input type="submit" value="Submit" name="submit">
    </form>
    <div class="aside">
        <aside>
            <b><a href="index.php">Back home</a></b>
        </aside>
    </div>
</body>
</html>