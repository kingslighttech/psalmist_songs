import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VouchersRecord extends FirestoreRecord {
  VouchersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Monthly" field.
  List<String>? _monthly;
  List<String> get monthly => _monthly ?? const [];
  bool hasMonthly() => _monthly != null;

  // "Yearly" field.
  List<String>? _yearly;
  List<String> get yearly => _yearly ?? const [];
  bool hasYearly() => _yearly != null;

  void _initializeFields() {
    _monthly = getDataList(snapshotData['Monthly']);
    _yearly = getDataList(snapshotData['Yearly']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('VOUCHERS');

  static Stream<VouchersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VouchersRecord.fromSnapshot(s));

  static Future<VouchersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VouchersRecord.fromSnapshot(s));

  static VouchersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VouchersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VouchersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VouchersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VouchersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VouchersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVouchersRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class VouchersRecordDocumentEquality implements Equality<VouchersRecord> {
  const VouchersRecordDocumentEquality();

  @override
  bool equals(VouchersRecord? e1, VouchersRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.monthly, e2?.monthly) &&
        listEquality.equals(e1?.yearly, e2?.yearly);
  }

  @override
  int hash(VouchersRecord? e) =>
      const ListEquality().hash([e?.monthly, e?.yearly]);

  @override
  bool isValidKey(Object? o) => o is VouchersRecord;
}
