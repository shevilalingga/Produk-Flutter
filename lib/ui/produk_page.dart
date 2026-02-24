import 'package:flutter/material.dart';
import 'package:produk_flutter_sevila/model/produk_model.dart';
import 'package:produk_flutter_sevila/service/api_service.dart';
import 'package:produk_flutter_sevila/ui/produk_form.dart';
import 'package:produk_flutter_sevila/ui/produk_detail.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  // Future untuk menyimpan data produk dari API
  late Future<List<Produk>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.getProducts();
  }

  // Method untuk refresh data
  void _refreshData() {
    setState(() {
      _futureProducts = ApiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Produk', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Buka form tambah produk, lalu refresh jika kembali
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProdukForm()),
              );
              if (result == true) {
                _refreshData();
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Produk>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            // State: Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black87),
              );
            }

            // State: Error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _refreshData,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            // State: Data kosong
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 60, color: Colors.black54),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada produk.',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProdukForm(),
                          ),
                        );
                        if (result == true) _refreshData();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Produk'),
                    ),
                  ],
                ),
              );
            }

            // State: Data berhasil dimuat
            return RefreshIndicator(
              onRefresh: () async => _refreshData(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ItemProduk(
                    produk: products[index],
                    onRefresh: _refreshData,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// Widget Item Produk (Card di dalam list)
// ============================================================
class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onRefresh;

  const ItemProduk({super.key, required this.produk, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Buka detail, lalu refresh list jika ada perubahan
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );
        if (result == true) {
          onRefresh();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.black54),
            ),
            const SizedBox(width: 16),

            // Info produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.namaProduk ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stok: ${produk.stok ?? 0}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${produk.harga ?? 0}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
