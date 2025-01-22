<?php
include '../koneksi.php'; // Pastikan file koneksi.php sudah terhubung dengan database

header('Content-Type: application/json');

// Ambil data tugas dari database
$sql = "SELECT * FROM tugas";
$result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
    $data = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Tidak ada tugas ditemukan']);
}

mysqli_close($conn);
?>
