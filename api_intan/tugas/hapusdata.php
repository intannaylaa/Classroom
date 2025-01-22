<?php
include '../koneksi.php'; // Pastikan file koneksi.php sudah terhubung dengan database

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

if (isset($_POST['id_tugas'])) {
    $id_tugas = (int)$_POST['id_tugas']; // Ubah ke integer

    // Hapus tugas berdasarkan id_tugas
    $sql = "DELETE FROM tugas WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id_tugas);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Tugas berhasil dihapus']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menghapus tugas']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'ID Tugas tidak ditemukan']);
}

$conn->close();
?>
