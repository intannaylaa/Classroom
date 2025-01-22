-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 22 Jan 2025 pada 21.17
-- Versi server: 10.5.27-MariaDB-cll-lve
-- Versi PHP: 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `teky6584_api_intan`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas_akademik`
--

CREATE TABLE `kelas_akademik` (
  `id` int(11) NOT NULL,
  `nomor_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(255) NOT NULL,
  `nama_dosen` varchar(255) NOT NULL,
  `ruang` varchar(50) NOT NULL,
  `sks` int(11) NOT NULL,
  `waktu` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `kelas_akademik`
--

INSERT INTO `kelas_akademik` (`id`, `nomor_kelas`, `nama_kelas`, `nama_dosen`, `ruang`, `sks`, `waktu`) VALUES
(25, 1122, 'INTERAKSI MANUSIA DAN KOMPUTER', 'SUZUKI SYOFIAN, S.KOM., M.KOM.', 'LAB KOM 8', 3, 'SENIN, 10.00-12.00'),
(26, 1133, 'MOBILE COMPUTING', 'AFRI YUDHA, M.Kom', 'LAB M2', 2, 'SELASA, 15.00-16.00'),
(27, 1144, 'INTERNET OF THINGS', 'ANDI SUSILO, S.Kom., M.T.I.', 'LAB LT 6', 2, 'RABU, 12.00-15.00'),
(28, 1166, 'KEAMANAN SIBER', 'HERIANTO, S.Pd., M.T.', 'LAB CYBER', 3, 'SABTU, 13.00-15.00'),
(29, 1177, 'INTERPERSONAL SKILL', 'Dr. LINDA NUR AFIFA, ST, MT', 'TEKNIK LT 6', 3, 'RABU, 14.00-15.00'),
(30, 1188, 'ETIKA REKAYASA', 'Yan Sofyan Andhana Saputra, S.Kom.,M.Kom', 'T-09', 2, 'KAMIS, 10.00-15.00'),
(32, 1199, 'FRAMEWORK 1', 'JIHAN ASKA S.KOM', 'LAB KOM 3', 5, 'SENIN, 09.00-14.00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `konsultasi`
--

CREATE TABLE `konsultasi` (
  `id` int(11) NOT NULL,
  `topik` varchar(255) NOT NULL,
  `keterangan` text NOT NULL,
  `pesan` text NOT NULL,
  `nomor` varchar(50) NOT NULL,
  `tanggal_konsultasi` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `konsultasi`
--

INSERT INTO `konsultasi` (`id`, `topik`, `keterangan`, `pesan`, `nomor`, `tanggal_konsultasi`) VALUES
(5, 'tess', 'halo, ini coba di hosting', 'ya, ini intan', '12', '2025-01-20 13:54:30'),
(6, 'Test', 'Topik UAS', 'Uas Sudah selesai', 'fxjvfskjskljskldfjdskjk', '2025-01-22 16:38:20');

-- --------------------------------------------------------

--
-- Struktur dari tabel `krs`
--

CREATE TABLE `krs` (
  `id` int(11) NOT NULL,
  `nomor_kelas` varchar(50) NOT NULL,
  `nama_kelas` varchar(100) NOT NULL,
  `nama_dosen` varchar(100) NOT NULL,
  `ruang` varchar(50) NOT NULL,
  `sks` int(11) NOT NULL,
  `waktu` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tugas`
--

CREATE TABLE `tugas` (
  `id` int(11) NOT NULL,
  `judul_tugas` varchar(255) NOT NULL,
  `deskripsi_tugas` text NOT NULL,
  `batas_waktu` datetime NOT NULL,
  `status` enum('belum dikumpulkan','sudah dikumpulkan') DEFAULT 'belum dikumpulkan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `tugas`
--

INSERT INTO `tugas` (`id`, `judul_tugas`, `deskripsi_tugas`, `batas_waktu`, `status`) VALUES
(4, 'Alert Sekuriti', 'Kebijakan Sekuriti dan Uji Sekuriti', '2025-09-12 10:00:02', 'sudah dikumpulkan'),
(5, 'Membuat CV dan Portofolio', 'menggunakan CV ATS ya', '2025-12-03 12:00:00', 'sudah dikumpulkan'),
(6, 'Mengerjakan Modul', 'Mobile computing menyenangkan', '2025-10-22 14:02:00', 'sudah dikumpulkan'),
(7, 'tes tugas', 'halo, ini percobaan udah di hosting', '2025-01-22 10:00:02', 'sudah dikumpulkan'),
(8, 'Membuat Review', 'makalah review jurnal', '2025-04-11 15:00:01', 'belum dikumpulkan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'admin', 'admin@gmail.com', '21232f297a57a5a743894a0e4a801fc3', 'admin', '2025-01-18 22:01:38'),
(2, 'userintan', 'user@gmail.com', 'ee11cbb19052e40b07aac0ca060c23ee', 'user', '2025-01-18 22:01:53');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `kelas_akademik`
--
ALTER TABLE `kelas_akademik`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `konsultasi`
--
ALTER TABLE `konsultasi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `krs`
--
ALTER TABLE `krs`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tugas`
--
ALTER TABLE `tugas`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `kelas_akademik`
--
ALTER TABLE `kelas_akademik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT untuk tabel `konsultasi`
--
ALTER TABLE `konsultasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `krs`
--
ALTER TABLE `krs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `tugas`
--
ALTER TABLE `tugas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
