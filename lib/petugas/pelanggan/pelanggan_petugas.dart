import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/riwayat_petugas.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/petugas/user/user_petugas.dart';
import 'package:kasir_pl1/login.dart';
import 'package:kasir_pl1/petugas/pelanggan/insert_pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/edit_pelanggan_petugas.dart';

class PelangganPetugas extends StatefulWidget {
  const PelangganPetugas({super.key});

  @override
  State<PelangganPetugas> createState() => _PelangganPetugasState();
}

class _PelangganPetugasState extends State<PelangganPetugas> {
  List<Map<String, dynamic>> pelanggans = [];
  List<Map<String, dynamic>> filteredPelanggan = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPelanggans();
    searchController.addListener(_searchPelanggan);
  }

  Future<void> fetchPelanggans() async {
    final response = await Supabase.instance.client.from('pelanggan').select();

    setState(() {
      pelanggans = List<Map<String, dynamic>>.from(response);
      filteredPelanggan = List.from(pelanggans);
    });
  }

  Future<void> _searchPelanggan() async {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredPelanggan = pelanggans.where((pelanggan) {
        final NamaPelanggan = pelanggan['NamaPelanggan'].toLowerCase();
        return NamaPelanggan.contains(query);
      }).toList();
    });
  }

  Future<void> _deletePelanggans(int id) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id);
      fetchPelanggans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pelanggan tidak ditemukan : $e'),
          backgroundColor: Colors.pinkAccent.shade100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: ClipRRect(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            ListTile(
              title: Text('Beranda',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HalamanBerandaPetugas()));
              },
            ),
            ListTile(
              title: Text('User',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPetugas()));
              },
            ),
            ListTile(
              title: Text('Produk',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProdukPetugas()));
              },
            ),
            ListTile(
              title: Text('Pelanggan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PelangganPetugas()));
              },
            ),
            ListTile(
              title: Text('Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PenjualanPetugas()));
              },
            ),
            ListTile(
              title: Text('Riwayat Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiwayatPetugas()));
              },
            ),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HalamanLogin()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Cari Produk...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
      body: filteredPelanggan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredPelanggan.length,
              itemBuilder: (context, index) {
                final pelanggan = filteredPelanggan[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.pinkAccent.shade100, blurRadius: 10.0)
                      ]),
                  child: ListTile(
                    title: Text(pelanggan['NamaPelanggan'],
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('Alamat : ${pelanggan['Alamat']}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('No. Telp : ${pelanggan['NomorTelepon']}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPelangganPetugas(
                                            NamaPelanggan:
                                                pelanggan['NamaPelanggan'],
                                            Alamat: pelanggan['Alamat'],
                                            NomorTelepon:
                                                pelanggan['NomorTelepon'],
                                          )));

                              if (result != null) {
                                setState(() {
                                  pelanggans[index] = {
                                    'NamaPelanggan': result['NamaPelanggan'],
                                    'Alamat': result['Alamat'],
                                    'NomorTelepon': result['NomorTelepon']
                                  };
                                });
                              }
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue),
                        IconButton(
                            onPressed: () {
                              _deletePelanggans(pelanggan['PelangganID']);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red)
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InsertPelangganPetugas()));
            if (result == true) {
              fetchPelanggans();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent.shade100),
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
