// lib/screens/pengaturan_screen.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  final _passLamaCtrl = TextEditingController();
  final _passBaruCtrl = TextEditingController();
  bool _obscureLama   = true;
  bool _obscureBaru   = true;
  String? _pesan;
  bool _pesanBerhasil = false;

  Future<void> _simpanPassword() async {
    final db     = DatabaseHelper.instance;
    final passDb = await db.getPengaturan('password');

    if (_passLamaCtrl.text != passDb) {
      setState(() { _pesan = 'Password saat ini salah.'; _pesanBerhasil = false; });
      return;
    }
    if (_passBaruCtrl.text.trim().isEmpty) {
      setState(() { _pesan = 'Password baru tidak boleh kosong.'; _pesanBerhasil = false; });
      return;
    }

    await db.setPengaturan('password', _passBaruCtrl.text);
    setState(() { _pesan = 'Password berhasil diperbarui!'; _pesanBerhasil = true; });
    _passLamaCtrl.clear();
    _passBaruCtrl.clear();
  }

  @override
  void dispose() {
    _passLamaCtrl.dispose();
    _passBaruCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // ── Ganti Password Card ──────────────────────
                  _sectionCard(
                    icon: Icons.lock_rounded,
                    title: 'Ganti Password',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('PASSWORD SAAT INI'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passLamaCtrl,
                          obscureText: _obscureLama,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password saat ini',
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppTheme.primaryLight, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureLama
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: AppTheme.textSecondary,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureLama = !_obscureLama),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _FieldLabel('PASSWORD BARU'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passBaruCtrl,
                          obscureText: _obscureBaru,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password baru',
                            prefixIcon: const Icon(Icons.lock_open_rounded,
                                color: AppTheme.primaryLight, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureBaru
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: AppTheme.textSecondary,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureBaru = !_obscureBaru),
                            ),
                          ),
                        ),

                        // Pesan feedback
                        if (_pesan != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  (_pesanBerhasil
                                          ? AppTheme.accentGreen
                                          : AppTheme.accent)
                                      .withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (_pesanBerhasil
                                        ? AppTheme.accentGreen
                                        : AppTheme.accent)
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _pesanBerhasil
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.error_outline_rounded,
                                  color: _pesanBerhasil
                                      ? AppTheme.accentGreen
                                      : AppTheme.accent,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _pesan!,
                                  style: TextStyle(
                                    color: _pesanBerhasil
                                        ? AppTheme.accentGreen
                                        : AppTheme.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _simpanPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('SIMPAN PASSWORD'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Developer Card ───────────────────────────
                  _sectionCard(
                    icon: Icons.badge_rounded,
                    title: 'Developer',
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/foto_developer.jpg',
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KHOIRUL HIDAYAH',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'NIM: 2241760021',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              _DevBadge(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Logout ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('KELUAR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accent,
                        side: const BorderSide(color: AppTheme.accent, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
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

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
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
                child: Icon(icon, size: 18, color: AppTheme.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.divider),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DevBadge extends StatelessWidget {
  const _DevBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'DEVELOPER APLIKASI',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
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
