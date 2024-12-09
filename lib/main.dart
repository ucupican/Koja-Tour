import 'package:flutter/material.dart';
import 'screens/hotel_list_screen.dart';
import 'screens/kuliner_list_screen.dart';
import 'screens/wisata_list_screen.dart';
import 'screens/tempatibadah_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

// LANDING PAGE WITH ANIMATIONS
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeController.forward();

    // Slide-in animation for the description
    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderImage(fadeController: _fadeController),
            const SizedBox(height: 30),
            TitleText(slideController: _slideController),
            const SizedBox(height: 16),
            DescriptionText(fadeController: _fadeController),
            const SizedBox(height: 20),
            InstructionText(slideController: _slideController),
            const SizedBox(height: 10),
            _buildInstructionItem("1. Pilih kategori sesuai kebutuhan Anda."),
            _buildInstructionItem(
                "2. Jelajahi daftar lokasi menarik dengan informasi lengkap."),
            _buildInstructionItem("3. Gunakan fitur peta untuk navigasi."),
            const SizedBox(height: 30),
            StartButton(fadeController: _fadeController),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

// HEADER IMAGE WITH ANIMATION
class HeaderImage extends StatelessWidget {
  final AnimationController fadeController;
  const HeaderImage({super.key, required this.fadeController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeController,
      child: Image.asset(
        'assets/images/siginjai.jpg', // Replace with your own image
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}

// TITLE TEXT WITH SLIDE ANIMATION
class TitleText extends StatelessWidget {
  final AnimationController slideController;
  const TitleText({super.key, required this.slideController});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: slideController,
        curve: Curves.easeOut,
      )),
      child: const Text(
        "Selamat Datang di KoJa Tour",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}

// DESCRIPTION TEXT WITH FADE ANIMATION
class DescriptionText extends StatelessWidget {
  final AnimationController fadeController;
  const DescriptionText({super.key, required this.fadeController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeController,
      child: Text(
        "KoJa Tour adalah aplikasi panduan wisata di Kota Jambi. Anda dapat menjelajahi tempat wisata, hotel, kuliner, dan tempat ibadah dengan mudah.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

// INSTRUCTION TEXT WITH SLIDE ANIMATION
class InstructionText extends StatelessWidget {
  final AnimationController slideController;
  const InstructionText({super.key, required this.slideController});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: slideController,
        curve: Curves.easeOut,
      )),
      child: const Text(
        "Cara Menggunakan Aplikasi:",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// START BUTTON WITH FADE ANIMATION
class StartButton extends StatelessWidget {
  final AnimationController fadeController;
  const StartButton({super.key, required this.fadeController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeController,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // Button color
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Mulai Jelajahi",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KoJa Tour',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 255, 7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Card Info
              Card(
                margin: const EdgeInsets.only(top: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.teal, size: 30),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wisata Kota Jambi',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.teal),
                              const SizedBox(width: 6),
                              Text(
                                'Senin, 11 November 2024',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Image and Info Card
              Card(
                margin: const EdgeInsets.only(top: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: SizedBox(
                        height: 350,
                        child: Image.asset(
                          'assets/images/siginjai.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Siginjai, Kota Jambi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Category Grid
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar Kategori',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15, // Horizontal spacing between cards
                mainAxisSpacing: 15, // Vertical spacing between cards
                padding: const EdgeInsets.all(10),
                childAspectRatio: 1.4, // Adjust the aspect ratio of the card
                children: [
                  _buildCategoryCard('Hotel', Icons.hotel, Colors.blue,
                      'assets/images/hotel.png', context),
                  _buildCategoryCard('Kuliner', Icons.restaurant, Colors.red,
                      'assets/images/kuliner.png', context),
                  _buildCategoryCard('Tempat Ibadah', Icons.mosque,
                      Colors.green, 'assets/images/mesjid.png', context),
                  _buildCategoryCard('Wisata', Icons.place, Colors.orange,
                      'assets/images/wisata.png', context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color,
      String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to respective category screen
        if (title == 'Hotel') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HotelListScreen()));
        } else if (title == 'Kuliner') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const KulinerListScreen()));
        } else if (title == 'Tempat Ibadah') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TempatIbadahListScreen()));
        } else if (title == 'Wisata') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const WisataListScreen()));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
