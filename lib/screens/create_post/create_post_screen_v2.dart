import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/media_attachment.dart';
import '../../widgets/create_post/borderless_text_field.dart';
import '../../widgets/create_post/control_chip.dart';
import '../../widgets/create_post/action_sheet.dart';
import '../../widgets/create_post/media_preview_item.dart';

class CreatePostScreenV2 extends StatefulWidget {
  const CreatePostScreenV2({Key? key}) : super(key: key);

  @override
  State<CreatePostScreenV2> createState() => _CreatePostScreenV2State();
}

class _CreatePostScreenV2State extends State<CreatePostScreenV2> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // State
  bool _hasContent = false;
  List<MediaAttachment> _attachments = [];
  String _selectedAudience = 'Public';
  String _selectedCategory = 'Infrastructure';
  String _selectedPriority = 'Normal';
  String _selectedLanguage = 'English';
  String? _selectedLocation;
  Color? _backgroundColor;
  double _sheetHeight = 420;

  // Options
  final List<String> _audiences = ['Public', 'Followers', 'Private'];
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
  void initState() {
    super.initState();
    _textController.addListener(_updateContentState);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _updateContentState() {
    setState(() {
      _hasContent = _textController.text.trim().isNotEmpty || _attachments.isNotEmpty;
    });
  }

  // Media Pickers
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
          topLeft: Radius.circular(responsive.sp(20)),
          topRight: Radius.circular(responsive.sp(20)),
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
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.green),
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
          _sheetHeight = 250; // Collapse sheet
        });
      }
      _updateContentState();
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
          _sheetHeight = 250;
        });
        _updateContentState();
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
          _sheetHeight = 250;
        });
        _updateContentState();
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
              _sheetHeight = 250;
            });
          }
        }
        _updateContentState();
      }
    } catch (e) {
      _showError('Failed to pick audio: $e');
    }
  }

  void _removeAttachment(String id) {
    setState(() {
      _attachments.removeWhere((attachment) => attachment.id == id);
      if (_attachments.isEmpty) {
        _sheetHeight = 420; // Expand sheet
      }
    });
    _updateContentState();
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
    if (!_hasContent) {
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

  void _showAudienceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelectorSheet(
        title: 'Select Audience',
        options: _audiences,
        currentValue: _selectedAudience,
        onSelected: (value) {
          setState(() {
            _selectedAudience = value;
          });
        },
      ),
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelectorSheet(
        title: 'Select Category',
        options: _categories,
        currentValue: _selectedCategory,
        onSelected: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
      ),
    );
  }

  void _showPrioritySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelectorSheet(
        title: 'Select Priority',
        options: _priorities,
        currentValue: _selectedPriority,
        onSelected: (value) {
          setState(() {
            _selectedPriority = value;
          });
        },
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelectorSheet(
        title: 'Select Language',
        options: _languages,
        currentValue: _selectedLanguage,
        onSelected: (value) {
          setState(() {
            _selectedLanguage = value;
          });
        },
      ),
    );
  }

  Widget _buildSelectorSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    final responsive = context.responsive;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.sp(20)),
          topRight: Radius.circular(responsive.sp(20)),
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
            Padding(
              padding: EdgeInsets.all(responsive.sp(20)),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: responsive.sp(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...options.map((option) {
              final isSelected = option == currentValue;
              return ListTile(
                title: Text(option),
                trailing: isSelected 
                  ? const Icon(Icons.check, color: AppTheme.greenPrimary)
                  : null,
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
            SizedBox(height: responsive.sp(12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: _backgroundColor ?? AppTheme.white,
      
      // ============================================================
      // SECTION 1: TOP NAVIGATION BAR
      // ============================================================
      appBar: _buildAppBar(responsive),
      
      body: Stack(
        children: [
          // ============================================================
          // SECTION 2: CONTENT EDITOR AREA (Scrollable)
          // ============================================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Identity Section
                _buildUserIdentity(responsive),
                
                // Divider between user identity and content
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppTheme.greySoft.withOpacity(0.5),
                ),
                
                // Borderless Text Input
                BorderlessTextField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  hintText: "What's happening around you?",
                  minLines: 5,
                  maxLines: null,
                  backgroundColor: _backgroundColor,
                  onChanged: (text) => _updateContentState(),
                ),
                
                // Media Preview Area
                if (_attachments.isNotEmpty)
                  _buildMediaPreview(responsive),
                
                // Space for bottom action sheet
                SizedBox(height: _sheetHeight + responsive.sp(20)),
              ],
            ),
          ),
          
          // ============================================================
          // SECTION 3: EXPANDABLE BOTTOM ACTION SHEET (Fixed)
          // ============================================================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              // Make sheet draggable
              onVerticalDragUpdate: (details) {
                setState(() {
                  _sheetHeight -= details.delta.dy;
                  // Constrain between min and max
                  _sheetHeight = _sheetHeight.clamp(200.0, 500.0);
                });
              },
              onVerticalDragEnd: (details) {
                // Snap to nearest position
                setState(() {
                  if (_sheetHeight < 300) {
                    _sheetHeight = 250; // Collapsed
                  } else {
                    _sheetHeight = 420; // Expanded
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: _buildActionSheet(responsive),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION 1: TOP NAVIGATION BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar(Responsive responsive) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.white,
      
      // Left: Close (X) icon
      leading: IconButton(
        icon: Icon(Icons.close, color: AppTheme.textPrimary, size: responsive.sp(24)),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.all(responsive.sp(16)),
      ),
      
      // Center: Title
      title: Text(
        'Create Post',
        style: TextStyle(
          fontSize: responsive.sp(18),
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      centerTitle: true,
      
      // Right: Post button
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(16),
            vertical: responsive.sp(8),
          ),
          child: ElevatedButton(
            onPressed: _hasContent ? _handlePost : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasContent 
                ? AppTheme.greenPrimary 
                : AppTheme.greyMedium.withOpacity(0.5),
              foregroundColor: AppTheme.white,
              elevation: 0,
              disabledBackgroundColor: AppTheme.greyMedium.withOpacity(0.5),
              disabledForegroundColor: AppTheme.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.sp(8)),
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
    );
  }

  // ============================================================
  // SECTION 2: CONTENT EDITOR AREA - User Identity
  // ============================================================
  Widget _buildUserIdentity(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name
          Row(
            children: [
              CircleAvatar(
                radius: responsive.sp(20),
                backgroundColor: AppTheme.greenPrimary,
                child: Icon(
                  Icons.person,
                  color: AppTheme.white,
                  size: responsive.sp(24),
                ),
              ),
              SizedBox(width: responsive.sp(12)),
              Text(
                'You', // TODO: Get from user state
                style: TextStyle(
                  fontSize: responsive.sp(16),
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.sp(12)),
          
          // Control Chips Row 1
          Wrap(
            spacing: responsive.sp(8),
            runSpacing: responsive.sp(8),
            children: [
              ControlChip(
                icon: Icons.public,
                label: _selectedAudience,
                iconColor: Colors.blue,
                onTap: _showAudienceSelector,
              ),
              ControlChip(
                icon: Icons.language,
                label: _selectedLanguage,
                iconColor: AppTheme.greenPrimary,
                onTap: _showLanguageSelector,
              ),
              if (_selectedLocation != null)
                ControlChip(
                  icon: Icons.location_on,
                  label: _selectedLocation!,
                  iconColor: Colors.red,
                  onTap: () {
                    // TODO: Edit location
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION 2: CONTENT EDITOR AREA - Media Preview
  // ============================================================
  Widget _buildMediaPreview(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      margin: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
      child: Column(
        children: [
          SizedBox(
            height: responsive.sp(130),
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
          ),
          SizedBox(height: responsive.sp(16)),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION 3: EXPANDABLE BOTTOM ACTION SHEET
  // ============================================================
  Widget _buildActionSheet(Responsive responsive) {
    final actionItems = [
      ActionSheetItem(
        icon: Icons.photo_library,
        label: 'Photo/video',
        color: Colors.green,
        onTap: _pickPhotoVideo,
      ),
      ActionSheetItem(
        icon: Icons.mic,
        label: 'Add Audio',
        color: Colors.blue,
        onTap: _pickAudio,
      ),
      ActionSheetItem(
        icon: Icons.category,
        label: 'Category: $_selectedCategory',
        color: AppTheme.greenPrimary,
        onTap: _showCategorySelector,
      ),
      ActionSheetItem(
        icon: Icons.priority_high,
        label: 'Priority: $_selectedPriority',
        color: _selectedPriority == 'Emergency' 
          ? AppTheme.alertOrange
          : _selectedPriority == 'High Risk'
              ? Colors.orange
              : AppTheme.greenPrimary,
        onTap: _showPrioritySelector,
      ),
      ActionSheetItem(
        icon: Icons.location_on,
        label: _selectedLocation ?? 'Add Location',
        color: Colors.red,
        onTap: () {
          // TODO: Location picker
          setState(() {
            _selectedLocation = 'Current Location';
          });
        },
      ),
      ActionSheetItem(
        icon: Icons.palette,
        label: 'Background colour',
        color: Colors.teal,
        onTap: () {
          // TODO: Color picker
          setState(() {
            _backgroundColor = _backgroundColor == null 
              ? Colors.blue[50]
              : null;
          });
        },
      ),
    ];

    return ActionSheet(
      items: actionItems,
      height: _sheetHeight,
    );
  }
}
