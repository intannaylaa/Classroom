<?php
include '../koneksi.php';

// Query untuk mengambil data kelas
$query = "SELECT * FROM kelas";
$result = mysqli_query($koneksi, $query);

$kelas = array();

while($row = mysqli_fetch_assoc($result)) {
    $kelas[] = $row;
}

echo json_encode($kelas);
?>
