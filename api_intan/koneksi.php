<?php
$host = 'localhost';
$user = 'teky6584_api_intan';
$password = 'Tc5SkhsjHHZo';
$dbname = 'teky6584_api_intan';

// Mengatur header respons untuk format JSON
header('Content-Type: application/json');

// Membuat koneksi
$conn = new mysqli($host, $user, $password, $dbname);

// Memeriksa apakah koneksi berhasil
if ($conn->connect_error) {
    // Jika koneksi gagal, tampilkan pesan error JSON
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed',
        'error_code' => $conn->connect_errno,
        'error_message' => $conn->connect_error
    ]);
    exit();  // Menghentikan eksekusi lebih lanjut
}

// Jika koneksi berhasil, kita bisa melanjutkan ke eksekusi query
// Anda bisa menambahkan query atau logic lainnya di bawah ini
?>
