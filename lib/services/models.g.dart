// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entries _$EntriesFromJson(Map<String, dynamic> json) => Entries(
      addedBy: json['addedBy'] as String? ?? "",
      details: json['details'] == null
          ? null
          : Details.fromJson(json['details'] as Map<String, dynamic>),
      entryID: json['entryID'] as String? ?? "",
      entryLog: json['entryLog'].toString(),
      gaadiID: json['gaadiID'] as String? ?? "",
    );

Map<String, dynamic> _$EntriesToJson(Entries instance) => <String, dynamic>{
      'addedBy': instance.addedBy,
      'details': instance.details,
      'entryID': instance.entryID,
      'entryLog': instance.entryLog.toString(),
      'gaadiID': instance.gaadiID,
    };

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
      amount: json['amount'] as int? ?? 0,
      category: json['category'] as String? ?? "",
      isIncome: json['isIncome'] as bool? ?? false,
      remarks: json['remarks'] as String? ?? "",
    );

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
      'amount': instance.amount,
      'category': instance.category,
      'isIncome': instance.isIncome,
      'remarks': instance.remarks,
    };

Gaadi _$GaadiFromJson(Map<String, dynamic> json) => Gaadi(
    addedBy: json['addedBy'] as String? ?? "",
    entries: (json['entries'] as List<dynamic>?)
            ?.map((e) => Entries.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    log: json['log'] as String? ?? "",
    seats: json['seats'] as int? ?? 0,
    gaadiID: json['gaadiID'] as String? ?? "");

Map<String, dynamic> _$GaadiToJson(Gaadi instance) => <String, dynamic>{
      'addedBy': instance.addedBy,
      'entries': instance.entries,
      'log': instance.log,
      'seats': instance.seats,
      'gaadiID': instance.gaadiID,
    };

UserModel _$UsersFromJson(Map<String, dynamic> json) => UserModel(
      gaadiList: (json['gaadiList'] as List<dynamic>?)
              ?.map((e) => Gaadi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      log: json['log'] as String? ?? "",
      name: json['name'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$UsersToJson(UserModel instance) => <String, dynamic>{
      'gaadiList': instance.gaadiList,
      'log': instance.log,
      'name': instance.name,
      'type': instance.type,
    };
