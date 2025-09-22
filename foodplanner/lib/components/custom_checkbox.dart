import 'package:flutter/widgets.dart';
import 'package:foodplanner/config/colors.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    this.controller,
    this.activeColor = AppColors.background,
    this.inactiveColor = AppColors.background,
    this.size = 24.0,
    this.enabled = true,
    this.disabledOpacity = 0.5,
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  /// Determines if widget is enabled
  final bool enabled;

  /// Determines current state.
  final ValueNotifier<bool>? controller;

  /// Determines background color for the active state.
  final Color activeColor;

  /// Determines background color for the inactive state.
  final Color inactiveColor;

  /// Determines width.
  final double size;

  /// Determines opacity of disabled control.
  final double disabledOpacity;

  /// The initial value.
  final bool initialValue;

  /// Called when the value of the switch should change.
  final ValueChanged? onChanged;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 250);
  late ValueNotifier<bool> _controller;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = ValueNotifier<bool>(widget.initialValue); // Always create it

    _valueController.addListener(_handleControllerValueChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: _controller.value ? 1.0 : 0.0, // Use _controller.value
    );
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller?.removeListener(_handleControllerValueChanged);
    _valueController
      ..removeListener(_handleControllerValueChanged)
      ..addListener(_handleControllerValueChanged);

    if (oldWidget.initialValue != widget.initialValue) {
      _valueController.value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handlePressed,
        child: Opacity(
          opacity: _isEnabled ? 1 : widget.disabledOpacity,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: _colorAnimation.value, // Uses the animated color
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _valueController.value
                        ? AppColors.primary
                        : AppColors.primary,
                    width: 2,
                  ),
                ),
                child: _valueController.value
                    ? Center(
                        child: CustomPaint(
                          size: Size(widget.size * 0.6, widget.size * 0.6),
                          painter: CheckmarkPainter(
                            color: AppColors.background,
                            strokeWidth: 3.0,
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  ValueNotifier<bool> get _valueController => widget.controller ?? _controller;

  bool get _isEnabled =>
      widget.enabled && (widget.controller != null || widget.onChanged != null);

  void _handleControllerValueChanged() {
    final nextValue = _valueController.value;
    widget.onChanged?.call(nextValue);

    if (nextValue) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handlePressed() {
    if (!_isEnabled) {
      return;
    }

    _valueController.value = !_valueController.value;
  }

  void _initAnimation() {
    // For a checkbox, we just need a simple scale or opacity animation
    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _valueController.removeListener(_handleControllerValueChanged);

    _controller.dispose();

    _animationController.dispose();

    super.dispose();
  }
}

class CheckmarkPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CheckmarkPainter({
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Define the checkmark path
    final path = Path();

    // Start point (bottom-left of checkmark)
    path.moveTo(size.width * 0.2, size.height * 0.5);

    // Middle point (bottom of checkmark)
    path.lineTo(size.width * 0.45, size.height * 0.7);

    // End point (top-right of checkmark)
    path.lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
