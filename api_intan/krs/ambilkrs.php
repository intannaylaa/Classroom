<?php
include '../koneksi.php';

// Mengatur header agar response dalam format JSON
header('Content-Type: application/json');

// Mendapatkan nomor_kelas dari query parameter
$nomor_kelas = isset($_GET['nomor_kelas']) ? $_GET['nomor_kelas'] : '';

// Cek jika nomor_kelas ada dan tidak kosong
if (!empty($nomor_kelas)) {
    $sql = "SELECT * FROM krs WHERE nomor_kelas = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $nomor_kelas);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Mengambil data krs dan mengonversinya menjadi JSON
        $krsData = $result->fetch_assoc();
        echo json_encode(['status' => 'success', 'data' => $krsData]);
    } else {
        // Jika KRS tidak ditemukan
        echo json_encode(['status' => 'error', 'message' => 'KRS tidak ditemukan']);
    }

    $stmt->close();
} else {
    // Jika nomor_kelas tidak ditemukan atau kosong
    echo json_encode(['status' => 'error', 'message' => 'Nomor kelas tidak ditemukan']);
}

$conn->close();
?>
