import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/components/text_field.dart';

// class for editable fields / tiles on the settings pages
class EditableSettingsTile extends StatefulWidget {
  final String title;
  final String initialValue;
  final String hintText;
  final bool isEdited;
  final ValueChanged<String> onChanged;
  final bool obscure;

  const EditableSettingsTile({
    super.key, 
    required this.title,
    required this.initialValue,
    required this.isEdited,
    required this.onChanged,
    required this.obscure,
    this.hintText = '',
  });

  @override
  State<StatefulWidget> createState() => _EditableSettingsTileState();
}

class _EditableSettingsTileState extends State<EditableSettingsTile> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant EditableSettingsTile oldWidget){
    super.didUpdateWidget(oldWidget);
    if(oldWidget.isEdited && !widget.isEdited && !_isEditing){
      _controller.text = widget.initialValue;
    }
    if(!_isEditing && widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose;
    _controller.dispose;
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
    });
  }

  void _onEditPressed(){
    setState(() {
      _isEditing = true;
      _focusNode.requestFocus();
    });
  }

  Widget _buildContent() {
    if (_isEditing || widget.isEdited){
      return Center(
        child: Container(
          width: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: CustomTextField(
            controller: _controller,
            errorText: '',
            hintText: widget.hintText,
            obscureText: widget.obscure,
            color: Colors.transparent,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            borderShown: false,
          ),
        ),
      );
    } else {
      return Row (
        mainAxisAlignment:MainAxisAlignment.end,
        children: [
          Text(
            widget.hintText,
            style: AppTextStyles.bigText,
          )
        ]
      );
    }
  }

  Widget _buildIconButton() {
    return IconButton(
      icon: SFIcon(
        SFIcons.sf_pencil,
        color: AppColors.textPrimary,
        fontSize: 28,
      ),
      onPressed: _onEditPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsWidget(
      title: widget.title,
      type: SettingsType.inlineItems,
      showSpacer: false,
      cta: Expanded(
        child: Row(
          children: [
            Expanded(
              child: _buildContent(),
            ),
            _buildIconButton(),
          ],
        ),
      )
    );
  }
}