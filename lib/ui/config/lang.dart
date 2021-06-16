import 'package:flutter/material.dart';

import 'package:tomo_app/main.dart';
import 'package:tomo_app/ui/model/pref.dart';


class LangData{
  String name;
  String engName;
  String image;
  bool current;
  int id;
  TextDirection direction;
  LangData({this.name, this.engName, this.image, this.current, this.id, this.direction});
}

class Lang {

  static var english = 1;
  static var german = 2;
  static var espanol = 3;
  static var french = 4;
  static var korean = 5;
  static var arabic = 6;
  static var portugal = 7;
  static var rus = 8;

  var direction = TextDirection.ltr;

  List<LangData> langData = [
    LangData(name: "English", engName: "English", image: "assets/usa.png", current: false, id: english, direction: TextDirection.ltr),
    LangData(name: "Deutsh", engName: "German", image: "assets/ger.png", current: false, id: german, direction: TextDirection.ltr),
    LangData(name: "Spana", engName: "Spanish", image: "assets/esp.png", current: false, id: espanol, direction: TextDirection.ltr),
    LangData(name: "Français", engName: "French", image: "assets/fra.png", current: false, id: french, direction: TextDirection.ltr),
    LangData(name: "한국어", engName: "Korean", image: "assets/kor.png", current: false, id: korean, direction: TextDirection.ltr),
    LangData(name: "عربى", engName: "Arabic", image: "assets/arabic.png", current: false, id: arabic, direction: TextDirection.rtl),
    LangData(name: "Português", engName: "Portuguese", image: "assets/portugal.png", current: false, id: portugal, direction: TextDirection.ltr),
    LangData(name: "Русский", engName: "Russian", image: "assets/rus.jpg", current: false, id: rus, direction: TextDirection.ltr),
  ];

