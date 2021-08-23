import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Grades extends StatefulWidget {
  const Grades({Key key}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  DateTime today;
  @override
  Widget build(BuildContext context) {
    today = DateTime.now();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Grades',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Batch').orderBy('StartAt',descending: true).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot>snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.docs.map((mdoc) => FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Batch').doc(mdoc.id).collection('Enrollments').doc(FirebaseAuth.instance.currentUser.phoneNumber).get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                        if (mdata.hasData) {
                          if(mdata.data.exists){
                            return Padding(padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (BuildContext context) => getGrade(batchID: mdoc.id,)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20.h),
                                          child: Text(
                                            mdoc.id, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Class: ' + mdoc['Class'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                            Text('Subject Code: ' + mdoc['Subject'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Timing: ' + mdoc['StartAt'] + ' - ' + mdoc['EndAt'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                            Text('Location: ' + mdoc['Location'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            'Faculty', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top: 10.h,bottom: 20.h),
                                        child: FutureBuilder(
                                            future: FirebaseFirestore.instance.collection('Staff').doc(mdoc['Faculty']).get(),
                                            builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                                              if (mdataa.hasData) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text('Name: ' + mdataa.data['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                                    Text('Phone: ' + mdoc['Faculty'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                                  ],
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else{
                            return Container(height: 0,width: 0,);
                          }
                        } else {
                          return Container(height: 0,width: 0,);
                        }
                      }),
                  ).toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

class getGrade extends StatefulWidget {
  final String batchID;
  const getGrade({Key key, this.batchID}) : super(key: key);

  @override
  _getGradeState createState() => _getGradeState();
}

class _getGradeState extends State<getGrade> {

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.batchID,
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('Grades').orderBy('PostDate',descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot>snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.docs.map((mdoc) {
                      if(mdoc.data().containsKey(FirebaseAuth.instance.currentUser.phoneNumber)){
                        return Padding(
                          padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w,0),
                          child: Container(
                            width: 400.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Container(width:380.w,child: Center(child: Text(mdoc['Title'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,))),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Center(child: Text('Marks: ' + mdoc[FirebaseAuth.instance.currentUser.phoneNumber] + '/' + mdoc['TotalMarks'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,)),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Container(width:380.w,child: Center(child: Text(mdoc['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                                ),
                                SizedBox(
                                  height: 10.h,
                                )

                              ],
                            ),
                          ),
                        );
                      }
                      else{
                        return Container(height: 0,width: 0,);
                      }
                    }).toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

