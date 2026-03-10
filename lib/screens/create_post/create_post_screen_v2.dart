import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerSheet(
        onLocationSelected: (location) {
          setState(() {
            _selectedLocation = location;
          });
        },
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
                  onTap: () => setState(() => _selectedLocation = null),
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
        onTap: _showLocationPicker,
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

// ---------------------------------------------------------------------------
// Location Picker Bottom Sheet
// ---------------------------------------------------------------------------

class _LocationPickerSheet extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;

  const _LocationPickerSheet({required this.onLocationSelected});

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  bool _isLoadingLocation = false;
  bool _isSearching = false;

  Future<void> _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final locations = await locationFromAddress(query);
      if (!mounted) return;
      final List<String> results = [];
      for (final loc in locations.take(5)) {
        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            if (p.name != null && p.name!.isNotEmpty) p.name,
            if (p.locality != null && p.locality!.isNotEmpty) p.locality,
            if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
              p.administrativeArea,
            if (p.country != null && p.country!.isNotEmpty) p.country,
          ];
          results.add(parts.join(', '));
        }
      }
      if (mounted) setState(() => _suggestions = results);
    } catch (_) {
      if (mounted) setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Location services are disabled.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showError('Location permission permanently denied.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      String locationName = 'Current Location';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ];
        if (parts.isNotEmpty) locationName = parts.join(', ');
      }
      widget.onLocationSelected(locationName);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      _showError('Could not get current location.');
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.alertOrange,
      ),
    );
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _MapPickerScreen()),
    );
    if (result != null && mounted) {
      widget.onLocationSelected(result);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75 + bottomInset,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
          topRight: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: responsive.sp(12)),
              child: Container(
                width: responsive.sp(40),
                height: responsive.sp(4),
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.sp(16),
              responsive.sp(16),
              responsive.sp(16),
              responsive.sp(8),
            ),
            child: Text(
              'Add Location',
              style: TextStyle(
                fontSize: responsive.sp(18),
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Type a location name...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.greyMedium),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.greenPrimary,
                          ),
                        ),
                      )
                    : _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.greyMedium),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _suggestions = []);
                            },
                          )
                        : null,
                filled: true,
                fillColor: AppTheme.greySoft.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(12),
                  vertical: responsive.sp(12),
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onLocationSelected(value.trim());
                  Navigator.pop(context);
                }
              },
            ),
          ),

          SizedBox(height: responsive.sp(8)),

          // Geocoded suggestions
          if (_suggestions.isNotEmpty)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.place_outlined,
                        color: AppTheme.greyMedium),
                    title: Text(
                      _suggestions[index],
                      style: TextStyle(fontSize: responsive.sp(14)),
                    ),
                    onTap: () {
                      widget.onLocationSelected(_suggestions[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

          // Static options (shown when no suggestions)
          if (_suggestions.isEmpty) ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.greenPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: _isLoadingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.greenPrimary,
                        ),
                      )
                    : const Icon(Icons.my_location,
                        color: AppTheme.greenPrimary, size: 20),
              ),
              title: Text(
                'Use current location',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                'Automatically detect your location',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.greyMedium,
                ),
              ),
              onTap: _isLoadingLocation ? null : _useCurrentLocation,
            ),
            Divider(
              indent: responsive.sp(16),
              endIndent: responsive.sp(16),
              color: AppTheme.greySoft,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.map_outlined, color: Colors.blue, size: 20),
              ),
              title: Text(
                'Choose on map',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                'Drop a pin anywhere on the map',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.greyMedium,
                ),
              ),
              onTap: _openMapPicker,
            ),
          ],

          SizedBox(height: responsive.sp(16) + bottomInset),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Map Picker Full-Screen
// ---------------------------------------------------------------------------

class _MapPickerScreen extends StatefulWidget {
  const _MapPickerScreen();

  @override
  State<_MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<_MapPickerScreen> {
  LatLng _pickedLatLng = const LatLng(9.0820, 8.6753); // Centre of Nigeria
  String _pickedAddress = 'Move the map to select a location';
  bool _isResolving = false;

  Future<void> _resolveAddress(LatLng latLng) async {
    setState(() {
      _isResolving = true;
      _pickedLatLng = latLng;
    });
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ];
        setState(() {
          _pickedAddress = parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _pickedAddress =
            '${_pickedLatLng.latitude.toStringAsFixed(5)}, ${_pickedLatLng.longitude.toStringAsFixed(5)}');
      }
    } finally {
      if (mounted) setState(() => _isResolving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pick Location',
          style: TextStyle(
            fontSize: responsive.sp(18),
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLatLng,
              zoom: 6,
            ),
            onCameraIdle: () => _resolveAddress(_pickedLatLng),
            onCameraMove: (position) => _pickedLatLng = position.target,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Fixed centre pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: Icon(
                Icons.location_pin,
                size: 48,
                color: AppTheme.greenPrimary,
              ),
            ),
          ),

          // Bottom confirmation card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                responsive.sp(16),
                responsive.sp(16),
                responsive.sp(16),
                responsive.sp(24) + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
                  topRight: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppTheme.greenPrimary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _isResolving
                            ? Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.greenPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Resolving address...',
                                    style: TextStyle(
                                      fontSize: responsive.sp(13),
                                      color: AppTheme.greyMedium,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                _pickedAddress,
                                style: TextStyle(
                                  fontSize: responsive.sp(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.sp(16)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isResolving
                          ? null
                          : () => Navigator.pop(context, _pickedAddress),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.greenPrimary,
                        foregroundColor: AppTheme.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: responsive.sp(14)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                      child: Text(
                        'Confirm Location',
                        style: TextStyle(
                          fontSize: responsive.sp(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
