

import 'dart:async';
import 'dart:math';
import 'package:attendencemanager/box.dart';
import 'package:attendencemanager/subjectmodel.dart';
import 'package:flutter/material.dart';
import 'package:attendencemanager/subject_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
var days=0;
var overallattendence=0.0;
var subject_no=0;
var status=0;
late Box box;
var subjectname;
bool _alreadyshown = true;
//var statusString="";
List<subject_details> subject=[];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(subjectModelAdapter());
  box = await Hive.openBox('subjectstored');
  if(getdays('days')!=null) {
    days = await getdays('days');
  }
  if(await gettotalsubjects('subject_number')!=101010) {
    subject_no = await gettotalsubjects('subject_number');
    print(subject_no);
  }
  for(int i=0;i<subject_no;i++){
    subject_Model s = await getdata(i, 'subjectlocation');
    var l = await getlast(i);
    subject.add(subject_details(name: s.name,present_days: s.presnetdaysinhive,absent_days: s.absentdaysinhive));
    subject[i].total_days;
    subject[i].last_action = l;
    subject[i].coloroftile = Colors.primaries[Random().nextInt(Colors.primaries.length)].shade900;
  }
    //for(int i=0;i<1;i++){
      //print(getstoringdata(0));
    //}
  // if(getdata(0, 'subjectlocation')!=null){
  //   subject_Model s = await getdata(0, 'subjectlocation');
  //   subject.add(subject_details(name: s.name,present_days: s.presnetdaysinhive,absent_days: s.absentdaysinhive));
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
      textTheme: GoogleFonts.interTextTheme()
      ,scaffoldBackgroundColor: Color.fromRGBO(49, 56, 75, 100)),
      title: 'Flutter Demo',
      home: splash(),
    );
  }
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 1),
        () =>  Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) => days==0?wrapping(): home())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/immigration.png',
        width: 200, height: 200,),
      ),
    );
  }
}
class wrapping extends StatefulWidget {
  const wrapping({Key? key}) : super(key: key);

  @override
  State<wrapping> createState() => _wrappingState();
}

class _wrappingState extends State<wrapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(0.0),
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(("Set Your Criteria "),
                    style: TextStyle(color: Colors.white
                        ,fontSize: 18),), SizedBox(height: 10,),
                  Text("${days} %",
                    style: TextStyle(color: Colors.white,
                        fontSize: 16),),
                  Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      divisions: 100,
                      min: 0.0,
                      max: 100.0,
                      value: days.toDouble(),
                      onChanged: (value){
                        setState((){
                          if(value!=0 && value!=100) {
                            days = value.toInt();
                          }
                        });
                      }),
                  TextButton(onPressed: (){storedays('days', days);Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));}, child: Text("Save", style: TextStyle(color: Colors.white,fontSize: 18),))
                ],
              ),
            )
        ),
      ),
    );
  }
}


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  void initState(){
    super.initState();
  }

  String error = " ";
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    return SafeArea(child:
      Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            error = " ";
            showModalBottomSheet(isScrollControlled:true,context: context,
                builder: (context){
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(49, 55, 68, 15)
                ),
                child: Padding(
                  padding: EdgeInsets.only(top:15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20 ,horizontal: 60),
                      child:
                          Column(
                            mainAxisAlignment : MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            SizedBox(height: 10,),
                      Text("Add Subject",style:
                        TextStyle(fontSize: 18,color: Colors.white),),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: myController,
                        decoration:
                        InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: "Enter Subject name",
                          labelStyle: TextStyle(color: Colors.white)
                        ),style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                          ),),
                          TextButton(
                              onPressed: (){
                                if(!myController.text.isEmpty && !(myController.text.trim().isEmpty)) {
                                  subject.add(subject_details(
                                    name: myController.text.trimLeft(),
                                    present_days: 0,
                                    absent_days: 0,));
                                  putdata(myController.text.trimLeft(), 0, 0, subject_no,
                                      'subjectlocation');
                                  putlast(subject_no, " ");
                                  subject[subject_no].coloroftile =  Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800;

                                  subject_no++;
                                  puttotalsubjects(
                                      'subject_number', subject_no);
                                  print(subject_no);
                                  print(subject);
                                  setState((){});
                                  Navigator.pop(context);
                                }
                                else{
                                  setState((){});
                                }
                              },
                              child: Text("Add"),style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                          ),),
                        ],
                      ),]),
                    ),
                  ),
                ),
              );
                });
          },
          backgroundColor: Color.fromRGBO(49, 55, 68, 10),
          child: Icon(Icons.add),
        ),
      body: HomeSheet(),
    ),
    );
  }
}



