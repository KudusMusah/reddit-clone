import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/features/communities/data/models/community_model.dart';

abstract interface class CommunityRemoteDatasource {
  Future<void> createCommunity(CommunityModel community);
}

class CommunityRemoteDatasourceImpl implements CommunityRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;

  CommunityRemoteDatasourceImpl({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _community =>
      _firebaseFirestore.collection("communities");

  @override
  Future<void> createCommunity(CommunityModel community) async {
    try {
      final communityDoc = await _community.doc(community.name).get();
      if (communityDoc.exists) {
        throw CommunityException("Community with that name exits");
      }

      return _community.doc(community.name).set(community.toJson());
    } catch (e) {
      if (e is CommunityException) {
        throw CommunityException("Community with that name exits");
      }
      throw CommunityException(e.toString());
    }
  }
}
