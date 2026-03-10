import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/media_attachment.dart';
import '../../widgets/create_post/content_type_button.dart';
import '../../widgets/create_post/media_preview_item.dart';
import '../../widgets/create_post/expandable_text_field.dart';
import '../../widgets/create_post/option_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Media attachments
  final List<MediaAttachment> _attachments = [];
  
  // Selected options
  String? _selectedLocation;
  String _selectedCategory = 'Infrastructure';
  String _selectedPriority = 'Normal';
  String _selectedLanguage = 'English';
  String? _selectedFeeling;
  List<String> _taggedPeople = [];
  
  // Categories and priorities
  final List<String> _categories = [
    'Infrastructure',
    'Event',
    'Announcement',
    'Security',
    'Environment',
    'Health',
  ];
  
  final List<String> _priorities = ['Normal', 'High Risk', 'Emergency'];
  final List<String> _languages = ['English', 'Yoruba', 'Hausa', 'Igbo'];

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // Media picking methods
  Future<void> _pickPhotoVideo() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMediaPickerSheet(),
    );
  }

  Widget _buildMediaPickerSheet() {
    final responsive = context.responsive;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
          topRight: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: responsive.sp(12)),
            Container(
              width: responsive.sp(40),
              height: responsive.sp(4),
              decoration: BoxDecoration(
                color: AppTheme.greyMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: responsive.sp(20)),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.greenPrimary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.greenPrimary),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppTheme.greenPrimary),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
            SizedBox(height: responsive.sp(12)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      for (var image in images) {
        final file = File(image.path);
        final fileSize = await file.length();
        
        setState(() {
          _attachments.add(MediaAttachment(
            id: _uuid.v4(),
            type: MediaType.image,
            file: file,
            fileName: image.name,
            fileSize: fileSize,
          ));
        });
      }
    } catch (e) {
      _showError('Failed to pick images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final file = File(photo.path);
        final fileSize = await file.length();
        
        setState(() {
          _attachments.add(MediaAttachment(
            id: _uuid.v4(),
            type: MediaType.image,
            file: file,
            fileName: photo.name,
            fileSize: fileSize,
          ));
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        final file = File(video.path);
        final fileSize = await file.length();
        
        setState(() {
          _attachments.add(MediaAttachment(
            id: _uuid.v4(),
            type: MediaType.video,
            file: file,
            fileName: video.name,
            fileSize: fileSize,
          ));
        });
      }
    } catch (e) {
      _showError('Failed to record video: $e');
    }
  }

  Future<void> _pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            setState(() {
              _attachments.add(MediaAttachment(
                id: _uuid.v4(),
                type: MediaType.audio,
                file: File(file.path!),
                fileName: file.name,
                fileSize: file.size,
              ));
            });
          }
        }
      }
    } catch (e) {
      _showError('Failed to pick audio: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            setState(() {
              _attachments.add(MediaAttachment(
                id: _uuid.v4(),
                type: MediaType.file,
                file: File(file.path!),
                fileName: file.name,
                fileSize: file.size,
              ));
            });
          }
        }
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  void _removeAttachment(String id) {
    setState(() {
      _attachments.removeWhere((attachment) => attachment.id == id);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.alertOrange,
      ),
    );
  }

  void _handlePost() {
    if (_textController.text.trim().isEmpty && _attachments.isEmpty) {
      _showError('Please add some content to your post');
      return;
    }

    // TODO: Implement post creation logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: AppTheme.greenPrimary,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Post',
          style: TextStyle(
            fontSize: responsive.sp(18),
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(responsive.sp(8)),
            child: ElevatedButton(
              onPressed: _handlePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.greenPrimary,
                foregroundColor: AppTheme.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(20),
                  vertical: responsive.sp(10),
                ),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main post card
            Container(
              margin: EdgeInsets.all(responsive.sp(12)),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User header
                  _buildUserHeader(responsive),
                  
                  // Text input
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
                    child: ExpandableTextField(
                      controller: _textController,
                      focusNode: _textFocusNode,
                      hintText: "What's on your mind?",
                      minLines: 3,
                      maxLines: 10,
                    ),
                  ),
                  
                  SizedBox(height: responsive.sp(12)),
                  
                  // Media previews
                  if (_attachments.isNotEmpty) _buildMediaPreviews(responsive),
                  
                  // Content type buttons
                  _buildContentTypeButtons(responsive),
                  
                  SizedBox(height: responsive.sp(12)),
                ],
              ),
            ),
            
            // Custom options
            _buildCustomOptions(responsive),
            
            SizedBox(height: responsive.sp(80)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Row(
        children: [
          CircleAvatar(
            radius: responsive.sp(24),
            backgroundColor: AppTheme.greenPrimary,
            child: Icon(
              Icons.person,
              size: responsive.sp(28),
              color: AppTheme.white,
            ),
          ),
          SizedBox(width: responsive.sp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: responsive.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.sp(2)),
                Row(
                  children: [
                    Icon(
                      Icons.public,
                      size: responsive.sp(14),
                      color: AppTheme.greyMedium,
                    ),
                    SizedBox(width: responsive.sp(4)),
                    Text(
                      'Public',
                      style: TextStyle(
                        fontSize: responsive.sp(12),
                        color: AppTheme.greyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreviews(Responsive responsive) {
    return Container(
      height: responsive.sp(130),
      margin: EdgeInsets.only(
        left: responsive.sp(16),
        bottom: responsive.sp(12),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachments.length,
        itemBuilder: (context, index) {
          return MediaPreviewItem(
            media: _attachments[index],
            onRemove: () => _removeAttachment(_attachments[index].id),
          );
        },
      ),
    );
  }

  Widget _buildContentTypeButtons(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(12),
        vertical: responsive.sp(12),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.greySoft,
            width: 1,
          ),
        ),
      ),
      child: Wrap(
        spacing: responsive.sp(8),
        runSpacing: responsive.sp(8),
        children: [
          ContentTypeButton(
            icon: Icons.photo_library,
            label: 'Photo/Video',
            isSelected: _attachments.any((a) => 
              a.type == MediaType.image || a.type == MediaType.video),
            onTap: _pickPhotoVideo,
          ),
          ContentTypeButton(
            icon: Icons.audiotrack,
            label: 'Audio',
            isSelected: _attachments.any((a) => a.type == MediaType.audio),
            onTap: _pickAudio,
          ),
          ContentTypeButton(
            icon: Icons.insert_drive_file,
            label: 'File',
            isSelected: _attachments.any((a) => a.type == MediaType.file),
            onTap: _pickFile,
          ),
          ContentTypeButton(
            icon: Icons.videocam,
            label: 'Live Video',
            activeColor: Colors.red,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Live video coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomOptions(Responsive responsive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sp(12)),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(responsive.sp(16)),
            child: Text(
              'Add to your post',
              style: TextStyle(
                fontSize: responsive.sp(14),
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          
          // Options row 1
          Wrap(
            children: [
              OptionButton(
                icon: Icons.location_on,
                label: 'Location',
                iconColor: AppTheme.greenPrimary,
                showBadge: _selectedLocation != null,
                onTap: () => _showLocationPicker(responsive),
              ),
              OptionButton(
                icon: Icons.person_add,
                label: 'Tag People',
                iconColor: Colors.blue,
                showBadge: _taggedPeople.isNotEmpty,
                onTap: () {
                  // TODO: Implement tag people
                },
              ),
              OptionButton(
                icon: Icons.mood,
                label: 'Feeling/Activity',
                iconColor: Colors.amber,
                showBadge: _selectedFeeling != null,
                onTap: () {
                  // TODO: Implement feeling/activity
                },
              ),
            ],
          ),
          
          Divider(height: 1, color: AppTheme.greySoft),
          
          // Category selector
          _buildCategorySelector(responsive),
          
          Divider(height: 1, color: AppTheme.greySoft),
          
          // Priority selector
          _buildPrioritySelector(responsive),
          
          Divider(height: 1, color: AppTheme.greySoft),
          
          // Language selector
          _buildLanguageSelector(responsive),
          
          SizedBox(height: responsive.sp(8)),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                size: responsive.sp(18),
                color: AppTheme.greyMedium,
              ),
              SizedBox(width: responsive.sp(8)),
              Text(
                'Category',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.sp(12)),
          Wrap(
            spacing: responsive.sp(8),
            runSpacing: responsive.sp(8),
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                selectedColor: AppTheme.greenPrimary,
                checkmarkColor: AppTheme.white,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                  fontSize: responsive.sp(12),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: AppTheme.greySoft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.priority_high,
                size: responsive.sp(18),
                color: AppTheme.greyMedium,
              ),
              SizedBox(width: responsive.sp(8)),
              Text(
                'Priority Level',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.sp(12)),
          Wrap(
            spacing: responsive.sp(8),
            runSpacing: responsive.sp(8),
            children: _priorities.map((priority) {
              final isSelected = _selectedPriority == priority;
              Color priorityColor = AppTheme.greenPrimary;
              if (priority == 'High Risk') priorityColor = Colors.orange;
              if (priority == 'Emergency') priorityColor = AppTheme.alertOrange;
              
              return FilterChip(
                label: Text(priority),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = priority;
                  });
                },
                selectedColor: priorityColor,
                checkmarkColor: AppTheme.white,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                  fontSize: responsive.sp(12),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: AppTheme.greySoft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Row(
        children: [
          Icon(
            Icons.language,
            size: responsive.sp(18),
            color: AppTheme.greyMedium,
          ),
          SizedBox(width: responsive.sp(8)),
          Text(
            'Language:',
            style: TextStyle(
              fontSize: responsive.sp(14),
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(width: responsive.sp(12)),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              underline: const SizedBox(),
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(
                    language,
                    style: TextStyle(
                      fontSize: responsive.sp(13),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(Responsive responsive) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
            topRight: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: responsive.sp(12)),
            Container(
              width: responsive.sp(40),
              height: responsive.sp(4),
              decoration: BoxDecoration(
                color: AppTheme.greyMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(responsive.sp(16)),
              child: Text(
                'Select Location',
                style: TextStyle(
                  fontSize: responsive.sp(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.my_location, color: AppTheme.greenPrimary),
              title: const Text('Use current location'),
              onTap: () {
                setState(() {
                  _selectedLocation = 'Current Location';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
