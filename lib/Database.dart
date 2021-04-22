import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FirebaseDb {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Retrieving user id
  getuid() {
    return auth.currentUser!.uid;
  }

  adduser(uid, name) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('User Data');
    return users
        .doc(uid)
        .set({
          'user_name': name, // John Doe
          // 42
        })
        .then((value) => print("Username Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Anonymous sign-in
  signinanony() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user!.uid;
  }

  //register with email and password
  registerwithemail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return 'Account Created';
  }

  //Update value
  updatevalue(docid, cat) async {
    CollectionReference news =
        FirebaseFirestore.instance.collection('All News');
    return news
        .doc(docid)
        .update({cat: FieldValue.increment(1)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //update horoscope value
  updatezodiacvalue(docid, cat, sign) async {
    CollectionReference news = FirebaseFirestore.instance.collection(sign);
    return news
        .doc(docid)
        .update({cat: FieldValue.increment(1)})
        .then((value) => print("impression updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  //Signin with email and Password

  signinwithemail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.uid != null) {
        return 'Login Successful';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  //Add Bookmark
  addBookmark(docid, uid, title, image, desc, date, category, username) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(uid)
        .collection(uid);
    return users
        .doc(docid)
        .set({
          'title': title,
          'image_url': image,
          'description': desc,
          'date': date,
          'category': category,
          'timestamp': Timestamp.now(),
          'username': username,
        })
        .then((value) => print("Blog Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  removebookmark(uid, docid) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(uid)
        .collection(uid);
    return users
        .doc(docid)
        .delete()
        .then((value) => print("Blog Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<Database> main1() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'follow_db.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE follow(id TEXT PRIMARY KEY)",
        );
      },
      version: 2,
    );
  }

  Future<void> insertfollow(Database database, Bookmark bookmark) async {
    final Database db = await database;
    await db.insert(
      'follow',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> followids(Database database) async {
    final Database db = await database;
    var result = await db.rawQuery("SELECT id FROM follow");
    return result.reversed.toList();
  }

  Future<void> deletefollow(Database database, String id) async {
    final db = await database;

    await db.delete(
      'follow',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<Database> main2() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'bookmark_db.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE bookmarks(id TEXT PRIMARY KEY)",
        );
      },
      version: 2,
    );
  }

  Future<void> insertbookmark(Database database, Bookmark bookmark) async {
    final Database db = await database;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> bookmarksids(Database database) async {
    final Database db = await database;
    var result = await db.rawQuery("SELECT id FROM Bookmarks");
    return result.reversed.toList();
  }

  Future<void> deleteBM(Database database, String id) async {
    final db = await database;

    await db.delete(
      'bookmarks',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //Reset Password
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  //Sign Out

  signout() async {
    await FirebaseAuth.instance.signOut();
  }
}

class Bookmark {
  final String id;

  Bookmark({
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}
