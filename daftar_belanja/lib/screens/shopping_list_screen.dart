// Import package material design dari Flutter untuk komponen UI
import "package:flutter/material.dart";
// Import package firebase_database untuk tipe data DatabaseEvent
import "package:firebase_database/firebase_database.dart";
// Import ShoppingService yang berisi method untuk akses Firebase
import "package:daftar_belanja/services/shopping_service.dart";

// Widget ShoppingListScreen menggunakan StatefulWidget karena punya state yang berubah
class ShoppingListScreen extends StatefulWidget {
  // Constructor
  const ShoppingListScreen({super.key});

  // Membuat State untuk widget ini
  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

// Class State yang menyimpan state dan logika dari ShoppingListScreen
class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Membuat instance ShoppingService untuk mengakses Firebase
  final ShoppingService _shoppingService = ShoppingService();
  // Controller untuk mengontrol input text (nama barang)
  final TextEditingController _nameController = TextEditingController();

  // Method dispose dipanggil saat widget dihapus dari widget tree
  @override
  void dispose() {
    // Membersihkan controller agar tidak terjadi memory leak
    _nameController.dispose();
    // Memanggil dispose parent class
    super.dispose();
  }

  // Method build untuk membangun tampilan UI
  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar halaman (AppBar, body, FAB, dll)
    return Scaffold(
      // Body adalah konten utama halaman
      body: SafeArea(
        // SafeArea memastikan konten tidak tertutup status bar/notch
        child: Padding(
          // Padding memberikan jarak 16 pixel di semua sisi
          padding: const EdgeInsets.all(16),
          // Column menyusun widget secara vertikal
          child: Column(
            // CrossAxisAlignment.start membuat widget rata kiri
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== JUDUL ==========
              // Widget Text untuk menampilkan judul halaman
              const Text(
                'Daftar Belanja',
                // Style: ukuran 24, tebal (bold)
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Spasi vertikal 16 pixel antara judul dan input
              const SizedBox(height: 16),

              // ========== INPUT NAMA BARANG + TOMBOL TAMBAH ==========
              // Row menyusun widget secara horizontal
              Row(
                children: [
                  // Expanded membuat TextField mengisi sisa ruang yang tersedia
                  Expanded(
                    // TextField untuk input teks dari pengguna
                    child: TextField(
                      // Menghubungkan controller ke TextField
                      controller: _nameController,
                      // Decoration untuk mengatur tampilan TextField
                      decoration: const InputDecoration(
                        // Hint text muncul saat TextField kosong
                        hintText: 'Masukkan nama barang',
                      ),
                    ),
                  ),
                  // IconButton sebagai tombol tambah (+)
                  IconButton(
                    // Ikon plus (+)
                    icon: const Icon(Icons.add),
                    // Aksi saat tombol ditekan
                    onPressed: () {
                      // Mengambil teks dari controller dan menghapus spasi di awal/akhir
                      final name = _nameController.text.trim();
                      // Validasi: hanya tambah jika nama tidak kosong
                      if (name.isNotEmpty) {
                        // Memanggil method addShoppingItem untuk menyimpan ke Firebase
                        _shoppingService.addShoppingItem(name);
                        // Mengosongkan input setelah item ditambahkan
                        _nameController.clear();
                      }
                    },
                  ),
                ],
              ),
              // Spasi vertikal 8 pixel antara input dan list
              const SizedBox(height: 8),

              // ========== LIST ITEM DARI FIREBASE ==========
              // Expanded agar ListView mengisi sisa ruang vertikal
              Expanded(
                // StreamBuilder mendengarkan stream data dari Firebase secara realtime
                child: StreamBuilder<DatabaseEvent>(
                  // Stream data dari method getShoppingList()
                  stream: _shoppingService.getShoppingList(),
                  // Builder dipanggil setiap kali ada data baru dari stream
                  builder: (context, snapshot) {
                    // Menampilkan loading indicator saat menunggu data pertama kali
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Menampilkan pesan error jika terjadi kesalahan
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // Mengambil data dari snapshot Firebase
                    final data = snapshot.data?.snapshot.value;

                    // Jika data null (kosong), tampilkan pesan
                    if (data == null) {
                      return const Center(child: Text('Belum ada item.'));
                    }

                    // Mengkonversi data dari Firebase (Map) ke dalam bentuk Map Dart
                    final Map<dynamic, dynamic> itemsMap =
                        data as Map<dynamic, dynamic>;
                    // Mengubah Map menjadi List agar bisa diiterasi
                    final items = itemsMap.entries.toList();

                    // ListView.builder membuat list yang efisien (hanya render item yang terlihat)
                    return ListView.builder(
                      // Jumlah item dalam list
                      itemCount: items.length,
                      // Builder untuk setiap item dalam list
                      itemBuilder: (context, index) {
                        // Mengambil key unik dari item (digunakan untuk hapus)
                        final key = items[index].key as String;
                        // Mengkonversi value item menjadi Map<String, dynamic>
                        final item = Map<String, dynamic>.from(
                          items[index].value as Map,
                        );
                        // Mengambil nama barang dari data item
                        final String name = item['name'] ?? '';

                        // ListTile menampilkan satu baris item dengan format standar
                        return ListTile(
                          // Title menampilkan nama barang
                          title: Text(name),
                          // Trailing menampilkan widget di sisi kanan (tombol hapus)
                          trailing: IconButton(
                            // Ikon tempat sampah (delete)
                            icon: const Icon(Icons.delete),
                            // Aksi saat tombol hapus ditekan
                            onPressed: () {
                              // Memanggil method removeShoppingItem untuk hapus dari Firebase
                              _shoppingService.removeShoppingItem(key);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}