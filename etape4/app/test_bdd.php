<?php
$servername = "data-container";
$username = "testuser";
$password = "testpassword";
$dbname = "testdb";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql_create = "INSERT INTO test_table (message) VALUES ('Hello from the database!')";
$conn->query($sql_create);

$sql_read = "SELECT message FROM test_table ORDER BY id DESC LIMIT 1";
$result = $conn->query($sql_read);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "Latest message: " . $row["message"];
    }
} else {
    echo "No messages found!";
}

$conn->close();
?>
