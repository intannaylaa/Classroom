<?php
include '../koneksi.php';

// Cek koneksi ke database
if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Koneksi ke database gagal']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $judul_tugas = $_POST['judul_tugas'] ?? '';
    $deskripsi_tugas = $_POST['deskripsi_tugas'] ?? '';
    $batas_waktu = $_POST['batas_waktu'] ?? '';

    if (empty($judul_tugas) || empty($deskripsi_tugas) || empty($batas_waktu)) {
        echo json_encode(['status' => 'error', 'message' => 'Data tidak lengkap']);
        exit();
    }

    $stmt = $conn->prepare("INSERT INTO tugas (judul_tugas, deskripsi_tugas, batas_waktu, status) VALUES (?, ?, ?, 'belum dikumpulkan')");
    $stmt->bind_param("sss", $judul_tugas, $deskripsi_tugas, $batas_waktu);

    if ($stmt->execute()) {
        $lastId = $conn->insert_id; // Mendapatkan ID tugas yang baru ditambahkan
        echo json_encode(['status' => 'success', 'id' => $lastId]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menambahkan tugas']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Metode tidak valid']);
}

$conn->close();
?>
