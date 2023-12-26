import 'package:archive_idea/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database database;

  //데이타 베이스 초기화 및 열기
  initDatabase() async {
    //데이타베이스 경로 가져오기

    String path = join(await getDatabasesPath(), 'archive_idea.db');

    //데이터베이스 열기 / 생성
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        //데이터베이스가 생성될떄 실행되는 코드
        db.execute('''
        CREATE TABLE IF NOT EXISTS tb_idea(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT,
        motive TEXT,
        content TEXT,
        priority INTEGER,
        feedback TEXT,
        createdAt INTEGER
        )
        ''');
      },
    );
  }


  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await database.insert('tb_idea', idea.toMap());
  }

  //조회 select
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await database.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

//수정 update
  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return database
        .update('tb_idea', idea.toMap(), where: 'id = ?', whereArgs: [idea.id]);
  }
//삭제 delete
  Future<int> deleteIdeaInfo(int id) async {
    return database
        .delete('tb_idea', where: 'id = ?', whereArgs: [id]);
  }

  //데이터 베이스 닫기
Future<void> closeDatabase() async{
    await database.close();
}
}
