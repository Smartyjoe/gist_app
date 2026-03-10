import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../config/app_theme.dart';
import '../../models/user.dart';
import '../../utils/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;
  late TextEditingController _locationController;

  File? _pickedImage;
  DateTime? _birthday;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _websiteController = TextEditingController(text: widget.user.website ?? '');
    _locationController = TextEditingController(text: widget.user.location ?? '');
    _birthday = widget.user.birthday;

    for (final c in [_nameController, _usernameController, _bioController,
        _websiteController, _locationController]) {
      c.addListener(() => setState(() => _hasChanges = true));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _hasChanges = true;
      });
    }
  }

  void _showPhotoOptions() {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(20))),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: responsive.sp(12)),
              Container(
                width: responsive.sp(40), height: responsive.sp(4),
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(responsive.sp(16)),
                child: Text('Profile photo',
                    style: TextStyle(fontSize: responsive.sp(16), fontWeight: FontWeight.w700)),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppTheme.greenPrimary),
                title: const Text('Choose from gallery'),
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.greenPrimary),
                title: const Text('Take a photo'),
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
              ),
              if (_pickedImage != null || widget.user.avatar != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppTheme.alertOrange),
                  title: const Text('Remove photo', style: TextStyle(color: AppTheme.alertOrange)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() { _pickedImage = null; _hasChanges = true; });
                  },
                ),
              SizedBox(height: responsive.sp(12)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 18),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.greenPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() { _birthday = picked; _hasChanges = true; });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.user.copyWith(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      birthday: _birthday,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(
              fontSize: responsive.sp(15), color: AppTheme.textPrimary)),
        ),
        leadingWidth: responsive.sp(80),
        title: Text('Edit Profile',
            style: TextStyle(fontSize: responsive.sp(17), fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _hasChanges ? _save : null,
            child: Text('Save',
                style: TextStyle(
                  fontSize: responsive.sp(15),
                  fontWeight: FontWeight.w700,
                  color: _hasChanges ? AppTheme.greenPrimary : AppTheme.greyMedium,
                )),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            // ── Avatar ───────────────────────────────────────────────────
            Container(
              color: AppTheme.white,
              padding: EdgeInsets.symmetric(vertical: responsive.sp(24)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: responsive.sp(50),
                          backgroundColor: AppTheme.greySoft,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!) as ImageProvider
                              : widget.user.avatar != null
                                  ? NetworkImage(widget.user.avatar!)
                                  : null,
                          child: (_pickedImage == null && widget.user.avatar == null)
                              ? Icon(Icons.person, size: responsive.sp(50), color: AppTheme.greyMedium)
                              : null,
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: EdgeInsets.all(responsive.sp(6)),
                            decoration: const BoxDecoration(
                              color: AppTheme.greenPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt, size: responsive.sp(14), color: AppTheme.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.sp(12)),
                  GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Text('Change profile photo',
                        style: TextStyle(fontSize: responsive.sp(14),
                            color: AppTheme.greenPrimary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            SizedBox(height: responsive.sp(8)),

            // ── Fields ────────────────────────────────────────────────────
            Container(
              color: AppTheme.white,
              child: Column(
                children: [
                  _EditField(
                    label: 'Name',
                    controller: _nameController,
                    responsive: responsive,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                  ),
                  _EditField(
                    label: 'Username',
                    controller: _usernameController,
                    responsive: responsive,
                    prefix: '@',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Username is required';
                      if (v.contains(' ')) return 'No spaces allowed';
                      return null;
                    },
                  ),
                  _EditField(
                    label: 'Bio',
                    controller: _bioController,
                    responsive: responsive,
                    maxLines: 4,
                    maxLength: 150,
                    hint: 'Tell your community about yourself...',
                  ),
                  _EditField(
                    label: 'Website',
                    controller: _websiteController,
                    responsive: responsive,
                    hint: 'https://',
                    keyboardType: TextInputType.url,
                  ),
                  _EditField(
                    label: 'Location',
                    controller: _locationController,
                    responsive: responsive,
                    hint: 'City, Country',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: responsive.sp(8)),

            // ── Birthday ──────────────────────────────────────────────────
            Container(
              color: AppTheme.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: responsive.sp(16), vertical: responsive.sp(4)),
                title: Text('Birthday',
                    style: TextStyle(fontSize: responsive.sp(13),
                        color: AppTheme.greyMedium, fontWeight: FontWeight.w500)),
                subtitle: Text(
                  _birthday != null
                      ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                      : 'Optional',
                  style: TextStyle(fontSize: responsive.sp(15), color: AppTheme.textPrimary),
                ),
                trailing: Icon(Icons.chevron_right, color: AppTheme.greyMedium, size: responsive.sp(20)),
                onTap: _pickBirthday,
              ),
            ),

            SizedBox(height: responsive.sp(32)),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Responsive responsive;
  final String? hint;
  final String? prefix;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool showDivider;

  const _EditField({
    required this.label,
    required this.controller,
    required this.responsive,
    this.hint,
    this.prefix,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(12), responsive.sp(16), 0),
          child: Text(label,
              style: TextStyle(fontSize: responsive.sp(12),
                  color: AppTheme.greyMedium, fontWeight: FontWeight.w600)),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: responsive.sp(15), color: AppTheme.textPrimary),
          decoration: InputDecoration(
            prefixText: prefix,
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.greyMedium, fontSize: responsive.sp(15)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.sp(16), vertical: responsive.sp(8)),
            counterStyle: TextStyle(fontSize: responsive.sp(11), color: AppTheme.greyMedium),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, indent: responsive.sp(16), color: AppTheme.greySoft),
      ],
    );
  }
}
