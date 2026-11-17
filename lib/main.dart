
import 'package:flutter/material.dart';

void main() {
  runApp(const PDFPlusApp());
}

class PDFPlusApp extends StatelessWidget {
  const PDFPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Plus',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769E8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FF),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'name': 'Image to PDF', 'icon': Icons.image_outlined},
    {'name': 'Merge PDF', 'icon': Icons.merge_type},
    {'name': 'Split PDF', 'icon': Icons.call_split},
    {'name': 'Compress PDF', 'icon': Icons.compress},
    {'name': 'PDF to Images', 'icon': Icons.photo_library_outlined},
    {'name': 'Rotate PDF', 'icon': Icons.rotate_right},
    {'name': 'Protect PDF', 'icon': Icons.lock_outline},
    {'name': 'Unlock PDF', 'icon': Icons.lock_open},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Color(0xFF1769E8), size: 30),
            SizedBox(width: 9),
            Text(
              'PDF Plus',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
            color: Color(0xFF1769E8),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1769E8), Color(0xFF55A2FF)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your PDFs, simplified.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Simple tools to manage your documents.',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 18),
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 38,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'PDF Tools',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tools.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 13,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: const Color(0xFFE5ECF8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tool['icon'] as IconData,
                          color: const Color(0xFF1769E8),
                          size: 32,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tool['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263956),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'PDF Plus • Your documents, your control',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
