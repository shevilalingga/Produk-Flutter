import 'package:flutter/material.dart';
import 'package:produk_flutter_sevila/model/produk_model.dart';
import 'package:produk_flutter_sevila/service/api_service.dart';
import 'package:produk_flutter_sevila/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ======== HEADER GRADIENT ========
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  produk.namaProduk ?? '-',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ======== KONTEN DETAIL ========
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 260, 20, 20),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow("ID", produk.id?.toString() ?? '-'),
                    const Divider(height: 30),
                    _buildDetailRow(
                      "Harga",
                      "Rp ${produk.harga ?? 0}",
                      isPrice: true,
                    ),
                    const Divider(height: 30),
                    _buildDetailRow("Stok", '${produk.stok ?? 0}'),
                    const Divider(height: 30),
                    _buildDetailRow("Deskripsi", produk.deskripsi ?? '-'),
                    const Divider(height: 30),
                    _buildDetailRow("Dibuat", produk.createdAt ?? '-'),

                    const SizedBox(height: 30),

                    // ======== TOMBOL EDIT ========
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdukForm(produk: produk),
                            ),
                          );
                          if (result == true && mounted) {
                            Navigator.pop(
                              context,
                              true,
                            ); // Kembali ke list & refresh
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "Edit Produk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ======== TOMBOL HAPUS ========
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isDeleting ? null : _konfirmasiHapus,
                        icon: _isDeleting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(Icons.delete),
                        label: Text(
                          _isDeleting ? "Menghapus..." : "Hapus Produk",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: Baris detail (label - value)
  Widget _buildDetailRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isPrice ? 20 : 16,
              fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
              color: isPrice ? Colors.green : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  /// Konfirmasi hapus produk via dialog
  Future<void> _konfirmasiHapus() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Yakin ingin menghapus "${widget.produk.namaProduk}"? Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);

    try {
      final success = await ApiService.deleteProduct(widget.produk.id!);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil dihapus!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kembali ke list & refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus produk.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }
}
