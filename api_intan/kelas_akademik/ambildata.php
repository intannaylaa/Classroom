<?php
include '../koneksi.php';

// Cek koneksi ke database
if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Koneksi ke database gagal']);
    exit();
}

// Ambil data kelas akademik dari database
$sql = "SELECT * FROM kelas_akademik";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $kelas = [];
    while($row = $result->fetch_assoc()) {
        $kelas[] = $row;
    }
    echo json_encode(['status' => 'success', 'data' => $kelas]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Data tidak ditemukan']);
}

// Menutup koneksi setelah selesai
$conn->close();
?>
