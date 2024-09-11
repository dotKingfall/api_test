import 'package:apitesting/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_helper.dart' as api;

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

int selectedIndex = -1;
bool isEditing = false;
final GlobalKey<FormState> _changeFK = GlobalKey<FormState>();

//Editing controllers
final ecFname = TextEditingController();
final ecLname = TextEditingController();
final ecAge = TextEditingController();
final ecHobbies = TextEditingController();
final cId = TextEditingController();

class _UserCardState extends State<UserCard> {
  @override
  void dispose() {
    ecFname.dispose();
    ecLname.dispose();
    ecAge.dispose();
    ecHobbies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 5.0),
      width: 350,
      height: 700,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: IconButton(
                  onPressed: () {
                    if (selectedIndex >= 0) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text("Are you sure?"),
                                content: Text(
                                    "${api.users[selectedIndex].fName} will be deleted."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: cblack,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      String tmp =
                                          api.users[selectedIndex].fName;
                                      api.delUser(cId.text, selectedIndex);
                                      ecFname.text = "";
                                      ecLname.text = "";
                                      ecHobbies.text = "";
                                      ecAge.text = "";
                                      cId.text = "NONE SELECTED";
                                      setState(() {
                                        selectedIndex = -1;
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              api.successSnackbar(tmp, 0));
                                    },
                                    child: Text(
                                      "Yes!",
                                      style: cblack,
                                    ),
                                  ),
                                ]);
                          });
                    }
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                    size: 36,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: cId,
                  canRequestFocus: false,
                  style: cwhite,
                  decoration: iddec,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: IconButton(
                  onPressed: () {
                    if (selectedIndex != -1) {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    }
                  },
                  icon: isEditing
                      ? const Icon(
                          Icons.edit_off,
                          color: Colors.white,
                          size: 30,
                        )
                      : const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Image(
              image: AssetImage("assets/no-image.png"),
            ),
          ),
          Form(
            key: _changeFK,
            child: Container(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Column(
                children: [
                  eUserField("First Name", 15, ecFname),
                  eUserField("Last Name", 45, ecLname),
                  eUserField("Age", 3, ecAge),
                  eUserField("Hobbies", 150, ecHobbies),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: isEditing == false
                ? null
                : () {
                    if (_changeFK.currentState!.validate()) {
                      if (checkChanges()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return confirmChoice(context);
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          //TODO
                          const SnackBar(
                            content: Text("Nothing has changed! :)"),
                          ),
                        );
                      }
                    }
                  },
            child: Text(
              "SAVE",
              style: isEditing == false
                  ? save(Colors.transparent)
                  : save(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget eUserField(String label, int mxLen, TextEditingController c) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextFormField(
      controller: c,
      canRequestFocus: isEditing,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: mxLen,
      cursorColor: Colors.white,
      cursorErrorColor: Colors.white,
      cursorHeight: 20,
      style: cwhite,
      decoration: eutdec(label),
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

Widget confirmChoice(BuildContext context) {
  return AlertDialog(
    title: Text(
      "Are you sure?",
      style: cblack,
    ),
    content: SizedBox(
      height: 200,
      width: 550,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Before",
                  style: cblack,
                ),
                Text(
                  api.users[selectedIndex].fName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  api.users[selectedIndex].lName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  api.users[selectedIndex].hobbies,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  "${api.users[selectedIndex].age}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          separate,
          SizedBox(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Now",
                  style: cblack,
                ),
                Text(
                  ecFname.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  ecLname.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  ecHobbies.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  ecAge.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: cblack,
        ),
      ),
      TextButton(
        onPressed: () {
          api.updtUser(cId.text, ecFname.text, ecLname.text, ecHobbies.text,
              ecAge.text, selectedIndex);
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(api.successSnackbar(ecFname.text, 1));
        },
        child: Text(
          "Yes!",
          style: cblack,
        ),
      ),
    ],
  );
}

bool checkChanges() {
  bool somethingChanged = false;
  if (ecFname.text != api.users[selectedIndex].fName) {
    somethingChanged = true;
  }
  if (ecLname.text != api.users[selectedIndex].lName) {
    somethingChanged = true;
  }
  if (ecHobbies.text != api.users[selectedIndex].hobbies) {
    somethingChanged = true;
  }
  if (ecAge.text != "${api.users[selectedIndex].age}") {
    somethingChanged = true;
  }
  return somethingChanged;
}

Widget separate = const VerticalDivider(
  color: Colors.black45,
);