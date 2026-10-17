class GenerusModel {
  final String id;
  final String name;
  final String nisn;
  final String kelas;
  final String level; // PAUD, SD, SMP, SMA
  final String gender;
  final String parentName;
  final String parentPhone;
  final String address;

  GenerusModel({
    required this.id,
    required this.name,
    required this.nisn,
    required this.kelas,
    required this.level,
    required this.gender,
    required this.parentName,
    required this.parentPhone,
    required this.address,
  });

  GenerusModel copyWith({
    String? name,
    String? nisn,
    String? kelas,
    String? level,
    String? gender,
    String? parentName,
    String? parentPhone,
    String? address,
  }) {
    return GenerusModel(
      id: id,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      kelas: kelas ?? this.kelas,
      level: level ?? this.level,
      gender: gender ?? this.gender,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      address: address ?? this.address,
    );
  }
}

class PengajarModel {
  final String id;
  final String name;
  final String role;
  final String subject;
  final List<String> classes;
  final String phone;

  PengajarModel({
    required this.id,
    required this.name,
    required this.role,
    required this.subject,
    required this.classes,
    required this.phone,
  });

  PengajarModel copyWith({
    String? name,
    String? role,
    String? subject,
    List<String>? classes,
    String? phone,
  }) {
    return PengajarModel(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      subject: subject ?? this.subject,
      classes: classes ?? this.classes,
      phone: phone ?? this.phone,
    );
  }
}

class KelasModel {
  final String id;
  final String name;
  final String level;
  final String teacherName;
  final int studentCount;

  KelasModel({
    required this.id,
    required this.name,
    required this.level,
    required this.teacherName,
    required this.studentCount,
  });
}

class MateriModel {
  final String id;
  final String title;
  final String category; // Tilawah, Hafalan, Doa, Pegon
  final String summary;
  final String detail;
  final int progress; // 0 - 100

  MateriModel({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.detail,
    required this.progress,
  });
}

class PertemuanModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String status; // Akan Datang, Selesai
  final String description;

  PertemuanModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.description,
  });

  PertemuanModel copyWith({
    String? title,
    String? date,
    String? time,
    String? location,
    String? status,
    String? description,
  }) {
    return PertemuanModel(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}

enum AttendanceStatus { hadir, terlambat, izin, sakit, alpa }

class AbsensiRecord {
  final String generusId;
  final String generusName;
  final String generusKelas;
  AttendanceStatus status;

  AbsensiRecord({
    required this.generusId,
    required this.generusName,
    required this.generusKelas,
    this.status = AttendanceStatus.hadir,
  });
}

class PembinaanModel {
  final String id;
  final String generusName;
  final String date;
  final String category;
  final String notes;
  final String followupAction;
  final String status; // Selesai, Dalam Proses

  PembinaanModel({
    required this.id,
    required this.generusName,
    required this.date,
    required this.category,
    required this.notes,
    required this.followupAction,
    required this.status,
  });

  PembinaanModel copyWith({
    String? generusName,
    String? date,
    String? category,
    String? notes,
    String? followupAction,
    String? status,
  }) {
    return PembinaanModel(
      id: id,
      generusName: generusName ?? this.generusName,
      date: date ?? this.date,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      followupAction: followupAction ?? this.followupAction,
      status: status ?? this.status,
    );
  }
}

class PrestasiModel {
  final String id;
  final String generusName;
  final String title;
  final String category;
  final String level;
  final String date;
  final String documentation;

  PrestasiModel({
    required this.id,
    required this.generusName,
    required this.title,
    required this.category,
    required this.level,
    required this.date,
    required this.documentation,
  });

  PrestasiModel copyWith({
    String? generusName,
    String? title,
    String? category,
    String? level,
    String? date,
    String? documentation,
  }) {
    return PrestasiModel(
      id: id,
      generusName: generusName ?? this.generusName,
      title: title ?? this.title,
      category: category ?? this.category,
      level: level ?? this.level,
      date: date ?? this.date,
      documentation: documentation ?? this.documentation,
    );
  }
}

class LaporanModel {
  final String id;
  final String title;
  final String date;
  final String category;
  final String summary;
  final String status;

  LaporanModel({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    required this.summary,
    required this.status,
  });
}
