library api;

import 'package:flutter/material.dart';

import '../main.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

var users = [].obs;
final dio = Dio(BaseOptions(baseUrl: "http://localhost:8000/"));

Future getList() async {
  var res = await dio.get("list");
  for (var el in res.data) {
    users.add(
      User(
          id: el["id"],
          fName: el["fname"],
          lName: el["lname"],
          hobbies: el["hobbies"],
          age: el["age"]),
    );
  }
  return res.data;
}

addUser(String fn, ln, hbb, age) async {
  DateTime base = DateTime.now();
  String tmp = "${base.day}${base.millisecond}${users.length + 1}";
  var res =
      await dio.post("add?id=$tmp&fname=$fn&lname=$ln&hobbies=$hbb&age=$age");
  if (res.data['res'] == 0) {
    users.add(
      User(
        id: int.parse(tmp),
        fName: fn,
        lName: ln,
        hobbies: hbb,
        age: int.parse(age),
      ),
    );
  }
  return 1;
}

updtUser(String id, fn, ln, hbb, age, int index) async {
  await dio.put(
      "updt?id=$id&fname_new=$fn&lname_new=$ln&hobbies_new=$hbb&age_new=$age");
  users[index].fName = fn;
  users[index].lName = ln;
  users[index].hobbies = hbb;
  users[index].age = int.parse(age);
  return 1;
}

delUser(String id, int index) async{
  await dio.delete("del?id=$id");
  users.removeAt(index);
  return 1;
}

SnackBar successSnackbar(String name, int method){
  if(method == 0){
    return SnackBar(content: Text("You have deleted $name's user."));
  }
  else if(method == 1){
    return SnackBar(content: Text("You have updated $name's info."));
  }
  return SnackBar(content: Text("You have added $name as an user."));
}