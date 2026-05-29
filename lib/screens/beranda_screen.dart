// lib/screens/beranda_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../utils/app_theme.dart';
import 'tambah_tugas_screen.dart';
import 'daftar_tugas_screen.dart';
import 'pengaturan_screen.dart';
import '../widgets/chart_tugas.dart';

class BerandaScreen extends StatefulWidget {
  final String username;
  const BerandaScreen({super.key, required this.username});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selesai = 0;
  int _belum = 0;
  Map<String, int> _chartData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final stats = await db.getStatistik();
    final chart = await db.getTugasSelesaiPerHari();
    setState(() {
      _selesai = stats['selesai'] ?? 0;
      _belum = stats['belum'] ?? 0;
      _chartData = chart;
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Gradient ───────────────────────────
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.headerGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_greeting,',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.checklist_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Stat cards dalam header
                      Row(
                        children: [
                          _StatCard(
                            label: 'Tugas Selesai',
                            value: _selesai,
                            icon: Icons.check_circle_rounded,
                            color: const Color(0xFF43A047),
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            label: 'Belum Selesai',
                            value: _belum,
                            icon: Icons.pending_actions_rounded,
                            color: const Color(0xFFE53935),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Grafik ───────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: AppTheme.cardShadow,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.bar_chart_rounded,
                                      size: 18, color: AppTheme.primary),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tugas Selesai / Hari',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text('7 hari terakhir  [BONUS]',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 130,
                              child: ChartTugas(data: _chartData),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Label Menu ───────────────────────────
                      const Text(
                        'Menu Utama',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Grid Menu ────────────────────────────
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.1,
                        children: [
                          _NavButton(
                            icon: Icons.priority_high_rounded,
                            label: 'Tambah Tugas Penting',
                            color: AppTheme.accent,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TambahTugasScreen(
                                      kategori: 'penting'),
                                ),
                              );
                              _loadData();
                            },
                          ),
                          _NavButton(
                            icon: Icons.add_task_rounded,
                            label: 'Tambah Tugas Biasa',
                            color: AppTheme.accentGreen,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TambahTugasScreen(
                                      kategori: 'biasa'),
                                ),
                              );
                              _loadData();
                            },
                          ),
                          _NavButton(
                            icon: Icons.format_list_bulleted_rounded,
                            label: 'Daftar Tugas',
                            color: AppTheme.primary,
                            gradient: AppTheme.primaryGradient,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DaftarTugasScreen()),
                              );
                              _loadData();
                            },
                          ),
                          _NavButton(
                            icon: Icons.settings_rounded,
                            label: 'Pengaturan',
                            color: const Color(0xFF546E7A),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF546E7A), Color(0xFF78909C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PengaturanScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nav Button ─────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final LinearGradient gradient;
  final VoidCallback onTap;
  const _NavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
