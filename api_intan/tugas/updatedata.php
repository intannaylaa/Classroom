<?php
include '../koneksi.php'; // Pastikan file koneksi.php sudah terhubung dengan database

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id_tugas = $_POST['id_tugas'];
    $judul_tugas = $_POST['judul_tugas'];
    $deskripsi_tugas = $_POST['deskripsi_tugas'];
    $status = $_POST['status'];
    $batas_waktu = $_POST['batas_waktu'];

    // Update tugas berdasarkan id_tugas
    $sql = "UPDATE tugas SET judul_tugas = ?, deskripsi_tugas = ?, status = ?, batas_waktu = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssi", $judul_tugas, $deskripsi_tugas, $status, $batas_waktu, $id_tugas);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Tugas berhasil diperbarui']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal memperbarui tugas']);
    }

    $stmt->close();
}

$conn->close();
?>