class HomeSheet extends StatefulWidget {
  const HomeSheet({Key? key}) : super(key: key);

  @override
  State<HomeSheet> createState() => _HomeSheetState();
}

class _HomeSheetState extends State<HomeSheet> {
  @override
  void initState(){
    super.initState();
    _initBannerAd();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  _initBannerAd(){
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState((){
              _isAdLoaded = true;
            });
            },
            onAdFailedToLoad: (ad,error) {}
        ),
        request: AdRequest());
    _bannerAd.load();
  }

  var getColor;
  getcolor(S){
    var s=Colors.green;
    var y=Colors.red;
      if(S>=days){
        return s;
      }
      else{
        return y;
      }
}
getcardcolor(S){
    var s= Color.fromRGBO(18, 65, 19, 100);
    var y= Color.fromRGBO(73, 23, 24, 80);
    if(S>=days){
      return s;
  }
    else{
      return y;
  }
  }
refresh(){
    for(int i=0;i<subject.length;i++) {
      subject[i].statusString =
          setStatus(subject[i].present_days, subject[i].total_days);
    }
    setState((){});
}
  setStatus(int presentdays, int totaldays) {
    int i=1;
    int counter=0;
    if ((((days * totaldays) - (100 * presentdays)) / (100-days)).ceil() > 0) {
      status = (((days * totaldays) - (100 * presentdays)) / (100-days)).ceil();
      return "Attend next ${status} classes to get\nback on track ";
    }
    while(i<i+1){
      if (((presentdays / (totaldays+i)) * 100) > days) {
        counter=i;
        i=i+1;
      }
      else {
        break;
      }
    }
    if(counter==1){
      return "You may leave next class";
    }
    if (counter>0) {
      return "You may leave next ${counter} classes";
    }
    else {
      return "You cannot leave next class";
    }
  }
  @override
  Widget build(BuildContext context) {
    String now = DateFormat("MMMM").format(DateTime.now());
    String now2 = DateFormat("dd").format(DateTime.now());
    String now3 = DateFormat("yyyy").format(DateTime.now());
    return Column(
      children:[
        Column(
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:[
       ]),
            //SizedBox(height: 10,),
            Boxes(height: MediaQuery.of(context).size.height * 0.10, width: MediaQuery.of(context).size.width * 0.96,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(("  ${now}"),style: TextStyle(
                        fontSize: 18
                        ,color: Colors.white
                    ),),
                    Text((" ${now2}"),style: TextStyle(
                        fontSize: 18
                        ,color: Colors.white
                    ),),
                    Text(" ${now3}",style: TextStyle(
                        fontSize: 14
                        ,color: Colors.white
                    ),),]),
                    SizedBox(height: 15,),
                    GestureDetector(
                    onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => criteria())).then((value) => setState((){refresh();}));}, child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10,),
                            Text("Goal : ",
                            style:TextStyle(//fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white24,
                            ),),
                            Text("${days}%",
                            style: TextStyle(fontWeight: FontWeight.w400,
                              fontSize: 26,
                              color: Colors.white,
                            ),)
                          ],
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
            ),],
        ),
        SizedBox(height: 2,),
        Expanded(
    child:
        ListView.builder(
          itemCount: subject.length,
        itemBuilder: (context,index){
            return GestureDetector(
            onTap: (){},
              onLongPress: (){
              showModalBottomSheet(
                  context: context,
                  builder: (context){
                    return SingleChildScrollView(
                      child: Container(
                        color: Color.fromRGBO(49, 55, 68, 15),
                        child: Column(
                          children: [
                            TextButton(onPressed: (){
                              showModalBottomSheet(context: context, builder: (context){
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(49, 55, 68, 15)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top:15,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20 ,horizontal: 40),
                                        child:
                                        Column(
                                            mainAxisAlignment : MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("Are you Sure?",style:
                                              TextStyle(fontSize: 18,color: Colors.white),),
                                              SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children:[
                                                  TextButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("No"),style: ButtonStyle(
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

                                                  ),),
                                                  TextButton(
                                                    onPressed: (){
                                                      if(subject[index].total_days>0) {
                                                        setState(() {
                                                          if (subject[index].last_action.endsWith(
                                                              "1")) {
                                                            subject[index].present_days =
                                                                subject[index].present_days - 1;
                                                            subject[index].totalDays();
                                                            subject[index].subjectpercentage();
                                                            subject[index].last_action =
                                                                subject[index].last_action.substring(0,
                                                                    subject[index].last_action.length -
                                                                        1);
                                                            subject[index].statusString = setStatus(
                                                                subject[index].present_days,
                                                                subject[index].total_days);
                                                            putdata(subject[index].name,
                                                                subject[index].present_days,
                                                                subject[index].absent_days, index,
                                                                'subjectlocation');
                                                            putlast(index, subject[index].last_action);
                                                            Navigator.pop(context);
                                                          }
                                                          else {
                                                            subject[index].absent_days =
                                                                subject[index].absent_days - 1;
                                                            subject[index].totalDays();
                                                            subject[index].subjectpercentage();
                                                            subject[index].last_action =
                                                                subject[index].last_action.substring(0,
                                                                    subject[index].last_action.length -
                                                                        1);
                                                            subject[index].statusString = setStatus(
                                                                subject[index].present_days,
                                                                subject[index].total_days);
                                                            putdata(subject[index].name,
                                                                subject[index].present_days,
                                                                subject[index].absent_days, index,
                                                                'subjectlocation');
                                                            putlast(index, subject[index].last_action);
                                                            Navigator.pop(context);
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Text("Yes"),style: ButtonStyle(
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                                  ),),
                                                ],
                                              ),]),
                                      ),
                                    ),
                                  ),
                                );
                              });

                            }, child: Text("Undo")
                              ,style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),),
                            TextButton(onPressed: (){
                              showModalBottomSheet(context: context, builder: (context){
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(49, 55, 68, 15)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top:15,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20 ,horizontal: 40),
                                        child:
                                        Column(
                                            mainAxisAlignment : MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("Are you Sure?",style:
                                              TextStyle(fontSize: 18,color: Colors.white),),
                                              SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children:[
                                                  TextButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("No"),style: ButtonStyle(
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

                                                  ),),
                                                  TextButton(
                                                    onPressed: (){
                                                      setState((){
                                                        subject[index].present_days=0;
                                                        subject[index].absent_days=0;
                                                        subject[index].totalDays();
                                                        subject[index].subjectpercentage();
                                                        subject[index].statusString=setStatus(subject[index].present_days, subject[index].total_days);
                                                        putdata(subject[index].name, 0, 0, index, 'subjectlocation');
                                                        putlast(index, " ");
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text("Yes"),style: ButtonStyle(
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                                  ),),
                                                ],
                                              ),]),
                                      ),
                                    ),
                                  ),
                                );
                              });

                            }, child: Text("Reset Attendence")
                            ,style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),),
                            TextButton(onPressed: (){
                              showModalBottomSheet(context: context, builder: (context){
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(49, 55, 68, 15)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top:15,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20 ,horizontal: 40),
                                        child:
                                        Column(
                                            mainAxisAlignment : MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("Are you Sure?",style:
                                              TextStyle(fontSize: 18,color: Colors.white),),
                                              SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children:[
                                                  TextButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("No"),style: ButtonStyle(
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

                                                  ),),
                                                  TextButton(
                                                    onPressed: (){
                                                      setState((){
                                                        subject.removeAt(index);
                                                        for(int i=0;i<subject.length;i++){
                                                          putdata(subject[i].name, subject[i].present_days, subject[i].absent_days, i, 'subjectlocation');
                                                          putlast(i, subject[i].last_action);
                                                        }
                                                        subject_no--;
                                                        puttotalsubjects('subject_number', subject_no);
                                                        Navigator.of(context)..pop()..pop();
                                                      });
                                                    },
                                                    child: Text("Yes"),style: ButtonStyle(
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                                  ),),
                                                ],
                                              ),]),
                                      ),
                                    ),
                                  ),
                                );
                              });

                            }, child: Text("Delete Subject")
                            ,style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),),
                          ],
                        ),
                      ),
                    );
                  });
              },
                child:Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Color.fromRGBO(59, 65, 79, 100),
              elevation: 1,
              shadowColor: getcardcolor(subject[index].getsubjectpercentage()),
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white12
                      ),
                    )
                    ),
              Container(
              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 14),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 9,),
                        Text(subject[index].name
                        ,style: TextStyle(fontSize: 21.0,color: Colors.white,
                          fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10,),
                        Text("Attendance : ",style:
                          TextStyle(fontSize:9,color: Colors.white30),
                        ),
                        Text("${subject[index].present_days} / ${subject[index].gettotalDays().toString()}",
                        style: TextStyle(fontSize: 15.0,color: Colors.white),
                        ),
                        SizedBox(height: 4.0,),
                        Text("Status :",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white30
                        ),),
                        Text(subject[index].statusString,maxLines: 2,
                        style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(3.0),
                          padding: EdgeInsets.all(9.0),
                          decoration: BoxDecoration(

                            ),
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(10.0),
                            // ),color: getcolor(subject[index].getsubjectpercentage()),
                          child: Text("${subject[index].getsubjectpercentage().toStringAsFixed(2)}",
                          style: TextStyle(
                          fontSize: 18
                          ,color: getcolor(subject[index].getsubjectpercentage()).shade50,
                          fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          children:[
                            IconButton(onPressed: (){
                              setState(() {
                                subject[index].present_days=subject[index].present_days+1;
                                subject[index].totalDays();
                                subject[index].subjectpercentage();
                                print(subject[index].present_days);
                                subject[index].lastactionset(1);
                                subject[index].statusString=setStatus(subject[index].present_days, subject[index].total_days);
                                putdata(subject[index].name, subject[index].present_days, subject[index].absent_days, index, 'subjectlocation');
                                putlast(index, subject[index].last_action);
                              });
                            }, icon: Icon(Icons.check,color: Colors.green,)),
                        IconButton(onPressed: (){
                          setState(() {
                            subject[index].absent_days=subject[index].absent_days+1;
                            subject[index].totalDays();
                            subject[index].subjectpercentage();
                            print(subject[index].absent_days);
                            subject[index].lastactionset(0);
                            subject[index].statusString=setStatus(subject[index].present_days, subject[index].total_days);
                            putdata(subject[index].name, subject[index].present_days, subject[index].absent_days, index, 'subjectlocation');
                            putlast(index, subject[index].last_action);
                          });
                          }, icon: Icon(Icons.close,color: Colors.red,)),
          ]
          ),
                      ],
                    ),
                  ],
              ),
            ),GFProgressBar(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      percentage: subject[index].getsubjectpercentage()/100,
                      lineHeight: 1,
                      alignment: MainAxisAlignment.spaceBetween,
                      child: const Text('80%', textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      backgroundColor: GFColors.TRANSPARENT,
                      progressBarColor: getcolor(subject[index].getsubjectpercentage()),
                    ),
                  SizedBox(height: 10,),],
              ),
                  ),
                ),
            );
        },
        ),),
    Container(
            width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: _isAdLoaded? AdWidget(ad: _bannerAd):SizedBox(height: 20,))
    ],
    );
  }

  getthecolor() {
    var Color =  Colors.primaries[Random().nextInt(Colors.primaries.length)].shade700;
    if(Color==Colors.red.shade700){
      Color =  Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800;
    }
    if(Color==Colors.red.shade700){
      Color =  Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800;
    }
    return Color;
  }
}


