import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlbumsRecord extends FirestoreRecord {
  AlbumsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "album_title" field.
  String? _albumTitle;
  String get albumTitle => _albumTitle ?? '';
  bool hasAlbumTitle() => _albumTitle != null;

  // "album_tracks" field.
  List<DocumentReference>? _albumTracks;
  List<DocumentReference> get albumTracks => _albumTracks ?? const [];
  bool hasAlbumTracks() => _albumTracks != null;

  // "album_img" field.
  String? _albumImg;
  String get albumImg => _albumImg ?? '';
  bool hasAlbumImg() => _albumImg != null;

  // "album_id" field.
  String? _albumId;
  String get albumId => _albumId ?? '';
  bool hasAlbumId() => _albumId != null;

  // "artist_name" field.
  String? _artistName;
  String get artistName => _artistName ?? '';
  bool hasArtistName() => _artistName != null;

  void _initializeFields() {
    _albumTitle = snapshotData['album_title'] as String?;
    _albumTracks = getDataList(snapshotData['album_tracks']);
    _albumImg = snapshotData['album_img'] as String?;
    _albumId = snapshotData['album_id'] as String?;
    _artistName = snapshotData['artist_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Albums');

  static Stream<AlbumsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AlbumsRecord.fromSnapshot(s));

  static Future<AlbumsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AlbumsRecord.fromSnapshot(s));

  static AlbumsRecord fromSnapshot(DocumentSnapshot snapshot) => AlbumsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AlbumsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AlbumsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AlbumsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AlbumsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAlbumsRecordData({
  String? albumTitle,
  String? albumImg,
  String? albumId,
  String? artistName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'album_title': albumTitle,
      'album_img': albumImg,
      'album_id': albumId,
      'artist_name': artistName,
    }.withoutNulls,
  );

  return firestoreData;
}

class AlbumsRecordDocumentEquality implements Equality<AlbumsRecord> {
  const AlbumsRecordDocumentEquality();

  @override
  bool equals(AlbumsRecord? e1, AlbumsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.albumTitle == e2?.albumTitle &&
        listEquality.equals(e1?.albumTracks, e2?.albumTracks) &&
        e1?.albumImg == e2?.albumImg &&
        e1?.albumId == e2?.albumId &&
        e1?.artistName == e2?.artistName;
  }

  @override
  int hash(AlbumsRecord? e) => const ListEquality().hash(
      [e?.albumTitle, e?.albumTracks, e?.albumImg, e?.albumId, e?.artistName]);

  @override
  bool isValidKey(Object? o) => o is AlbumsRecord;
}
