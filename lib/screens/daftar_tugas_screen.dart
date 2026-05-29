// lib/screens/daftar_tugas_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/tugas.dart';
import '../utils/app_theme.dart';

class DaftarTugasScreen extends StatefulWidget {
  const DaftarTugasScreen({super.key});

  @override
  State<DaftarTugasScreen> createState() => _DaftarTugasScreenState();
}

class _DaftarTugasScreenState extends State<DaftarTugasScreen> {
  List<Tugas> _tugas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final list = await DatabaseHelper.instance.getAllTugas();
    setState(() { _tugas = list; _loading = false; });
  }

  Future<void> _toggleSelesai(Tugas t) async {
    await DatabaseHelper.instance.updateSelesai(t.id!, !t.selesai);
    _loadTugas();
  }

  @override
  Widget build(BuildContext context) {
    final selesai = _tugas.where((t) => t.selesai).length;
    final total   = _tugas.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Daftar Tugas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$total tugas',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),

                  // Progress bar
                  if (total > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$selesai dari $total tugas selesai',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              Text(
                                '${(selesai / total * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: selesai / total,
                              backgroundColor: Colors.white.withOpacity(0.25),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── List ─────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary))
                : _tugas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.inbox_rounded,
                                  size: 40, color: AppTheme.primaryLight),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada tugas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tambah tugas dari halaman Beranda.',
                              style: TextStyle(
                                  fontSize: 13, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _tugas.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final t = _tugas[i];
                          final isPenting = t.kategori == 'penting';
                          final arrowColor =
                              isPenting ? AppTheme.accent : AppTheme.accentGreen;

                          String tanggal = t.tanggalJatuhTempo;
                          try {
                            final d = DateTime.parse(t.tanggalJatuhTempo);
                            tanggal = DateFormat('dd MMM yyyy', 'id_ID').format(d);
                          } catch (_) {}

                          return GestureDetector(
                            onTap: () => _toggleSelesai(t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: t.selesai
                                    ? const Color(0xFFF0FDF4)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: t.selesai
                                      ? AppTheme.accentGreen.withOpacity(0.3)
                                      : AppTheme.divider,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppTheme.cardShadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Checkbox
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: t.selesai
                                          ? AppTheme.accentGreen
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: t.selesai
                                            ? AppTheme.accentGreen
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: t.selesai
                                        ? const Icon(Icons.check_rounded,
                                            size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.judul,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: t.selesai
                                                ? AppTheme.textSecondary
                                                : AppTheme.textPrimary,
                                            decoration: t.selesai
                                                ? TextDecoration.lineThrough
                                                : null,
                                            decorationColor:
                                                AppTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            // Badge kategori
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: arrowColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                isPenting ? 'Penting' : 'Biasa',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: arrowColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(Icons.calendar_today_rounded,
                                                size: 11,
                                                color: AppTheme.textSecondary),
                                            const SizedBox(width: 3),
                                            Text(
                                              tanggal,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Arrow
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: arrowColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.play_arrow_rounded,
                                        color: arrowColor, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
