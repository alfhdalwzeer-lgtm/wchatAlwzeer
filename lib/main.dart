import 'package:flutter/material.dart';

void main() {
  runApp(const WchatAlwzeerApp());
}

class WchatAlwzeerApp extends StatelessWidget {
  const WchatAlwzeerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wchatAlwzeer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54),
          secondary: const Color(0xFF25D366),
        ),
        useMaterial3: false,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wchatAlwzeer'),
        backgroundColor: const Color(0xFF075E54),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "دردشات"),
            Tab(text: "الحالة"),
            Tab(text: "المكالمات"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text("الكاميرا")),
          ChatsTab(),
          Center(child: Text("الحالات")),
          Center(child: Text("سجل المكالمات")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.message, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF075E54),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text("مستخدم ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("مرحباً بك في wchatAlwzeer"),
          trailing: const Text("12:00 م", style: TextStyle(color: Colors.grey, fontSize: 12)),
        );
      },
    );
  }
}
