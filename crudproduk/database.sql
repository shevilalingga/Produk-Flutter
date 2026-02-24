-- ============================================
-- Database: db_crud_produk
-- ============================================

CREATE DATABASE IF NOT EXISTS db_crud_produk;
USE db_crud_produk;

-- ============================================
-- Tabel: products
-- ============================================

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(255) NOT NULL,
    harga INT NOT NULL,
    stok INT NOT NULL,
    deskripsi TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
