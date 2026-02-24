<?php
// ============================================
// DELETE - Hapus Produk
// ============================================

// CORS Headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Koneksi database
require_once __DIR__ . '/../config/konekdb.php';

// Ambil data JSON dari body request
$data = json_decode(file_get_contents("php://input"));

// Validasi: cek apakah ID ada
if (empty($data->id)) {
    http_response_code(400);
    echo json_encode([
        "status"  => false,
        "message" => "Field id wajib diisi."
    ]);
    exit();
}

// Validasi tipe data
if (!is_numeric($data->id)) {
    http_response_code(400);
    echo json_encode([
        "status"  => false,
        "message" => "Field id harus berupa angka."
    ]);
    exit();
}

try {
    // Cek apakah produk ada
    $checkQuery = "SELECT id FROM products WHERE id = :id";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bindParam(":id", $data->id, PDO::PARAM_INT);
    $checkStmt->execute();

    if ($checkStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode([
            "status"  => false,
            "message" => "Produk dengan ID {$data->id} tidak ditemukan."
        ]);
        exit();
    }

    $query = "DELETE FROM products WHERE id = :id";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(":id", $data->id, PDO::PARAM_INT);

    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode([
            "status"  => true,
            "message" => "Produk berhasil dihapus."
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status"  => false,
        "message" => "Gagal menghapus produk: " . $e->getMessage()
    ]);
}
