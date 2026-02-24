<?php
// ============================================
// READ - Ambil Semua Produk
// ============================================

// CORS Headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Koneksi database
require_once __DIR__ . '/../config/konekdb.php';

try {
    // Cek apakah ada parameter id untuk read satu produk
    if (isset($_GET['id'])) {
        $id = $_GET['id'];

        if (!is_numeric($id)) {
            http_response_code(400);
            echo json_encode([
                "status"  => false,
                "message" => "ID harus berupa angka."
            ]);
            exit();
        }

        $query = "SELECT * FROM products WHERE id = :id";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            http_response_code(200);
            echo json_encode([
                "status"  => true,
                "message" => "Data produk ditemukan.",
                "data"    => $row
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "status"  => false,
                "message" => "Produk dengan ID $id tidak ditemukan."
            ]);
        }
    } else {
        // Ambil semua produk
        $query = "SELECT * FROM products ORDER BY created_at DESC";
        $stmt = $conn->prepare($query);
        $stmt->execute();

        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);

        http_response_code(200);
        echo json_encode([
            "status"  => true,
            "message" => "Data produk berhasil diambil.",
            "data"    => $products
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status"  => false,
        "message" => "Gagal mengambil data produk: " . $e->getMessage()
    ]);
}
