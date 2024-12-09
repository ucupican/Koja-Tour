import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:koja/bypasser.dart';

class WisataListScreen extends StatefulWidget {
  const WisataListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WisataListScreenState createState() => _WisataListScreenState();
}

class _WisataListScreenState extends State<WisataListScreen> {
  // List to store fetched hotel data
  List<Map<String, dynamic>> touristSpots = [];

  // Flag for loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWisataListScreen(); // Fetch WisataListScreen when the screen is first loaded
  }

  Future<void> fetchWisataListScreen() async {
    final response =
        await bypassRequest("http://tessssss.rf.gd/api.php?endpoint=wisata");

    if (response != null) {
      try {
        // Parse the response JSON and assign it to the WisataListScreenList
        final List<dynamic> fetchedWisataListScreen = jsonDecode(response);
        setState(() {
          touristSpots =
              List<Map<String, dynamic>>.from(fetchedWisataListScreen);
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
        print('Failed to fetch WisataListScreen data.');
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
        title: const Text('Daftar Wisata Kota Jambi'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: touristSpots.length,
          itemBuilder: (context, index) {
            final spot = touristSpots[index];
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
                      builder: (context) => WisataDetailScreen(
                        name: spot['name']!,
                        image: spot['image']!,
                        category: spot['category']!,
                        address: spot['address']!,
                        description: spot['description']!,
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.network(
                          spot['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        spot['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WisataDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final String category;
  final String address;
  final String description;

  const WisataDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.category,
    required this.address,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Wisata'),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar dengan ukuran tetap
            Container(
              height: 300, // Tinggi tetap
              width: double.infinity, // Lebar penuh
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi detail
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori
                    Row(
                      children: [
                        const Icon(Icons.category,
                            color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Alamat
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

                    // Deskripsi
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
