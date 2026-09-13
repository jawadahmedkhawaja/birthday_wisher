import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env: $e');
  }

  runApp(const BirthdayApp());
}

// ============================================================
// CONFIGURATION
// ============================================================

class Config {
  static String value(String key, String fallback) {
    if (!dotenv.isInitialized) {
      return fallback;
    }

    final value = dotenv.env[key];

    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }

  static String get myName => value('YOUR_NAME', 'Kh. Naveed');

  static String get herName => value('HER_NAME', 'My Love');

  static String get birthday => value('BIRTHDAY', '2005-09-10');

  static String get greeting =>
      value('BIRTHDAY_GREETING', 'Happy Birthday, My Love ❤️');

  static String get message => value(
    'BIRTHDAY_MESSAGE',
    'Today is a very special day because it is the day '
        'someone incredibly special was born.\n\n'
        'I hope this little surprise makes you smile, because '
        'your smile is one of my favorite things in the world.\n\n'
        'May this new year of your life bring you beautiful '
        'memories, endless happiness, and everything your heart '
        'wishes for.\n\n'
        'You deserve all the love, happiness and beautiful '
        'moments in the world. ❤️',
  );

  static String get passcode {
    final parts = birthday.split('-');

    if (parts.length == 3 &&
        parts[0].length == 4 &&
        parts[1].length == 2 &&
        parts[2].length == 2 &&
        int.tryParse(parts[0]) != null &&
        int.tryParse(parts[1]) != null &&
        int.tryParse(parts[2]) != null) {
      return '${parts[2]}${parts[1]}${parts[0]}';
    }

    return '10092005';
  }
}

// ============================================================
// APP
// ============================================================

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A Little Surprise',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFFFEAF3),
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================
// MAIN SCREEN — 5 PAGES
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;

  late AnimationController backgroundController;

  @override
  void initState() {
    super.initState();

    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    backgroundController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 4) {
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RomanticBackground(controller: backgroundController),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final slideAnimation =
                    Tween<Offset>(
                      begin: const Offset(0.18, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    switch (currentPage) {
      case 0:
        return LockPage(key: const ValueKey('page0'), onUnlocked: nextPage);
      case 1:
        return LetterPage(key: const ValueKey('page1'), onNext: nextPage);
      case 2:
        return MemoriesPage(key: const ValueKey('page2'), onNext: nextPage);
      case 3:
        return ReasonsPage(key: const ValueKey('page3'), onNext: nextPage);
      case 4:
      default:
        return const CakePage(key: ValueKey('page4'));
    }
  }
}

// ============================================================
// ROMANTIC BACKGROUND
// ============================================================

class RomanticBackground extends StatelessWidget {
  final AnimationController controller;

  const RomanticBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final screen = MediaQuery.sizeOf(context);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFEAF4), Color(0xFFF7DDF1), Color(0xFFEBD8F4)],
            ),
          ),
          child: Stack(
            children: List.generate(28, (index) {
              final progress = (controller.value + index / 28) % 1.0;
              final x = ((index * 71) % 100) / 100.0;
              final y = 1.15 - progress * 1.35;
              final size = 8.0 + (index % 5) * 4.0;
              final rotation = math.sin(progress * math.pi * 2) * 0.4;

              return Positioned(
                left: screen.width * x,
                top: screen.height * y,
                child: Opacity(
                  opacity: 0.10 + (index % 3) * 0.04,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Icon(
                      index.isEven ? Icons.favorite : Icons.auto_awesome,
                      size: size,
                      color: index.isEven
                          ? const Color(0xFFD34C96)
                          : const Color(0xFF9C55C7),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD
// ============================================================

class LoveCard extends StatelessWidget {
  final Widget child;

  const LoveCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFE5A6CB), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D3E91).withValues(alpha: .18),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================
// TITLE
// ============================================================

class LoveTitle extends StatelessWidget {
  final String text;
  final double size;

  const LoveTitle(this.text, {super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF762467),
        fontSize: size,
        fontWeight: FontWeight.w900,
        height: 1.18,
      ),
    );
  }
}

// ============================================================
// ROMANTIC BUTTON
// ============================================================

class RomanticButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const RomanticButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF9B3BAE),
    this.icon,
  });

  @override
  State<RomanticButton> createState() => _RomanticButtonState();
}

