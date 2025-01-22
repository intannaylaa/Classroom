<?php
include '../koneksi.php';

// Mengambil data dari form
$nomor = isset($_POST['nomor']) ? $_POST['nomor'] : '';
$topik = isset($_POST['topik']) ? $_POST['topik'] : '';
$keterangan = isset($_POST['keterangan']) ? $_POST['keterangan'] : '';
$pesan = isset($_POST['pesan']) ? $_POST['pesan'] : '';
$tanggal_konsultasi = isset($_POST['tanggal_konsultasi']) ? $_POST['tanggal_konsultasi'] : '';

// Validasi input
if (empty($nomor) || empty($topik) || empty($keterangan) || empty($pesan) || empty($tanggal_konsultasi)) {
    echo 'Semua field harus diisi!';
    exit;
}

// Menyimpan data ke database
$sql = "INSERT INTO konsultasi (nomor, topik, keterangan, pesan, tanggal_konsultasi) 
        VALUES ('$nomor', '$topik', '$keterangan', '$pesan', '$tanggal_konsultasi')";

if ($conn->query($sql) === TRUE) {
    echo "Data konsultasi berhasil ditambahkan!";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
