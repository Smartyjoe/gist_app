import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/post.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/post/post_card.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _mapController;
  
  final LatLng _initialPosition = const LatLng(6.5244, 3.3792); // Lagos
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeMarkers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeMarkers() {
    // Mock markers - In production, fetch from API
    _markers.addAll([
      Marker(
        markerId: const MarkerId('1'),
        position: const LatLng(6.4531, 3.6014),
        infoWindow: const InfoWindow(
          title: 'Road Flooding',
          snippet: 'High Risk',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('2'),
        position: const LatLng(6.5449, 3.3364),
        infoWindow: const InfoWindow(
          title: 'Fire Emergency',
          snippet: 'Emergency',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        title: 'Explore',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.greenPrimary,
          labelColor: AppTheme.greenPrimary,
          unselectedLabelColor: AppTheme.greyMedium,
          tabs: const [
            Tab(text: 'Map View'),
            Tab(text: 'List View'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMapView(responsive),
          _buildListView(responsive),
        ],
      ),
    );
  }

  Widget _buildMapView(Responsive responsive) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 12,
          ),
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
        
        // Filter chips
        Positioned(
          top: responsive.sp(16),
          left: responsive.sp(16),
          right: responsive.sp(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true, responsive),
                SizedBox(width: responsive.sp(8)),
                _buildFilterChip('Emergency', false, responsive),
                SizedBox(width: responsive.sp(8)),
                _buildFilterChip('High Risk', false, responsive),
                SizedBox(width: responsive.sp(8)),
                _buildFilterChip('Infrastructure', false, responsive),
              ],
            ),
          ),
        ),
        
        // Location button
        Positioned(
          bottom: responsive.sp(100),
          right: responsive.sp(16),
          child: FloatingActionButton(
            onPressed: _goToCurrentLocation,
            backgroundColor: AppTheme.white,
            child: const Icon(
              Icons.my_location,
              color: AppTheme.greenPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(Responsive responsive) {
    // Mock trending posts
    final trendingPosts = [
      Post(
        id: '1',
        userId: 'user1',
        userName: 'Trending User',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        content: 'This is a trending report in your area.',
        type: PostType.text,
        category: 'Infrastructure',
        location: 'Lagos, Nigeria',
        latitude: 6.5244,
        longitude: 3.3792,
        likes: 500,
        comments: 150,
        shares: 200,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        language: 'en',
      ),
    ];

    return Column(
      children: [
        // Search and filter bar
        Container(
          padding: EdgeInsets.all(responsive.sp(AppTheme.spacing16)),
          color: AppTheme.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search reports...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      borderSide: const BorderSide(color: AppTheme.greySoft),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.sp(16),
                      vertical: responsive.sp(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.sp(8)),
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.greenPrimary,
                  foregroundColor: AppTheme.white,
                ),
              ),
            ],
          ),
        ),
        
        // Trending section
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: responsive.sp(8)),
            itemCount: trendingPosts.length,
            itemBuilder: (context, index) {
              return PostCard(post: trendingPosts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Responsive responsive) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: responsive.sp(12),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          // Handle filter selection
        });
      },
      backgroundColor: AppTheme.white,
      selectedColor: AppTheme.greenPrimary,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.white : AppTheme.textPrimary,
      ),
      elevation: 2,
      shadowColor: Colors.black26,
    );
  }

  void _goToCurrentLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
      ),
    );
  }
}