  Map<int, String> langEng = {
    // multi-restaurants
    92 : "Total Restaurants",
    105 : "Restaurants",
    116 : "Enter Restaurant Address",
    117 : "Enter Restaurant Phone",
    130 : "Enter Restaurant Mobile Phone",
    179 : "Choose Restaurant",
    186 : "Select Restaurant",
    192 : "The Restaurant field is request",
    207 : "Restaurants",
    208 : "Edit Restaurant",
    209 : "Add Restaurant",
    210 : "Enter Restaurant Name",
    237 : "Restaurants Management: Click for View Edit Delete",

    // all
    10 : "Enter Login",
    11 : "Login or Password in incorrect",
    12 : "Enter Password",
    13 : "Need user with role Administrator or Manager",
    14 : "Login",
    15 : "Password",
    16 : "LOGIN",
    17 : "Forgot password",
    18 : "E-mail address",
    19 : "SEND",
    20 : "Create an Account!",
    21 : "Login",
    22 : "Confirm Password",
    23 : "CREATE ACCOUNT",
    24 : "Orders",
    25 : "Notifications",
    26 : "Help & Support",
    27 : "Account",
    28 : "Languages",
    29 : "Sign Out",
    30 : "App Language",
    31 : "Log Out",
    32 : "User Name",
    33 : "E-mail",
    34 : "Products",
    35 : "Services",
    36 : "Delivery",
    37 : "Misc",
    38 : "Help & support",
    39 : "Not Have Notifications",
    40 : "This is very important information",
    41 : "All",
    42 : "Preparing",
    43 : "Ready",
    44 : "Order ID",
    45 : "Date",
    46 : "Distance",
    47 : "On Map",
    48 : "Accept",
    49 : "km",
    50 : "Not Have Orders",
    51 : "Complete",
    52 : "Customer name",
    53 : "Customer phone",
    54 : "Call to Customer",
    55 : "Back to Orders",
    56 : "Order Details",
    57 : "Subtotal",
    58 : "Shopping costs",
    59 : "Taxes",
    60 : "Total",
    61 : "Back to Map",
    62 : "Online/Offline",
    63 : "Phone",
    64 : "Edit profile",
    65 : "Save",
    66 : "Cancel",
    67 : "Enter your User Name",
    68 : "Enter your User E-mail",
    69 : "Enter your User Phone",
    70 : "Change password",
    71 : "Change",
    72 : "Old password",
    73 : "Enter your old password",
    74 : "New password",
    75 : "Enter your new password",
    76 : "Confirm New password",
    77 : "Open Gallery",
    78 : "Open Camera",
    79 : "Statistics",
    80 : "Earnings",
    81 : "week",
    82 : "month",
    83 : "Earning",
    84 : "Rejection",
    85 : "Reason to Reject",
    86 : "Send",
    87 : "Enter Reason",
    88 : "here",
    89 : "Map",
    90 : "Total Earning",
    91 : "Orders",
    93 : "Total Products",
    94 : "Products",
    95 : "Received",
    96 : "On the way",
    97 : "Delivered",
    98 : "Status",
    99 : "Set To",
    100 : "Set Driver",
    101 : "Change Driver",
    102 : "online",
    103 : "offline",
    104 : "Driver",
    106 : "ADD NEW",
    107 : "Delete",
    108 : "Edit",
    109 : "Yes, delete it!",
    110 : "No, cancel pls!",
    111 : "Are you sure?",
    112 : "You will not be able to recover this item!",
    113 : "Name",
    115 : "Address",
    118 : "Latitude",
    119 : "Enter Latitude. Example: 52.2165157",
    120 : "Longitude",
    121 : "Enter Longitude. Example: 2.331359",
    122 : "Select position on Map",
    123 : "Description",
    124 : "Enter description",
    125 : "Click here for select Image",
    126 : "Select image from:",
    127 : "Camera",
    128 : "Gallery",
    129 : "Select Place and press OK",
    133 : "Dishes List",
    134 : "My Dishes",
    //135 : "Category",
    135 : "A letter with a new password has been sent to the specified E-mail",
    136 : "User with this Email was not found!",
    137 : "Edit Dishes",
    138 : "Add new Dishes",
    139 : "Enter Dishes Name",
    140 : "Price",
    141 : "Enter Dishes price",
    142 : "Discount Price",
    143 : "Enter Discount Price",
    144 : "Ingredients",
    145 : "Enter Ingredients",
    146 : "Choose Food Category",
    147 : "All",
    148 : "Mobile Phone",
    149 : "Menu",
    150 : "Dishes",
    151 : "Reviews",
    152 : "Ingredients",
    153 : "Information",
    154 : "Enter your E-mail",
    //155 : "You E-mail is incorrect",
    155 : "Cancel",
    156 : "User with this Email was not found!",
    157 : "Failed to send Email. Please try again later.",
    158 : "Something went wrong.",
    159 : "A letter with a new password has been sent to the specified E-mail",
    160 : "Categories",
    161 : "VIEW ALL",
    162 : "Total Count:",
    163 : "ID:",
    164 : "Last update:",
    165 : "EDIT",
    166 : "DELETE",
    167 : "Enter Category name",
    168 : "Add New Category",
    169 : "Description",
    170 : "Enter description",
    171 : "Published item",
    172 : "The Name field is request",
    173 : "Current Image: ",
    174 : "PUBLISHED",
    175 : "HIDDEN",
    176 : "",
    177 : "Search",
    178 : "Ok",
    180 : "All",
    181 : "Add New Food",
    182 : "Enter Product name",
    183 : "Price",
    184 : "Enter Price",
    185 : "Select Category",
    187 : "Ingredients",
    188 : "Enter Ingredients",
    189 : "No",
    190 : "Select Nutritions",
    191 : "Select Extras",
    193 : "The Category field is request",
    194 : "The Price field is request",
    195 : "Extras Groups",
    196 : "Edit Extras Groups",
    197 : "Add New Extras Groups",
    198 : "Enter Extras Group Name",
    199 : "Extras",
    200 : "Add",
    201 : "Edit Category",
    202 : "Edit Product",
    203 : "Add Extras",
    204 : "Edit Extras",
    205 : "Select Extras Groups",
    206 : "The Extras Group field is request",
    211 : "Delivery Fee",
    212 : "Insert Delivery Fee",
    213 : "Percents",
    214 : "Delivery fee may be in percentages from order or a given amount.",
    215 : "The following fields are optional:",
    216 : "If `percent` CheckBox is clear, the delivery fee in application set a given amount.",
    217 : "Current:",
    218 : "Delivery Area",
    219 : "Select delivery Area in km or miles (Select in Admin Panel)",
    220 : "Opening Time:",
    221 : "Monday:",
    222 : "Confirm",
    223 : "Tuesday:",
    224 : "Wednesday:",
    225 : "Thursday:",
    226 : "Friday:",
    227 : "Saturday:",
    228 : "Sunday:",
    229 : "The Latitude field is request",
    230 : "The Longitude field is request",
    231 : "Change Driver",
    232 : "Cancelled",
    233 : "YES",
    234 : "NO",
    235 : "Curbside Pickup",
    236 : "Home",
    238 : "Click for Orders Management   Set Order State   Set Driver",
    239 : "Products Management: Click for View Edit Delete",
    240 : "Passwords don't equals",
    241 : "Enter New Password",
    242 : "Old password is incorrect",
    243 : "The password length must be more than 5 chars",
    244 : "Password change",
    245 : "User Profile change",
    246 : "Chat",
    247 : "Choose Category",
    248 : "This is demo application. Your can not modify this section.",
    249 : "Customer comment",
    250 : "You have no permissions",
    251 : "Need user with role Vendor",
    252 : "Shop",
    253 : "Shop Management: Click for View Edit Delete",
    254 : "Edit Shop",
    255 : "Enter Shop Name",
    256 : "Show All my orders",
    257 : "Back to shop",
    258 : "Coupon",
    259 : "The Market: ",
    260 : "have maximum delivery distance is ",
    261 : "is very long.",
    262 : "Product",
    263 : "does not participate in the promotion",
    264 : "The minimum purchase amount must be",
    265 : "Yandex.Kassa",
    266 : "Instamojo",
    267 : "Market",
    268 : "Categories",
    269 : "Sign In with Google",
    270 : "Sign In with Facebook",
    271 : " or ",
    272 : "This email is busy",
    273 : "Log In with Google",
    274 : "Log In with Facebook",
    275 : "Show Delivery Area",
    276 : "This filter will work throughout the application.",
    277 : "Select Address on Map",
    278 : "Add Address",
    279 : "Latitude",
    280 : "Longitude",
    281 : "Home",
    282 : "Work",
    283 : "Other",
    284 : "Default",
    285 : "Addresses not found",
    286 : "Enter address",
    287 : "default",

    288 : "On phone number",
    289 : "send SMS with code. Enter code",
    290 : "Failed to Verify Phone Number",
    291 : "Failed to sign in",
    292 : "Enter Vehicle Number",
    293 : "Vehicle Number",
    294 : "Minimum order amount",
    295 : "Variants",
    296 : "See Also",
    297 : "Reviews",
    298 : "Log In with Apple",
    299 : "Sign In with Apple",
    301 : "Create an Account!",
    302 : "E-mail address",
    303 : "Confirm Password",
    304 : "CREATE ACCOUNT",

    // single market
    1092 : "Total Market",
    1105 : "Market",
    1116 : "Enter Market Address",
    1117 : "Enter Market Phone",
    1130 : "Enter Market Mobile Phone",
    1179 : "Choose Market",
    1186 : "Select Market",
    1192 : "The Market field is request",
    1207 : "Market",
    1208 : "Edit Market",
    1209 : "Add Market",
    1210 : "Enter Market Name",
    1237 : "Market Management: click for Edit Market Information",
    // multi markets
    2092 : "Total Markets",
    2105 : "Markets",
    2116 : "Enter Market Address",
    2117 : "Enter Market Phone",
    2130 : "Enter Market Mobile Phone",
    2179 : "Choose Market",
    2186 : "Select Market",
    2192 : "The Market field is request",
    2207 : "Markets",
    2208 : "Edit Market",
    2209 : "Add Market",
    2210 : "Enter Market Name",
    2237 : "Markets Management: Click for View Edit Delete",
    2238 : "Sign Up",
    2239 : "Agree to the Terms of Service & Privacy Policy",
    2240 : "Account Registration",
    2241 : "GIFTS",

  };

