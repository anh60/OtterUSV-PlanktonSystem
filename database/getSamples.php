<?php
include 'conn.php';

$res = array();

$sql = "SELECT * FROM samples";
$sql = $conn->query($sql);

while ($row = $sql->fetch_assoc()) {
    $res[] = $row;
}

echo json_encode($res);