<?php
include '../koneksi.php';

// Mengatur header agar response dalam format JSON
header('Content-Type: application/json');

// Mendapatkan nomor dari query parameter
$nomor = isset($_GET['nomor']) ? $_GET['nomor'] : '';

if (!empty($nomor)) {
    // Query menggunakan prepared statement untuk menghindari SQL injection
    $sql = "SELECT * FROM konsultasi WHERE nomor = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $nomor);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Mengambil data konsultasi dan mengonversinya menjadi JSON
        $konsultasi = $result->fetch_assoc();
        echo json_encode(['status' => 'success', 'data' => $konsultasi]);
    } else {
        // Jika konsultasi tidak ditemukan
        echo json_encode(['status' => 'error', 'message' => 'Konsultasi tidak ditemukan']);
    }

    $stmt->close();
} else {
    // Jika nomor tidak ditemukan atau kosong
    echo json_encode(['status' => 'error', 'message' => 'Nomor tidak ditemukan']);
}

$conn->close();
?>
