import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SMSModel {
  SMSModel(this.number, this.message, this.state);
  String? number;
  String? message;
  String? state;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SMSModel> list = [
    SMSModel('15100667732', 'Hello 1', '0'),
    // SMSModel('15100667732', 'Hello 2', '0'),
    // SMSModel('15100667732', 'Hello 3', '0'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (var i = 0; i < list.length; i++) {
      widgetList.add(Row(
        children: [
          Text(list[i].number!),
          const SizedBox(
            width: 15,
          ),
          Text(list[i].message!),
          const SizedBox(
            width: 15,
          ),
          Text(list[i].state!),
        ],
      ));
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Example"),
        ),
        body: Container(
          child: Column(
            children: [
              Column(children: widgetList),
              ElevatedButton(
                  child: const Text("Send SMS"),
                  onPressed: () async {
                    sendSMS();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  sendSMS() async {
    for (var i = 0; i < list.length; i++) {
      SmsSender sender = new SmsSender();
      SmsMessage message = new SmsMessage(list[i].number, list[i].message);
      SmsMessage? msg =
          await sender.sendSms(message, simCard: SimCard(slot: 2, imei: ''));
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS sent");
          setState(() {
            list[i].state = '1';
          });
        }
      });

      // SmsStatus result = await BackgroundSms.sendMessage(
      //     phoneNumber: list[i].number!, message: list[i].message!, simSlot: 2);
      // if (result == SmsStatus.sent) {
      //   setState(() {
      //     list[i].state = '1';
      //   });
      // } else {
      //   print("Failed");
      // }
    }
  }
}
