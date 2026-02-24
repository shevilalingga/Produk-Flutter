import 'package:flutter/material.dart';
import 'package:produk_flutter_sevila/model/produk_model.dart';
import 'package:produk_flutter_sevila/service/api_service.dart';

class ProdukForm extends StatefulWidget {
  // Jika produk != null, maka mode EDIT. Jika null, mode CREATE.
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaProdukController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditMode => widget.produk != null;

  @override
  void initState() {
    super.initState();
    // Jika mode edit, pre-fill semua field dengan data produk
    if (_isEditMode) {
      _namaProdukController.text = widget.produk!.namaProduk ?? '';
      _hargaController.text = widget.produk!.harga?.toString() ?? '';
      _stokController.text = widget.produk!.stok?.toString() ?? '';
      _deskripsiController.text = widget.produk!.deskripsi ?? '';
    }
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? "Edit Produk" : "Tambah Produk",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  _isEditMode ? "Edit Data Produk" : "Tambah Produk Baru",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Field: Nama Produk
                _buildTextField(
                  controller: _namaProdukController,
                  label: "Nama Produk",
                  icon: Icons.inventory,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Field: Harga
                _buildTextField(
                  controller: _hargaController,
                  label: "Harga",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Harga harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Field: Stok
                _buildTextField(
                  controller: _stokController,
                  label: "Stok",
                  icon: Icons.warehouse,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok wajib diisi';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Stok harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Field: Deskripsi (opsional)
                _buildTextField(
                  controller: _deskripsiController,
                  label: "Deskripsi (opsional)",
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 30),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _simpanProduk,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isEditMode ? "Perbarui Produk" : "Simpan Produk",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method untuk membuat TextField dengan style konsisten
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  /// Proses simpan / update produk
  Future<void> _simpanProduk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final produk = Produk(
        id: widget.produk?.id,
        namaProduk: _namaProdukController.text,
        harga: int.parse(_hargaController.text),
        stok: int.parse(_stokController.text),
        deskripsi: _deskripsiController.text.isNotEmpty
            ? _deskripsiController.text
            : null,
      );

      bool success;
      if (_isEditMode) {
        success = await ApiService.updateProduct(produk);
      } else {
        success = await ApiService.createProduct(produk);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Produk berhasil diperbarui!'
                  : 'Produk berhasil ditambahkan!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // true = ada perubahan, perlu refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan produk.'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
