<?php
if(isset($_POST['submit'])) {
    $category = $_POST['category'];
    $name = $_POST['name'];
    $description = $_POST['description'];
    $link = $_POST['link'];

    $username = "root";
    $password = "";
    $database = "terms";
    $conn = new mysqli("localhost", $username, $password, $database);

    $query = "INSERT INTO term(category_id, name, description, link)
                VALUES(" . $category . ",'" . $name . "','" . $description . "','" . $link . "')";

    echo $query;

    if($conn->query($query) === TRUE){
        echo "New record created";
    }
    else{
        "Error: ".$query."<br>" . $conn->error;
    }
    $conn->close();
    header('Location: ..\..\index.php');
}

