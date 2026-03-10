import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: responsive.sp(20),
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_square,
              color: AppTheme.greenPrimary,
              size: responsive.sp(24),
            ),
            onPressed: () {
              // TODO: New message
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(responsive.sp(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: responsive.sp(80),
                color: AppTheme.greyMedium,
              ),
              SizedBox(height: responsive.sp(24)),
              Text(
                'No Messages Yet',
                style: TextStyle(
                  fontSize: responsive.sp(20),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: responsive.sp(12)),
              Text(
                'Start conversations with your community members',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  color: AppTheme.greyMedium,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.sp(24)),
              ElevatedButton(
                onPressed: () {
                  // TODO: Start new conversation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.greenPrimary,
                  foregroundColor: AppTheme.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.sp(32),
                    vertical: responsive.sp(14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Start Messaging',
                  style: TextStyle(
                    fontSize: responsive.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
