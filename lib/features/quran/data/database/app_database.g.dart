// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTranslatedMeta = const VerificationMeta(
    'nameTranslated',
  );
  @override
  late final GeneratedColumn<String> nameTranslated = GeneratedColumn<String>(
    'name_translated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahCountMeta = const VerificationMeta(
    'ayahCount',
  );
  @override
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
    'ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revelationTypeMeta = const VerificationMeta(
    'revelationType',
  );
  @override
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
    'revelation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    number,
    nameArabic,
    nameEnglish,
    nameTranslated,
    ayahCount,
    revelationType,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Surah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('name_translated')) {
      context.handle(
        _nameTranslatedMeta,
        nameTranslated.isAcceptableOrUnknown(
          data['name_translated']!,
          _nameTranslatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameTranslatedMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(
        _ayahCountMeta,
        ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
        _revelationTypeMeta,
        revelationType.isAcceptableOrUnknown(
          data['revelation_type']!,
          _revelationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      nameTranslated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_translated'],
      )!,
      ayahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_count'],
      )!,
      revelationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revelation_type'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslated;
  final int ayahCount;
  final String revelationType;
  final int displayOrder;
  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslated,
    required this.ayahCount,
    required this.revelationType,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['name_english'] = Variable<String>(nameEnglish);
    map['name_translated'] = Variable<String>(nameTranslated);
    map['ayah_count'] = Variable<int>(ayahCount);
    map['revelation_type'] = Variable<String>(revelationType);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      number: Value(number),
      nameArabic: Value(nameArabic),
      nameEnglish: Value(nameEnglish),
      nameTranslated: Value(nameTranslated),
      ayahCount: Value(ayahCount),
      revelationType: Value(revelationType),
      displayOrder: Value(displayOrder),
    );
  }

  factory Surah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      number: serializer.fromJson<int>(json['number']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      nameTranslated: serializer.fromJson<String>(json['nameTranslated']),
      ayahCount: serializer.fromJson<int>(json['ayahCount']),
      revelationType: serializer.fromJson<String>(json['revelationType']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'nameTranslated': serializer.toJson<String>(nameTranslated),
      'ayahCount': serializer.toJson<int>(ayahCount),
      'revelationType': serializer.toJson<String>(revelationType),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Surah copyWith({
    int? number,
    String? nameArabic,
    String? nameEnglish,
    String? nameTranslated,
    int? ayahCount,
    String? revelationType,
    int? displayOrder,
  }) => Surah(
    number: number ?? this.number,
    nameArabic: nameArabic ?? this.nameArabic,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    nameTranslated: nameTranslated ?? this.nameTranslated,
    ayahCount: ayahCount ?? this.ayahCount,
    revelationType: revelationType ?? this.revelationType,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      number: data.number.present ? data.number.value : this.number,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      nameTranslated: data.nameTranslated.present
          ? data.nameTranslated.value
          : this.nameTranslated,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
      revelationType: data.revelationType.present
          ? data.revelationType.value
          : this.revelationType,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('nameTranslated: $nameTranslated, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('revelationType: $revelationType, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    number,
    nameArabic,
    nameEnglish,
    nameTranslated,
    ayahCount,
    revelationType,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.number == this.number &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.nameTranslated == this.nameTranslated &&
          other.ayahCount == this.ayahCount &&
          other.revelationType == this.revelationType &&
          other.displayOrder == this.displayOrder);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> number;
  final Value<String> nameArabic;
  final Value<String> nameEnglish;
  final Value<String> nameTranslated;
  final Value<int> ayahCount;
  final Value<String> revelationType;
  final Value<int> displayOrder;
  const SurahsCompanion({
    this.number = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.nameTranslated = const Value.absent(),
    this.ayahCount = const Value.absent(),
    this.revelationType = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.number = const Value.absent(),
    required String nameArabic,
    required String nameEnglish,
    required String nameTranslated,
    required int ayahCount,
    required String revelationType,
    required int displayOrder,
  }) : nameArabic = Value(nameArabic),
       nameEnglish = Value(nameEnglish),
       nameTranslated = Value(nameTranslated),
       ayahCount = Value(ayahCount),
       revelationType = Value(revelationType),
       displayOrder = Value(displayOrder);
  static Insertable<Surah> custom({
    Expression<int>? number,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<String>? nameTranslated,
    Expression<int>? ayahCount,
    Expression<String>? revelationType,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (nameTranslated != null) 'name_translated': nameTranslated,
      if (ayahCount != null) 'ayah_count': ayahCount,
      if (revelationType != null) 'revelation_type': revelationType,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? number,
    Value<String>? nameArabic,
    Value<String>? nameEnglish,
    Value<String>? nameTranslated,
    Value<int>? ayahCount,
    Value<String>? revelationType,
    Value<int>? displayOrder,
  }) {
    return SurahsCompanion(
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameTranslated: nameTranslated ?? this.nameTranslated,
      ayahCount: ayahCount ?? this.ayahCount,
      revelationType: revelationType ?? this.revelationType,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (nameTranslated.present) {
      map['name_translated'] = Variable<String>(nameTranslated.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('nameTranslated: $nameTranslated, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('revelationType: $revelationType, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _globalAyahNumberMeta = const VerificationMeta(
    'globalAyahNumber',
  );
  @override
  late final GeneratedColumn<int> globalAyahNumber = GeneratedColumn<int>(
    'global_ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textArabicMeta = const VerificationMeta(
    'textArabic',
  );
  @override
  late final GeneratedColumn<String> textArabic = GeneratedColumn<String>(
    'text_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textTranslationMeta = const VerificationMeta(
    'textTranslation',
  );
  @override
  late final GeneratedColumn<String> textTranslation = GeneratedColumn<String>(
    'text_translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  @override
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
    'juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hizbQuarterMeta = const VerificationMeta(
    'hizbQuarter',
  );
  @override
  late final GeneratedColumn<int> hizbQuarter = GeneratedColumn<int>(
    'hizb_quarter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rukuMeta = const VerificationMeta('ruku');
  @override
  late final GeneratedColumn<int> ruku = GeneratedColumn<int>(
    'ruku',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sajdaMeta = const VerificationMeta('sajda');
  @override
  late final GeneratedColumn<bool> sajda = GeneratedColumn<bool>(
    'sajda',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sajda" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    globalAyahNumber,
    textArabic,
    textTranslation,
    page,
    juz,
    hizbQuarter,
    ruku,
    sajda,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ayah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('global_ayah_number')) {
      context.handle(
        _globalAyahNumberMeta,
        globalAyahNumber.isAcceptableOrUnknown(
          data['global_ayah_number']!,
          _globalAyahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_globalAyahNumberMeta);
    }
    if (data.containsKey('text_arabic')) {
      context.handle(
        _textArabicMeta,
        textArabic.isAcceptableOrUnknown(data['text_arabic']!, _textArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_textArabicMeta);
    }
    if (data.containsKey('text_translation')) {
      context.handle(
        _textTranslationMeta,
        textTranslation.isAcceptableOrUnknown(
          data['text_translation']!,
          _textTranslationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textTranslationMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('juz')) {
      context.handle(
        _juzMeta,
        juz.isAcceptableOrUnknown(data['juz']!, _juzMeta),
      );
    } else if (isInserting) {
      context.missing(_juzMeta);
    }
    if (data.containsKey('hizb_quarter')) {
      context.handle(
        _hizbQuarterMeta,
        hizbQuarter.isAcceptableOrUnknown(
          data['hizb_quarter']!,
          _hizbQuarterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hizbQuarterMeta);
    }
    if (data.containsKey('ruku')) {
      context.handle(
        _rukuMeta,
        ruku.isAcceptableOrUnknown(data['ruku']!, _rukuMeta),
      );
    } else if (isInserting) {
      context.missing(_rukuMeta);
    }
    if (data.containsKey('sajda')) {
      context.handle(
        _sajdaMeta,
        sajda.isAcceptableOrUnknown(data['sajda']!, _sajdaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      globalAyahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}global_ayah_number'],
      )!,
      textArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_arabic'],
      )!,
      textTranslation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_translation'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      juz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}juz'],
      )!,
      hizbQuarter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hizb_quarter'],
      )!,
      ruku: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruku'],
      )!,
      sajda: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sajda'],
      )!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final int globalAyahNumber;
  final String textArabic;
  final String textTranslation;
  final int page;
  final int juz;
  final int hizbQuarter;
  final int ruku;
  final bool sajda;
  const Ayah({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.globalAyahNumber,
    required this.textArabic,
    required this.textTranslation,
    required this.page,
    required this.juz,
    required this.hizbQuarter,
    required this.ruku,
    required this.sajda,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['global_ayah_number'] = Variable<int>(globalAyahNumber);
    map['text_arabic'] = Variable<String>(textArabic);
    map['text_translation'] = Variable<String>(textTranslation);
    map['page'] = Variable<int>(page);
    map['juz'] = Variable<int>(juz);
    map['hizb_quarter'] = Variable<int>(hizbQuarter);
    map['ruku'] = Variable<int>(ruku);
    map['sajda'] = Variable<bool>(sajda);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      globalAyahNumber: Value(globalAyahNumber),
      textArabic: Value(textArabic),
      textTranslation: Value(textTranslation),
      page: Value(page),
      juz: Value(juz),
      hizbQuarter: Value(hizbQuarter),
      ruku: Value(ruku),
      sajda: Value(sajda),
    );
  }

  factory Ayah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      globalAyahNumber: serializer.fromJson<int>(json['globalAyahNumber']),
      textArabic: serializer.fromJson<String>(json['textArabic']),
      textTranslation: serializer.fromJson<String>(json['textTranslation']),
      page: serializer.fromJson<int>(json['page']),
      juz: serializer.fromJson<int>(json['juz']),
      hizbQuarter: serializer.fromJson<int>(json['hizbQuarter']),
      ruku: serializer.fromJson<int>(json['ruku']),
      sajda: serializer.fromJson<bool>(json['sajda']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'globalAyahNumber': serializer.toJson<int>(globalAyahNumber),
      'textArabic': serializer.toJson<String>(textArabic),
      'textTranslation': serializer.toJson<String>(textTranslation),
      'page': serializer.toJson<int>(page),
      'juz': serializer.toJson<int>(juz),
      'hizbQuarter': serializer.toJson<int>(hizbQuarter),
      'ruku': serializer.toJson<int>(ruku),
      'sajda': serializer.toJson<bool>(sajda),
    };
  }

  Ayah copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    int? globalAyahNumber,
    String? textArabic,
    String? textTranslation,
    int? page,
    int? juz,
    int? hizbQuarter,
    int? ruku,
    bool? sajda,
  }) => Ayah(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    globalAyahNumber: globalAyahNumber ?? this.globalAyahNumber,
    textArabic: textArabic ?? this.textArabic,
    textTranslation: textTranslation ?? this.textTranslation,
    page: page ?? this.page,
    juz: juz ?? this.juz,
    hizbQuarter: hizbQuarter ?? this.hizbQuarter,
    ruku: ruku ?? this.ruku,
    sajda: sajda ?? this.sajda,
  );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      globalAyahNumber: data.globalAyahNumber.present
          ? data.globalAyahNumber.value
          : this.globalAyahNumber,
      textArabic: data.textArabic.present
          ? data.textArabic.value
          : this.textArabic,
      textTranslation: data.textTranslation.present
          ? data.textTranslation.value
          : this.textTranslation,
      page: data.page.present ? data.page.value : this.page,
      juz: data.juz.present ? data.juz.value : this.juz,
      hizbQuarter: data.hizbQuarter.present
          ? data.hizbQuarter.value
          : this.hizbQuarter,
      ruku: data.ruku.present ? data.ruku.value : this.ruku,
      sajda: data.sajda.present ? data.sajda.value : this.sajda,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('globalAyahNumber: $globalAyahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('textTranslation: $textTranslation, ')
          ..write('page: $page, ')
          ..write('juz: $juz, ')
          ..write('hizbQuarter: $hizbQuarter, ')
          ..write('ruku: $ruku, ')
          ..write('sajda: $sajda')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahNumber,
    ayahNumber,
    globalAyahNumber,
    textArabic,
    textTranslation,
    page,
    juz,
    hizbQuarter,
    ruku,
    sajda,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.globalAyahNumber == this.globalAyahNumber &&
          other.textArabic == this.textArabic &&
          other.textTranslation == this.textTranslation &&
          other.page == this.page &&
          other.juz == this.juz &&
          other.hizbQuarter == this.hizbQuarter &&
          other.ruku == this.ruku &&
          other.sajda == this.sajda);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<int> globalAyahNumber;
  final Value<String> textArabic;
  final Value<String> textTranslation;
  final Value<int> page;
  final Value<int> juz;
  final Value<int> hizbQuarter;
  final Value<int> ruku;
  final Value<bool> sajda;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.globalAyahNumber = const Value.absent(),
    this.textArabic = const Value.absent(),
    this.textTranslation = const Value.absent(),
    this.page = const Value.absent(),
    this.juz = const Value.absent(),
    this.hizbQuarter = const Value.absent(),
    this.ruku = const Value.absent(),
    this.sajda = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required int globalAyahNumber,
    required String textArabic,
    required String textTranslation,
    required int page,
    required int juz,
    required int hizbQuarter,
    required int ruku,
    this.sajda = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       globalAyahNumber = Value(globalAyahNumber),
       textArabic = Value(textArabic),
       textTranslation = Value(textTranslation),
       page = Value(page),
       juz = Value(juz),
       hizbQuarter = Value(hizbQuarter),
       ruku = Value(ruku);
  static Insertable<Ayah> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<int>? globalAyahNumber,
    Expression<String>? textArabic,
    Expression<String>? textTranslation,
    Expression<int>? page,
    Expression<int>? juz,
    Expression<int>? hizbQuarter,
    Expression<int>? ruku,
    Expression<bool>? sajda,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (globalAyahNumber != null) 'global_ayah_number': globalAyahNumber,
      if (textArabic != null) 'text_arabic': textArabic,
      if (textTranslation != null) 'text_translation': textTranslation,
      if (page != null) 'page': page,
      if (juz != null) 'juz': juz,
      if (hizbQuarter != null) 'hizb_quarter': hizbQuarter,
      if (ruku != null) 'ruku': ruku,
      if (sajda != null) 'sajda': sajda,
    });
  }

  AyahsCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<int>? globalAyahNumber,
    Value<String>? textArabic,
    Value<String>? textTranslation,
    Value<int>? page,
    Value<int>? juz,
    Value<int>? hizbQuarter,
    Value<int>? ruku,
    Value<bool>? sajda,
  }) {
    return AyahsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      globalAyahNumber: globalAyahNumber ?? this.globalAyahNumber,
      textArabic: textArabic ?? this.textArabic,
      textTranslation: textTranslation ?? this.textTranslation,
      page: page ?? this.page,
      juz: juz ?? this.juz,
      hizbQuarter: hizbQuarter ?? this.hizbQuarter,
      ruku: ruku ?? this.ruku,
      sajda: sajda ?? this.sajda,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (globalAyahNumber.present) {
      map['global_ayah_number'] = Variable<int>(globalAyahNumber.value);
    }
    if (textArabic.present) {
      map['text_arabic'] = Variable<String>(textArabic.value);
    }
    if (textTranslation.present) {
      map['text_translation'] = Variable<String>(textTranslation.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (hizbQuarter.present) {
      map['hizb_quarter'] = Variable<int>(hizbQuarter.value);
    }
    if (ruku.present) {
      map['ruku'] = Variable<int>(ruku.value);
    }
    if (sajda.present) {
      map['sajda'] = Variable<bool>(sajda.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('globalAyahNumber: $globalAyahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('textTranslation: $textTranslation, ')
          ..write('page: $page, ')
          ..write('juz: $juz, ')
          ..write('hizbQuarter: $hizbQuarter, ')
          ..write('ruku: $ruku, ')
          ..write('sajda: $sajda')
          ..write(')'))
        .toString();
  }
}

class $QuranSyncStateTableTable extends QuranSyncStateTable
    with TableInfo<$QuranSyncStateTableTable, QuranSyncStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranSyncStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedSurahsMeta = const VerificationMeta(
    'completedSurahs',
  );
  @override
  late final GeneratedColumn<int> completedSurahs = GeneratedColumn<int>(
    'completed_surahs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textEditionMeta = const VerificationMeta(
    'textEdition',
  );
  @override
  late final GeneratedColumn<String> textEdition = GeneratedColumn<String>(
    'text_edition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translationEditionMeta =
      const VerificationMeta('translationEdition');
  @override
  late final GeneratedColumn<String> translationEdition =
      GeneratedColumn<String>(
        'translation_edition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    completedSurahs,
    lastError,
    syncedAt,
    textEdition,
    translationEdition,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_sync_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranSyncStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('completed_surahs')) {
      context.handle(
        _completedSurahsMeta,
        completedSurahs.isAcceptableOrUnknown(
          data['completed_surahs']!,
          _completedSurahsMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('text_edition')) {
      context.handle(
        _textEditionMeta,
        textEdition.isAcceptableOrUnknown(
          data['text_edition']!,
          _textEditionMeta,
        ),
      );
    }
    if (data.containsKey('translation_edition')) {
      context.handle(
        _translationEditionMeta,
        translationEdition.isAcceptableOrUnknown(
          data['translation_edition']!,
          _translationEditionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranSyncStateTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranSyncStateTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      completedSurahs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_surahs'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      textEdition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_edition'],
      ),
      translationEdition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_edition'],
      ),
    );
  }

  @override
  $QuranSyncStateTableTable createAlias(String alias) {
    return $QuranSyncStateTableTable(attachedDatabase, alias);
  }
}

class QuranSyncStateTableData extends DataClass
    implements Insertable<QuranSyncStateTableData> {
  final int id;
  final String status;
  final int completedSurahs;
  final String? lastError;
  final DateTime? syncedAt;
  final String? textEdition;
  final String? translationEdition;
  const QuranSyncStateTableData({
    required this.id,
    required this.status,
    required this.completedSurahs,
    this.lastError,
    this.syncedAt,
    this.textEdition,
    this.translationEdition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['status'] = Variable<String>(status);
    map['completed_surahs'] = Variable<int>(completedSurahs);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || textEdition != null) {
      map['text_edition'] = Variable<String>(textEdition);
    }
    if (!nullToAbsent || translationEdition != null) {
      map['translation_edition'] = Variable<String>(translationEdition);
    }
    return map;
  }

  QuranSyncStateTableCompanion toCompanion(bool nullToAbsent) {
    return QuranSyncStateTableCompanion(
      id: Value(id),
      status: Value(status),
      completedSurahs: Value(completedSurahs),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      textEdition: textEdition == null && nullToAbsent
          ? const Value.absent()
          : Value(textEdition),
      translationEdition: translationEdition == null && nullToAbsent
          ? const Value.absent()
          : Value(translationEdition),
    );
  }

  factory QuranSyncStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranSyncStateTableData(
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      completedSurahs: serializer.fromJson<int>(json['completedSurahs']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      textEdition: serializer.fromJson<String?>(json['textEdition']),
      translationEdition: serializer.fromJson<String?>(
        json['translationEdition'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<String>(status),
      'completedSurahs': serializer.toJson<int>(completedSurahs),
      'lastError': serializer.toJson<String?>(lastError),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'textEdition': serializer.toJson<String?>(textEdition),
      'translationEdition': serializer.toJson<String?>(translationEdition),
    };
  }

  QuranSyncStateTableData copyWith({
    int? id,
    String? status,
    int? completedSurahs,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> textEdition = const Value.absent(),
    Value<String?> translationEdition = const Value.absent(),
  }) => QuranSyncStateTableData(
    id: id ?? this.id,
    status: status ?? this.status,
    completedSurahs: completedSurahs ?? this.completedSurahs,
    lastError: lastError.present ? lastError.value : this.lastError,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    textEdition: textEdition.present ? textEdition.value : this.textEdition,
    translationEdition: translationEdition.present
        ? translationEdition.value
        : this.translationEdition,
  );
  QuranSyncStateTableData copyWithCompanion(QuranSyncStateTableCompanion data) {
    return QuranSyncStateTableData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      completedSurahs: data.completedSurahs.present
          ? data.completedSurahs.value
          : this.completedSurahs,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      textEdition: data.textEdition.present
          ? data.textEdition.value
          : this.textEdition,
      translationEdition: data.translationEdition.present
          ? data.translationEdition.value
          : this.translationEdition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranSyncStateTableData(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('completedSurahs: $completedSurahs, ')
          ..write('lastError: $lastError, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('textEdition: $textEdition, ')
          ..write('translationEdition: $translationEdition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    completedSurahs,
    lastError,
    syncedAt,
    textEdition,
    translationEdition,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranSyncStateTableData &&
          other.id == this.id &&
          other.status == this.status &&
          other.completedSurahs == this.completedSurahs &&
          other.lastError == this.lastError &&
          other.syncedAt == this.syncedAt &&
          other.textEdition == this.textEdition &&
          other.translationEdition == this.translationEdition);
}

class QuranSyncStateTableCompanion
    extends UpdateCompanion<QuranSyncStateTableData> {
  final Value<int> id;
  final Value<String> status;
  final Value<int> completedSurahs;
  final Value<String?> lastError;
  final Value<DateTime?> syncedAt;
  final Value<String?> textEdition;
  final Value<String?> translationEdition;
  const QuranSyncStateTableCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.completedSurahs = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.textEdition = const Value.absent(),
    this.translationEdition = const Value.absent(),
  });
  QuranSyncStateTableCompanion.insert({
    this.id = const Value.absent(),
    required String status,
    this.completedSurahs = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.textEdition = const Value.absent(),
    this.translationEdition = const Value.absent(),
  }) : status = Value(status);
  static Insertable<QuranSyncStateTableData> custom({
    Expression<int>? id,
    Expression<String>? status,
    Expression<int>? completedSurahs,
    Expression<String>? lastError,
    Expression<DateTime>? syncedAt,
    Expression<String>? textEdition,
    Expression<String>? translationEdition,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (completedSurahs != null) 'completed_surahs': completedSurahs,
      if (lastError != null) 'last_error': lastError,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (textEdition != null) 'text_edition': textEdition,
      if (translationEdition != null) 'translation_edition': translationEdition,
    });
  }

  QuranSyncStateTableCompanion copyWith({
    Value<int>? id,
    Value<String>? status,
    Value<int>? completedSurahs,
    Value<String?>? lastError,
    Value<DateTime?>? syncedAt,
    Value<String?>? textEdition,
    Value<String?>? translationEdition,
  }) {
    return QuranSyncStateTableCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      completedSurahs: completedSurahs ?? this.completedSurahs,
      lastError: lastError ?? this.lastError,
      syncedAt: syncedAt ?? this.syncedAt,
      textEdition: textEdition ?? this.textEdition,
      translationEdition: translationEdition ?? this.translationEdition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedSurahs.present) {
      map['completed_surahs'] = Variable<int>(completedSurahs.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (textEdition.present) {
      map['text_edition'] = Variable<String>(textEdition.value);
    }
    if (translationEdition.present) {
      map['translation_edition'] = Variable<String>(translationEdition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranSyncStateTableCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('completedSurahs: $completedSurahs, ')
          ..write('lastError: $lastError, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('textEdition: $textEdition, ')
          ..write('translationEdition: $translationEdition')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $QuranSyncStateTableTable quranSyncStateTable =
      $QuranSyncStateTableTable(this);
  late final Index ayahsSurahAyahIdx = Index(
    'ayahs_surah_ayah_idx',
    'CREATE UNIQUE INDEX ayahs_surah_ayah_idx ON ayahs (surah_number, ayah_number)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surahs,
    ayahs,
    quranSyncStateTable,
    ayahsSurahAyahIdx,
  ];
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> number,
      required String nameArabic,
      required String nameEnglish,
      required String nameTranslated,
      required int ayahCount,
      required String revelationType,
      required int displayOrder,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> number,
      Value<String> nameArabic,
      Value<String> nameEnglish,
      Value<String> nameTranslated,
      Value<int> ayahCount,
      Value<String> revelationType,
      Value<int> displayOrder,
    });

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTranslated => $composableBuilder(
    column: $table.nameTranslated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTranslated => $composableBuilder(
    column: $table.nameTranslated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameTranslated => $composableBuilder(
    column: $table.nameTranslated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => column);

  GeneratedColumn<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahsTable,
          Surah,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
          Surah,
          PrefetchHooks Function()
        > {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> number = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<String> nameTranslated = const Value.absent(),
                Value<int> ayahCount = const Value.absent(),
                Value<String> revelationType = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => SurahsCompanion(
                number: number,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                nameTranslated: nameTranslated,
                ayahCount: ayahCount,
                revelationType: revelationType,
                displayOrder: displayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> number = const Value.absent(),
                required String nameArabic,
                required String nameEnglish,
                required String nameTranslated,
                required int ayahCount,
                required String revelationType,
                required int displayOrder,
              }) => SurahsCompanion.insert(
                number: number,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                nameTranslated: nameTranslated,
                ayahCount: ayahCount,
                revelationType: revelationType,
                displayOrder: displayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahsTable,
      Surah,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
      Surah,
      PrefetchHooks Function()
    >;
typedef $$AyahsTableCreateCompanionBuilder =
    AyahsCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      required int globalAyahNumber,
      required String textArabic,
      required String textTranslation,
      required int page,
      required int juz,
      required int hizbQuarter,
      required int ruku,
      Value<bool> sajda,
    });
typedef $$AyahsTableUpdateCompanionBuilder =
    AyahsCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<int> globalAyahNumber,
      Value<String> textArabic,
      Value<String> textTranslation,
      Value<int> page,
      Value<int> juz,
      Value<int> hizbQuarter,
      Value<int> ruku,
      Value<bool> sajda,
    });

class $$AyahsTableFilterComposer extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get globalAyahNumber => $composableBuilder(
    column: $table.globalAyahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textArabic => $composableBuilder(
    column: $table.textArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textTranslation => $composableBuilder(
    column: $table.textTranslation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hizbQuarter => $composableBuilder(
    column: $table.hizbQuarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ruku => $composableBuilder(
    column: $table.ruku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sajda => $composableBuilder(
    column: $table.sajda,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AyahsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get globalAyahNumber => $composableBuilder(
    column: $table.globalAyahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textArabic => $composableBuilder(
    column: $table.textArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textTranslation => $composableBuilder(
    column: $table.textTranslation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hizbQuarter => $composableBuilder(
    column: $table.hizbQuarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ruku => $composableBuilder(
    column: $table.ruku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sajda => $composableBuilder(
    column: $table.sajda,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get globalAyahNumber => $composableBuilder(
    column: $table.globalAyahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textArabic => $composableBuilder(
    column: $table.textArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textTranslation => $composableBuilder(
    column: $table.textTranslation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get hizbQuarter => $composableBuilder(
    column: $table.hizbQuarter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ruku =>
      $composableBuilder(column: $table.ruku, builder: (column) => column);

  GeneratedColumn<bool> get sajda =>
      $composableBuilder(column: $table.sajda, builder: (column) => column);
}

class $$AyahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AyahsTable,
          Ayah,
          $$AyahsTableFilterComposer,
          $$AyahsTableOrderingComposer,
          $$AyahsTableAnnotationComposer,
          $$AyahsTableCreateCompanionBuilder,
          $$AyahsTableUpdateCompanionBuilder,
          (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
          Ayah,
          PrefetchHooks Function()
        > {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<int> globalAyahNumber = const Value.absent(),
                Value<String> textArabic = const Value.absent(),
                Value<String> textTranslation = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> juz = const Value.absent(),
                Value<int> hizbQuarter = const Value.absent(),
                Value<int> ruku = const Value.absent(),
                Value<bool> sajda = const Value.absent(),
              }) => AyahsCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                globalAyahNumber: globalAyahNumber,
                textArabic: textArabic,
                textTranslation: textTranslation,
                page: page,
                juz: juz,
                hizbQuarter: hizbQuarter,
                ruku: ruku,
                sajda: sajda,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                required int globalAyahNumber,
                required String textArabic,
                required String textTranslation,
                required int page,
                required int juz,
                required int hizbQuarter,
                required int ruku,
                Value<bool> sajda = const Value.absent(),
              }) => AyahsCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                globalAyahNumber: globalAyahNumber,
                textArabic: textArabic,
                textTranslation: textTranslation,
                page: page,
                juz: juz,
                hizbQuarter: hizbQuarter,
                ruku: ruku,
                sajda: sajda,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AyahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AyahsTable,
      Ayah,
      $$AyahsTableFilterComposer,
      $$AyahsTableOrderingComposer,
      $$AyahsTableAnnotationComposer,
      $$AyahsTableCreateCompanionBuilder,
      $$AyahsTableUpdateCompanionBuilder,
      (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
      Ayah,
      PrefetchHooks Function()
    >;
typedef $$QuranSyncStateTableTableCreateCompanionBuilder =
    QuranSyncStateTableCompanion Function({
      Value<int> id,
      required String status,
      Value<int> completedSurahs,
      Value<String?> lastError,
      Value<DateTime?> syncedAt,
      Value<String?> textEdition,
      Value<String?> translationEdition,
    });
typedef $$QuranSyncStateTableTableUpdateCompanionBuilder =
    QuranSyncStateTableCompanion Function({
      Value<int> id,
      Value<String> status,
      Value<int> completedSurahs,
      Value<String?> lastError,
      Value<DateTime?> syncedAt,
      Value<String?> textEdition,
      Value<String?> translationEdition,
    });

class $$QuranSyncStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuranSyncStateTableTable> {
  $$QuranSyncStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedSurahs => $composableBuilder(
    column: $table.completedSurahs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textEdition => $composableBuilder(
    column: $table.textEdition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationEdition => $composableBuilder(
    column: $table.translationEdition,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuranSyncStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuranSyncStateTableTable> {
  $$QuranSyncStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedSurahs => $composableBuilder(
    column: $table.completedSurahs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textEdition => $composableBuilder(
    column: $table.textEdition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationEdition => $composableBuilder(
    column: $table.translationEdition,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuranSyncStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuranSyncStateTableTable> {
  $$QuranSyncStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get completedSurahs => $composableBuilder(
    column: $table.completedSurahs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get textEdition => $composableBuilder(
    column: $table.textEdition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationEdition => $composableBuilder(
    column: $table.translationEdition,
    builder: (column) => column,
  );
}

class $$QuranSyncStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranSyncStateTableTable,
          QuranSyncStateTableData,
          $$QuranSyncStateTableTableFilterComposer,
          $$QuranSyncStateTableTableOrderingComposer,
          $$QuranSyncStateTableTableAnnotationComposer,
          $$QuranSyncStateTableTableCreateCompanionBuilder,
          $$QuranSyncStateTableTableUpdateCompanionBuilder,
          (
            QuranSyncStateTableData,
            BaseReferences<
              _$AppDatabase,
              $QuranSyncStateTableTable,
              QuranSyncStateTableData
            >,
          ),
          QuranSyncStateTableData,
          PrefetchHooks Function()
        > {
  $$QuranSyncStateTableTableTableManager(
    _$AppDatabase db,
    $QuranSyncStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranSyncStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranSyncStateTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuranSyncStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> completedSurahs = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> textEdition = const Value.absent(),
                Value<String?> translationEdition = const Value.absent(),
              }) => QuranSyncStateTableCompanion(
                id: id,
                status: status,
                completedSurahs: completedSurahs,
                lastError: lastError,
                syncedAt: syncedAt,
                textEdition: textEdition,
                translationEdition: translationEdition,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String status,
                Value<int> completedSurahs = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> textEdition = const Value.absent(),
                Value<String?> translationEdition = const Value.absent(),
              }) => QuranSyncStateTableCompanion.insert(
                id: id,
                status: status,
                completedSurahs: completedSurahs,
                lastError: lastError,
                syncedAt: syncedAt,
                textEdition: textEdition,
                translationEdition: translationEdition,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranSyncStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranSyncStateTableTable,
      QuranSyncStateTableData,
      $$QuranSyncStateTableTableFilterComposer,
      $$QuranSyncStateTableTableOrderingComposer,
      $$QuranSyncStateTableTableAnnotationComposer,
      $$QuranSyncStateTableTableCreateCompanionBuilder,
      $$QuranSyncStateTableTableUpdateCompanionBuilder,
      (
        QuranSyncStateTableData,
        BaseReferences<
          _$AppDatabase,
          $QuranSyncStateTableTable,
          QuranSyncStateTableData
        >,
      ),
      QuranSyncStateTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$QuranSyncStateTableTableTableManager get quranSyncStateTable =>
      $$QuranSyncStateTableTableTableManager(_db, _db.quranSyncStateTable);
}
