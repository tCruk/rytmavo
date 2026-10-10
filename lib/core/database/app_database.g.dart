// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ShiftTypesTable extends ShiftTypes
    with TableInfo<$ShiftTypesTable, ShiftTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    abbreviation,
    kind,
    color,
    startMinutes,
    endMinutes,
    sortOrder,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      ),
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShiftTypesTable createAlias(String alias) {
    return $ShiftTypesTable(attachedDatabase, alias);
  }
}

class ShiftTypeRow extends DataClass implements Insertable<ShiftTypeRow> {
  final String id;
  final String name;
  final String abbreviation;

  /// `early | late | night | off | custom` – see `ShiftKind` in the domain.
  final String kind;
  final int color;
  final int? startMinutes;
  final int? endMinutes;
  final int sortOrder;
  final bool isArchived;
  final DateTime createdAt;
  const ShiftTypeRow({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.kind,
    required this.color,
    this.startMinutes,
    this.endMinutes,
    required this.sortOrder,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['kind'] = Variable<String>(kind);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || startMinutes != null) {
      map['start_minutes'] = Variable<int>(startMinutes);
    }
    if (!nullToAbsent || endMinutes != null) {
      map['end_minutes'] = Variable<int>(endMinutes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShiftTypesCompanion toCompanion(bool nullToAbsent) {
    return ShiftTypesCompanion(
      id: Value(id),
      name: Value(name),
      abbreviation: Value(abbreviation),
      kind: Value(kind),
      color: Value(color),
      startMinutes: startMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinutes),
      endMinutes: endMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinutes),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory ShiftTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftTypeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      kind: serializer.fromJson<String>(json['kind']),
      color: serializer.fromJson<int>(json['color']),
      startMinutes: serializer.fromJson<int?>(json['startMinutes']),
      endMinutes: serializer.fromJson<int?>(json['endMinutes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'kind': serializer.toJson<String>(kind),
      'color': serializer.toJson<int>(color),
      'startMinutes': serializer.toJson<int?>(startMinutes),
      'endMinutes': serializer.toJson<int?>(endMinutes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShiftTypeRow copyWith({
    String? id,
    String? name,
    String? abbreviation,
    String? kind,
    int? color,
    Value<int?> startMinutes = const Value.absent(),
    Value<int?> endMinutes = const Value.absent(),
    int? sortOrder,
    bool? isArchived,
    DateTime? createdAt,
  }) => ShiftTypeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    abbreviation: abbreviation ?? this.abbreviation,
    kind: kind ?? this.kind,
    color: color ?? this.color,
    startMinutes: startMinutes.present ? startMinutes.value : this.startMinutes,
    endMinutes: endMinutes.present ? endMinutes.value : this.endMinutes,
    sortOrder: sortOrder ?? this.sortOrder,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  ShiftTypeRow copyWithCompanion(ShiftTypesCompanion data) {
    return ShiftTypeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      kind: data.kind.present ? data.kind.value : this.kind,
      color: data.color.present ? data.color.value : this.color,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftTypeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('kind: $kind, ')
          ..write('color: $color, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    abbreviation,
    kind,
    color,
    startMinutes,
    endMinutes,
    sortOrder,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftTypeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.kind == this.kind &&
          other.color == this.color &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class ShiftTypesCompanion extends UpdateCompanion<ShiftTypeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<String> kind;
  final Value<int> color;
  final Value<int?> startMinutes;
  final Value<int?> endMinutes;
  final Value<int> sortOrder;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShiftTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.kind = const Value.absent(),
    this.color = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftTypesCompanion.insert({
    required String id,
    required String name,
    required String abbreviation,
    required String kind,
    required int color,
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    required int sortOrder,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       abbreviation = Value(abbreviation),
       kind = Value(kind),
       color = Value(color),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt);
  static Insertable<ShiftTypeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? kind,
    Expression<int>? color,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? sortOrder,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (kind != null) 'kind': kind,
      if (color != null) 'color': color,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? abbreviation,
    Value<String>? kind,
    Value<int>? color,
    Value<int?>? startMinutes,
    Value<int?>? endMinutes,
    Value<int>? sortOrder,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShiftTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      kind: kind ?? this.kind,
      color: color ?? this.color,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('kind: $kind, ')
          ..write('color: $color, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RotationPatternsTable extends RotationPatterns
    with TableInfo<$RotationPatternsTable, RotationPatternRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RotationPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotsJsonMeta = const VerificationMeta(
    'slotsJson',
  );
  @override
  late final GeneratedColumn<String> slotsJson = GeneratedColumn<String>(
    'slots_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    validFrom,
    anchorDate,
    slotsJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rotation_patterns';
  @override
  VerificationContext validateIntegrity(
    Insertable<RotationPatternRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('slots_json')) {
      context.handle(
        _slotsJsonMeta,
        slotsJson.isAcceptableOrUnknown(data['slots_json']!, _slotsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_slotsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RotationPatternRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RotationPatternRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      )!,
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_date'],
      )!,
      slotsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slots_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RotationPatternsTable createAlias(String alias) {
    return $RotationPatternsTable(attachedDatabase, alias);
  }
}

class RotationPatternRow extends DataClass
    implements Insertable<RotationPatternRow> {
  final String id;

  /// ISO date `YYYY-MM-DD` from which this version applies (inclusive).
  final String validFrom;

  /// ISO date at which `slots[0]` applies; positions repeat modulo length.
  final String anchorDate;

  /// JSON array of shift type ids, e.g. `["early","early","late",...]`.
  final String slotsJson;
  final DateTime createdAt;
  const RotationPatternRow({
    required this.id,
    required this.validFrom,
    required this.anchorDate,
    required this.slotsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['valid_from'] = Variable<String>(validFrom);
    map['anchor_date'] = Variable<String>(anchorDate);
    map['slots_json'] = Variable<String>(slotsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RotationPatternsCompanion toCompanion(bool nullToAbsent) {
    return RotationPatternsCompanion(
      id: Value(id),
      validFrom: Value(validFrom),
      anchorDate: Value(anchorDate),
      slotsJson: Value(slotsJson),
      createdAt: Value(createdAt),
    );
  }

  factory RotationPatternRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RotationPatternRow(
      id: serializer.fromJson<String>(json['id']),
      validFrom: serializer.fromJson<String>(json['validFrom']),
      anchorDate: serializer.fromJson<String>(json['anchorDate']),
      slotsJson: serializer.fromJson<String>(json['slotsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'validFrom': serializer.toJson<String>(validFrom),
      'anchorDate': serializer.toJson<String>(anchorDate),
      'slotsJson': serializer.toJson<String>(slotsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RotationPatternRow copyWith({
    String? id,
    String? validFrom,
    String? anchorDate,
    String? slotsJson,
    DateTime? createdAt,
  }) => RotationPatternRow(
    id: id ?? this.id,
    validFrom: validFrom ?? this.validFrom,
    anchorDate: anchorDate ?? this.anchorDate,
    slotsJson: slotsJson ?? this.slotsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  RotationPatternRow copyWithCompanion(RotationPatternsCompanion data) {
    return RotationPatternRow(
      id: data.id.present ? data.id.value : this.id,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      slotsJson: data.slotsJson.present ? data.slotsJson.value : this.slotsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RotationPatternRow(')
          ..write('id: $id, ')
          ..write('validFrom: $validFrom, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, validFrom, anchorDate, slotsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RotationPatternRow &&
          other.id == this.id &&
          other.validFrom == this.validFrom &&
          other.anchorDate == this.anchorDate &&
          other.slotsJson == this.slotsJson &&
          other.createdAt == this.createdAt);
}

class RotationPatternsCompanion extends UpdateCompanion<RotationPatternRow> {
  final Value<String> id;
  final Value<String> validFrom;
  final Value<String> anchorDate;
  final Value<String> slotsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RotationPatternsCompanion({
    this.id = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.slotsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RotationPatternsCompanion.insert({
    required String id,
    required String validFrom,
    required String anchorDate,
    required String slotsJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       validFrom = Value(validFrom),
       anchorDate = Value(anchorDate),
       slotsJson = Value(slotsJson),
       createdAt = Value(createdAt);
  static Insertable<RotationPatternRow> custom({
    Expression<String>? id,
    Expression<String>? validFrom,
    Expression<String>? anchorDate,
    Expression<String>? slotsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (validFrom != null) 'valid_from': validFrom,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (slotsJson != null) 'slots_json': slotsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RotationPatternsCompanion copyWith({
    Value<String>? id,
    Value<String>? validFrom,
    Value<String>? anchorDate,
    Value<String>? slotsJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RotationPatternsCompanion(
      id: id ?? this.id,
      validFrom: validFrom ?? this.validFrom,
      anchorDate: anchorDate ?? this.anchorDate,
      slotsJson: slotsJson ?? this.slotsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (slotsJson.present) {
      map['slots_json'] = Variable<String>(slotsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RotationPatternsCompanion(')
          ..write('id: $id, ')
          ..write('validFrom: $validFrom, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftOverridesTable extends ShiftOverrides
    with TableInfo<$ShiftOverridesTable, ShiftOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftTypeIdMeta = const VerificationMeta(
    'shiftTypeId',
  );
  @override
  late final GeneratedColumn<String> shiftTypeId = GeneratedColumn<String>(
    'shift_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_types (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, shiftTypeId, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('shift_type_id')) {
      context.handle(
        _shiftTypeIdMeta,
        shiftTypeId.isAcceptableOrUnknown(
          data['shift_type_id']!,
          _shiftTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shiftTypeIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  ShiftOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftOverrideRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      shiftTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_type_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShiftOverridesTable createAlias(String alias) {
    return $ShiftOverridesTable(attachedDatabase, alias);
  }
}

class ShiftOverrideRow extends DataClass
    implements Insertable<ShiftOverrideRow> {
  /// ISO date, one override per day.
  final String date;
  final String shiftTypeId;
  final String? note;
  final DateTime createdAt;
  const ShiftOverrideRow({
    required this.date,
    required this.shiftTypeId,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['shift_type_id'] = Variable<String>(shiftTypeId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShiftOverridesCompanion toCompanion(bool nullToAbsent) {
    return ShiftOverridesCompanion(
      date: Value(date),
      shiftTypeId: Value(shiftTypeId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory ShiftOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftOverrideRow(
      date: serializer.fromJson<String>(json['date']),
      shiftTypeId: serializer.fromJson<String>(json['shiftTypeId']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'shiftTypeId': serializer.toJson<String>(shiftTypeId),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShiftOverrideRow copyWith({
    String? date,
    String? shiftTypeId,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => ShiftOverrideRow(
    date: date ?? this.date,
    shiftTypeId: shiftTypeId ?? this.shiftTypeId,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  ShiftOverrideRow copyWithCompanion(ShiftOverridesCompanion data) {
    return ShiftOverrideRow(
      date: data.date.present ? data.date.value : this.date,
      shiftTypeId: data.shiftTypeId.present
          ? data.shiftTypeId.value
          : this.shiftTypeId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftOverrideRow(')
          ..write('date: $date, ')
          ..write('shiftTypeId: $shiftTypeId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, shiftTypeId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftOverrideRow &&
          other.date == this.date &&
          other.shiftTypeId == this.shiftTypeId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ShiftOverridesCompanion extends UpdateCompanion<ShiftOverrideRow> {
  final Value<String> date;
  final Value<String> shiftTypeId;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShiftOverridesCompanion({
    this.date = const Value.absent(),
    this.shiftTypeId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftOverridesCompanion.insert({
    required String date,
    required String shiftTypeId,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       shiftTypeId = Value(shiftTypeId),
       createdAt = Value(createdAt);
  static Insertable<ShiftOverrideRow> custom({
    Expression<String>? date,
    Expression<String>? shiftTypeId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (shiftTypeId != null) 'shift_type_id': shiftTypeId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftOverridesCompanion copyWith({
    Value<String>? date,
    Value<String>? shiftTypeId,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShiftOverridesCompanion(
      date: date ?? this.date,
      shiftTypeId: shiftTypeId ?? this.shiftTypeId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (shiftTypeId.present) {
      map['shift_type_id'] = Variable<String>(shiftTypeId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftOverridesCompanion(')
          ..write('date: $date, ')
          ..write('shiftTypeId: $shiftTypeId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdOnMeta = const VerificationMeta(
    'createdOn',
  );
  @override
  late final GeneratedColumn<String> createdOn = GeneratedColumn<String>(
    'created_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedOnMeta = const VerificationMeta(
    'archivedOn',
  );
  @override
  late final GeneratedColumn<String> archivedOn = GeneratedColumn<String>(
    'archived_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    iconKey,
    color,
    createdOn,
    archivedOn,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(
        _createdOnMeta,
        createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta),
      );
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('archived_on')) {
      context.handle(
        _archivedOnMeta,
        archivedOn.isAcceptableOrUnknown(data['archived_on']!, _archivedOnMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      createdOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_on'],
      )!,
      archivedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archived_on'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final String id;
  final String name;
  final String? description;

  /// Key into the app's icon catalogue (domain-level string, not IconData).
  final String iconKey;
  final int color;

  /// ISO date of creation; the habit is never due before this day.
  final String createdOn;

  /// ISO date from which the habit is archived (inclusive), or null.
  final String? archivedOn;
  final int sortOrder;
  const HabitRow({
    required this.id,
    required this.name,
    this.description,
    required this.iconKey,
    required this.color,
    required this.createdOn,
    this.archivedOn,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['color'] = Variable<int>(color);
    map['created_on'] = Variable<String>(createdOn);
    if (!nullToAbsent || archivedOn != null) {
      map['archived_on'] = Variable<String>(archivedOn);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconKey: Value(iconKey),
      color: Value(color),
      createdOn: Value(createdOn),
      archivedOn: archivedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedOn),
      sortOrder: Value(sortOrder),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      color: serializer.fromJson<int>(json['color']),
      createdOn: serializer.fromJson<String>(json['createdOn']),
      archivedOn: serializer.fromJson<String?>(json['archivedOn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'iconKey': serializer.toJson<String>(iconKey),
      'color': serializer.toJson<int>(color),
      'createdOn': serializer.toJson<String>(createdOn),
      'archivedOn': serializer.toJson<String?>(archivedOn),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  HabitRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? iconKey,
    int? color,
    String? createdOn,
    Value<String?> archivedOn = const Value.absent(),
    int? sortOrder,
  }) => HabitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    iconKey: iconKey ?? this.iconKey,
    color: color ?? this.color,
    createdOn: createdOn ?? this.createdOn,
    archivedOn: archivedOn.present ? archivedOn.value : this.archivedOn,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      color: data.color.present ? data.color.value : this.color,
      createdOn: data.createdOn.present ? data.createdOn.value : this.createdOn,
      archivedOn: data.archivedOn.present
          ? data.archivedOn.value
          : this.archivedOn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('createdOn: $createdOn, ')
          ..write('archivedOn: $archivedOn, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    iconKey,
    color,
    createdOn,
    archivedOn,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconKey == this.iconKey &&
          other.color == this.color &&
          other.createdOn == this.createdOn &&
          other.archivedOn == this.archivedOn &&
          other.sortOrder == this.sortOrder);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> iconKey;
  final Value<int> color;
  final Value<String> createdOn;
  final Value<String?> archivedOn;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.color = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.archivedOn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String iconKey,
    required int color,
    required String createdOn,
    this.archivedOn = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       iconKey = Value(iconKey),
       color = Value(color),
       createdOn = Value(createdOn),
       sortOrder = Value(sortOrder);
  static Insertable<HabitRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconKey,
    Expression<int>? color,
    Expression<String>? createdOn,
    Expression<String>? archivedOn,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconKey != null) 'icon_key': iconKey,
      if (color != null) 'color': color,
      if (createdOn != null) 'created_on': createdOn,
      if (archivedOn != null) 'archived_on': archivedOn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? iconKey,
    Value<int>? color,
    Value<String>? createdOn,
    Value<String?>? archivedOn,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      createdOn: createdOn ?? this.createdOn,
      archivedOn: archivedOn ?? this.archivedOn,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<String>(createdOn.value);
    }
    if (archivedOn.present) {
      map['archived_on'] = Variable<String>(archivedOn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('createdOn: $createdOn, ')
          ..write('archivedOn: $archivedOn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitRulesTable extends HabitRules
    with TableInfo<$HabitRulesTable, HabitRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetShiftTypeIdsJsonMeta =
      const VerificationMeta('targetShiftTypeIdsJson');
  @override
  late final GeneratedColumn<String> targetShiftTypeIdsJson =
      GeneratedColumn<String>(
        'target_shift_type_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weekdaysJsonMeta = const VerificationMeta(
    'weekdaysJson',
  );
  @override
  late final GeneratedColumn<String> weekdaysJson = GeneratedColumn<String>(
    'weekdays_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindersJsonMeta = const VerificationMeta(
    'remindersJson',
  );
  @override
  late final GeneratedColumn<String> remindersJson = GeneratedColumn<String>(
    'reminders_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    validFrom,
    targetShiftTypeIdsJson,
    weekdaysJson,
    remindersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('target_shift_type_ids_json')) {
      context.handle(
        _targetShiftTypeIdsJsonMeta,
        targetShiftTypeIdsJson.isAcceptableOrUnknown(
          data['target_shift_type_ids_json']!,
          _targetShiftTypeIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetShiftTypeIdsJsonMeta);
    }
    if (data.containsKey('weekdays_json')) {
      context.handle(
        _weekdaysJsonMeta,
        weekdaysJson.isAcceptableOrUnknown(
          data['weekdays_json']!,
          _weekdaysJsonMeta,
        ),
      );
    }
    if (data.containsKey('reminders_json')) {
      context.handle(
        _remindersJsonMeta,
        remindersJson.isAcceptableOrUnknown(
          data['reminders_json']!,
          _remindersJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      )!,
      targetShiftTypeIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_shift_type_ids_json'],
      )!,
      weekdaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays_json'],
      ),
      remindersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminders_json'],
      ),
    );
  }

  @override
  $HabitRulesTable createAlias(String alias) {
    return $HabitRulesTable(attachedDatabase, alias);
  }
}

class HabitRuleRow extends DataClass implements Insertable<HabitRuleRow> {
  final String id;
  final String habitId;
  final String validFrom;

  /// JSON array of shift type ids; empty array = due on every shift.
  final String targetShiftTypeIdsJson;

  /// JSON array of ISO weekdays (1 = Monday … 7 = Sunday) or null = any.
  final String? weekdaysJson;

  /// JSON object `{ "<shiftTypeId>": "HH:mm" }` or null = no reminders.
  final String? remindersJson;
  const HabitRuleRow({
    required this.id,
    required this.habitId,
    required this.validFrom,
    required this.targetShiftTypeIdsJson,
    this.weekdaysJson,
    this.remindersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['valid_from'] = Variable<String>(validFrom);
    map['target_shift_type_ids_json'] = Variable<String>(
      targetShiftTypeIdsJson,
    );
    if (!nullToAbsent || weekdaysJson != null) {
      map['weekdays_json'] = Variable<String>(weekdaysJson);
    }
    if (!nullToAbsent || remindersJson != null) {
      map['reminders_json'] = Variable<String>(remindersJson);
    }
    return map;
  }

  HabitRulesCompanion toCompanion(bool nullToAbsent) {
    return HabitRulesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      validFrom: Value(validFrom),
      targetShiftTypeIdsJson: Value(targetShiftTypeIdsJson),
      weekdaysJson: weekdaysJson == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdaysJson),
      remindersJson: remindersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(remindersJson),
    );
  }

  factory HabitRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRuleRow(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      validFrom: serializer.fromJson<String>(json['validFrom']),
      targetShiftTypeIdsJson: serializer.fromJson<String>(
        json['targetShiftTypeIdsJson'],
      ),
      weekdaysJson: serializer.fromJson<String?>(json['weekdaysJson']),
      remindersJson: serializer.fromJson<String?>(json['remindersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'validFrom': serializer.toJson<String>(validFrom),
      'targetShiftTypeIdsJson': serializer.toJson<String>(
        targetShiftTypeIdsJson,
      ),
      'weekdaysJson': serializer.toJson<String?>(weekdaysJson),
      'remindersJson': serializer.toJson<String?>(remindersJson),
    };
  }

  HabitRuleRow copyWith({
    String? id,
    String? habitId,
    String? validFrom,
    String? targetShiftTypeIdsJson,
    Value<String?> weekdaysJson = const Value.absent(),
    Value<String?> remindersJson = const Value.absent(),
  }) => HabitRuleRow(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    validFrom: validFrom ?? this.validFrom,
    targetShiftTypeIdsJson:
        targetShiftTypeIdsJson ?? this.targetShiftTypeIdsJson,
    weekdaysJson: weekdaysJson.present ? weekdaysJson.value : this.weekdaysJson,
    remindersJson: remindersJson.present
        ? remindersJson.value
        : this.remindersJson,
  );
  HabitRuleRow copyWithCompanion(HabitRulesCompanion data) {
    return HabitRuleRow(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      targetShiftTypeIdsJson: data.targetShiftTypeIdsJson.present
          ? data.targetShiftTypeIdsJson.value
          : this.targetShiftTypeIdsJson,
      weekdaysJson: data.weekdaysJson.present
          ? data.weekdaysJson.value
          : this.weekdaysJson,
      remindersJson: data.remindersJson.present
          ? data.remindersJson.value
          : this.remindersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRuleRow(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('validFrom: $validFrom, ')
          ..write('targetShiftTypeIdsJson: $targetShiftTypeIdsJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('remindersJson: $remindersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    validFrom,
    targetShiftTypeIdsJson,
    weekdaysJson,
    remindersJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRuleRow &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.validFrom == this.validFrom &&
          other.targetShiftTypeIdsJson == this.targetShiftTypeIdsJson &&
          other.weekdaysJson == this.weekdaysJson &&
          other.remindersJson == this.remindersJson);
}

class HabitRulesCompanion extends UpdateCompanion<HabitRuleRow> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> validFrom;
  final Value<String> targetShiftTypeIdsJson;
  final Value<String?> weekdaysJson;
  final Value<String?> remindersJson;
  final Value<int> rowid;
  const HabitRulesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.targetShiftTypeIdsJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.remindersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitRulesCompanion.insert({
    required String id,
    required String habitId,
    required String validFrom,
    required String targetShiftTypeIdsJson,
    this.weekdaysJson = const Value.absent(),
    this.remindersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       validFrom = Value(validFrom),
       targetShiftTypeIdsJson = Value(targetShiftTypeIdsJson);
  static Insertable<HabitRuleRow> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? validFrom,
    Expression<String>? targetShiftTypeIdsJson,
    Expression<String>? weekdaysJson,
    Expression<String>? remindersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (validFrom != null) 'valid_from': validFrom,
      if (targetShiftTypeIdsJson != null)
        'target_shift_type_ids_json': targetShiftTypeIdsJson,
      if (weekdaysJson != null) 'weekdays_json': weekdaysJson,
      if (remindersJson != null) 'reminders_json': remindersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? validFrom,
    Value<String>? targetShiftTypeIdsJson,
    Value<String?>? weekdaysJson,
    Value<String?>? remindersJson,
    Value<int>? rowid,
  }) {
    return HabitRulesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      validFrom: validFrom ?? this.validFrom,
      targetShiftTypeIdsJson:
          targetShiftTypeIdsJson ?? this.targetShiftTypeIdsJson,
      weekdaysJson: weekdaysJson ?? this.weekdaysJson,
      remindersJson: remindersJson ?? this.remindersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (targetShiftTypeIdsJson.present) {
      map['target_shift_type_ids_json'] = Variable<String>(
        targetShiftTypeIdsJson.value,
      );
    }
    if (weekdaysJson.present) {
      map['weekdays_json'] = Variable<String>(weekdaysJson.value);
    }
    if (remindersJson.present) {
      map['reminders_json'] = Variable<String>(remindersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitRulesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('validFrom: $validFrom, ')
          ..write('targetShiftTypeIdsJson: $targetShiftTypeIdsJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('remindersJson: $remindersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [habitId, date, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, date};
  @override
  HabitCompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletionRow(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $HabitCompletionsTable createAlias(String alias) {
    return $HabitCompletionsTable(attachedDatabase, alias);
  }
}

class HabitCompletionRow extends DataClass
    implements Insertable<HabitCompletionRow> {
  final String habitId;
  final String date;
  final DateTime completedAt;
  const HabitCompletionRow({
    required this.habitId,
    required this.date,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<String>(date);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      habitId: Value(habitId),
      date: Value(date),
      completedAt: Value(completedAt),
    );
  }

  factory HabitCompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletionRow(
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<String>(json['date']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<String>(date),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  HabitCompletionRow copyWith({
    String? habitId,
    String? date,
    DateTime? completedAt,
  }) => HabitCompletionRow(
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    completedAt: completedAt ?? this.completedAt,
  );
  HabitCompletionRow copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletionRow(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionRow(')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, date, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletionRow &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.completedAt == this.completedAt);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletionRow> {
  final Value<String> habitId;
  final Value<String> date;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const HabitCompletionsCompanion({
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    required String habitId,
    required String date,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       completedAt = Value(completedAt);
  static Insertable<HabitCompletionRow> custom({
    Expression<String>? habitId,
    Expression<String>? date,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCompletionsCompanion copyWith({
    Value<String>? habitId,
    Value<String>? date,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return HabitCompletionsCompanion(
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingsEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsEntryRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingsEntryRow extends DataClass
    implements Insertable<SettingsEntryRow> {
  final String key;
  final String value;
  const SettingsEntryRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory SettingsEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsEntryRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsEntryRow copyWith({String? key, String? value}) =>
      SettingsEntryRow(key: key ?? this.key, value: value ?? this.value);
  SettingsEntryRow copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsEntryRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntryRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntryRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsEntryRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingsEntryRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShiftTypesTable shiftTypes = $ShiftTypesTable(this);
  late final $RotationPatternsTable rotationPatterns = $RotationPatternsTable(
    this,
  );
  late final $ShiftOverridesTable shiftOverrides = $ShiftOverridesTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitRulesTable habitRules = $HabitRulesTable(this);
  late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(
    this,
  );
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shiftTypes,
    rotationPatterns,
    shiftOverrides,
    habits,
    habitRules,
    habitCompletions,
    settingsEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_rules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_completions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ShiftTypesTableCreateCompanionBuilder = ShiftTypesCompanion Function({
  required String id,
  required String name,
  required String abbreviation,
  required String kind,
  required int color,
  Value<int?> startMinutes,
  Value<int?> endMinutes,
  required int sortOrder,
  Value<bool> isArchived,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ShiftTypesTableUpdateCompanionBuilder = ShiftTypesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> abbreviation,
  Value<String> kind,
  Value<int> color,
  Value<int?> startMinutes,
  Value<int?> endMinutes,
  Value<int> sortOrder,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ShiftTypesTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftTypesTable, ShiftTypeRow> {
  $$ShiftTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftOverridesTable, List<ShiftOverrideRow>>
  _shiftOverridesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shiftOverrides,
    aliasName: 'shift_types__id__shift_overrides__shift_type_id',
  );

  $$ShiftOverridesTableProcessedTableManager get shiftOverridesRefs {
    final manager = $$ShiftOverridesTableTableManager(
      $_db,
      $_db.shiftOverrides,
    ).filter((f) => f.shiftTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftOverridesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftTypesTable> {
  $$ShiftTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shiftOverridesRefs(
    Expression<bool> Function($$ShiftOverridesTableFilterComposer f) f,
  ) {
    final $$ShiftOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftOverrides,
      getReferencedColumn: (t) => t.shiftTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftOverridesTableFilterComposer(
            $db: $db,
            $table: $db.shiftOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftTypesTable> {
  $$ShiftTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftTypesTable> {
  $$ShiftTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> shiftOverridesRefs<T extends Object>(
    Expression<T> Function($$ShiftOverridesTableAnnotationComposer a) f,
  ) {
    final $$ShiftOverridesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftOverrides,
      getReferencedColumn: (t) => t.shiftTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftOverridesTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftTypesTable,
          ShiftTypeRow,
          $$ShiftTypesTableFilterComposer,
          $$ShiftTypesTableOrderingComposer,
          $$ShiftTypesTableAnnotationComposer,
          $$ShiftTypesTableCreateCompanionBuilder,
          $$ShiftTypesTableUpdateCompanionBuilder,
          (ShiftTypeRow, $$ShiftTypesTableReferences),
          ShiftTypeRow,
          PrefetchHooks Function({bool shiftOverridesRefs})
        > {
  $$ShiftTypesTableTableManager(_$AppDatabase db, $ShiftTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> abbreviation = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftTypesCompanion(
                id: id,
                name: name,
                abbreviation: abbreviation,
                kind: kind,
                color: color,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String abbreviation,
                required String kind,
                required int color,
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                required int sortOrder,
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShiftTypesCompanion.insert(
                id: id,
                name: name,
                abbreviation: abbreviation,
                kind: kind,
                color: color,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShiftTypesTable, ShiftTypeRow>(table),
                  $$ShiftTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftOverridesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shiftOverridesRefs) db.shiftOverrides,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftOverridesRefs)
                    await $_getPrefetchedData<
                      ShiftTypeRow,
                      $ShiftTypesTable,
                      ShiftOverrideRow
                    >(
                      currentTable: table,
                      referencedTable: $$ShiftTypesTableReferences
                          ._shiftOverridesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShiftTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).shiftOverridesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.shiftTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShiftTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftTypesTable,
      ShiftTypeRow,
      $$ShiftTypesTableFilterComposer,
      $$ShiftTypesTableOrderingComposer,
      $$ShiftTypesTableAnnotationComposer,
      $$ShiftTypesTableCreateCompanionBuilder,
      $$ShiftTypesTableUpdateCompanionBuilder,
      (ShiftTypeRow, $$ShiftTypesTableReferences),
      ShiftTypeRow,
      PrefetchHooks Function({bool shiftOverridesRefs})
    >;
typedef $$RotationPatternsTableCreateCompanionBuilder =
    RotationPatternsCompanion Function({
      required String id,
      required String validFrom,
      required String anchorDate,
      required String slotsJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RotationPatternsTableUpdateCompanionBuilder =
    RotationPatternsCompanion Function({
      Value<String> id,
      Value<String> validFrom,
      Value<String> anchorDate,
      Value<String> slotsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RotationPatternsTableFilterComposer
    extends Composer<_$AppDatabase, $RotationPatternsTable> {
  $$RotationPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RotationPatternsTableOrderingComposer
    extends Composer<_$AppDatabase, $RotationPatternsTable> {
  $$RotationPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RotationPatternsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RotationPatternsTable> {
  $$RotationPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slotsJson =>
      $composableBuilder(column: $table.slotsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RotationPatternsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RotationPatternsTable,
          RotationPatternRow,
          $$RotationPatternsTableFilterComposer,
          $$RotationPatternsTableOrderingComposer,
          $$RotationPatternsTableAnnotationComposer,
          $$RotationPatternsTableCreateCompanionBuilder,
          $$RotationPatternsTableUpdateCompanionBuilder,
          (
            RotationPatternRow,
            BaseReferences<
              _$AppDatabase,
              $RotationPatternsTable,
              RotationPatternRow
            >,
          ),
          RotationPatternRow,
          PrefetchHooks Function()
        > {
  $$RotationPatternsTableTableManager(
    _$AppDatabase db,
    $RotationPatternsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RotationPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RotationPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RotationPatternsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> validFrom = const Value.absent(),
                Value<String> anchorDate = const Value.absent(),
                Value<String> slotsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RotationPatternsCompanion(
                id: id,
                validFrom: validFrom,
                anchorDate: anchorDate,
                slotsJson: slotsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String validFrom,
                required String anchorDate,
                required String slotsJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RotationPatternsCompanion.insert(
                id: id,
                validFrom: validFrom,
                anchorDate: anchorDate,
                slotsJson: slotsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RotationPatternsTable, RotationPatternRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $RotationPatternsTable,
                    RotationPatternRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RotationPatternsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RotationPatternsTable,
      RotationPatternRow,
      $$RotationPatternsTableFilterComposer,
      $$RotationPatternsTableOrderingComposer,
      $$RotationPatternsTableAnnotationComposer,
      $$RotationPatternsTableCreateCompanionBuilder,
      $$RotationPatternsTableUpdateCompanionBuilder,
      (
        RotationPatternRow,
        BaseReferences<
          _$AppDatabase,
          $RotationPatternsTable,
          RotationPatternRow
        >,
      ),
      RotationPatternRow,
      PrefetchHooks Function()
    >;
typedef $$ShiftOverridesTableCreateCompanionBuilder =
    ShiftOverridesCompanion Function({
      required String date,
      required String shiftTypeId,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShiftOverridesTableUpdateCompanionBuilder =
    ShiftOverridesCompanion Function({
      Value<String> date,
      Value<String> shiftTypeId,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ShiftOverridesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShiftOverridesTable, ShiftOverrideRow> {
  $$ShiftOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftTypesTable _shiftTypeIdTable(_$AppDatabase db) => db.shiftTypes
      .createAlias('shift_overrides__shift_type_id__shift_types__id');

  $$ShiftTypesTableProcessedTableManager get shiftTypeId {
    final $_column = $_itemColumn<String>('shift_type_id')!;

    final manager = $$ShiftTypesTableTableManager(
      $_db,
      $_db.shiftTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftTypesTableFilterComposer get shiftTypeId {
    final $$ShiftTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTypeId,
      referencedTable: $db.shiftTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTypesTableFilterComposer(
            $db: $db,
            $table: $db.shiftTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftTypesTableOrderingComposer get shiftTypeId {
    final $$ShiftTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTypeId,
      referencedTable: $db.shiftTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTypesTableOrderingComposer(
            $db: $db,
            $table: $db.shiftTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShiftTypesTableAnnotationComposer get shiftTypeId {
    final $$ShiftTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTypeId,
      referencedTable: $db.shiftTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftOverridesTable,
          ShiftOverrideRow,
          $$ShiftOverridesTableFilterComposer,
          $$ShiftOverridesTableOrderingComposer,
          $$ShiftOverridesTableAnnotationComposer,
          $$ShiftOverridesTableCreateCompanionBuilder,
          $$ShiftOverridesTableUpdateCompanionBuilder,
          (ShiftOverrideRow, $$ShiftOverridesTableReferences),
          ShiftOverrideRow,
          PrefetchHooks Function({bool shiftTypeId})
        > {
  $$ShiftOverridesTableTableManager(
    _$AppDatabase db,
    $ShiftOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> shiftTypeId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftOverridesCompanion(
                date: date,
                shiftTypeId: shiftTypeId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String shiftTypeId,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShiftOverridesCompanion.insert(
                date: date,
                shiftTypeId: shiftTypeId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShiftOverridesTable, ShiftOverrideRow>(table),
                  $$ShiftOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shiftTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.shiftTypeId,
                        referencedTable: $$ShiftOverridesTableReferences
                            ._shiftTypeIdTable(db),
                        referencedColumn: $$ShiftOverridesTableReferences
                            ._shiftTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShiftOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftOverridesTable,
      ShiftOverrideRow,
      $$ShiftOverridesTableFilterComposer,
      $$ShiftOverridesTableOrderingComposer,
      $$ShiftOverridesTableAnnotationComposer,
      $$ShiftOverridesTableCreateCompanionBuilder,
      $$ShiftOverridesTableUpdateCompanionBuilder,
      (ShiftOverrideRow, $$ShiftOverridesTableReferences),
      ShiftOverrideRow,
      PrefetchHooks Function({bool shiftTypeId})
    >;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  required String iconKey,
  required int color,
  required String createdOn,
  Value<String?> archivedOn,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> iconKey,
  Value<int> color,
  Value<String> createdOn,
  Value<String?> archivedOn,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitRow> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitRulesTable, List<HabitRuleRow>>
  _habitRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitRules,
    aliasName: 'habits__id__habit_rules__habit_id',
  );

  $$HabitRulesTableProcessedTableManager get habitRulesRefs {
    final manager = $$HabitRulesTableTableManager(
      $_db,
      $_db.habitRules,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HabitCompletionsTable, List<HabitCompletionRow>>
  _habitCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitCompletions,
    aliasName: 'habits__id__habit_completions__habit_id',
  );

  $$HabitCompletionsTableProcessedTableManager get habitCompletionsRefs {
    final manager = $$HabitCompletionsTableTableManager(
      $_db,
      $_db.habitCompletions,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archivedOn => $composableBuilder(
    column: $table.archivedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitRulesRefs(
    Expression<bool> Function($$HabitRulesTableFilterComposer f) f,
  ) {
    final $$HabitRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitRules,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitRulesTableFilterComposer(
            $db: $db,
            $table: $db.habitRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> habitCompletionsRefs(
    Expression<bool> Function($$HabitCompletionsTableFilterComposer f) f,
  ) {
    final $$HabitCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archivedOn => $composableBuilder(
    column: $table.archivedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get createdOn =>
      $composableBuilder(column: $table.createdOn, builder: (column) => column);

  GeneratedColumn<String> get archivedOn => $composableBuilder(
    column: $table.archivedOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> habitRulesRefs<T extends Object>(
    Expression<T> Function($$HabitRulesTableAnnotationComposer a) f,
  ) {
    final $$HabitRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitRules,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.habitRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> habitCompletionsRefs<T extends Object>(
    Expression<T> Function($$HabitCompletionsTableAnnotationComposer a) f,
  ) {
    final $$HabitCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitRow,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitRow, $$HabitsTableReferences),
          HabitRow,
          PrefetchHooks Function({
            bool habitRulesRefs,
            bool habitCompletionsRefs,
          })
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> createdOn = const Value.absent(),
                Value<String?> archivedOn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                description: description,
                iconKey: iconKey,
                color: color,
                createdOn: createdOn,
                archivedOn: archivedOn,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String iconKey,
                required int color,
                required String createdOn,
                Value<String?> archivedOn = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                description: description,
                iconKey: iconKey,
                color: color,
                createdOn: createdOn,
                archivedOn: archivedOn,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTable, HabitRow>(table),
                  $$HabitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({habitRulesRefs = false, habitCompletionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (habitRulesRefs) db.habitRules,
                    if (habitCompletionsRefs) db.habitCompletions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (habitRulesRefs)
                        await $_getPrefetchedData<
                          HabitRow,
                          $HabitsTable,
                          HabitRuleRow
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._habitRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(
                                db,
                                table,
                                p0,
                              ).habitRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (habitCompletionsRefs)
                        await $_getPrefetchedData<
                          HabitRow,
                          $HabitsTable,
                          HabitCompletionRow
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._habitCompletionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(
                                db,
                                table,
                                p0,
                              ).habitCompletionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitRow,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitRow, $$HabitsTableReferences),
      HabitRow,
      PrefetchHooks Function({bool habitRulesRefs, bool habitCompletionsRefs})
    >;
typedef $$HabitRulesTableCreateCompanionBuilder = HabitRulesCompanion Function({
  required String id,
  required String habitId,
  required String validFrom,
  required String targetShiftTypeIdsJson,
  Value<String?> weekdaysJson,
  Value<String?> remindersJson,
  Value<int> rowid,
});
typedef $$HabitRulesTableUpdateCompanionBuilder = HabitRulesCompanion Function({
  Value<String> id,
  Value<String> habitId,
  Value<String> validFrom,
  Value<String> targetShiftTypeIdsJson,
  Value<String?> weekdaysJson,
  Value<String?> remindersJson,
  Value<int> rowid,
});

final class $$HabitRulesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitRulesTable, HabitRuleRow> {
  $$HabitRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_rules__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitRulesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitRulesTable> {
  $$HabitRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetShiftTypeIdsJson => $composableBuilder(
    column: $table.targetShiftTypeIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdaysJson => $composableBuilder(
    column: $table.weekdaysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remindersJson => $composableBuilder(
    column: $table.remindersJson,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitRulesTable> {
  $$HabitRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetShiftTypeIdsJson => $composableBuilder(
    column: $table.targetShiftTypeIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdaysJson => $composableBuilder(
    column: $table.weekdaysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remindersJson => $composableBuilder(
    column: $table.remindersJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitRulesTable> {
  $$HabitRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get targetShiftTypeIdsJson => $composableBuilder(
    column: $table.targetShiftTypeIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekdaysJson => $composableBuilder(
    column: $table.weekdaysJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remindersJson => $composableBuilder(
    column: $table.remindersJson,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitRulesTable,
          HabitRuleRow,
          $$HabitRulesTableFilterComposer,
          $$HabitRulesTableOrderingComposer,
          $$HabitRulesTableAnnotationComposer,
          $$HabitRulesTableCreateCompanionBuilder,
          $$HabitRulesTableUpdateCompanionBuilder,
          (HabitRuleRow, $$HabitRulesTableReferences),
          HabitRuleRow,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitRulesTableTableManager(_$AppDatabase db, $HabitRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> validFrom = const Value.absent(),
                Value<String> targetShiftTypeIdsJson = const Value.absent(),
                Value<String?> weekdaysJson = const Value.absent(),
                Value<String?> remindersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitRulesCompanion(
                id: id,
                habitId: habitId,
                validFrom: validFrom,
                targetShiftTypeIdsJson: targetShiftTypeIdsJson,
                weekdaysJson: weekdaysJson,
                remindersJson: remindersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String validFrom,
                required String targetShiftTypeIdsJson,
                Value<String?> weekdaysJson = const Value.absent(),
                Value<String?> remindersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitRulesCompanion.insert(
                id: id,
                habitId: habitId,
                validFrom: validFrom,
                targetShiftTypeIdsJson: targetShiftTypeIdsJson,
                weekdaysJson: weekdaysJson,
                remindersJson: remindersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitRulesTable, HabitRuleRow>(table),
                  $$HabitRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitRulesTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$HabitRulesTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitRulesTable,
      HabitRuleRow,
      $$HabitRulesTableFilterComposer,
      $$HabitRulesTableOrderingComposer,
      $$HabitRulesTableAnnotationComposer,
      $$HabitRulesTableCreateCompanionBuilder,
      $$HabitRulesTableUpdateCompanionBuilder,
      (HabitRuleRow, $$HabitRulesTableReferences),
      HabitRuleRow,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$HabitCompletionsTableCreateCompanionBuilder =
    HabitCompletionsCompanion Function({
      required String habitId,
      required String date,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$HabitCompletionsTableUpdateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<String> habitId,
      Value<String> date,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

final class $$HabitCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletionRow
        > {
  $$HabitCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_completions__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletionRow,
          $$HabitCompletionsTableFilterComposer,
          $$HabitCompletionsTableOrderingComposer,
          $$HabitCompletionsTableAnnotationComposer,
          $$HabitCompletionsTableCreateCompanionBuilder,
          $$HabitCompletionsTableUpdateCompanionBuilder,
          (HabitCompletionRow, $$HabitCompletionsTableReferences),
          HabitCompletionRow,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitCompletionsTableTableManager(
    _$AppDatabase db,
    $HabitCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion(
                habitId: habitId,
                date: date,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required String date,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion.insert(
                habitId: habitId,
                date: date,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitCompletionsTable, HabitCompletionRow>(
                    table,
                  ),
                  $$HabitCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitCompletionsTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$HabitCompletionsTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCompletionsTable,
      HabitCompletionRow,
      $$HabitCompletionsTableFilterComposer,
      $$HabitCompletionsTableOrderingComposer,
      $$HabitCompletionsTableAnnotationComposer,
      $$HabitCompletionsTableCreateCompanionBuilder,
      $$HabitCompletionsTableUpdateCompanionBuilder,
      (HabitCompletionRow, $$HabitCompletionsTableReferences),
      HabitCompletionRow,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingsEntryRow,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingsEntryRow,
            BaseReferences<
              _$AppDatabase,
              $SettingsEntriesTable,
              SettingsEntryRow
            >,
          ),
          SettingsEntryRow,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsEntriesTable, SettingsEntryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsEntriesTable,
                    SettingsEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingsEntryRow,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingsEntryRow,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntryRow>,
      ),
      SettingsEntryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShiftTypesTableTableManager get shiftTypes =>
      $$ShiftTypesTableTableManager(_db, _db.shiftTypes);
  $$RotationPatternsTableTableManager get rotationPatterns =>
      $$RotationPatternsTableTableManager(_db, _db.rotationPatterns);
  $$ShiftOverridesTableTableManager get shiftOverrides =>
      $$ShiftOverridesTableTableManager(_db, _db.shiftOverrides);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitRulesTableTableManager get habitRules =>
      $$HabitRulesTableTableManager(_db, _db.habitRules);
  $$HabitCompletionsTableTableManager get habitCompletions =>
      $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
}
