import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'comment.dart';
class Comments extends StatefulWidget {
  int postId;
   Comments({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComments(widget.postId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("data"),
          FutureBuilder<List<Comment>>(
            future: fetchComments(widget.postId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(3.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: (){
                            int id= snapshot.data![index].id;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Comments( postId: id),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black26
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data![index].email, style: const TextStyle(color: Colors.white, fontSize: 22),),
                                  ),
                                ),
                              )

                            ],
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
Future<List<Comment>> fetchComments (int posId) async {
final response= await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$posId'));
if(response.statusCode==200){
  return commentFromJson(response.body);
}else{
  throw Exception('error occurred');
}
}
