import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class TranslationOverlay extends StatefulWidget {
  final String originalText;
  final String translatedText;
  final VoidCallback onClose;

  const TranslationOverlay({
    Key? key,
    required this.originalText,
    required this.translatedText,
    required this.onClose,
  }) : super(key: key);

  @override
  State<TranslationOverlay> createState() => _TranslationOverlayState();
}

class _TranslationOverlayState extends State<TranslationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String _sourceLanguage = 'English';
  String _targetLanguage = 'Yoruba';

  final List<String> _languages = [
    'English',
    'Yoruba',
    'Hausa',
    'Igbo',
    'French',
    'Arabic',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    _controller.reverse().then((_) => widget.onClose());
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
    });
  }

  void _copyTranslation() {
    Clipboard.setData(ClipboardData(text: widget.translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Translation copied to clipboard'),
        backgroundColor: AppTheme.greenPrimary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: _handleClose,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping the card
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: EdgeInsets.all(responsive.sp(24)),
                  constraints: BoxConstraints(
                    maxWidth: responsive.sp(500),
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(responsive.sp(16)),
                        decoration: BoxDecoration(
                          color: AppTheme.greenPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppTheme.radiusLarge),
                            topRight: Radius.circular(AppTheme.radiusLarge),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.translate,
                              color: AppTheme.white,
                              size: responsive.sp(24),
                            ),
                            SizedBox(width: responsive.sp(12)),
                            Text(
                              'Translation',
                              style: TextStyle(
                                fontSize: responsive.sp(18),
                                fontWeight: FontWeight.w700,
                                color: AppTheme.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppTheme.white,
                                size: responsive.sp(24),
                              ),
                              onPressed: _handleClose,
                            ),
                          ],
                        ),
                      ),

                      // Language selector
                      Padding(
                        padding: EdgeInsets.all(responsive.sp(16)),
                        child: Row(
                          children: [
                            Expanded(
                              child: _LanguageDropdown(
                                value: _sourceLanguage,
                                languages: _languages,
                                onChanged: (value) {
                                  setState(() {
                                    _sourceLanguage = value!;
                                  });
                                },
                                responsive: responsive,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.swap_horiz,
                                color: AppTheme.greenPrimary,
                                size: responsive.sp(28),
                              ),
                              onPressed: _swapLanguages,
                            ),
                            Expanded(
                              child: _LanguageDropdown(
                                value: _targetLanguage,
                                languages: _languages,
                                onChanged: (value) {
                                  setState(() {
                                    _targetLanguage = value!;
                                  });
                                },
                                responsive: responsive,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: AppTheme.greySoft),

                      // Translation content
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(responsive.sp(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Original text
                              Text(
                                'Original',
                                style: TextStyle(
                                  fontSize: responsive.sp(12),
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.greyMedium,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: responsive.sp(8)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(responsive.sp(12)),
                                decoration: BoxDecoration(
                                  color: AppTheme.greySoft.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMedium,
                                  ),
                                ),
                                child: Text(
                                  widget.originalText,
                                  style: TextStyle(
                                    fontSize: responsive.sp(15),
                                    color: AppTheme.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.sp(20)),

                              // Translated text
                              Row(
                                children: [
                                  Text(
                                    'Translation',
                                    style: TextStyle(
                                      fontSize: responsive.sp(12),
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.greyMedium,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Copy button
                                  InkWell(
                                    onTap: _copyTranslation,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusSmall,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.sp(8),
                                        vertical: responsive.sp(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.copy,
                                            size: responsive.sp(16),
                                            color: AppTheme.greenPrimary,
                                          ),
                                          SizedBox(width: responsive.sp(4)),
                                          Text(
                                            'Copy',
                                            style: TextStyle(
                                              fontSize: responsive.sp(12),
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.greenPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: responsive.sp(8)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(responsive.sp(12)),
                                decoration: BoxDecoration(
                                  color: AppTheme.greenPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMedium,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.greenPrimary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  widget.translatedText,
                                  style: TextStyle(
                                    fontSize: responsive.sp(15),
                                    color: AppTheme.textPrimary,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(height: 1, color: AppTheme.greySoft),

                      // Footer with info
                      Padding(
                        padding: EdgeInsets.all(responsive.sp(12)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: responsive.sp(16),
                              color: AppTheme.greyMedium,
                            ),
                            SizedBox(width: responsive.sp(8)),
                            Expanded(
                              child: Text(
                                'Translations are powered by AI and may not be 100% accurate',
                                style: TextStyle(
                                  fontSize: responsive.sp(11),
                                  color: AppTheme.greyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String value;
  final List<String> languages;
  final ValueChanged<String?> onChanged;
  final Responsive responsive;

  const _LanguageDropdown({
    required this.value,
    required this.languages,
    required this.onChanged,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(12),
        vertical: responsive.sp(8),
      ),
      decoration: BoxDecoration(
        color: AppTheme.greySoft.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppTheme.textPrimary,
          size: responsive.sp(24),
        ),
        style: TextStyle(
          fontSize: responsive.sp(14),
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
        items: languages.map((language) {
          return DropdownMenuItem(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
