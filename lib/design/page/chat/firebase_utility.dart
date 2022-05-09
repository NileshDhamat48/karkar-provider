import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseUtility {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static String chatMessageCollection = "messages";
  static String chatUserList = "users_chat_list";

  final CollectionReference userschatlistsCollection = FirebaseFirestore.instance.collection(chatUserList);
  final CollectionReference usersMessagesCollection = FirebaseFirestore.instance.collection(chatMessageCollection);

  // static DocumentSnapshot? lastChatDocument;
  static bool hasMoreChats = true;

  final StreamController<List<DocumentSnapshot>> streamController = StreamController<List<DocumentSnapshot>>();

  Stream listentoChatsRealtime(
    String groupChatId,
    String myId,
  ) {
    getMesaageFirstTime(groupId: groupChatId, myId: myId);
    return streamController.stream;
  }

  void getMesaageFirstTime({
    required String groupId,
    required String myId,
  }) async {
    messagesreadupdatebadgevaluetozero(
      groupChatId: groupId,
      myid: myId,
    );
    final list = await _firebaseFirestore
        .collection('messages')
        .where('group_id', isEqualTo: groupId)
        // .where('message_for', arrayContains: myId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .get();
    streamController.add(list.docs);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMesaageAll({
    required String groupId,
    required String myId,
  }) {
    messagesreadupdatebadgevaluetozero(
      groupChatId: groupId,
      myid: myId,
    );
    return _firebaseFirestore
        .collection('messages')
        .where('group_id', isEqualTo: groupId)
        // .where('message_for', arrayContains: myId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void getMesaageNextPage({
    required String groupId,
    required String myId,
    required DocumentSnapshot lastChatDocument,
  }) async {
    messagesreadupdatebadgevaluetozero(
      groupChatId: groupId,
      myid: myId,
    );
    final list = await _firebaseFirestore
        .collection('messages')
        .where('group_id', isEqualTo: groupId)
        // .where('message_for', arrayContains: myId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastChatDocument)
        .limit(20)
        .get();
    streamController.add(list.docs);
  }

  Future<void> messagesreadupdatebadgevaluetozero({required String groupChatId, required String myid}) async {
    QuerySnapshot qs = await userschatlistsCollection.where('group_id', isEqualTo: groupChatId).get();
    if (qs.docs.isNotEmpty) {
      if (qs.docs[0]['usera_id'] == myid) {
        userschatlistsCollection.doc(qs.docs[0].id).update({"usera_badge": 0});
      } else {
        userschatlistsCollection.doc(qs.docs[0].id).update({"userb_badge": 0});
      }
    }
  }

  Future<void> sendChatData({
    required String myId,
    required String otherId,
    required String groupChatId,
    String? fileUrl,
    required String type,
    String? message,
    GeoPoint? location,
    String? price,
    String? paymentStatus,
  }) {
    return usersMessagesCollection.doc().set(
      {
        'id_from': myId,
        'id_to': otherId,
        'group_id': groupChatId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        if (fileUrl != null) 'file_url': fileUrl,
        'type': type,
        if (message != null) 'message': message,
        if (location != null) 'location': location,
        if (paymentStatus != null) 'payment_status': paymentStatus,
        if (price != null) 'price': price,
      },
    );
  }

  Future<void> enterDatainUsersChatListCollection({
    required String chattype,
    required String useraId,
    required String userbId,
    required String groupchatid,
    required String myid,
    required String message,
  }) async {
    List<String> idsarray = [useraId, userbId];

    QuerySnapshot qs = await userschatlistsCollection.where('group_id', isEqualTo: groupchatid).get();
    //check chat list Uesr collcation is Empty or not
    if (qs.docs.isNotEmpty) {
      userschatlistsCollection.doc(qs.docs[0].id).update({
        "type": chattype,
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "usera_badge": FieldValue.increment(
          (myid == userbId ? (1) : (0)),
        ),
        "userb_badge": FieldValue.increment(
          (myid == useraId ? (1) : (0)),
        ),
      });
    } else {
      userschatlistsCollection.doc().set({
        "message": message,
        "usera_id": useraId,
        "userb_id": userbId,
        "type": chattype,
        "group_id": groupchatid,
        "idsarray": idsarray,
        "usera_badge": myid == userbId ? 1 : 0,
        "userb_badge": myid == useraId ? 1 : 0,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  Stream<QuerySnapshot> getUsersChatList(String userId) {
    return userschatlistsCollection.where('idsarray', arrayContains: userId).snapshots();
  }

  Stream<QuerySnapshot> getUsersChatListIndividualBadgeValue(
    String myId,
    String otherId,
  ) {
    print("here aa bb cc");
    String groupChatId = "";
    if (int.parse(otherId) < int.parse(myId)) {
      groupChatId = '$otherId-$myId';
    } else {
      groupChatId = '$myId-$otherId';
    }
    print("groupchatid here aaa " + groupChatId);
    return userschatlistsCollection.where('group_id', isEqualTo: groupChatId).snapshots();
  }

  Future<String?> uploadImage(
    String foldername,
    File image,
    String userid,
  ) async {
    try {
      String? downloadUrl;
      Reference reference = FirebaseStorage.instance
          .ref()
          .child(foldername + "/" + DateTime.now().toString() + "/" + userid + "." + path.extension(image.path));
      UploadTask uploadTask = reference.putData(image.readAsBytesSync());
      TaskSnapshot storageTaskSnapshot;

      await uploadTask.whenComplete(() {}).then(
        (snapshot) async {
          // ignore: unnecessary_null_comparison
          if (snapshot.ref != null) {
            storageTaskSnapshot = snapshot;
            downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
          } else {
            log('Error from image repo ');
          }
        },
      );
      return downloadUrl;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return '';
    }
  }
}
