<?php
include '../koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

if (isset($_POST['nomor_kelas'])) {
    $nomor_kelas = $conn->real_escape_string($_POST['nomor_kelas']);

    // Query untuk menghapus data berdasarkan nama kelas
    $sql = "DELETE FROM kelas_akademik WHERE nomor_kelas = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $nomor_kelas);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Kelas berhasil dihapus']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menghapus kelas']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Nama kelas tidak ditemukan']);
}

$conn->close();
?>
