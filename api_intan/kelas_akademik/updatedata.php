<?php
include '../koneksi.php';

if (isset($_POST['nomor_kelas'], $_POST['nama_kelas'], $_POST['nama_dosen'], $_POST['sks'], $_POST['waktu'], $_POST['ruang'])) {
    // Sanitize and validate the input data
    $nomor_kelas = $conn->real_escape_string($_POST['nomor_kelas']);
    $nama_kelas = $conn->real_escape_string($_POST['nama_kelas']);
    $nama_dosen = $conn->real_escape_string($_POST['nama_dosen']);
    $sks = (int)$_POST['sks'];
    $waktu = $conn->real_escape_string($_POST['waktu']);
    $ruang = $conn->real_escape_string($_POST['ruang']);

    // Validate that all fields are provided and valid
    if (empty($nomor_kelas) || empty($nama_kelas) || empty($nama_dosen) || empty($waktu) || empty($ruang) || $sks <= 0) {
        echo json_encode(['status' => 'error', 'message' => 'Semua data harus diisi dengan benar']);
        exit();
    }

    // Query to update the class based on nomor_kelas
    $sql = "UPDATE kelas_akademik 
            SET nama_kelas=?, nama_dosen=?, sks=?, waktu=?, ruang=? 
            WHERE nomor_kelas=?";
    
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("ssisss", $nama_kelas, $nama_dosen, $sks, $waktu, $ruang, $nomor_kelas);

        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Kelas berhasil diperbarui']);
        } else {
            // Log error detail
            error_log("Error updating record: " . $stmt->error);
            echo json_encode(['status' => 'error', 'message' => 'Gagal memperbarui kelas. Silakan coba lagi']);
        }

        $stmt->close();
    } else {
        // Log error detail for query
        error_log("Error in SQL query: " . $conn->error);
        echo json_encode(['status' => 'error', 'message' => 'Terjadi kesalahan dalam query']);
    }

} else {
    echo json_encode(['status' => 'error', 'message' => 'Data tidak lengkap atau tidak valid']);
}

$conn->close();
?>
