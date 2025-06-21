import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "subID" field.
  String? _subID;
  String get subID => _subID ?? '';
  bool hasSubID() => _subID != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "cusID" field.
  String? _cusID;
  String get cusID => _cusID ?? '';
  bool hasCusID() => _cusID != null;

  // "planID" field.
  String? _planID;
  String get planID => _planID ?? '';
  bool hasPlanID() => _planID != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "plan_duration" field.
  String? _planDuration;
  String get planDuration => _planDuration ?? '';
  bool hasPlanDuration() => _planDuration != null;

  // "subTIME" field.
  DateTime? _subTIME;
  DateTime? get subTIME => _subTIME;
  bool hasSubTIME() => _subTIME != null;

  // "MSG" field.
  List<String>? _msg;
  List<String> get msg => _msg ?? const [];
  bool hasMsg() => _msg != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "admin" field.
  bool? _admin;
  bool get admin => _admin ?? false;
  bool hasAdmin() => _admin != null;

  // "blocklist" field.
  List<DocumentReference>? _blocklist;
  List<DocumentReference> get blocklist => _blocklist ?? const [];
  bool hasBlocklist() => _blocklist != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _displayName = snapshotData['display_name'] as String?;
    _subID = snapshotData['subID'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _cusID = snapshotData['cusID'] as String?;
    _planID = snapshotData['planID'] as String?;
    _status = snapshotData['status'] as String?;
    _planDuration = snapshotData['plan_duration'] as String?;
    _subTIME = snapshotData['subTIME'] as DateTime?;
    _msg = getDataList(snapshotData['MSG']);
    _phoneNumber = snapshotData['phone_number'] as String?;
    _admin = snapshotData['admin'] as bool?;
    _blocklist = getDataList(snapshotData['blocklist']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? uid,
  DateTime? createdTime,
  String? displayName,
  String? subID,
  String? photoUrl,
  String? cusID,
  String? planID,
  String? status,
  String? planDuration,
  DateTime? subTIME,
  String? phoneNumber,
  bool? admin,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'uid': uid,
      'created_time': createdTime,
      'display_name': displayName,
      'subID': subID,
      'photo_url': photoUrl,
      'cusID': cusID,
      'planID': planID,
      'status': status,
      'plan_duration': planDuration,
      'subTIME': subTIME,
      'phone_number': phoneNumber,
      'admin': admin,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.displayName == e2?.displayName &&
        e1?.subID == e2?.subID &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.cusID == e2?.cusID &&
        e1?.planID == e2?.planID &&
        e1?.status == e2?.status &&
        e1?.planDuration == e2?.planDuration &&
        e1?.subTIME == e2?.subTIME &&
        listEquality.equals(e1?.msg, e2?.msg) &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.admin == e2?.admin &&
        listEquality.equals(e1?.blocklist, e2?.blocklist);
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.uid,
        e?.createdTime,
        e?.displayName,
        e?.subID,
        e?.photoUrl,
        e?.cusID,
        e?.planID,
        e?.status,
        e?.planDuration,
        e?.subTIME,
        e?.msg,
        e?.phoneNumber,
        e?.admin,
        e?.blocklist
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
