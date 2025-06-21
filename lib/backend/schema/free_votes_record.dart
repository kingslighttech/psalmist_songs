import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FreeVotesRecord extends FirestoreRecord {
  FreeVotesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "CAT2" field.
  List<DocumentReference>? _cat2;
  List<DocumentReference> get cat2 => _cat2 ?? const [];
  bool hasCat2() => _cat2 != null;

  // "CAT1" field.
  List<DocumentReference>? _cat1;
  List<DocumentReference> get cat1 => _cat1 ?? const [];
  bool hasCat1() => _cat1 != null;

  // "CAT3" field.
  List<DocumentReference>? _cat3;
  List<DocumentReference> get cat3 => _cat3 ?? const [];
  bool hasCat3() => _cat3 != null;

  // "CAT4" field.
  List<DocumentReference>? _cat4;
  List<DocumentReference> get cat4 => _cat4 ?? const [];
  bool hasCat4() => _cat4 != null;

  void _initializeFields() {
    _cat2 = getDataList(snapshotData['CAT2']);
    _cat1 = getDataList(snapshotData['CAT1']);
    _cat3 = getDataList(snapshotData['CAT3']);
    _cat4 = getDataList(snapshotData['CAT4']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('FREE_VOTES');

  static Stream<FreeVotesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FreeVotesRecord.fromSnapshot(s));

  static Future<FreeVotesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FreeVotesRecord.fromSnapshot(s));

  static FreeVotesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FreeVotesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FreeVotesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FreeVotesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FreeVotesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FreeVotesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFreeVotesRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class FreeVotesRecordDocumentEquality implements Equality<FreeVotesRecord> {
  const FreeVotesRecordDocumentEquality();

  @override
  bool equals(FreeVotesRecord? e1, FreeVotesRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.cat2, e2?.cat2) &&
        listEquality.equals(e1?.cat1, e2?.cat1) &&
        listEquality.equals(e1?.cat3, e2?.cat3) &&
        listEquality.equals(e1?.cat4, e2?.cat4);
  }

  @override
  int hash(FreeVotesRecord? e) =>
      const ListEquality().hash([e?.cat2, e?.cat1, e?.cat3, e?.cat4]);

  @override
  bool isValidKey(Object? o) => o is FreeVotesRecord;
}
