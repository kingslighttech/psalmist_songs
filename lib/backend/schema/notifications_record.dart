import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "APPversion" field.
  String? _aPPversion;
  String get aPPversion => _aPPversion ?? '';
  bool hasAPPversion() => _aPPversion != null;

  // "TITLE" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "MESSAGE" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "LINK" field.
  String? _link;
  String get link => _link ?? '';
  bool hasLink() => _link != null;

  // "C2A" field.
  String? _c2a;
  String get c2a => _c2a ?? '';
  bool hasC2a() => _c2a != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "userveiw" field.
  List<DocumentReference>? _userveiw;
  List<DocumentReference> get userveiw => _userveiw ?? const [];
  bool hasUserveiw() => _userveiw != null;

  void _initializeFields() {
    _aPPversion = snapshotData['APPversion'] as String?;
    _title = snapshotData['TITLE'] as String?;
    _message = snapshotData['MESSAGE'] as String?;
    _link = snapshotData['LINK'] as String?;
    _c2a = snapshotData['C2A'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _userveiw = getDataList(snapshotData['userveiw']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('NOTIFICATIONS');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  String? aPPversion,
  String? title,
  String? message,
  String? link,
  String? c2a,
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'APPversion': aPPversion,
      'TITLE': title,
      'MESSAGE': message,
      'LINK': link,
      'C2A': c2a,
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.aPPversion == e2?.aPPversion &&
        e1?.title == e2?.title &&
        e1?.message == e2?.message &&
        e1?.link == e2?.link &&
        e1?.c2a == e2?.c2a &&
        e1?.date == e2?.date &&
        listEquality.equals(e1?.userveiw, e2?.userveiw);
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.aPPversion,
        e?.title,
        e?.message,
        e?.link,
        e?.c2a,
        e?.date,
        e?.userveiw
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
