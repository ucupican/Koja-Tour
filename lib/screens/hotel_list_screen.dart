import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:koja/bypasser.dart';
import 'dart:convert';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  List<dynamic> hotels = [];

  // Fungsi untuk mengambil data dari API
  Future<void> fetchHotels() async {
    final response =
        await bypassRequest("http://tessssss.rf.gd/api.php?endpoint=hotels");

    if (response != null) {
      try {
        // Parse the response JSON and assign it to the hotels list
        final List<dynamic> fetchedHotels = jsonDecode(response);
        setState(() {
          hotels = fetchedHotels;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing JSON: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('Failed to fetch hotels data.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Hotel Kota Jambi'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: hotels.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Menampilkan loading saat data masih kosong
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: hotels.map((hotel) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          // Arahkan ke screen detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDetailScreen(
                                name: hotel['name'],
                                image: hotel['image'],
                                location: LatLng(hotel['location_lat'],
                                    hotel['location_lng']),
                                address: hotel['address'],
                                phone: hotel['phone'],
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          children: [
                            // Gambar hotel
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                hotel['image'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Nama hotel
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                hotel['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

class HotelDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final LatLng location;
  final String address;
  final String phone;

  const HotelDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.location,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Hotel'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: Column(
        children: [
          // Peta hotel dengan lokasi
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: location, // Lokasi awal
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", // Peta
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      builder: (context) => const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Informasi hotel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hotel, color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phone,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
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
}
