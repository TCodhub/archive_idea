import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper = DatabaseHelper();
  List<IdeaInfo> lstIdeaInfo = []; //아이디어 목록들이 담길 공간

  @override
  void initState() {
    super.initState();
    //아이디어 목록들 가져오기
    setInsertIdeaInfo();
    getIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Archive Idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return listItem(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //새 작성화면으로 이동
        },
        child: Image.asset(
          'assets/icon.png',
          width: 48,
          height: 48,
        ),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
        //opacity는 1이 maximum숫자이다
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      height: 82,
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1, color: Color(0xffd9d9d9)),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          //아이디어 제목/title
          Container(
            margin: EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            child: Text(
              lstIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          //createdAt
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  margin: EdgeInsets.only(right: 16, bottom: 8),
                  child: Text(
                    DateFormat("YYYY.MM.dd HH:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(lstIdeaInfo[index].createdAt),
                    ),
                    style: TextStyle(color: Color(0xffaeaeae)),
                  ))),

          //priority(별형태로, as star shape)
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: RatingBar.builder(
                  initialRating: lstIdeaInfo[index].priority.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemSize: 16,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  ignoreGestures: true,
                  updateOnDrag: false,
                  onRatingUpdate: (value) {}),
            ),
          ),
        ],
      ),
    );
  }



  void getIdeaInfo() async {
    //idea 정보들을 가져와 전역변수에 담기
    await dbHelper.initDatabase();
    lstIdeaInfo = await dbHelper.getAllIdeaInfo();
    //idea를 작성한 순서대로 배치해야 하는데, 그러려면 역순으로 배치해야 함
    lstIdeaInfo.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    setState(() {}); //list ui update
  }

  Future setInsertIdeaInfo() async {
    //삽입하는 메서드
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(IdeaInfo(
        title: '환경보존 문제해결 앱 아이디어',
        motive: 'for test',
        content: '환경보존 문제해결 앱 아이디어',
        priority: 5,
        feedback: 'test',
        createdAt: DateTime.now().millisecondsSinceEpoch));
  }

}
