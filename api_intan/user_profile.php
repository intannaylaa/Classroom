<?php
include('koneksi.php');  // Pastikan file koneksi.php terhubung ke database 'akademik'

header('Content-Type: application/json'); // Tentukan bahwa respons dalam format JSON

// Periksa apakah ID pengguna ada dalam request
if (isset($_GET['id'])) {
    $get_id = intval($_GET['id']);
} else {
    echo json_encode(['error' => 'ID pengguna tidak diberikan']);
    exit();
}

// Ambil data pengguna dari tabel users di database akademik
$query = "SELECT * FROM users WHERE id = ?";
$stmt = $conn->prepare($query);

// Pastikan statement berhasil disiapkan
if ($stmt) {
    $stmt->bind_param("i", $get_id); // Bind parameter dengan tipe integer
    $stmt->execute();
    $result = $stmt->get_result();

    // Periksa apakah data ditemukan
    if ($result->num_rows > 0) {
        $data_user = $result->fetch_assoc();
        echo json_encode($data_user);  // Kirim data sebagai JSON
    } else {
        echo json_encode(['error' => 'Pengguna tidak ditemukan']);
    }

    $stmt->close(); // Tutup statement
} else {
    echo json_encode(['error' => 'Query gagal: ' . $conn->error]);
}

$conn->close(); // Tutup koneksi
?>
