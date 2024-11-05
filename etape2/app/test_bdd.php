<?php
$servername = "data";  
$username = "root";
$password = "example";
$dbname = "test_db";
$port = 3306;  

try {
    $conn = new PDO("mysql:host=$servername;port=$port;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $conn->exec("CREATE TABLE IF NOT EXISTS visitors (
        id INT AUTO_INCREMENT PRIMARY KEY,
        visit_time DATETIME
    )");

    $conn->exec("INSERT INTO visitors (visit_time) VALUES (NOW())");

    $stmt = $conn->prepare("SELECT COUNT(*) AS visit_count FROM visitors");
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo "Nombre total de visites : " . $result['visit_count'];

} catch (PDOException $e) {
    echo "Erreur : " . $e->getMessage();
}
?>
