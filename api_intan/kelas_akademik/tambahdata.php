<?php
include '../koneksi.php';

// Cek koneksi ke database
if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Koneksi ke database gagal']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil data dari request POST dan lakukan sanitasi
    $nomor_kelas = $_POST['nomor_kelas'] ?? '';
    $nama_kelas = $_POST['nama_kelas'] ?? '';
    $nama_dosen = $_POST['nama_dosen'] ?? '';
    $ruang = $_POST['ruang'] ?? '';
    $sks = $_POST['sks'] ?? '';
    $waktu = $_POST['waktu'] ?? '';

    // Validasi input untuk memastikan semua data terisi
    if (empty($nomor_kelas) || empty($nama_kelas) || empty($nama_dosen) || empty($ruang) || empty($sks) || empty($waktu)) {
        echo json_encode(['status' => 'error', 'message' => 'Data tidak lengkap']);
        exit();
    }

    // Gunakan prepared statement untuk menghindari SQL Injection
    $stmt = $conn->prepare("INSERT INTO kelas_akademik (nomor_kelas, nama_kelas, nama_dosen, ruang, sks, waktu) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $nomor_kelas, $nama_kelas, $nama_dosen, $ruang, $sks, $waktu);

    // Eksekusi query
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal menyimpan data ke database']);
    }

    // Menutup statement setelah selesai
    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Metode tidak valid']);
}

// Menutup koneksi setelah selesai
$conn->close();
?>
