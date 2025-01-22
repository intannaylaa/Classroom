<?php
include '../koneksi.php'; // Pastikan file koneksi.php sudah terhubung dengan database

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id_tugas = $_POST['id_tugas'];
    
    // Update status tugas menjadi 'sudah dikumpulkan'
    $query = "UPDATE tugas SET status = 'sudah dikumpulkan' WHERE id = '$id_tugas'";

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal memperbarui status']);
    }
}

mysqli_close($conn);
?>
