import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/model/user_model.dart';

const String COLLECTION_USERS = "users";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference<UserModel> _collectionReference;

  DatabaseService() {
    _collectionReference = _firestore
        .collection(COLLECTION_USERS)
        .withConverter<UserModel>(
            fromFirestore: (snapshots, _) =>
                UserModel.fromJson(snapshots.data()!),
            toFirestore: (userModell, _) => userModell.toJson());
  }

  Future<void> saveData(UserModel userModel) async {
    try {
      await _collectionReference.doc(userModel.id).set(userModel);
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot<UserModel> doc =
          await _collectionReference.doc(userId).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
  //   try {
  //    await _collectionReference.doc(userId).update(data);
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  Future<void> updateUserData(
      String userId, String name, String about, String? gender) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "about": about,
        "gender": gender,
      };
      await _collectionReference.doc(userId).update(data);
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  Future<void> updateProfile(String userId, String? profileUrl) async {
    try {
      Map<String, dynamic> data = {
        "profileImage": profileUrl,
      };
      await _collectionReference.doc(userId).update(data);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      QuerySnapshot<UserModel> querySnapshot = await _collectionReference.where("email", isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  
}
