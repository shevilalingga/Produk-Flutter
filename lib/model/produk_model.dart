class Produk {
  int? id;
  String? namaProduk;
  int? harga;
  int? stok;
  String? deskripsi;
  String? createdAt;

  Produk({
    this.id,
    this.namaProduk,
    this.harga,
    this.stok,
    this.deskripsi,
    this.createdAt,
  });

  /// Factory constructor untuk membuat objek Produk dari JSON (response API)
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      namaProduk: json['nama_produk'],
      harga: json['harga'] is int
          ? json['harga']
          : int.tryParse(json['harga'].toString()),
      stok: json['stok'] is int
          ? json['stok']
          : int.tryParse(json['stok'].toString()),
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'],
    );
  }

  /// Mengubah objek Produk ke Map (untuk dikirim ke API sebagai JSON)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_produk': namaProduk,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
    };
  }
}
