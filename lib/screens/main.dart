import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const WchatAlwzeerApp());
}

class WchatAlwzeerApp extends StatelessWidget {
  const WchatAlwzeerApp({super.key});

  static const gold = Color(0xFFD4AF37);
  static const dark = Color(0xFF0B1015);
  static const navy = Color(0xFF18232C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dark,
        primaryColor: gold,
        fontFamily: 'sans',
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: gold,
          surface: navy,
        ),
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

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ChatsPage(),
    GroupsPage(),
    CallsPage(),
    StatusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1015),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                elevation: 8,
                onPressed: () {},
                child: const Icon(Icons.chat_rounded),
              )
            : null,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF151E26),
        border: Border(
          top: BorderSide(
            color: Color(0xFF28343E),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: NavigationBar(
          height: 68,
          backgroundColor: const Color(0xFF151E26),
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: const Color(0xFFD4AF37),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(
                Icons.chat_bubble,
                color: Colors.black,
              ),
              label: 'الدردشات',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(
                Icons.groups,
                color: Colors.black,
              ),
              label: 'المجموعات',
            ),
            NavigationDestination(
              icon: Icon(Icons.call_outlined),
              selectedIcon: Icon(
                Icons.call,
                color: Colors.black,
              ),
              label: 'المكالمات',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(
                Icons.auto_awesome,
                color: Colors.black,
              ),
              label: 'الحالة',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// الدردشات
// ============================================================

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'مستخدم الفهد',
        'message': 'مرحباً بك في الفهد 🐆',
        'time': '12:45 م',
      },
      {
        'name': 'الفهد',
        'message': 'أهلاً وسهلاً بك',
        'time': '11:30 ص',
      },
      {
        'name': 'الصادق موبايل',
        'message': 'تم إرسال رسالة جديدة',
        'time': '10:15 ص',
      },
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _topBar(
            context,
            title: 'الفهد',
            showSearch: true,
          ),
        ),

        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 12, 14, 16),
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF283640),
                  Color(0xFF11181E),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(.35),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -25,
                  top: -25,
                  child: Icon(
                    Icons.pets,
                    size: 170,
                    color: const Color(0xFFD4AF37).withOpacity(.10),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(22),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الفهد',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'أداء وتميز',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تواصل بسرعة وأمان',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Text(
              'المحادثات',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final chat = chats[index];

              return _chatTile(
                context,
                name: chat['name']!,
                message: chat['message']!,
                time: chat['time']!,
              );
            },
            childCount: chats.length,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// المجموعات
// ============================================================

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _topBar(
            context,
            title: 'المجموعات',
            showSearch: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Icon(
                  Icons.groups_rounded,
                  size: 80,
                  color: const Color(0xFFD4AF37).withOpacity(.8),
                ),
                const SizedBox(height: 20),
                const Text(
                  'المجموعات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'أنشئ مجموعة وابدأ التواصل مع أصدقائك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// المكالمات
// ============================================================

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _topBar(
            context,
            title: 'المكالمات',
            showSearch: false,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Icon(
                  Icons.call_rounded,
                  size: 78,
                  color: const Color(0xFFD4AF37).withOpacity(.8),
                ),
                const SizedBox(height: 20),
                const Text(
                  'لا توجد مكالمات بعد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ستظهر هنا المكالمات الصوتية ومكالمات الفيديو',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// الحالة
// ============================================================

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _topBar(
            context,
            title: 'الحالة',
            showSearch: false,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151E26),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFFD4AF37),
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالتي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'اضغط لإضافة حالة جديدة',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 55),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 65,
                    color: Color(0xFFD4AF37),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'لا توجد حالات بعد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ستظهر تحديثات جهات اتصالك هنا',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// الشريط العلوي
// ============================================================

Widget _topBar(
  BuildContext context, {
  required String title,
  required bool showSearch,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(14, 42, 10, 14),
    decoration: const BoxDecoration(
      color: Color(0xFF1E2A32),
      border: Border(
        bottom: BorderSide(
          color: Color(0xFF293740),
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFFD4AF37),
          ),
          onSelected: (value) {
            if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'profile',
              child: Text('الملف الشخصي'),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Text('الإعدادات'),
            ),
          ],
        ),
        if (showSearch)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Color(0xFFD4AF37),
            ),
          ),
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.pets,
          color: Color(0xFFD4AF37),
          size: 27,
        ),
      ],
    ),
  );
}

// ============================================================
// عنصر المحادثة
// ============================================================

Widget _chatTile(
  BuildContext context, {
  required String name,
  required String message,
  required String time,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(userName: name),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF202A31),
            width: .8,
          ),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 29,
            backgroundColor: Color(0xFFD4AF37),
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.done_all,
                color: Color(0xFF4FC3F7),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
