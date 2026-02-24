<?php
// ============================================
// CREATE - Tambah Produk Baru
// ============================================

// CORS Headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Hanya terima method POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        "status"  => false,
        "message" => "Method tidak diizinkan. Gunakan POST."
    ]);
    exit();
}

// Koneksi database
require_once __DIR__ . '/../config/konekdb.php';

// Ambil data JSON dari body request
$data = json_decode(file_get_contents("php://input"));

// Validasi: cek apakah data yang dibutuhkan ada dan tidak kosong
if (
    empty($data->nama_produk) ||
    !isset($data->harga) ||
    !isset($data->stok)
) {
    http_response_code(400);
    echo json_encode([
        "status"  => false,
        "message" => "Data tidak lengkap. Field nama_produk, harga, dan stok wajib diisi."
    ]);
    exit();
}

// Validasi tipe data
if (!is_numeric($data->harga) || !is_numeric($data->stok)) {
    http_response_code(400);
    echo json_encode([
        "status"  => false,
        "message" => "Field harga dan stok harus berupa angka."
    ]);
    exit();
}

try {
    $query = "INSERT INTO products (nama_produk, harga, stok, deskripsi) VALUES (:nama_produk, :harga, :stok, :deskripsi)";
    $stmt = $conn->prepare($query);

    $stmt->bindParam(":nama_produk", $data->nama_produk);
    $stmt->bindParam(":harga", $data->harga, PDO::PARAM_INT);
    $stmt->bindParam(":stok", $data->stok, PDO::PARAM_INT);

    $deskripsi = !empty($data->deskripsi) ? $data->deskripsi : null;
    $stmt->bindParam(":deskripsi", $deskripsi);

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode([
            "status"  => true,
            "message" => "Produk berhasil ditambahkan.",
            "data"    => [
                "id" => $conn->lastInsertId()
            ]
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status"  => false,
        "message" => "Gagal menambahkan produk: " . $e->getMessage()
    ]);
}