class addpage extends StatefulWidget {
  const addpage({Key? key}) : super(key: key);

  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {
  @override
  void initState(){
    super.initState();
    ss();
  }
  ss(){
    setState((){});
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:Container(
      child: Column(
        children: [ Expanded(
       child:
          ListView.builder(
              itemCount: subject.length,
              itemBuilder: (context , index){
                return GestureDetector(
                  onLongPress: (){

                  },
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(subject[index].name,
                    style: TextStyle(color: Colors.white24),),
                  ),
                ));
              }),),
          addsubjectdialog(),
        ],
      ),
        ),
    );
  }
}

// class Addsubject extends StatelessWidget {
//   const Addsubject({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final myController = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Subject"),
//       ),
//         body:
//         Container(
//       child: Column(
//         children: [
//           TextField(
//             controller: myController,
//             decoration:
//             InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: "Enter Subject name",
//             ),
//           ),
//           TextField(
//             decoration:
//             InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: " ",
//             ),
//           ),
//           Row(
//             children:[
//               TextButton(
//                   onPressed: (){
//                     Navigator.pop(context);
//                   },
//                   child: Text("Cancel")),
//           TextButton(
//               onPressed: (){
//                 subject_no++;
//                 subject.add(subject_details(name: myController.text,present_days: 0,absent_days: 0,));
//                 putdata(myController.text, 0, 0, myController.text, 'subjectlocation');
//                 putid(subject_no, myController.text);
//                 print(subject);
//                 Navigator.pop(context);
//               },
//               child: Text("Add")),
//     ],
//           ),
//         ],
//       ),
//         ),
//     );
//   }
// }

