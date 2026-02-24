<?php
// ============================================
// Koneksi Database menggunakan PDO
// ============================================

$host = "localhost";
$db_name = "db_crud_produk";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8mb4", $username, $password);

    // Set PDO error mode ke exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Nonaktifkan emulated prepared statements untuk keamanan
    $conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
} catch (PDOException $e) {
    // Jika koneksi gagal, kembalikan response JSON
    http_response_code(500);
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode([
        "status"  => false,
        "message" => "Koneksi database gagal: " . $e->getMessage()
    ]);
    exit();
}
