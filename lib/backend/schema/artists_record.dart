import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ArtistsRecord extends FirestoreRecord {
  ArtistsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "artistName" field.
  String? _artistName;
  String get artistName => _artistName ?? '';
  bool hasArtistName() => _artistName != null;

  // "artistBio" field.
  String? _artistBio;
  String get artistBio => _artistBio ?? '';
  bool hasArtistBio() => _artistBio != null;

  // "artistArt" field.
  String? _artistArt;
  String get artistArt => _artistArt ?? '';
  bool hasArtistArt() => _artistArt != null;

  // "songTittle" field.
  String? _songTittle;
  String get songTittle => _songTittle ?? '';
  bool hasSongTittle() => _songTittle != null;

  // "songFile" field.
  SongFileStruct? _songFile;
  SongFileStruct get songFile => _songFile ?? SongFileStruct();
  bool hasSongFile() => _songFile != null;

  // "date_added" field.
  DateTime? _dateAdded;
  DateTime? get dateAdded => _dateAdded;
  bool hasDateAdded() => _dateAdded != null;

  // "filetype" field.
  String? _filetype;
  String get filetype => _filetype ?? '';
  bool hasFiletype() => _filetype != null;

  // "song_comment" field.
  DocumentReference? _songComment;
  DocumentReference? get songComment => _songComment;
  bool hasSongComment() => _songComment != null;

  // "song_views" field.
  int? _songViews;
  int get songViews => _songViews ?? 0;
  bool hasSongViews() => _songViews != null;

  // "banner_no" field.
  int? _bannerNo;
  int get bannerNo => _bannerNo ?? 0;
  bool hasBannerNo() => _bannerNo != null;

  // "song_likes" field.
  List<DocumentReference>? _songLikes;
  List<DocumentReference> get songLikes => _songLikes ?? const [];
  bool hasSongLikes() => _songLikes != null;

  // "no_votes" field.
  int? _noVotes;
  int get noVotes => _noVotes ?? 0;
  bool hasNoVotes() => _noVotes != null;

  // "genre" field.
  String? _genre;
  String get genre => _genre ?? '';
  bool hasGenre() => _genre != null;

  // "Album_id" field.
  DocumentReference? _albumId;
  DocumentReference? get albumId => _albumId;
  bool hasAlbumId() => _albumId != null;

  // "artist_ID" field.
  String? _artistID;
  String get artistID => _artistID ?? '';
  bool hasArtistID() => _artistID != null;

  // "songIMG" field.
  String? _songIMG;
  String get songIMG => _songIMG ?? '';
  bool hasSongIMG() => _songIMG != null;

  void _initializeFields() {
    _artistName = snapshotData['artistName'] as String?;
    _artistBio = snapshotData['artistBio'] as String?;
    _artistArt = snapshotData['artistArt'] as String?;
    _songTittle = snapshotData['songTittle'] as String?;
    _songFile = snapshotData['songFile'] is SongFileStruct
        ? snapshotData['songFile']
        : SongFileStruct.maybeFromMap(snapshotData['songFile']);
    _dateAdded = snapshotData['date_added'] as DateTime?;
    _filetype = snapshotData['filetype'] as String?;
    _songComment = snapshotData['song_comment'] as DocumentReference?;
    _songViews = castToType<int>(snapshotData['song_views']);
    _bannerNo = castToType<int>(snapshotData['banner_no']);
    _songLikes = getDataList(snapshotData['song_likes']);
    _noVotes = castToType<int>(snapshotData['no_votes']);
    _genre = snapshotData['genre'] as String?;
    _albumId = snapshotData['Album_id'] as DocumentReference?;
    _artistID = snapshotData['artist_ID'] as String?;
    _songIMG = snapshotData['songIMG'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ARTISTS');

  static Stream<ArtistsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ArtistsRecord.fromSnapshot(s));

  static Future<ArtistsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ArtistsRecord.fromSnapshot(s));

  static ArtistsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ArtistsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArtistsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArtistsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArtistsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArtistsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArtistsRecordData({
  String? artistName,
  String? artistBio,
  String? artistArt,
  String? songTittle,
  SongFileStruct? songFile,
  DateTime? dateAdded,
  String? filetype,
  DocumentReference? songComment,
  int? songViews,
  int? bannerNo,
  int? noVotes,
  String? genre,
  DocumentReference? albumId,
  String? artistID,
  String? songIMG,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'artistName': artistName,
      'artistBio': artistBio,
      'artistArt': artistArt,
      'songTittle': songTittle,
      'songFile': SongFileStruct().toMap(),
      'date_added': dateAdded,
      'filetype': filetype,
      'song_comment': songComment,
      'song_views': songViews,
      'banner_no': bannerNo,
      'no_votes': noVotes,
      'genre': genre,
      'Album_id': albumId,
      'artist_ID': artistID,
      'songIMG': songIMG,
    }.withoutNulls,
  );

  // Handle nested data for "songFile" field.
  addSongFileStructData(firestoreData, songFile, 'songFile');

  return firestoreData;
}

class ArtistsRecordDocumentEquality implements Equality<ArtistsRecord> {
  const ArtistsRecordDocumentEquality();

  @override
  bool equals(ArtistsRecord? e1, ArtistsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.artistName == e2?.artistName &&
        e1?.artistBio == e2?.artistBio &&
        e1?.artistArt == e2?.artistArt &&
        e1?.songTittle == e2?.songTittle &&
        e1?.songFile == e2?.songFile &&
        e1?.dateAdded == e2?.dateAdded &&
        e1?.filetype == e2?.filetype &&
        e1?.songComment == e2?.songComment &&
        e1?.songViews == e2?.songViews &&
        e1?.bannerNo == e2?.bannerNo &&
        listEquality.equals(e1?.songLikes, e2?.songLikes) &&
        e1?.noVotes == e2?.noVotes &&
        e1?.genre == e2?.genre &&
        e1?.albumId == e2?.albumId &&
        e1?.artistID == e2?.artistID &&
        e1?.songIMG == e2?.songIMG;
  }

  @override
  int hash(ArtistsRecord? e) => const ListEquality().hash([
        e?.artistName,
        e?.artistBio,
        e?.artistArt,
        e?.songTittle,
        e?.songFile,
        e?.dateAdded,
        e?.filetype,
        e?.songComment,
        e?.songViews,
        e?.bannerNo,
        e?.songLikes,
        e?.noVotes,
        e?.genre,
        e?.albumId,
        e?.artistID,
        e?.songIMG
      ]);

  @override
  bool isValidKey(Object? o) => o is ArtistsRecord;
}
