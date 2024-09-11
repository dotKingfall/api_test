import 'package:apitesting/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_card.dart'
    show ecFname, ecAge, ecLname, ecHobbies, cId, selectedIndex;
import 'api_helper.dart' as api;

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

final ccFname = TextEditingController();
final ccAge = TextEditingController();
final ccLname = TextEditingController();
final ccHobbies = TextEditingController();

class _UserListState extends State<UserList> {
  final GlobalKey<FormState> _createFK = GlobalKey();
  late final Future builderFuture = api.getList();

  @override
  void initState() {
    cId.text = "NONE SELECTED";
    super.initState();
  }

  @override
  void dispose() {
    ccFname.dispose();
    ccLname.dispose();
    ccHobbies.dispose();
    ccAge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 35.0, right: 35.0),
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "USERS LIST",
                        style: userListTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Create a new user",
                            style: cblack,
                            textAlign: TextAlign.center,
                          ),
                          content: Form(
                            key: _createFK,
                            child: SizedBox(
                              height: 350,
                              width: 550,
                              child: Column(
                                children: [
                                  cUserField("First Name", 15, ccFname),
                                  cUserField("Last Name", 45, ccLname),
                                  cUserField("Age", 3, ccAge),
                                  cUserField("Hobbies", 150, ccHobbies),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ccFname.text = "";
                                ccLname.text = "";
                                ccHobbies.text = "";
                                ccAge.text = "";
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: cblack,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_createFK.currentState!.validate()) {
                                  api.addUser(ccFname.text, ccLname.text,
                                      ccHobbies.text, ccAge.text);
                                  String tmp = ccFname.text;
                                  ccFname.text = "";
                                  ccLname.text = "";
                                  ccHobbies.text = "";
                                  ccAge.text = "";
                                  setState(() {});
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(api.successSnackbar(tmp, -1));
                                }
                              },
                              child: Text(
                                "Add",
                                style: cblack,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Text(
                      "NEW +",
                      style: cblack,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder(
                future: builderFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return progressIndicator;
                  } else if (snapshot.hasError) {
                    return apiError;
                  } else {
                    return Obx(
                      () => api.users.isEmpty
                          ? Center(
                              child: Text(
                                "NO USERS ADDED",
                                style: userListTitle,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: api.users.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: () {
                                      cId.text = "${api.users[index].id}";
                                      ecFname.text = api.users[index].fName;
                                      ecLname.text = api.users[index].lName;
                                      ecAge.text = "${api.users[index].age}";
                                      ecHobbies.text = api.users[index].hobbies;

                                      selectedIndex = index;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${api.users[index].id}",
                                                style: cardUserId,
                                              ),
                                              Text(
                                                api.users[index].fName,
                                                style: cblack,
                                              ),
                                            ],
                                          ),
                                          const Flexible(
                                            child: FractionallySizedBox(
                                              widthFactor: .7,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Text(
                                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cUserField(String label, int mxLen, TextEditingController c) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextFormField(
      controller: c,
      canRequestFocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: mxLen,
      cursorColor: Colors.grey[800],
      cursorErrorColor: Colors.grey[800],
      cursorHeight: 20,
      style: cblack,
      decoration: cutdec(label),
      validator: (String? value) {
        if (mxLen == 3) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty!";
          } else if (value.isNumericOnly == false) {
            return "You must type a whole positive number";
          } else if (value.isNumericOnly && int.parse(value) <= 5) {
            return "User must be at least 6 years old";
          }
        } else {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty!";
          }
        }
        return null;
      },
    ),
  );
}

Widget noneAdded = Center(
  child: Text(
    "NONE",
    style: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: 40,
    ),
    textAlign: TextAlign.center,
  ),
);

Widget apiError = Center(
  child: Text(
    "SOMETHING WENT WRONG",
    style: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: 40,
    ),
    textAlign: TextAlign.center,
  ),
);

Widget progressIndicator = CircularProgressIndicator(
  color: Colors.grey[800],
);
