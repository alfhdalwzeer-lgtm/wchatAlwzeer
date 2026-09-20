import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'alwazir_chat.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        receiverId TEXT NOT NULL,
        text TEXT NOT NULL,
        isMe INTEGER NOT NULL DEFAULT 0,
        isRead INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_chat
      ON messages(chatId)
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          phone TEXT NOT NULL UNIQUE,
          createdAt INTEGER NOT NULL
        )
      ''');
    }
  }

  // =========================
  // المستخدمون
  // =========================

  Future<int> createUser({
    required String userId,
    required String name,
    required String phone,
  }) async {
    final db = await database;

    return db.insert(
      'users',
      {
        'userId': userId,
        'name': name,
        'phone': phone,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(
    String userId,
  ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<Map<String, dynamic>?> getUserByPhone(
    String phone,
  ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<List<Map<String, dynamic>>> getAllUsers({
    String? excludeUserId,
  }) async {
    final db = await database;

    if (excludeUserId == null) {
      return db.query(
        'users',
        orderBy: 'createdAt DESC',
      );
    }

    return db.query(
      'users',
      where: 'userId != ?',
      whereArgs: [excludeUserId],
      orderBy: 'createdAt DESC',
    );
  }

  // =========================
  // المحادثات
  // =========================

  String createChatId(
    String user1,
    String user2,
  ) {
    final users = [user1, user2]..sort();
    return '${users[0]}_${users[1]}';
  }

  Future<int> insertMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
    required bool isMe,
    bool isRead = false,
  }) async {
    final db = await database;

    return db.insert(
      'messages',
      {
        'chatId': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'isMe': isMe ? 1 : 0,
        'isRead': isRead ? 1 : 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getMessages(
    String chatId,
  ) async {
    final db = await database;

    return db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'createdAt ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getChatSummaries(
    String currentUserId,
  ) async {
    final db = await database;

    return db.rawQuery('''
      SELECT
        m.chatId,
        m.text,
        m.createdAt,
        m.senderId,
        m.receiverId,
        m.isRead
      FROM messages m
      INNER JOIN (
        SELECT chatId, MAX(createdAt) AS latestTime
        FROM messages
        GROUP BY chatId
      ) latest
      ON m.chatId = latest.chatId
      AND m.createdAt = latest.latestTime
      ORDER BY m.createdAt DESC
    ''');
  }

  Future<void> markMessagesAsRead(
    String chatId,
  ) async {
    final db = await database;

    await db.update(
      'messages',
      {'isRead': 1},
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
  }

  Future<void> clearChat(
    String chatId,
  ) async {
    final db = await database;

    await db.delete(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
  }

  Future<void> clearAllMessages() async {
    final db = await database;

    await db.delete('messages');
  }
}
