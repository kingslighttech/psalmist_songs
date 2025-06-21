import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PricesRecord extends FirestoreRecord {
  PricesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "voteprice" field.
  int? _voteprice;
  int get voteprice => _voteprice ?? 0;
  bool hasVoteprice() => _voteprice != null;

  // "monthlysub_price" field.
  int? _monthlysubPrice;
  int get monthlysubPrice => _monthlysubPrice ?? 0;
  bool hasMonthlysubPrice() => _monthlysubPrice != null;

  // "yearlysub_price" field.
  int? _yearlysubPrice;
  int get yearlysubPrice => _yearlysubPrice ?? 0;
  bool hasYearlysubPrice() => _yearlysubPrice != null;

  // "voteprice_dollar" field.
  int? _votepriceDollar;
  int get votepriceDollar => _votepriceDollar ?? 0;
  bool hasVotepriceDollar() => _votepriceDollar != null;

  // "appSTAT" field.
  bool? _appSTAT;
  bool get appSTAT => _appSTAT ?? false;
  bool hasAppSTAT() => _appSTAT != null;

  // "voteSTAT" field.
  bool? _voteSTAT;
  bool get voteSTAT => _voteSTAT ?? false;
  bool hasVoteSTAT() => _voteSTAT != null;

  // "supportArtist" field.
  bool? _supportArtist;
  bool get supportArtist => _supportArtist ?? false;
  bool hasSupportArtist() => _supportArtist != null;

  // "lastArtist_id" field.
  String? _lastArtistId;
  String get lastArtistId => _lastArtistId ?? '';
  bool hasLastArtistId() => _lastArtistId != null;

  void _initializeFields() {
    _voteprice = castToType<int>(snapshotData['voteprice']);
    _monthlysubPrice = castToType<int>(snapshotData['monthlysub_price']);
    _yearlysubPrice = castToType<int>(snapshotData['yearlysub_price']);
    _votepriceDollar = castToType<int>(snapshotData['voteprice_dollar']);
    _appSTAT = snapshotData['appSTAT'] as bool?;
    _voteSTAT = snapshotData['voteSTAT'] as bool?;
    _supportArtist = snapshotData['supportArtist'] as bool?;
    _lastArtistId = snapshotData['lastArtist_id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('prices');

  static Stream<PricesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PricesRecord.fromSnapshot(s));

  static Future<PricesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PricesRecord.fromSnapshot(s));

  static PricesRecord fromSnapshot(DocumentSnapshot snapshot) => PricesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PricesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PricesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PricesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PricesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPricesRecordData({
  int? voteprice,
  int? monthlysubPrice,
  int? yearlysubPrice,
  int? votepriceDollar,
  bool? appSTAT,
  bool? voteSTAT,
  bool? supportArtist,
  String? lastArtistId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'voteprice': voteprice,
      'monthlysub_price': monthlysubPrice,
      'yearlysub_price': yearlysubPrice,
      'voteprice_dollar': votepriceDollar,
      'appSTAT': appSTAT,
      'voteSTAT': voteSTAT,
      'supportArtist': supportArtist,
      'lastArtist_id': lastArtistId,
    }.withoutNulls,
  );

  return firestoreData;
}

class PricesRecordDocumentEquality implements Equality<PricesRecord> {
  const PricesRecordDocumentEquality();

  @override
  bool equals(PricesRecord? e1, PricesRecord? e2) {
    return e1?.voteprice == e2?.voteprice &&
        e1?.monthlysubPrice == e2?.monthlysubPrice &&
        e1?.yearlysubPrice == e2?.yearlysubPrice &&
        e1?.votepriceDollar == e2?.votepriceDollar &&
        e1?.appSTAT == e2?.appSTAT &&
        e1?.voteSTAT == e2?.voteSTAT &&
        e1?.supportArtist == e2?.supportArtist &&
        e1?.lastArtistId == e2?.lastArtistId;
  }

  @override
  int hash(PricesRecord? e) => const ListEquality().hash([
        e?.voteprice,
        e?.monthlysubPrice,
        e?.yearlysubPrice,
        e?.votepriceDollar,
        e?.appSTAT,
        e?.voteSTAT,
        e?.supportArtist,
        e?.lastArtistId
      ]);

  @override
  bool isValidKey(Object? o) => o is PricesRecord;
}
