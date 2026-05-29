// lib/screens/tambah_tugas_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/tugas.dart';
import '../utils/app_theme.dart';

class TambahTugasScreen extends StatefulWidget {
  final String kategori;
  const TambahTugasScreen({super.key, required this.kategori});

  @override
  State<TambahTugasScreen> createState() => _TambahTugasScreenState();
}

class _TambahTugasScreenState extends State<TambahTugasScreen> {
  final _judulCtrl    = TextEditingController();
  final _deskripsiCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;

  bool   get isPenting     => widget.kategori == 'penting';
  Color  get kategoriColor => isPenting ? AppTheme.accent : AppTheme.accentGreen;
  String get kategoriLabel => isPenting ? 'PENTING' : 'BIASA';
  String get pageTitle     => isPenting ? 'Tambah Tugas Penting' : 'Tambah Tugas Biasa';
  String get judulHint     => isPenting ? 'Contoh: Submit laporan' : 'Contoh: Beli buah';

  LinearGradient get _gradient => isPenting
      ? const LinearGradient(colors: [Color(0xFFE53935), Color(0xFFEF5350)],
          begin: Alignment.topLeft, end: Alignment.bottomRight)
      : const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
          begin: Alignment.topLeft, end: Alignment.bottomRight);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: kategoriColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _simpan() async {
    if (_judulCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.warning_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Judul tugas tidak boleh kosong.'),
          ]),
          backgroundColor: AppTheme.accentOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final tugas = Tugas(
      judul: _judulCtrl.text.trim(),
      deskripsi: _deskripsiCtrl.text.trim(),
      tanggalJatuhTempo: DateFormat('yyyy-MM-dd').format(_selectedDate),
      kategori: widget.kategori,
      tanggalDibuat: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    await DatabaseHelper.instance.insertTugas(tugas);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Tugas berhasil disimpan!'),
          ]),
          backgroundColor: AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header Gradient ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: _gradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // AppBar manual
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          tooltip: '<< Kembali',
                        ),
                        Text(
                          pageTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPenting
                                    ? Icons.priority_high_rounded
                                    : Icons.task_alt_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                kategoriLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Form ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // Tanggal jatuh tempo
                  const _FieldLabel('TANGGAL JATUH TEMPO'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.cardShadow,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: kategoriColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.calendar_month_rounded,
                                size: 20, color: kategoriColor),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd MMMM yyyy', 'id_ID')
                                .format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Judul tugas
                  const _FieldLabel('JUDUL TUGAS'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _judulCtrl,
                    decoration: InputDecoration(
                      hintText: judulHint,
                      prefixIcon: Icon(Icons.title_rounded,
                          color: kategoriColor, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  const _FieldLabel('DESKRIPSI'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _deskripsiCtrl,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Jelaskan detail tugasmu...',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.notes_rounded,
                            color: AppTheme.primaryLight, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: _gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: kategoriColor.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _loading ? null : _simpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('SIMPAN'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}
