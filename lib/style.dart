import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle cwhite = GoogleFonts.montserrat(
  color: Colors.white,
);

TextStyle cblack = GoogleFonts.montserrat(
  color: Colors.black,
);

TextStyle title = GoogleFonts.chakraPetch(color: Colors.white, fontSize: 40);

//Create user textfield decoration
cutdec(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelStyle: GoogleFonts.montserrat(
      color: Colors.grey[800],
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
    errorStyle: GoogleFonts.montserrat(
      color: const Color(0xffb00000),
    ),
  );
}

TextStyle userListTitle = GoogleFonts.montserrat(
  color: Colors.grey[800],
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

TextStyle cardUserId = GoogleFonts.montserrat(
  color: Colors.grey[800],
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

eutdec(String label) {
  return InputDecoration(
    labelText: label,
    border: InputBorder.none,
    floatingLabelStyle: cwhite,
    labelStyle: cwhite,
    counterStyle: cwhite,
    counterText: "",
    errorStyle: GoogleFonts.montserrat(
      color: Colors.white24,
    ),
  );
}

TextStyle save(Color color){
  return GoogleFonts.montserrat(
    color: color,
    fontSize: 24,
  );
}

InputDecoration iddec = InputDecoration(
  border: InputBorder.none,
  floatingLabelStyle: null,
  labelStyle: cwhite,
  counterStyle: cwhite,
  counterText: "",
);