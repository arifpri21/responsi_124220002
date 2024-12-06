import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealDetailPage extends StatefulWidget {
  final String mealId;

  const MealDetailPage({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  Map<String, dynamic>? mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mealDetails = data['meals'][0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(mealDetails?['strMeal'] ?? 'Loading...'),
        elevation: 0,
      ),
      body: mealDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar dengan efek bayangan dan border radius
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(mealDetails!['strMealThumb']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Makanan
                        Text(
                          mealDetails!['strMeal'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Kategori dan Area
                        Row(
                          children: [
                            Chip(
                              label: Text(mealDetails!['strCategory']),
                              backgroundColor: Colors.deepOrange,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Chip(
                              label: Text(mealDetails!['strArea']),
                              backgroundColor: Colors.green,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Instruksi memasak
                        const Text(
                          'Instructions:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mealDetails!['strInstructions'],
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        // Tombol untuk menonton video tutorial
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            final videoUrl = mealDetails!['strYoutube'];
                            if (videoUrl != null && videoUrl.isNotEmpty) {
                              // Navigasi ke WebView untuk video tutorial
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewPage(videoUrl),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Watch Video Tutorial',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Tutorial')),
      body: Center(
        child: Text('Implementasi WebView untuk URL: $url'),
      ),
    );
  }
}
