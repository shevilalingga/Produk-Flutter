import 'package:flutter/material.dart';
import 'package:produk_flutter_sevila/ui/produk_page.dart';

// Fungsi main() adalah titik awal (entry point) dari semua aplikasi Flutter.
// Sama seperti fungsi main() di C++, Java, atau Dart standar.
void main() {
  // runApp() adalah fungsi yang menjalankan aplikasi Flutter.
  // Fungsi ini "mengembangkan" (inflate) widget yang diberikan (MyApp) dan menampilkannya di layar.
  runApp(const MyApp());
}

// MyApp adalah widget root (akar/induk) dari aplikasi Anda.
// Kita menggunakan StatelessWidget karena konfigurasi dasar aplikasi ini (seperti tema, judul)
// tidak berubah secara dinamis saat aplikasi berjalan.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Method build() adalah bagian paling penting. Di sinilah kita mendeskripsikan
  // bagaimana tampilan widget ini. Flutter akan memanggil method ini saat widget perlu digambar.
  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget pembungkus utama yang menyediakan gaya desain Material (Google).
    // Ini mengatur tema, navigasi, dan struktur dasar aplikasi.
    return MaterialApp(
      title:
          "Aplikasi Flutter Pertama", // Judul aplikasi (tampak di recent apps/task switcher)
      // Menghilangkan pita "DEBUG" kecil di pojok kanan atas aplikasi saat mode debug
      debugShowCheckedModeBanner: false,

      // properti 'home' menentukan halaman pertama yang muncul saat aplikasi dibuka.
      // Di sini kita mengatur agar aplikasi langsung membuka widget 'ProdukPage'.
      home: ProdukPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Kode di bawah ini adalah kode bawaan (template Counter/Penghitung) saat Anda membuat project Flutter baru.
// Kode ini TIDAK SEDANG DIGUNAKAN sekarang karena di atas (pada properti home) kita menggunakan 'ProdukPage()'.
//
// Saya biarkan di sini sebagai referensi belajar StatefulWidget (Widget yang bisa berubah tampilannya).
// Jika ingin melihat halaman ini, ubah baris 'home: ProdukPage(),' di atas menjadi:
// home: const MyHomePage(title: 'Flutter Demo Home Page'),
// ---------------------------------------------------------------------------

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/
