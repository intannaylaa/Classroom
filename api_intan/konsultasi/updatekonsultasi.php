<?php
include '../koneksi.php';

if (isset($_POST['nomor']) && isset($_POST['topik']) && isset($_POST['keterangan']) && isset($_POST['pesan']) && isset($_POST['tanggal_konsultasi'])) {
    $nomor = $_POST['nomor'];
    $topik = $_POST['topik'];
    $keterangan = $_POST['keterangan'];
    $pesan = $_POST['pesan'];
    $tanggal_konsultasi = $_POST['tanggal_konsultasi'];

    // Prepare the SQL statement
    $stmt = $conn->prepare("UPDATE konsultasi 
                            SET topik = ?, keterangan = ?, pesan = ?, tanggal_konsultasi = ? 
                            WHERE nomor = ?");
    
    // Bind parameters to the prepared statement
    $stmt->bind_param("sssss", $topik, $keterangan, $pesan, $tanggal_konsultasi, $nomor);

    // Execute the statement
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Konsultasi berhasil diperbarui']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Gagal memperbarui konsultasi: ' . $stmt->error]);
    }

    // Close the statement
    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Data tidak lengkap atau tidak valid']);
}

// Close the connection
$conn->close();
?>
