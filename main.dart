import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String r_num='',r_msg='';
int co=0;
Future main() async {
  receive();
  runApp(
    MaterialApp(title: 'sms_app', home:MyApp1()),

  );
  SmsQuery query = new SmsQuery();
  List<SmsMessage> messages = await query.getAllSms;


}

void receive() {
  SmsReceiver receiver = new SmsReceiver();
  receiver.onSmsReceived.listen((SmsMessage msg){
    print(msg.address);
    print(msg.body);
    r_num=msg.address;
    r_msg=msg.body;
    Map<String, String>data = <String, String>{
      "number": "123",
      "messages": "ji",
    };
    DocumentReference documentReference =
    Firestore.instance.collection("users").document("inbox");

    documentReference.setData(data).whenComplete((){
      print("data inserted");
    }).catchError((e)=>print(e) );
  });
}


class MyApp1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyApp();
  }
}

class MyApp extends State<MyApp1> {
  String msg, num;
  TextEditingController c1=TextEditingController();
  TextEditingController c2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*  theme: ThemeData(

        primarySwatch: Colors.blue,
      ),*/
        appBar: AppBar(
          title: Text('sms_app'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                controller: c1,
                decoration: InputDecoration(
                    labelText: 'number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),

              ),

                TextField(
                  controller: c2,
                  decoration: InputDecoration(
                      labelText: 'message',

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  

                ),

              RaisedButton(
                  child: Text('send'),
                  onPressed: () {
                    setState(() {
                      send_sms();
                    });

                  }),
                    ListTile(
                      title: Text(r_num),
                      subtitle: Text(r_msg),

                    )





          ],
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  send_sms() {
    num=c1.text;
    msg=c2.text;
    SmsSender sender = SmsSender();
    SmsMessage message = new SmsMessage(num,msg);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("sms is sent");
      } else if (state == SmsMessageState.Delivered) {
        print("sms is delivered");
      }
    });
    sender.sendSms(message);
  }
}
