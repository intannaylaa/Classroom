<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

// Ambil data JSON dari request
$data = json_decode(file_get_contents("php://input"), true);

$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

// Validasi input
if (empty($username) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Username and password are required"]);
    exit;
}

// Enkripsi password dengan MD5
$hashedPassword = md5($password);

$query = "SELECT * FROM users WHERE username = ? LIMIT 1";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $username);  // Bind parameter tipe string
$stmt->execute();

$result = $stmt->get_result();
$user = $result->fetch_assoc();

// Periksa kecocokan password yang di-hash
if ($user && $hashedPassword === $user['password']) {
    $response = [
        "status" => "success",
        "message" => "Login successful",
        "data" => [
            "id" => $user['id'],
            "username" => $user['username'],
            "email" => $user['email'],
            "role" => $user['role']
        ]
    ];
    echo json_encode($response);
} else {
    echo json_encode(["status" => "error", "message" => "Invalid username or password"]);
}
?>
