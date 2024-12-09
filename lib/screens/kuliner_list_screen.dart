import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:koja/bypasser.dart'; // Assuming this is where bypassRequest function is located.

class KulinerListScreen extends StatefulWidget {
  const KulinerListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KulinerListScreenState createState() => _KulinerListScreenState();
}

class _KulinerListScreenState extends State<KulinerListScreen> {
  // List to store fetched hotel data
  List<Map<String, dynamic>> kulinerList = [];

  // Flag for loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKuliner(); // Fetch Kuliner when the screen is first loaded
  }

  Future<void> fetchKuliner() async {
    final response =
        await bypassRequest("http://tessssss.rf.gd/api.php?endpoint=kuliner");

    if (response != null) {
      try {
        // Parse the response JSON and assign it to the kulinerList
        final List<dynamic> fetchedKuliner = jsonDecode(response);
        setState(() {
          kulinerList = List<Map<String, dynamic>>.from(fetchedKuliner);
          isLoading = false; // Set loading flag to false once data is fetched
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing JSON: $e');
        }
        setState(() {
          isLoading = false; // Stop loading even in case of error
        });
        // Handle parsing error
      }
    } else {
      if (kDebugMode) {
        print('Failed to fetch Kuliner data.');
      }
      setState(() {
        isLoading = false; // Stop loading if request fails
      });
      // Handle null response
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kuliner Kota Jambi'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: kulinerList.length,
              itemBuilder: (context, index) {
                final kuliner = kulinerList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KulinerDetailScreen(
                            name: kuliner['name'],
                            image: kuliner['image'],
                            location: LatLng(kuliner['location_lat'],
                                kuliner['location_lng']),
                            address: kuliner['address'],
                            phone: kuliner['phone'],
                            description: kuliner['description'],
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              kuliner['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            kuliner['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class KulinerDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final LatLng location;
  final String address;
  final String phone;
  final String description;

  const KulinerDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.location,
    required this.address,
    required this.phone,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kuliner'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: location,
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                        const Icon(Icons.restaurant,
                            color: Colors.green, size: 30),
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
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
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

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KulinerListScreen(),
  ));
}
