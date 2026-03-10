import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../utils/responsive.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _selectedCategory = AppConstants.reportCategories[0];
  String _selectedPriority = 'Normal';
  String _selectedType = 'Text';
  String _selectedLanguage = 'en';
  XFile? _selectedMedia;
  
  final List<String> _priorities = ['Normal', 'High Risk', 'Emergency'];
  final List<String> _postTypes = ['Text', 'Video', 'Audio'];

  @override
  void dispose() {
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Create Report'),
        backgroundColor: AppTheme.white,
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              'Post',
              style: TextStyle(
                color: AppTheme.greenPrimary,
                fontSize: responsive.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.sp(AppTheme.spacing16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Type Selection
            _buildSectionTitle('Report Type', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            _buildPostTypeSelector(responsive),
            
            SizedBox(height: responsive.sp(AppTheme.spacing20)),
            
            // Content Input
            _buildSectionTitle('Description', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe the issue or incident...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing20)),
            
            // Media Selection
            if (_selectedType != 'Text') ...[
              _buildSectionTitle('Media', responsive),
              SizedBox(height: responsive.sp(AppTheme.spacing8)),
              _buildMediaPicker(responsive),
              SizedBox(height: responsive.sp(AppTheme.spacing20)),
            ],
            
            // Category Selection
            _buildSectionTitle('Category', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(16),
                  vertical: responsive.sp(12),
                ),
              ),
              items: AppConstants.reportCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing20)),
            
            // Priority Selection
            _buildSectionTitle('Priority Level', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            _buildPrioritySelector(responsive),
            
            SizedBox(height: responsive.sp(AppTheme.spacing20)),
            
            // Location Input
            _buildSectionTitle('Location', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing20)),
            
            // Language Selection
            _buildSectionTitle('Language', responsive),
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(16),
                  vertical: responsive.sp(12),
                ),
              ),
              items: AppConstants.supportedLanguages.map((lang) {
                return DropdownMenuItem(
                  value: lang.code,
                  child: Text(lang.nativeName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing32)),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.sp(16),
                  ),
                ),
                child: Text(
                  'Submit Report',
                  style: TextStyle(fontSize: responsive.sp(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Responsive responsive) {
    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.sp(16),
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildPostTypeSelector(Responsive responsive) {
    return Row(
      children: _postTypes.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type != _postTypes.last ? responsive.sp(8) : 0,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.sp(12),
                  horizontal: responsive.sp(4),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.greenPrimary : AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: isSelected ? AppTheme.greenPrimary : AppTheme.greySoft,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPostTypeIcon(type),
                      color: isSelected ? AppTheme.white : AppTheme.greyMedium,
                      size: responsive.sp(28),
                    ),
                    SizedBox(height: responsive.sp(4)),
                    Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                        fontSize: responsive.sp(13),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelector(Responsive responsive) {
    return Wrap(
      spacing: responsive.sp(8),
      runSpacing: responsive.sp(8),
      children: _priorities.map((priority) {
        final isSelected = _selectedPriority == priority;
        return ChoiceChip(
          label: Text(
            priority,
            style: TextStyle(
              fontSize: responsive.sp(13),
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedPriority = priority;
            });
          },
          selectedColor: priority == 'Emergency'
              ? AppTheme.alertOrange
              : priority == 'High Risk'
                  ? AppTheme.alertOrange.withOpacity(0.8)
                  : AppTheme.greenPrimary,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: responsive.sp(13),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(12),
            vertical: responsive.sp(8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMediaPicker(Responsive responsive) {
    return InkWell(
      onTap: _pickMedia,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        height: responsive.sp(150),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.greySoft, width: 2),
        ),
        child: _selectedMedia == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _selectedType == 'Video' ? Icons.videocam : Icons.audiotrack,
                    size: responsive.sp(48),
                    color: AppTheme.greyMedium,
                  ),
                  SizedBox(height: responsive.sp(8)),
                  Text(
                    'Tap to select ${_selectedType.toLowerCase()}',
                    style: TextStyle(
                      fontSize: responsive.sp(14),
                      color: AppTheme.greyMedium,
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.greenPrimary,
                      size: responsive.sp(48),
                    ),
                    SizedBox(height: responsive.sp(8)),
                    Text(
                      'Media selected',
                      style: TextStyle(
                        fontSize: responsive.sp(14),
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  IconData _getPostTypeIcon(String type) {
    switch (type) {
      case 'Video':
        return Icons.videocam;
      case 'Audio':
        return Icons.audiotrack;
      default:
        return Icons.text_fields;
    }
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    
    if (_selectedType == 'Video') {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      setState(() {
        _selectedMedia = video;
      });
    } else if (_selectedType == 'Audio') {
      // In production, use audio picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio picker would open here')),
      );
    }
  }

  void _getCurrentLocation() {
    // In production, use geolocator to get current location
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Getting current location...')),
    );
  }

  void _handleSubmit() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    // In production, submit to API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted successfully!')),
    );
    Navigator.pop(context);
  }
}
