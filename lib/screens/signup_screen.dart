import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';
import 'package:task_mvp/utils/utils.dart';

import '../provider/auth_provider.dart';
import '../utils/login_text_field.dart';
import '../utils/password_text_field.dart';
import '../utils/phone_number_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------- Logo and Title ------------------------
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "TASK-WAN",
                            style: TextStyle(
                              fontSize: 35,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Management App",
                            style: TextStyle(color: Colors.grey, fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    //------------------- Subtitle -----------------------------
                    Center(
                      child: Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    //------------------- Input Fields --------------------------
                    LoginTextField(
                      controller: fNameController,
                      hintText: 'First Name',
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your First Name' : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    LoginTextField(
                      controller: lNameController,
                      hintText: 'Last Name',
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your Last Name' : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    LoginTextField(
                      controller: emailController,
                      hintText: 'Email',
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    PasswordTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    PhoneNumberField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    //------------------- Date of Birth -------------------------
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: LoginTextField(
                          controller: dobController,
                          hintText: 'Date of Birth',
                          validator: (value) => value!.isEmpty
                              ? 'Please select your date of birth'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    //------------------- Address Field -------------------------
                    LoginTextField(
                      controller: addressController,
                      hintText: 'Address',
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    //------------------- Signup Button -------------------------
                    Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )
                          : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await Provider.of<AuthProvider>(context,
                                  listen: false)
                                  .register(
                                emailController.text,
                                phoneController.text,
                                fNameController.text,
                                lNameController.text,
                                "password",
                                addressController.text,
                                dobController.text,
                                passwordController.text,
                              );
                              showSnackBar(
                                  context, 'Signup Successful');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NavBar()),
                              );
                            } catch (e) {
                              showSnackBar(context,
                                  'Signup failed. Please try again.');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2,
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    //------------------- Already Have Account -----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
