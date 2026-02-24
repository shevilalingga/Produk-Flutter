# Produk Flutter App

Dokumentasi Singkat & Spesifik

### Komponen Sistem
Aplikasi Produk ini tidak berdiri sendiri, melainkan bertumpu pada arsitektur Client-Server.
- **Client App (Flutter):** Pusat *source code* ada di `lib/`. Berisi pemanggilan `service/` yang menerjemahkan JSON dari API untuk ditampilkan di folder `ui/`. Tersedia contoh komponen dasar UI pada `row_widget.dart` dan `column_widget.dart`.
- **Server DB (PHP SQL):** Komponen pengolah datanya bertempat di folder `crudproduk/`. Dilengkapi skema `database.sql` dengan fiksasi *endpoint produk* dan *config routing*.

### Tiga Langkah Instalasi Dasar
1. **Impor** file sql `database.sql` ke server MySQL Anda.
2. **Posisikan** folder API (`crudproduk/`) beserta isinya agar dapat diakses via rute http lokal (localhost).
3. **Running** *engine* flutter dengan memanggil perintah terminal `flutter run`. Sesuaikan rujukan alamat web service (IP) pada base URL service Flutter Anda.
