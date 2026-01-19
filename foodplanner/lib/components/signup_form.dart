import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/password_requirements.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/signup_form_model.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';

class SignupForm extends StatefulWidget {

  final String title, buttonText;
  final Widget? selection;
  final Future<void> Function(Map<String, String>) onSubmit;
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  const SignupForm({
    super.key,
    required this.title,
    required this.buttonText,
    this.selection,
    required this.onSubmit,
  });

  @override
  State<SignupForm> createState() =>  SignupFormState();
}

class SignupFormState extends State<SignupForm> {

  SignupFormModel model = SignupFormModel();

  bool isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    model.passwordFocus.addListener(_onFocusChange);
  }

  void dispose() {
    model.passwordFocus.removeListener(_onFocusChange);
    
    model.dispose();
    super.dispose();
  }

  // Changing current state based on whether the password field is active
  void _onFocusChange() {
    setState(() {
      isPasswordFocused = model.passwordFocus.hasFocus;
    });
  }

  Widget _buildHintText(String hintText){
    return Text(
      hintText,
      style: AppTextStyles.bigText.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller, String errorText, FocusNode focusNode, void Function(String) onChanged, bool obscureText){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomTextField(
        controller: controller,
        errorText: errorText,
        hintText: hintText,
        focusNode: focusNode,
        onChanged: onChanged,
        obscureText: obscureText,
      ),
    );
  }

  List<Widget> _buildFormBody() {
    return [
      SizedBox(height: 10),
      Text(widget.title, style: AppTextStyles.title),
      SizedBox(height: 10),

      _buildHintText('Fornavn'),
      _buildInputField(
        'Fornavn', 
        model.firstNameController, 
        model.firstNameError, 
        model.firstNameFocus, 
        (input) => setState(() => model.validateFirstName()),
        false,
      ),
      SizedBox(height: 15),

      _buildHintText('Efternavn'),
      _buildInputField(
        'Efternavn', 
        model.lastNameController, 
        model.lastNameError, 
        model.lastNameFocus, 
        (input) => setState(() => model.validateLastName()),
        false,
      ),
      SizedBox(height: 15),

      _buildHintText('Email'),
      _buildInputField(
        'Email', 
        model.emailController, 
        model.emailError, 
        model.emailFocus, 
        (input) => setState(() => model.validateEmail()), 
        false,
      ),
      SizedBox(height: 15),

      _buildHintText('Adgangskode'),
      _buildInputField(
        'Adgangskode', 
        model.passwordController, 
        isPasswordFocused ? '' : model.passwordError, 
        model.passwordFocus, 
        (input) { 
          setState(() {
            model.validatePassword();
            model.validateConfirmPassword();
          });
        }, 
        true,
      ),

      if (isPasswordFocused) // only show list of password requirements if user is active in password field
        PasswordRequirements(
          validationStatus: model.passwordValidationStatus,
        ),
      SizedBox(height: 15),

      _buildHintText('Bekræft adgangskode'),
      _buildInputField(
        'Bekræft adgangskode', 
        model.confirmPasswordController, 
        model.confirmPasswordError, 
        model.confirmPasswordFocus, 
        (input) => setState(() => model.validateConfirmPassword()), 
        true
      ),
      SizedBox(height: 15),
      if (widget.selection != null) widget.selection!,
    ];
  }

  void _submit() {
    setState(() {
      model.validateAll();
    });

    if(model.hasError) {
      return;
    }

    widget.onSubmit(model.formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Egebakkeskolen\nFoodplanner',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 3,
              child: Column(
                children: _buildFormBody(),
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: widget.buttonText,
              onTab: model.fieldsNotEmpty && !model.hasError ? _submit : null, // if fields are not empty and none has an error, activate the button for signing up
            ),
          ],
        ),
      ),
    );
  }
}
