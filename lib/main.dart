import 'dart:convert';
import 'dart:math';
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
            // 🕋 ভয় (Fear)
            [Color(0xFF141E30), Color(0xFF243B55)], // Midnight navy blue blend

            // 🌫️ হতাশা (Despair)
            [Color(0xFF232526), Color(0xFF414345)], // Deep charcoal grey to steel

            // 🔥 রাগ (Anger)
            [Color(0xFF93291E), Color(0xFFED213A)], // Crimson to bright rage red

            // 🌞 আনন্দ (Joy)
            [Color(0xFFFFB75E), Color(0xFFED8F03)], // Warm golden orange

            // 🌪️ উদ্বেগ (Anxiety)
            [Color(0xFF355C7D), Color(0xFF6C5B7B)], // Muted indigo to soft purple

            // 🌫️ আত্মগ্লানি (Guilt)
            [Color(0xFF606C88), Color(0xFF3F4C6B)], // Faded blue-gray with somber tone

            // 😔 আত্মবিশ্বাসের অভাব (Low confidence)
            [Color(0xFF434343), Color(0xFF000000)], // Fading deep black to grey

            // 🌿 কৃতজ্ঞতা (Gratitude)
            [Color(0xFF56ab2f), Color(0xFFA8E063)], // Green of growth and peace
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
  final Random _random = Random();

  FeelingDetailPage(this.feeling, {super.key});

  Widget getQuranSection(List<dynamic> list) {
    if (list.isEmpty) return const Text("N/A");

    final item = list[_random.nextInt(list.length)];
    if (item is! Map) return Text(item.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item['arabic'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Amiri', // or 'Scheherazade' if available
              height: 2,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item['reference'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item['bangla'] ?? '',
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget getHadithSection(List<dynamic> list) {
    if (list.isEmpty) return const Text("N/A");

    final item = list[_random.nextInt(list.length)];
    if (item is! Map) return Text(item.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['text'] ?? '',
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item['reference'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDuaSection(List<dynamic> list) {
    if (list.isEmpty) return const Text("N/A");

    final item = list[_random.nextInt(list.length)];
    if (item is! Map) return Text(item.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item['arabic'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Amiri',
              height: 2,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item['bangla'] ?? '',
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget simpleTextBox(String content, {Color? color}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16),
        ),
      );

  Widget section(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 24),
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
            section("🕋 কুরআন", getQuranSection(feeling.quran)),
            section("📜 হাদীস", getHadithSection(feeling.hadith)),
            section("🤲 দুআ", getDuaSection(feeling.dua)),
            section("🧠 প্রতিফলন", simpleTextBox(_getRandom(feeling.reflections))),
            section("💬 কোট", simpleTextBox(_getRandom(feeling.quotes))),
            section("📌 উপদেশ", simpleTextBox(_getRandom(feeling.advice))),
          ],
        ),
      ),
    );
  }

  String _getRandom(List<dynamic> list) {
    if (list.isEmpty) return 'N/A';
    return list[_random.nextInt(list.length)].toString();
  }
}
