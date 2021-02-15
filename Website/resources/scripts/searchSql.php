<?php
if(isset($_POST['submit'])){
    $name = $_POST['name'];

    $username = "root";
    $password = "";
    $database = "terms";
    $conn = new mysqli("localhost", $username, $password, $database);

    $query = "Select category.name as category, term.name, description, link
                FROM term
                LEFT OUTER JOIN category on term.category_id = category.id
                WHERE term.name like '%".$name."%'";

    echo '<!DOCTYPE html>
        <html>
        <head>
            <link href=".\resources\styles\terms.css" rel="stylesheet" type="text/css">
        </head>
        <body>
        <table border = "0" cellspacing="2" cellpadding="2">
            <tr>
                <th>Category</th>
                <th>Name</th>
                <th>Description</th>
                <th>Link</th>
            </tr>';

    if($result = $conn->query($query)){
        while($row = $result->fetch_assoc()){
            $field1 = $row["category"];
            $field2 = $row["name"];
            $field3 = $row["description"];
            $field4 = $row["link"];

            echo '<tr>
                <td>'.$field1.'</td>
                <td>'.$field2.'</td>
                <td>'.$field3.'</td>
                <td><a href="'.$field4.'">'.$field4.'</a></td>
              </tr>';
        }
    }
    echo '
            <div class="aside">
                <aside>
                    <b><a href="index.php">Back home</a></b>
                </aside>
            </div>
        </body>
        </html>';
    $conn->close();
}

