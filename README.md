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
<img width="1365" height="639" alt="image" src="https://github.com/user-attachments/assets/b56d8354-e54e-4c5e-ad1a-88811d2c3ade" />
<img width="1366" height="608" alt="image" src="https://github.com/user-attachments/assets/c7f7af1a-5a5f-448d-8783-91e83ae0187f" />
<img width="1362" height="642" alt="image" src="https://github.com/user-attachments/assets/ae4da8ae-b85b-4199-ba8a-c29230007a78" />
<img width="1366" height="597" alt="image" src="https://github.com/user-attachments/assets/a4702ee9-0cb6-435b-8fbe-dec256d80f53" />
<img width="1366" height="637" alt="image" src="https://github.com/user-attachments/assets/c0859fcc-2362-41af-9590-93b474fed102" />
