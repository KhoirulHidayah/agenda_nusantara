// lib/models/tugas.dart

class Tugas {
  final int? id;
  final String judul;
  final String deskripsi;
  final String tanggalJatuhTempo;
  final String kategori; // 'penting' | 'biasa'
  final bool selesai;
  final String tanggalDibuat;

  Tugas({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggalJatuhTempo,
    required this.kategori,
    this.selesai = false,
    required this.tanggalDibuat,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal_jatuh_tempo': tanggalJatuhTempo,
        'kategori': kategori,
        'selesai': selesai ? 1 : 0,
        'tanggal_dibuat': tanggalDibuat,
      };

  factory Tugas.fromMap(Map<String, dynamic> map) => Tugas(
        id: map['id'],
        judul: map['judul'],
        deskripsi: map['deskripsi'] ?? '',
        tanggalJatuhTempo: map['tanggal_jatuh_tempo'],
        kategori: map['kategori'],
        selesai: map['selesai'] == 1,
        tanggalDibuat: map['tanggal_dibuat'],
      );

  Tugas copyWith({bool? selesai}) => Tugas(
        id: id,
        judul: judul,
        deskripsi: deskripsi,
        tanggalJatuhTempo: tanggalJatuhTempo,
        kategori: kategori,
        selesai: selesai ?? this.selesai,
        tanggalDibuat: tanggalDibuat,
      );
}
