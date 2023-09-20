import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:faker/faker.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '../utils/drop_list_model.dart';
import '../utils/navigation_service.dart';
import '../utils/select_drop_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import '../utils/utils.dart';
import 'HomePage.dart';
import 'login.dart';

class Register extends StatefulWidget {

  final int version;
  final bool forUpdate;

  const Register(this.version, this.forUpdate, {Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController inPutIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isLoading = false;
  bool found = false;
  bool shouldProceed = false;
  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "Sales Agent"),
    OptionItem(id: "2", title: "HR"),
    OptionItem(id: "3", title: "Cleaner"),
    OptionItem(id: "4", title: "Branch Manager"),
    OptionItem(id: "6", title: "Loan Officer"),
    OptionItem(id: "7", title: "Head Of Sales"),
    OptionItem(id: "8", title: "Head Of Operations"),
    OptionItem(id: "9", title: "Sales(Team Lead) Head office"),
    OptionItem(id: "10", title: "Internal Control"),
    OptionItem(id: "11", title: "Admin Officer"),
    OptionItem(id: "12", title: "Reconciliation Officer"),
    OptionItem(id: "13", title: "Sales(Team Lead) Ondo"),
    OptionItem(id: "14", title: "Sales strategy officer"),
    OptionItem(id: "15", title: "Driver"),
    OptionItem(id: "16", title: "Accountant"),
    OptionItem(id: "17", title: "Investment advisor"),
    OptionItem(id: "18", title: "Customer Service Officer"),
    OptionItem(id: "19", title: "Sales"),
    OptionItem(id: "20", title: "Chief Strategy Holdco/Ag-GM"),
    OptionItem(id: "21", title: "General Manager"),
  ]);
  OptionItem optionItemSelected = OptionItem(id: "d", title: "Select Designation");
  late NavigationService _navigation;
  FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File imageFile = File('');
  bool hasFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            //child: allFields(),
            child: !shouldProceed ? single() : allFields(),
          ),
        ),
      ),
    );
  }

  Widget single(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text("Please enter your ID number located on your ID card"),
        const SizedBox(height: 10),
        TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: inPutIdController,
            // validator: (text) {
            //   if (!text!.startsWith("NTL")) {
            //     return "ID not valid";
            //   }
            //   return null;
            // },
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26)),
              labelText: "ID Number",
              errorStyle: TextStyle(color: Colors.red),
              prefixIcon: Icon(Icons.person),
              hintText: 'eg. GM003',
            )),
        const SizedBox(height: 20),
       found ? Text("ID not found", style: TextStyle(color: Colors.red),) : Container(),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: (){
              if(inPutIdController.text.isNotEmpty){
                getData();
              }else{
                Utils.showToast("ID required");
              }
            },
            child: const Text("Check")
        ),
        const SizedBox(height: 5),
        TextButton(
            onPressed: (){
              _navigation.navigateToPage(Login(widget.version, widget.forUpdate));
            },
            child: Text("Login")
        )
      ],
    );
  }

  @override
  void initState() {
   // getData();
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();

  }

  Future<void> processImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File file = await Utils.compressImages(File(image!.path));
    setState(() {
      imageFile = file;
      hasFile = true;
    });

  }

    Future<String> uploadAndGetUrl(File imageFile) async {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("profile_pics").child("$time.jpg");
      await ref.putFile(imageFile);
      String image = await ref.getDownloadURL();
      return image;
  }

  Widget allFields(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        SizedBox(
            width: 100, height: 100,
            child:
            GestureDetector(
              onTap: () async {
                processImage();
              },
              child: FadedScaleAnimation(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: hasFile ? FileImage(imageFile) : null
                ),

              ),
            ),
        ),
        const SizedBox(height: 10),
        const Text("Select a photo of you"),
        const SizedBox(height: 10),
        TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _fullNameController,
            validator: (text) {
              if (text!.contains("[-+.^:,]")) {
                return "Name not valid!";
              }
              return null;
            },
            onChanged: (value) {

            },
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26)),
              labelText: "Name",
              errorStyle:
              TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.person),
              hintText: 'Name',
            )),
        const SizedBox(height: 10),
        TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: TextEditingController(text: inPutIdController.text),
            enabled: false,
            validator: (text) {
              if (text!.contains("[-+.^:,]")) {
                return "Name not valid!";
              }
              return null;
            },
            onChanged: (value) {

            },
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26)),
              labelText: "ID Number",
              errorStyle:
              TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.person),
              hintText: 'ID Number',
            )),
        const SizedBox(height: 10),
        SelectDropList(
          optionItemSelected,
          dropListModel,
              (optionItem){
            setState(() {
              optionItemSelected = optionItem;
            });
          },
        ),
        const SizedBox(height: 10),
        optionItemSelected.title == "Cleaner" ? Container() : TextFormField(
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Colors.blue,
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (text) {
              if (!text!.contains("@ccsl.ng")) {
                return "Email not valid!";
              }
              return null;
            },
            onChanged: (value) {
            },
            decoration: const InputDecoration(
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26)),
              labelText: "Email(Not required for cleaners)",
              errorStyle: TextStyle(color: Colors.red),
              prefixIcon: Icon(Icons.email),
              hintText: 'Email',

            )) ,
        const SizedBox(height: 10),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          cursorColor: Colors.blue,
          controller: _passController,
          validator: (text) {
            if (text!.length < 8) {
              return "Password too short";
            }
            return null;
          },
          onChanged: (value) {
          },
          decoration: const InputDecoration(
            focusColor: Colors.blue,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26)),
            labelText: "Password",
            errorStyle: TextStyle(color: Colors.red),
            prefixIcon: Icon(Icons.lock),
            hintText: 'Password',

          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
            onPressed: (){
              if(_fullNameController.text.isNotEmpty){
                if(inPutIdController.text.isNotEmpty){
                  if(optionItemSelected.title != "Select Designation"){
                    
                    if(optionItemSelected.title == "Cleaner"){

                        if(_passController.text.length > 7){
                          register(_fullNameController.text,
                              inPutIdController.text,
                              _emailController.text,
                              optionItemSelected.title,
                              _passController.text);
                        }else{
                          Utils.showToast("password is too short");
                        }

                    }else{
                      if(_emailController.text.contains("ccsl.ng")){

                        if(_passController.text.length > 7){
                          register(_fullNameController.text,
                              inPutIdController.text,
                              _emailController.text,
                              optionItemSelected.title,
                              _passController.text);
                        }else{
                          Utils.showToast("password is too short");
                        }

                      }else{
                        Utils.showToast("Email Address must be a ---- email");
                      }
                    }

                   
                  }else{
                    Utils.showToast("Please select a department");
                  }
                }else{
                  Utils.showToast("Something is seriously wrong, please restart the app");
                }
              }else{
                Utils.showToast("Name is required");
              }
            },
            child: const Text("Continue")
        ),
        const SizedBox(height: 5),
        TextButton(
            onPressed: (){
              _navigation.navigateToPage( Login(widget.version, widget.forUpdate));
            },
            child: Text("Login")
        )
      ],
    );
  }

  void getData(){
    List<dynamic> list = [];
    setState(() {
      isLoading = true;
    });
    staffs.doc("ids").get().then((value) async {
      setState(() {
        list = value.data()!["id_number"];
        shouldProceed = list.contains(inPutIdController.text.replaceAll(" ", ""));
        isLoading = false;
        found = !shouldProceed;
      });

    }).onError((error, stackTrace) {
      setState(() {
        isLoading = true;
      });
      Utils.showToast("Something went wrong, try again");
    });
  }

  Future<void> register(String name, String id, String email_, String department, String pass) async {
    final faker = Faker();

    String email = email_ == "" ? faker.internet.email() : email_;

    setState(() {
      isLoading = true;
    });

    var document = await users.doc(id).get();
    if(document.exists){
      setState(() {
        isLoading = false;
      });
      Utils.showToast("You have an account already, please login");
    }else{
      auth.createUserWithEmailAndPassword(email: email.replaceAll(" ", ""), password: pass)
          .then((value) async {

        if(imageFile == null || imageFile.path == null || imageFile.path.isEmpty){
          //String url = await uploadAndGetUrl(imageFile);

          await users.doc(id).set({
            "name":name,
            "app_version":Utils.appVersion,
            "emp_status":true,
            "work_state":"OUT",
            "reg_time": FieldValue.serverTimestamp(),
            "email":email,
            "department":department,
            "id_number":id,
            "last_report":"NONE",
            "image": "https://firebasestorage.googleapis.com/v0/b/---.appspot.com/o/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg?alt=media&token=95a3b265-2240-464d-b27c-65751651171f",
            "system_time": FieldValue.serverTimestamp(),
          }).then((value) async {

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('id', id); // key,value

            setState(() {
              isLoading = false;
            });
            _navigation.navigateToPage( MyHomePage(widget.forUpdate, widget.version));
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
            Utils.showToast("Something went wrong");
          });
        }else{
          String url = await uploadAndGetUrl(imageFile);
          await users.doc(id).set({
            "name":name,
            "emp_status":true,
            "work_state":"OUT",
            "email":email,
            "department":department,
            "id_number":id,
            "image":url,
            "last_report":"NONE",
            "app_version": Utils.appVersion,
            "system_time": FieldValue.serverTimestamp(),
            "reg_time": FieldValue.serverTimestamp(),
          }).then((value) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('id', id); // key,value
            setState(() {
              isLoading = false;
            });
           // _navigation.navigateToPage(const MyHomePage());
            _navigation.removeAndNavigateToRoute("/home");
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
            Utils.showToast("Something went wrong");
          });
        }

      }).onError((error, stackTrace) {
        Utils.showToast("Something went wrong: $error");
        setState(() {
          isLoading = false;
        });
      });
    }

  }

}
