import 'package:flutter/widgets.dart';
import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
// Import ShoppingService yang berisi method untuk akses Firebase
import "package:mdp_gold/services/gold_service.dart";


class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  final goldService _goldService = goldService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Emas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _goldService.getPriceList(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final data = snapshot.data?.snapshot.value;

          if (data == null) {
            return const Center(child: Text('Belum ada item.'));
          }

          final Map<dynamic, dynamic> itemsMap =
            data as Map<dynamic, dynamic>;
                    // Mengubah Map menjadi List agar bisa diiterasi
          
          final items = itemsMap.entries.toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder : (context,index){
            // Mengkonversi value item menjadi Map<String, dynamic>
            final item = Map<String, dynamic>.from(
              items[index].value as Map,
              );
            // Mengambil nama barang dari data ite 
            final String tanggal = item['tanggal'] ?? '';
            final String harga = item['harga'] ?? '';

            return ListTile(
              title: Text(harga),
              subtitle : Text(tanggal),
              );
            }
          );
        }
        ),
    );
  }
}