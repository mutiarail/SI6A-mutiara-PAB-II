// Import package firebase_database untuk mengakses Firebase Realtime Database
import "package:firebase_database/firebase_database.dart";

// Class ShoppingService berisi method-method untuk mengakses data di Firebase
class ShoppingService {
  // Membuat referensi ke node 'shopping_list' di Firebase Realtime Database
  // Semua data akan disimpan di bawah node ini
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'shopping_list',
  );

  // Method untuk mengambil data daftar belanja secara realtime
  // Mengembalikan Stream yang akan otomatis update saat data berubah
  Stream<DatabaseEvent> getShoppingList() {
    // onValue mengembalikan stream yang mendengarkan perubahan data
    return _database.onValue;
  }

  // Method untuk menambahkan item baru ke daftar belanja
  // Parameter: name (nama barang)
  Future<void> addShoppingItem(String name) async {
    // push() membuat key unik otomatis untuk setiap item
    // set() menyimpan data ke Firebase
    await _database.push().set({
      'name': name, // Menyimpan nama barang
    });
  }

  // Method untuk menghapus item dari daftar belanja
  // Parameter: key (key unik dari item yang ingin dihapus)
  Future<void> removeShoppingItem(String key) async {
    // child(key) mengakses item berdasarkan key-nya
    // remove() menghapus item tersebut dari Firebase
    await _database.child(key).remove();
  }
}