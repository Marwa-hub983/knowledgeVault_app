import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/colors.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';
import 'package:knowledge_vault_app/shared/constants/responsive/responsive_utils.dart';
import 'package:knowledge_vault_app/shared/constants/text_fields/text_field.dart';

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 42),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 260,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFE3DFFF),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock),
                          Text(
                            'ENCRYPTED WORKSPACE',
                            style: FontPalette.hW700S16.copyWith(
                              color: Color(0xFF17145C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Welcome Back', style: FontPalette.hW700S32),
                    SizedBox(height: 8),
                    Text(
                      'Login in to access your personal knowledge vault',
                      style: FontPalette.hW400S14,
                    ),

                    SizedBox(height: 18),
                    _buildLoginUi(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildLoginUi() {
  return Container(
    height: 480,
    decoration: BoxDecoration(
      color: kWhiteOverlay20,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
      
          TextFeildWidget(
            prefix: const Icon(Icons.email_outlined),
            hintText: 'name@example.com',
            topLabelText: 'Email Address',
          ),
      
          const SizedBox(height: 12),
      
          TextFeildWidget(
            prefix: const Icon(Icons.lock),
            topLabelText: 'Password',
            hintText: 'Enter your password',
      
            // Toggle password visibility
            obscureText: !isVisible,
      
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Icon(
                isVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
          ),
          SizedBox(height: 12,),
          Row(
            children: [Spacer(),
            Text('Forgot Password',style: FontPalette.hW500S16.copyWith(color: kPrimaryColor),)],
          )
        ],
      ),
    ),
  );
}

}
