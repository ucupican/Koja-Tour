import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:koja/bypasser.dart'; // Untuk koordinat

class TempatIbadahListScreen extends StatefulWidget {
  const TempatIbadahListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TempatIbadahListScreenState createState() => _TempatIbadahListScreenState();
}

class _TempatIbadahListScreenState extends State<TempatIbadahListScreen> {
  final List<Map<String, dynamic>> tempatIbadah = [];

  // Fetch data from the API
  Future<void> fetchTempatIbadah() async {
    final response = await bypassRequest(
        "http://tessssss.rf.gd/api.php?endpoint=tempatibadah");

    if (response != null) {
      try {
        // Parse the response JSON
        final List<dynamic> fetchedTempatIbadah = jsonDecode(response);

        setState(() {
          tempatIbadah.clear();
          tempatIbadah.addAll(fetchedTempatIbadah.map((item) {
            return {
              'nama': item['nama'],
              'lokasi': LatLng(item['lokasi_lat'], item['lokasi_lng']),
            };
          }).toList());
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing JSON: $e');
        }
        // Handle parsing error
      }
    } else {
      if (kDebugMode) {
        print('Failed to fetch tempat ibadah data.');
      }
      // Handle null response
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTempatIbadah(); // Fetch data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tempat Ibadah',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: tempatIbadah.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tempatIbadah.length,
              itemBuilder: (context, index) {
                final tempat = tempatIbadah[index];

                // Validasi data lokasi
                if (tempat['lokasi'] == null || tempat['nama'] == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widget FlutterMap
                      SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: FlutterMap(
                            options: MapOptions(
                              center: tempat['lokasi'], // Lokasi pusat peta
                              zoom: 16, // Zoom level
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const [
                                  'a',
                                  'b',
                                  'c'
                                ], // Subdomain untuk caching
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: tempat['lokasi'],
                                    builder: (context) => const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Nama Tempat Ibadah
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 36, 255, 7),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tempat['nama'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
