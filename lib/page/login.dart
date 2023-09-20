import 'package:credit_capital/page/register.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../utils/navigation_service.dart';
import 'package:get_it/get_it.dart';

import '../utils/utils.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {


  final int version;
  final bool forUpdate;

  const Login(this.version, this.forUpdate, {Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isLoading = false;
  late NavigationService _navigation;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Image.asset("assets/logo_black.png", height: 100,),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Colors.blue,
                    controller: _emailController,
                    validator: (text) {
                      if (!text!.contains("@")) {
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
                      labelText: "Email",
                      errorStyle:
                      TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',

                    )),
                const SizedBox(height: 20),

                TextFormField(
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
                      errorStyle:
                      TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',

                    ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                    onPressed: (){
                      if(_emailController.text.isNotEmpty && _passController.text.isNotEmpty){
                        login(_emailController.text, _passController.text);
                      }else{
                        Utils.showToast("Please fill out everything");
                      }
                    },
                    child: const Text("Continue")
                ),
                const SizedBox(height: 10),

                TextButton(
                    onPressed: (){
                      _navigation.navigateToPage(Register(widget.version, widget.forUpdate));
                    },
                    child: Text("Register")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String pass){
    setState(() {
      isLoading = true;
    });
    auth.signInWithEmailAndPassword(email: email, password: pass)
        .then((value) async {

      await users.doc(auth.currentUser?.uid).get().then((value) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', value.get("id_number")); // key,value
      });


      setState(() {
        isLoading = false;
      });
      _navigation.removeAndNavigateToRoute("/home");
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utils.showToast("There was a problem logging you in");
    });
  }

}
