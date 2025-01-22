<?php
include '../koneksi.php';  // Ganti dengan koneksi DB Anda

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nomor = $_POST['nomor'];

    $query = "DELETE FROM konsultasi WHERE nomor = '$nomor'";

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success', 'message' => 'berhasil dihapus']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menghapus ']);
    }
}
?>