class addsubjectdialog extends StatelessWidget {
  const addsubjectdialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    return TextButton(onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Add Subject"),
          actions: [
            Column(
              children: [
                TextField(
                  controller: myController,
                  decoration:
                  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Subject name",
                  ),
                ),
                SizedBox(height: 10.0,),
                Row(
                  children:[
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: (){
                          subject.add(subject_details(name: myController.text,present_days: 0,absent_days: 0,));
                          subject[subject_no--].totalDays();
                          putdata(myController.text, 0, 0, subject_no, 'subjectlocation');
                          putlast(subject_no, " ");
                          subject_no++;
                          puttotalsubjects('subject_number', subject_no);
                          print(subject_no);
                          print(subject);
                          Navigator.pop(context);
                        },
                        child: Text("Add")),
                  ],
                ),
              ],
            ),
            ],
        ),),
        child: const Text("Add Subject"));
  }
}


Widget listtile_(){
  return Row(
    children: [
      Column(
        children: [
          Text("1")
        ],
      ),
      Column(
        children: [
          Text("1")
        ],
      )
    ],
  );
}

class criteria extends StatefulWidget {
  const criteria({Key? key}) : super(key: key);

  @override
  State<criteria> createState() => _criteriaState();
}

class _criteriaState extends State<criteria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(("Set Your Criteria "),
                style: TextStyle(color: Colors.white
                ,fontSize: 18),), SizedBox(height: 10,),
                Text("${days} %",
                style: TextStyle(color: Colors.white,
                fontSize: 16),),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  divisions: 100,
                    min: 0.0,
                    max: 100.0,
                    value: days.toDouble(),
                    onChanged: (value){
                  setState((){
                    if(value!=0 && value!=100) {
                      days = value.toInt();
                    }
                  });
                    }),
                TextButton(onPressed: (){storedays('days', days);Navigator.pop(context);}, child: Text("Save", style: TextStyle(color: Colors.white,fontSize: 18),))
            ],
            ),
          )
        ),
      ),
    );
  }
}

class addsubject extends StatefulWidget {
  const addsubject({Key? key}) : super(key: key);

  @override
  State<addsubject> createState() => _addsubjectState();
}

class _addsubjectState extends State<addsubject> {
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    return Container(
      child:
      Column(children: [TextField(
        controller: myController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter Subject Name"
        ),
      ),
      SizedBox(height: 20,),
        TextButton(onPressed: () {
          Navigator.pop(context);
        },
            child: Text("Cancel")),
        TextButton(onPressed: (){},
            child: Text("Add"))
      ]),
    );
  }
}
