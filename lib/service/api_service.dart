import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:produk_flutter_sevila/model/produk_model.dart';

class ApiService {
  // ============================================================
  // BASE URL - Sesuaikan dengan environment kamu:
  //
  // Emulator Android : http://10.0.2.2/crudproduk/produk
  // Device Fisik     : http://<IP_KOMPUTER>/crudproduk/produk
  //                    contoh: http://192.168.1.10/crudproduk/produk
  // Chrome (Web)     : http://localhost/crudproduk/produk
  // ============================================================
  static const String baseUrl = 'http://localhost/crudproduk/produk';

  /// GET - Ambil semua produk
  static Future<List<Produk>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read.php'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == true) {
          final List data = body['data'];
          return data.map((item) => Produk.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  /// GET - Ambil satu produk berdasarkan ID
  static Future<Produk?> getProduct(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read.php?id=$id'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == true) {
          return Produk.fromJson(body['data']);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  /// POST - Tambah produk baru
  static Future<bool> createProduct(Produk produk) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produk.toJson()),
      );

      final body = json.decode(response.body);
      return body['status'] == true;
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }

  /// POST - Perbarui produk
  static Future<bool> updateProduct(Produk produk) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produk.toJson()),
      );

      final body = json.decode(response.body);
      return body['status'] == true;
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  /// POST - Hapus produk
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );

      final body = json.decode(response.body);
      return body['status'] == true;
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
