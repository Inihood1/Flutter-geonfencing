import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/navigation_service.dart';
import '../utils/utils.dart';
import 'HomePage.dart';



class StartPage extends StatefulWidget {

  final int version;
  final bool forUpdate;

  const StartPage(this.version, this.forUpdate, {Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  late NavigationService _navigation;
  bool isLoading = false;
  bool hasFile = false;
  bool found = false;
  bool shouldProceed = false;
  final TextEditingController inPutIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome"),),
      body: LoadingOverlay(
        isLoading: isLoading,
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            //child: allFields(),
            child:  Center(child: single()),
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
        Image.asset("assets/logo_black.png", height: 100,),
        const SizedBox(height: 20),
        const Text("Please enter your ID number located on your ID card. Form is case sensitive"),
        const SizedBox(height: 10),
        TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: inPutIdController,
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
        // const SizedBox(height: 5),
        // TextButton(
        //     onPressed: (){
        //       _navigation.navigateToPage( Login(widget.geofenceService, widget.version, widget.forUpdate));
        //     },
        //     child: Text("Login")
        // )
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
      });
      if(list.contains(inPutIdController.text.replaceAll(" ", ""))){
        setState(() {
          shouldProceed = list.contains(inPutIdController.text.replaceAll(" ", ""));
          found = !shouldProceed;
          isLoading = false;
        });
        getUserData(inPutIdController.text.replaceAll(" ", ""));
      }else{
        setState(() {
          isLoading = false;
        });
        Utils.showToast("ID not found");
      }

    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utils.showToast("Something went wrong, try again");
    });
  }

  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();

  }


  Future<void> getUserData(String id) async {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    if(shouldProceed){
      String email = await users.doc(id).get().then((value) => value.get("email"));
      auth.signInWithEmailAndPassword(email: email, password: "12345678").then((value) async {
        setState(() {
          isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', id); // key,value
        //_navigation.navigateToPage(MyHomePage(widget.forUpdate, widget.version));
        _navigation.removeAndNavigateToRoute('/home');
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        //print(error);
        if(error.toString().contains("wrong-password")){
          Utils.showToast("Wrong password");
        }else{
          Utils.showToast("Something went wrong");
        }
      });
    }
  }

}
