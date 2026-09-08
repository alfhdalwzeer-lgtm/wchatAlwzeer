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
        children: [
          const Center(child: Text("الكاميرا")),
          const ChatsTab(),
          const Center(child: Text("الحالات")),
          const Center(child: Text("سجل المكالمات")),
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
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF075E54),
            child: Image.asset('crown.png', errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white)),
          ),
          title: Text("مستخدم ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("مرحباً بك في تطبيق wchatAlwzeer"),
          trailing: const Text("12:00 م", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatDetailScreen(userName: "مستخدم ${index + 1}")),
            );
          },
        );
      },
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final String userName;
  const ChatDetailScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(userName),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("أهلاً بك! كيف يمكنني مساعدتك؟"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "اكتب رسالة...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF075E54),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
