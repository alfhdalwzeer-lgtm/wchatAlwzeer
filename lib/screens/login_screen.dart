import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  String _countryCode = '+967';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _login() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'أدخل رقم الهاتف أولاً',
            textAlign: TextAlign.right,
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'سيتم تسجيل الرقم $_countryCode $phone',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF080B0F),
        body: Stack(
          children: [
            // خلفية داكنة بطابع الفهد
            Positioned.fill(
              child: CustomPaint(
                painter: LeopardBackgroundPainter(),
              ),
            ),

            // طبقة داكنة فوق الخلفية
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.20),
                      const Color(0xFF080B0F).withOpacity(.92),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 42),

                      // شعار الفهد
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF151D24),
                          border: Border.all(
                            color: const Color(0xFFD4AF37),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37)
                                  .withOpacity(.20),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🐆',
                            style: TextStyle(fontSize: 54),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'الفهد',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Al-Wazir Chat',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 48),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'أدخل رقم هاتفك بترميز الدولة للمتابعة',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // رقم الهاتف
                      Row(
                        children: [
                          Container(
                            height: 58,
                            width: 92,
                            decoration: BoxDecoration(
                              color: const Color(0xFF151D24),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF303C46),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _countryCode,
                                dropdownColor: const Color(0xFF18232C),
                                iconEnabledColor:
                                    const Color(0xFFD4AF37),
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: '+967',
                                    child: Text(
                                      '+967',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+966',
                                    child: Text(
                                      '+966',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+971',
                                    child: Text(
                                      '+971',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+20',
                                    child: Text(
                                      '+20',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _countryCode = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFF151D24),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF303C46),
                                ),
                              ),
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'رقم الهاتف',
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // زر الدخول
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor:
                                const Color(0xFFD4AF37).withOpacity(.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'دخول / تسجيل',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'بالضغط على دخول، أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// خلفية زخرفية تعطي إحساس الفهد بدون الحاجة لأي حزمة خارجية.
class LeopardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD4AF37).withOpacity(.035);

    final positions = [
      Offset(size.width * .12, size.height * .16),
      Offset(size.width * .78, size.height * .20),
      Offset(size.width * .25, size.height * .42),
      Offset(size.width * .82, size.height * .48),
      Offset(size.width * .12, size.height * .68),
      Offset(size.width * .72, size.height * .76),
      Offset(size.width * .35, size.height * .88),
    ];

    for (final position in positions) {
      canvas.drawCircle(position, 42, paint);

      final innerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xFFD4AF37).withOpacity(.055);

      canvas.drawCircle(position, 25, innerPaint);
      canvas.drawCircle(
        position.translate(18, -12),
        12,
        innerPaint,
      );
      canvas.drawCircle(
        position.translate(-15, 14),
        10,
        innerPaint,
      );
    }

    final goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFD4AF37).withOpacity(.08);

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .34),
      size.width * .42,
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
