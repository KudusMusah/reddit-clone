import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reddit_clone/src/core/common/models/user_model.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';

abstract interface class ProfileRemoteDataSource {
  Future<void> editUserProfile(UserModel profile);
  Future<String> uploadImage(String path, String id, File image);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  ProfileRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _firebaseStorage = storage;

  CollectionReference get _users => _firestore.collection("users");

  @override
  Future<String> uploadImage(String path, String id, File image) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw ProfileException(e.message ?? e.toString());
    } catch (e) {
      throw ProfileException(e.toString());
    }
  }

  @override
  Future<void> editUserProfile(UserModel profile) async {
    try {
      await _users.doc(profile.uid).update(profile.toJson());
    } on FirebaseException catch (e) {
      throw ProfileException(e.message ?? e.toString());
    } catch (e) {
      throw ProfileException(e.toString());
    }
  }
}
