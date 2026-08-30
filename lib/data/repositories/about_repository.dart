import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/about_me.dart';
import '../models/time_line.dart';

class AboutRepository {
  AboutRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<AboutMe?> fetchAboutMe() async {
    final doc = await _firestore.collection('about').doc('me').get();
    final data = doc.data();
    if (data == null) return null;
    return AboutMe.fromJson(data);
  }

  Future<List<TimeLine>> fetchTimeline() async {
    final res = await _firestore.collection('timeline').get();
    final items = res.docs.map((e) => TimeLine.fromJson(e.data())).toList();
    items.sort((a, b) => b.startDate.compareTo(a.startDate));
    return items;
  }
}
