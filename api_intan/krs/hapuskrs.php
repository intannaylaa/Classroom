<?php
include '../koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

if (isset($_POST['nomor_kelas'])) {
    $nomor_kelas = $_POST['nomor_kelas'];

    // Query untuk menghapus data berdasarkan nomor_kelas
    $sql = "DELETE FROM krs WHERE nomor_kelas = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $nomor_kelas);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'KRS berhasil dihapus']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menghapus KRS']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Nomor kelas tidak ditemukan']);
}

$conn->close();
?>
