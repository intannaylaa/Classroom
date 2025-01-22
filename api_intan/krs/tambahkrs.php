<?php
include '../koneksi.php';  // Ensure your database connection is correct

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nomor_kelas = $_POST['nomor_kelas'] ?? '';
    $nama_kelas = $_POST['nama_kelas'] ?? '';
    $nama_dosen = $_POST['nama_dosen'] ?? '';
    $ruang = $_POST['ruang'] ?? '';
    $sks = $_POST['sks'] ?? '';
    $waktu = $_POST['waktu'] ?? '';

    // Validate input
    if (empty($nomor_kelas) || empty($nama_kelas) || empty($nama_dosen) || empty($ruang) || empty($sks) || empty($waktu)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields must be filled']);
        exit;
    }

    $query = "INSERT INTO krs (nomor_kelas, nama_kelas, nama_dosen, ruang, sks, waktu) 
              VALUES ('$nomor_kelas', '$nama_kelas', '$nama_dosen', '$ruang', '$sks', '$waktu')";

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success', 'message' => 'KRS added successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to add KRS']);
    }
}
?>
