import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FeelingsApp());
}

class FeelingsApp extends StatelessWidget {
  const FeelingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feelings App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor:Color(0xFFFAF9F6),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Feeling {
  final String name;
  final String color;
  final String emoji;
  final List<dynamic> quran, hadith, dua, reflections, quotes, advice;

  Feeling({
    required this.name,
    required this.color,
    required this.emoji,
    required this.quran,
    required this.hadith,
    required this.dua,
    required this.reflections,
    required this.quotes,
    required this.advice,
  });

  factory Feeling.fromJson(Map<String, dynamic> json) {
    return Feeling(
      name: json['name'],
      color: json['color'],
      emoji: json['emoji'],
      quran: json['quran'],
      hadith: json['hadith'],
      dua: json['dua'],
      reflections: json['reflections'],
      quotes: json['quotes'],
      advice: json['advice'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Feeling>> feelingsFuture;

  @override
  void initState() {
    super.initState();
    feelingsFuture = loadFeelings();
  }

  Future<List<Feeling>> loadFeelings() async {
    final data = await rootBundle.loadString('assets/Feelings_Box.json');
    final jsonResult = json.decode(data);
    final feelings = jsonResult['feelings'] as List;
    return feelings.map((e) => Feeling.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feelings Box')),
      body: FutureBuilder<List<Feeling>>(
        future: feelingsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feelings = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: feelings.length,
            itemBuilder: (context, index) {
              final feeling = feelings[index];

              // Optional: custom gradient color list
              final gradients = [
                [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                [Color(0xFF43C6AC), Color(0xFFF8FFAE)],
                [Color(0xFFFFA69E), Color(0xFFFF686B)],
                [Color(0xFF7F00FF), Color(0xFFE100FF)],
                [Color(0xFF89F7FE), Color(0xFF66A6FF)],
                [Color(0xFFBBD2C5), Color(0xFF536976)],
                [Color(0xFFEECDA3), Color(0xFFEF629F)],
              ];
              final gradientColors = gradients[index % gradients.length];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FeelingDetailPage(feeling)),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(3, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      feeling.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0,
                        shadows: [
                          Shadow(blurRadius: 2, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}

class FeelingDetailPage extends StatelessWidget {
  final Feeling feeling;
  const FeelingDetailPage(this.feeling, {super.key});

  Widget section(String title, String content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 16)),
          const Divider(height: 24),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(feeling.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            section("🕋 কুরআন", feeling.quran.isNotEmpty ? feeling.quran[0]['bangla'] : 'N/A'),
            section("📜 হাদীস", feeling.hadith.isNotEmpty ? feeling.hadith[0]['text'] : 'N/A'),
            section("🤲 দুআ", feeling.dua.isNotEmpty ? feeling.dua[0]['bangla'] : 'N/A'),
            section("🧠 প্রতিফলন", feeling.reflections.isNotEmpty ? feeling.reflections[0] : 'N/A'),
            section("💬 কোট", feeling.quotes.isNotEmpty ? feeling.quotes[0] : 'N/A'),
            section("📌 উপদেশ", feeling.advice.isNotEmpty ? feeling.advice[0] : 'N/A'),
          ],
        ),
      ),
    );
  }
}