  //
  //
  //
  setLang(int id){
    pref.set(Pref.language, "$id");
    if (id == english) {
      defaultLang = langEng;
      init = true;
    }


    for (var lang in langData) {
      lang.current = false;
      if (lang.id == id) {
        lang.current = true;
        direction = lang.direction;
      }
    }
  }

  Map<int, String> defaultLang;
  var init = false;

  String get(int id){
    if (!init) return "";

    if (theme.appType == "multivendor"){
      switch (id){
        case 105: id = 252; break; // Restaurants -> Shop
        case 208: id = 254; break; // Edit Restaurant -> Edit Shop
        case 210: id = 255; break; // Enter Restaurant Name -> Enter Shop Name
        case 237: id = 253; break; // Restaurants Management: Click for View Edit Delete -> Shop Management: Click for View Edit Delete
      }
    }else {
      if (theme.appTypePre == "market"){
        switch (id){
          case 92: id = 1092; break;
          case 105: id = 1105; break;
          case 116: id = 1116; break;
          case 117: id = 1117; break;
          case 130: id = 1130; break;
          case 179: id = 1179; break;
          case 186: id = 1186; break;
          case 192: id = 1192; break;
          case 207: id = 1207; break;
          case 208: id = 1208; break;
          case 209: id = 1209; break;
          case 210: id = 1210; break;
          case 237: id = 1237; break;
        }
      }
      if (theme.appTypePre == "markets")
        switch (id){
          case 92: id = 2092; break;
          case 105: id = 2105; break;
          case 116: id = 2116; break;
          case 117: id = 2117; break;
          case 130: id = 2130; break;
          case 179: id = 2179; break;
          case 186: id = 2186; break;
          case 192: id = 2192; break;
          case 207: id = 2207; break;
          case 208: id = 2208; break;
          case 209: id = 2209; break;
          case 210: id = 2210; break;
          case 237: id = 2237; break;
        }
    }

    var str = defaultLang[id];
    if (str == null)
      str = "";
    return str;
  }

}