class _RomanticButtonState extends State<RomanticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: .97,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: controller,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: widget.icon == null
              ? const SizedBox.shrink()
              : Icon(widget.icon),
          label: Text(widget.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            elevation: 8,
            shadowColor: widget.color.withValues(alpha: .35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAGE 1 — PASSCODE
// ============================================================

class LockPage extends StatefulWidget {
  final VoidCallback onUnlocked;

  const LockPage({super.key, required this.onUnlocked});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage>
    with SingleTickerProviderStateMixin {
  String entered = '';
  String error = '';

  late AnimationController heartController;

  @override
  void initState() {
    super.initState();

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    heartController.dispose();
    super.dispose();
  }

  void addDigit(String digit) {
    if (entered.length >= 8) return;

    setState(() {
      error = '';
      entered += digit;
    });

    if (entered.length == 8) {
      Future.delayed(const Duration(milliseconds: 180), unlock);
    }
  }

  void deleteDigit() {
    if (entered.isEmpty) return;

    setState(() {
      entered = entered.substring(0, entered.length - 1);
      error = '';
    });
  }

  void unlock() {
    if (entered == Config.passcode) {
      widget.onUnlocked();
      return;
    }

    setState(() {
      entered = '';
      error = 'Not quite… ❤️';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LoveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1.08).animate(
                  CurvedAnimation(
                    parent: heartController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: const Text('💗', style: TextStyle(fontSize: 78)),
              ),
              const SizedBox(height: 10),
              LoveTitle('A little surprise\nfor ${Config.herName}', size: 27),
              const SizedBox(height: 8),
              const Text(
                'Enter the special date ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9A558C),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              _PasscodeDisplay(length: 8, entered: entered),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: const TextStyle(
                    color: Color(0xFFD04483),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              NumberPad(onNumber: addDigit, onDelete: deleteDigit),
              const SizedBox(height: 20),
              RomanticButton(
                text: 'UNLOCK ❤️',
                icon: Icons.favorite,
                onPressed: unlock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodeDisplay extends StatelessWidget {
  final int length;
  final String entered;

  const _PasscodeDisplay({required this.length, required this.entered});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final active = index < entered.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 30,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF5D9ED) : const Color(0xFFFFF8FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? const Color(0xFFB33F91) : const Color(0xFFD99BC5),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: active
                ? const Text(
                    '♥',
                    key: ValueKey('filled'),
                    style: TextStyle(
                      color: Color(0xFF9B3BAE),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(key: ValueKey('empty')),
          ),
        );
      }),
    );
  }
}

class NumberPad extends StatelessWidget {
  final ValueChanged<String> onNumber;
  final VoidCallback onDelete;

  const NumberPad({super.key, required this.onNumber, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '⌫',
      '0',
      '♥',
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: numbers.map((number) {
        final isDelete = number == '⌫';

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (isDelete) {
              onDelete();
            } else if (number != '♥') {
              onNumber(number);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 61,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF8E8F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC45BA8), width: 1.8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F8D3E87),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: const Color(0xFF79276C),
                fontSize: number == '♥' ? 23 : 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// PAGE 2 — LOVE LETTER
// ============================================================

class LetterPage extends StatefulWidget {
  final VoidCallback onNext;

  const LetterPage({super.key, required this.onNext});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> with TickerProviderStateMixin {
  late AnimationController heartController;
  late AnimationController envelopeController;

  bool opened = false;

  @override
  void initState() {
    super.initState();

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    envelopeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    heartController.dispose();
    envelopeController.dispose();
    super.dispose();
  }

  void openLetter() {
    setState(() {
      opened = true;
    });

    envelopeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LoveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: .95, end: 1.08).animate(
                  CurvedAnimation(
                    parent: heartController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: const Text('💌', style: TextStyle(fontSize: 68)),
              ),
              const SizedBox(height: 8),
              LoveTitle('For ${Config.herName}', size: 30),
              const SizedBox(height: 20),
              if (!opened)
                _ClosedEnvelope(onTap: openLetter)
              else
                _OpenedLetter(),
              const SizedBox(height: 20),
              if (opened)
                RomanticButton(
                  text: 'OUR MEMORIES ✨',
                  icon: Icons.auto_awesome,
                  onPressed: widget.onNext,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClosedEnvelope extends StatelessWidget {
  final VoidCallback onTap;

  const _ClosedEnvelope({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.97, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5C9DE),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFC35B9F), width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 250),
                    painter: EnvelopePainter(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('❤️', style: TextStyle(fontSize: 52)),
                      SizedBox(height: 10),
                      Text(
                        'Tap to open',
                        style: TextStyle(
                          color: Color(0xFF7B286E),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7A8C8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width / 2, 130);
    path.lineTo(size.width, 20);
    canvas.drawPath(path, paint);

    final lower = Path();
    lower.moveTo(0, 230);
    lower.lineTo(size.width * .37, 130);
    lower.moveTo(size.width, 230);
    lower.lineTo(size.width * .63, 130);
    canvas.drawPath(lower, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OpenedLetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 440),
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFE3A0C4), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F9C3E82),
            blurRadius: 15,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            LoveTitle(Config.greeting, size: 25),
            const SizedBox(height: 22),
            Text(
              Config.message,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF40323D),
                fontSize: 17,
                height: 1.65,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'With all my love, ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8B306F),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              Config.myName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8B306F),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NEW PAGE 3 — MEMORIES PAGE
// ============================================================

class MemoriesPage extends StatefulWidget {
  final VoidCallback onNext;

  const MemoriesPage({super.key, required this.onNext});

  @override
  State<MemoriesPage> createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  int memoryIndex = 0;

  final List<Map<String, String>> memories = [
    {
      'emoji': '✨',
      'title': 'The First Time We Met',
      'desc':
          'From the very first second, I knew there was something uniquely magic about you.',
    },
    {
      'emoji': '☕',
      'title': 'Late Night Talks',
      'desc':
          'Hours pass like seconds when I am talking to you. Sharing every thought with you is my favorite thing.',
    },
    {
      'emoji': '🌟',
      'title': 'Making Each Other Laugh',
      'desc':
          'Your laugh is genuine music to my ears. Bringing a smile to your face is my main goal every day.',
    },
    {
      'emoji': '💫',
      'title': 'Every Little Moment',
      'desc':
          'Even the quietest moments feel like grand adventures as long as I am with you.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final current = memories[memoryIndex];

    return Center(
      child: SingleChildScrollView(
        child: LoveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📸', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 8),
              LoveTitle('Sweet Memories 💖', size: 26),
              const SizedBox(height: 6),
              Text(
                'Memory ${memoryIndex + 1} of ${memories.length}',
                style: const TextStyle(
                  color: Color(0xFF9A558C),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Container(
                  key: ValueKey('memory_$memoryIndex'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F7),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFEAA2CE),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        current['emoji']!,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        current['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7B286E),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        current['desc']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF523B4E),
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    onPressed: memoryIndex > 0
                        ? () => setState(() => memoryIndex--)
                        : null,
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF8B306F),
                      backgroundColor: const Color(0xFFF5D9ED),
                    ),
                  ),
                  Row(
                    children: List.generate(memories.length, (idx) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: idx == memoryIndex ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: idx == memoryIndex
                              ? const Color(0xFF9B3BAE)
                              : const Color(0xFFE2B0D5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  IconButton.filledTonal(
                    onPressed: memoryIndex < memories.length - 1
                        ? () => setState(() => memoryIndex++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF8B306F),
                      backgroundColor: const Color(0xFFF5D9ED),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              RomanticButton(
                text: 'WHY I LOVE YOU 💕',
                icon: Icons.favorite_border,
                onPressed: widget.onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// NEW PAGE 4 — REASONS PAGE
// ============================================================

class ReasonsPage extends StatefulWidget {
  final VoidCallback onNext;

  const ReasonsPage({super.key, required this.onNext});

  @override
  State<ReasonsPage> createState() => _ReasonsPageState();
}

class _ReasonsPageState extends State<ReasonsPage> {
  final List<Map<String, String>> reasons = [
    {
      'title': 'Your Kindness',
      'detail': 'You care so deeply about everyone around you.',
    },
    {
      'title': 'Your Warm Smile',
      'detail': 'It instantly brightens up even my darkest days.',
    },
    {
      'title': 'Your Gentle Heart',
      'detail': 'Being around you feels like home, comforting and safe.',
    },
    {
      'title': 'Simply Being You',
      'detail':
          'You do not need to change a thing; you are perfect as you are.',
    },
  ];

  final Set<int> revealed = {};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LoveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💐', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 8),
              LoveTitle('Why You Are Special ✨', size: 26),
              const SizedBox(height: 6),
              const Text(
                'Tap each card to reveal ❤️',
                style: TextStyle(
                  color: Color(0xFF9A558C),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              Column(
                children: List.generate(reasons.length, (index) {
                  final item = reasons[index];
                  final isRevealed = revealed.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isRevealed) {
                          revealed.remove(index);
                        } else {
                          revealed.add(index);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isRevealed
                            ? const Color(0xFFF9E3F3)
                            : const Color(0xFFFFF7FB),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isRevealed
                              ? const Color(0xFFB54BA2)
                              : const Color(0xFFE2B0D5),
                          width: 1.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isRevealed
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: const Color(0xFFB54BA2),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Color(0xFF7B286E),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isRevealed) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    item['detail']!,
                                    style: const TextStyle(
                                      color: Color(0xFF5C4155),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              RomanticButton(
                text: 'MAKE A WISH 🎂',
                icon: Icons.cake,
                onPressed: widget.onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAGE 5 — BIRTHDAY CAKE
// ============================================================

class CakePage extends StatefulWidget {
  const CakePage({super.key});

  @override
  State<CakePage> createState() => _CakePageState();
}

class _CakePageState extends State<CakePage> with TickerProviderStateMixin {
  bool blown = false;

  late AnimationController cakeController;
  late AnimationController heartController;

  @override
  void initState() {
    super.initState();

    cakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    cakeController.dispose();
    heartController.dispose();
    super.dispose();
  }

  void blowCandles() {
    setState(() {
      blown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LoveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: .96, end: 1.06).animate(
                  CurvedAnimation(
                    parent: heartController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: LoveTitle(
                  'Make a wish,\n${Config.herName}! 🎂',
                  size: 27,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                blown
                    ? 'Wish sent with love ✨❤️'
                    : 'Close your eyes and make a wish…',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF995084),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: cakeController,
                builder: (context, child) {
                  final scale =
                      1.0 + math.sin(cakeController.value * math.pi) * .025;

                  return Transform.scale(
                    scale: scale,
                    child: BirthdayCake(blown: blown),
                  );
                },
              ),
              const SizedBox(height: 5),
              RomanticButton(
                text: blown ? 'HAPPY BIRTHDAY ❤️' : 'BLOW THE CANDLES 🕯️',
                icon: blown ? Icons.favorite : Icons.local_fire_department,
                onPressed: blown ? null : blowCandles,
                color: blown
                    ? const Color(0xFFB95C9C)
                    : const Color(0xFF9B3BAE),
              ),
              const SizedBox(height: 18),
              if (blown) const _Celebration(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CAKE
// ============================================================

class BirthdayCake extends StatelessWidget {
  final bool blown;

  const BirthdayCake({super.key, required this.blown});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      width: double.infinity,
      child: CustomPaint(painter: CakePainter(blown: blown)),
    );
  }
}

// ============================================================
// CAKE PAINTER
// ============================================================

class CakePainter extends CustomPainter {
  final bool blown;

  CakePainter({required this.blown});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Plate
    final platePaint = Paint()..color = const Color(0xFFD7A2D9);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * .80),
        width: size.width * .78,
        height: 34,
      ),
      platePaint,
    );

    // Cake body
    final cakeBody = Path();
    cakeBody.moveTo(centerX - size.width * .32, size.height * .43);
    cakeBody.lineTo(centerX - size.width * .29, size.height * .70);
    cakeBody.quadraticBezierTo(
      centerX,
      size.height * .80,
      centerX + size.width * .29,
      size.height * .70,
    );
    cakeBody.lineTo(centerX + size.width * .32, size.height * .43);
    cakeBody.close();

    canvas.drawPath(cakeBody, Paint()..color = const Color(0xFF9B4FBE));

    // Cake top
    final cakeTop = Path();
    cakeTop.moveTo(centerX - size.width * .32, size.height * .43);
    cakeTop.cubicTo(
      centerX - size.width * .28,
      size.height * .23,
      centerX + size.width * .28,
      size.height * .23,
      centerX + size.width * .32,
      size.height * .43,
    );
    cakeTop.cubicTo(
      centerX + size.width * .18,
      size.height * .56,
      centerX - size.width * .18,
      size.height * .56,
      centerX - size.width * .32,
      size.height * .43,
    );
    cakeTop.close();

    canvas.drawPath(cakeTop, Paint()..color = const Color(0xFFC987D9));

    // Cream dots
    final creamPaint = Paint()..color = const Color(0xFFF8E9FF);

    for (int i = 0; i < 13; i++) {
      final angle = math.pi * 2 * i / 13;
      final x = centerX + math.cos(angle) * size.width * .235;
      final y = size.height * .41 + math.sin(angle) * size.height * .085;

      canvas.drawCircle(Offset(x, y), 7, creamPaint);
    }

    // Candles
    for (int i = 0; i < 5; i++) {
      final x = centerX + (i - 2) * 42;
      final top = size.height * .24 + (i.isOdd ? 8 : 0);

      final candlePaint = Paint()..color = Colors.white;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 5, top, 10, 48),
          const Radius.circular(4),
        ),
        candlePaint,
      );

      // Candle stripe
      final stripePaint = Paint()
        ..color = const Color(0xFFE29AC8)
        ..strokeWidth = 3;

      canvas.drawLine(
        Offset(x - 4, top + 10),
        Offset(x + 4, top + 3),
        stripePaint,
      );

      canvas.drawLine(
        Offset(x - 4, top + 25),
        Offset(x + 4, top + 18),
        stripePaint,
      );

      if (blown) {
        final flamePaint = Paint()..color = const Color(0xFFFFA62B);
        final flame = Path();

        flame.moveTo(x, top - 7);
        flame.quadraticBezierTo(x - 9, top - 18, x, top - 29);
        flame.quadraticBezierTo(x + 9, top - 18, x, top - 7);
        flame.close();

        canvas.drawPath(flame, flamePaint);

        // Inner flame
        canvas.drawCircle(
          Offset(x, top - 14),
          3,
          Paint()..color = const Color(0xFFFFE082),
        );
      }
    }

    // Sprinkles
    final sprinklePaint = Paint()..color = const Color(0xFFFFECFF);

    for (int i = 0; i < 18; i++) {
      final x =
          centerX -
          size.width * .24 +
          ((i * 31) % (size.width * .48)).toDouble();

      final y = size.height * .53 + ((i * 19) % 70).toDouble();

      canvas.drawCircle(Offset(x, y), 2.8, sprinklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CakePainter oldDelegate) {
    return oldDelegate.blown != blown;
  }
}

// ============================================================
// CELEBRATION
// ============================================================

class _Celebration extends StatelessWidget {
  const _Celebration();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('🎉 🥳 ✨ 💖 🎁', style: TextStyle(fontSize: 32)),
        SizedBox(height: 8),
        Text(
          'May all your dreams come true today and always!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8B306F),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
