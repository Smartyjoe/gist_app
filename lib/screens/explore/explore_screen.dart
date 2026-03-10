import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/post.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

// ── Mock incident data ────────────────────────────────────────────────────────

class _Incident {
  final String id;
  final String title;
  final String snippet;
  final String category;
  final PostPriority priority;
  final LatLng position;
  final String time;
  final int reports;

  const _Incident({
    required this.id,
    required this.title,
    required this.snippet,
    required this.category,
    required this.priority,
    required this.position,
    required this.time,
    required this.reports,
  });
}

const _incidents = [
  _Incident(id:'1', title:'Road Flooding', snippet:'Ojo Road impassable after heavy rain', category:'Infrastructure', priority:PostPriority.highRisk,   position:LatLng(6.4531,3.6014), time:'12m ago', reports:14),
  _Incident(id:'2', title:'Fire Emergency', snippet:'Building fire on Broad Street', category:'Emergency',      priority:PostPriority.emergency,  position:LatLng(6.4552,3.3825), time:'5m ago',  reports:31),
  _Incident(id:'3', title:'Power Outage',  snippet:'Whole estate without power - 6hrs', category:'Infrastructure', priority:PostPriority.highRisk,   position:LatLng(6.5244,3.3792), time:'1h ago',  reports:9),
  _Incident(id:'4', title:'Robbery Alert', snippet:'Armed robbery reported near Lekki toll gate', category:'Security',  priority:PostPriority.emergency,  position:LatLng(6.4698,3.5852), time:'3m ago',  reports:47),
  _Incident(id:'5', title:'Water Scarcity',snippet:'No water supply in Surulere for 3 days', category:'Health', priority:PostPriority.normal,     position:LatLng(6.5019,3.3515), time:'2h ago',  reports:22),
  _Incident(id:'6', title:'Traffic Accident',snippet:'Multi-car crash on Third Mainland Bridge', category:'Emergency', priority:PostPriority.emergency,  position:LatLng(6.5085,3.3934), time:'8m ago',  reports:19),
  _Incident(id:'7', title:'Broken Bridge', snippet:'Footbridge collapsed - Agege', category:'Infrastructure', priority:PostPriority.highRisk,   position:LatLng(6.6176,3.3172), time:'30m ago', reports:6),
  _Incident(id:'8', title:'Pollution Alert',snippet:'Black smoke from factory in Apapa', category:'Environment', priority:PostPriority.highRisk,   position:LatLng(6.4499,3.3614), time:'45m ago', reports:11),
  _Incident(id:'9', title:'Street Lighting',snippet:'Dark streets in Ikeja GRA since last week', category:'Infrastructure', priority:PostPriority.normal,     position:LatLng(6.5836,3.3468), time:'1d ago',  reports:4),
  _Incident(id:'10',title:'Cholera Warning',snippet:'Suspected cholera cases in Ajegunle', category:'Health', priority:PostPriority.emergency,  position:LatLng(6.4358,3.3682), time:'20m ago', reports:28),
  _Incident(id:'11',title:'Waste Dump',    snippet:'Illegal dumping blocking canal, Ikorodu', category:'Environment', priority:PostPriority.normal,     position:LatLng(6.6194,3.5061), time:'3h ago',  reports:7),
  _Incident(id:'12',title:'Gas Leak',      snippet:'Gas leak smell around Yaba market area', category:'Emergency', priority:PostPriority.emergency,  position:LatLng(6.5054,3.3743), time:'2m ago',  reports:53),
];

const _allCategories = ['All', 'Emergency', 'Infrastructure', 'Health', 'Security', 'Environment'];

Color _priorityColor(PostPriority p) {
  switch (p) {
    case PostPriority.emergency: return const Color(0xFFD32F2F);
    case PostPriority.highRisk:  return const Color(0xFFF57C00);
    case PostPriority.normal:    return const Color(0xFF1976D2);
  }
}

double _priorityHue(PostPriority p) {
  switch (p) {
    case PostPriority.emergency: return BitmapDescriptor.hueRed;
    case PostPriority.highRisk:  return BitmapDescriptor.hueOrange;
    case PostPriority.normal:    return BitmapDescriptor.hueAzure;
  }
}

// ── Main Widget ───────────────────────────────────────────────────────────────

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
  String _selectedCategory = 'All';
  bool _isSatellite = false;
  _Incident? _selectedIncident;

  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  Set<Marker> get _filteredMarkers {
    final filtered = _selectedCategory == 'All'
        ? _incidents
        : _incidents.where((i) => i.category == _selectedCategory).toList();
    return filtered.map((inc) => Marker(
      markerId: MarkerId(inc.id),
      position: inc.position,
      icon: BitmapDescriptor.defaultMarkerWithHue(_priorityHue(inc.priority)),
      infoWindow: InfoWindow.noText,
      onTap: () => _onMarkerTap(inc),
    )).toSet();
  }

  Map<PostPriority, int> get _priorityCounts {
    final counts = {
      PostPriority.emergency: 0,
      PostPriority.highRisk: 0,
      PostPriority.normal: 0,
    };
    for (final inc in _incidents) counts[inc.priority] = counts[inc.priority]! + 1;
    return counts;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _onMarkerTap(_Incident inc) {
    setState(() => _selectedIncident = inc);
  }

  void _dismissCard() {
    setState(() => _selectedIncident = null);
  }

  void _goToCurrentLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPosition, zoom: 13),
      ),
    );
  }

  void _zoomIn()  => _mapController?.animateCamera(CameraUpdate.zoomIn());
  void _zoomOut() => _mapController?.animateCamera(CameraUpdate.zoomOut());

  void _toggleSatellite() => setState(() => _isSatellite = !_isSatellite);

  void _selectCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      _selectedIncident = null;
    });
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

  // ── Map View ────────────────────────────────────────────────────────────────

  Widget _buildMapView(Responsive responsive) {
    final counts = _priorityCounts;
    return Stack(
      children: [
        // Google Map
        GestureDetector(
          onTap: _dismissCard,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 12),
            markers: _filteredMarkers,
            onMapCreated: (c) => _mapController = c,
            mapType: _isSatellite ? MapType.satellite : MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: (_) => _dismissCard(),
          ),
        ),

        // ── Top overlay ────────────────────────────────────────────────────
        Column(
          children: [
            // Incident stats strip
            Container(
              color: Colors.black.withOpacity(0.62),
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(16), vertical: responsive.sp(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatPill(count: counts[PostPriority.emergency]!, label: 'Emergency', color: const Color(0xFFD32F2F)),
                  _StatPill(count: counts[PostPriority.highRisk]!,  label: 'High Risk',  color: const Color(0xFFF57C00)),
                  _StatPill(count: counts[PostPriority.normal]!,    label: 'Reported',   color: const Color(0xFF1976D2)),
                  _StatPill(count: _incidents.length,               label: 'Total',      color: AppTheme.greyMedium),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.fromLTRB(responsive.sp(12), responsive.sp(10), responsive.sp(12), 0),
              child: Container(
                height: responsive.sp(42),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(responsive.sp(10)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0,2))],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search incidents...',
                    hintStyle: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greyMedium),
                    prefixIcon: Icon(Icons.search, size: responsive.sp(18), color: AppTheme.greyMedium),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: responsive.sp(16), color: AppTheme.greyMedium),
                            onPressed: () { _searchController.clear(); setState(() {}); })
                        : null,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: responsive.sp(11)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

            // Filter chips
            SizedBox(
              height: responsive.sp(44),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: responsive.sp(12), vertical: responsive.sp(6)),
                itemCount: _allCategories.length,
                separatorBuilder: (_, __) => SizedBox(width: responsive.sp(6)),
                itemBuilder: (_, i) {
                  final cat = _allCategories[i];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => _selectCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: responsive.sp(14), vertical: responsive.sp(4)),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.greenPrimary : AppTheme.white,
                        borderRadius: BorderRadius.circular(responsive.sp(20)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0,1))],
                      ),
                      child: Text(cat,
                        style: TextStyle(
                          fontSize: responsive.sp(12),
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                        )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // ── Right-side controls ─────────────────────────────────────────────
        Positioned(
          right: responsive.sp(12),
          bottom: _selectedIncident != null ? responsive.sp(200) : responsive.sp(100),
          child: Column(
            children: [
              _MapControlButton(icon: Icons.add, onTap: _zoomIn, responsive: responsive),
              SizedBox(height: responsive.sp(6)),
              _MapControlButton(icon: Icons.remove, onTap: _zoomOut, responsive: responsive),
              SizedBox(height: responsive.sp(12)),
              _MapControlButton(
                icon: _isSatellite ? Icons.map_outlined : Icons.satellite_alt_outlined,
                onTap: _toggleSatellite,
                responsive: responsive,
              ),
              SizedBox(height: responsive.sp(6)),
              _MapControlButton(icon: Icons.my_location, onTap: _goToCurrentLocation, responsive: responsive, highlighted: true),
            ],
          ),
        ),

        // ── Incident peek card ──────────────────────────────────────────────
        AnimatedPositioned(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          left: 0, right: 0,
          bottom: _selectedIncident != null ? 0 : -responsive.sp(200),
          child: _selectedIncident != null
              ? _IncidentPeekCard(
                  incident: _selectedIncident!,
                  onDismiss: _dismissCard,
                  onViewPost: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening "${_selectedIncident!.title}"...'), behavior: SnackBarBehavior.floating)),
                  responsive: responsive,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── List View ────────────────────────────────────────────────────────────────

  Widget _buildListView(Responsive responsive) {
    final query = _searchController.text.toLowerCase();
    final filtered = _selectedCategory == 'All'
        ? _incidents
        : _incidents.where((i) => i.category == _selectedCategory).toList();
    final searched = query.isEmpty
        ? filtered
        : filtered.where((i) =>
            i.title.toLowerCase().contains(query) ||
            i.snippet.toLowerCase().contains(query)).toList();

    return Column(
      children: [
        // Search + filter bar
        Container(
          color: AppTheme.white,
          padding: EdgeInsets.fromLTRB(responsive.sp(12), responsive.sp(10), responsive.sp(12), 0),
          child: Column(
            children: [
              // Search
              Container(
                height: responsive.sp(42),
                decoration: BoxDecoration(
                  color: AppTheme.greySoft.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(responsive.sp(10)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search incidents...',
                    hintStyle: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greyMedium),
                    prefixIcon: Icon(Icons.search, size: responsive.sp(18), color: AppTheme.greyMedium),
                    border: InputBorder.none, focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: responsive.sp(11)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              // Category chips
              SizedBox(
                height: responsive.sp(44),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: responsive.sp(6)),
                  itemCount: _allCategories.length,
                  separatorBuilder: (_, __) => SizedBox(width: responsive.sp(6)),
                  itemBuilder: (_, i) {
                    final cat = _allCategories[i];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => _selectCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: responsive.sp(14), vertical: responsive.sp(4)),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.greenPrimary : AppTheme.greySoft.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(responsive.sp(20)),
                        ),
                        child: Text(cat,
                          style: TextStyle(
                            fontSize: responsive.sp(12), fontWeight: FontWeight.w600,
                            color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                          )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppTheme.greySoft),

        // Results count
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.sp(16), vertical: responsive.sp(8)),
          child: Row(children: [
            Text('${searched.length} incident${searched.length == 1 ? "" : "s"}',
                style: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greyMedium, fontWeight: FontWeight.w500)),
          ]),
        ),

        // Incident list
        Expanded(
          child: searched.isEmpty
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: responsive.sp(48), color: AppTheme.greyMedium),
                    SizedBox(height: responsive.sp(12)),
                    Text('No incidents found', style: TextStyle(fontSize: responsive.sp(15), color: AppTheme.greyMedium)),
                  ],
                ))
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: responsive.sp(16)),
                  itemCount: searched.length,
                  itemBuilder: (_, i) => _IncidentListTile(
                    incident: searched[i],
                    responsive: responsive,
                    onTap: () {
                      _tabController.animateTo(0);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(searched[i].position, 15));
                        setState(() => _selectedIncident = searched[i]);
                      });
                    },
                  ),
                ),
        ),
      ],
    );
  }
} // end _ExploreScreenState

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatPill({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Responsive responsive;
  final bool highlighted;
  const _MapControlButton({required this.icon, required this.onTap, required this.responsive, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.sp(40),
        height: responsive.sp(40),
        decoration: BoxDecoration(
          color: highlighted ? AppTheme.greenPrimary : AppTheme.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0,2))],
        ),
        child: Icon(icon, size: responsive.sp(20), color: highlighted ? AppTheme.white : AppTheme.textPrimary),
      ),
    );
  }
}

class _IncidentPeekCard extends StatelessWidget {
  final _Incident incident;
  final VoidCallback onDismiss;
  final VoidCallback onViewPost;
  final Responsive responsive;

  const _IncidentPeekCard({
    required this.incident,
    required this.onDismiss,
    required this.onViewPost,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(incident.priority);
    return Container(
      margin: EdgeInsets.fromLTRB(responsive.sp(12), 0, responsive.sp(12), responsive.sp(16) + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(responsive.sp(16)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16, offset: const Offset(0,-2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coloured priority bar
          Container(
            height: responsive.sp(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(16))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(responsive.sp(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: responsive.sp(8), vertical: responsive.sp(3)),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(responsive.sp(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: responsive.sp(6), height: responsive.sp(6),
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          SizedBox(width: responsive.sp(4)),
                          Text(incident.category,
                              style: TextStyle(fontSize: responsive.sp(11), color: color, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(incident.time,
                        style: TextStyle(fontSize: responsive.sp(11), color: AppTheme.greyMedium)),
                    SizedBox(width: responsive.sp(8)),
                    GestureDetector(
                      onTap: onDismiss,
                      child: Icon(Icons.close, size: responsive.sp(18), color: AppTheme.greyMedium),
                    ),
                  ],
                ),
                SizedBox(height: responsive.sp(8)),
                Text(incident.title,
                    style: TextStyle(fontSize: responsive.sp(16), fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                SizedBox(height: responsive.sp(4)),
                Text(incident.snippet,
                    style: TextStyle(fontSize: responsive.sp(13), color: AppTheme.textSecondary, height: 1.4)),
                SizedBox(height: responsive.sp(12)),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: responsive.sp(14), color: AppTheme.greyMedium),
                    SizedBox(width: responsive.sp(4)),
                    Text('${incident.reports} reports',
                        style: TextStyle(fontSize: responsive.sp(12), color: AppTheme.greyMedium)),
                    const Spacer(),
                    SizedBox(
                      height: responsive.sp(34),
                      child: ElevatedButton(
                        onPressed: onViewPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.greenPrimary,
                          foregroundColor: AppTheme.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.sp(8))),
                        ),
                        child: Text('View Post', style: TextStyle(fontSize: responsive.sp(13), fontWeight: FontWeight.w600)),
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
}

class _IncidentListTile extends StatelessWidget {
  final _Incident incident;
  final Responsive responsive;
  final VoidCallback onTap;

  const _IncidentListTile({required this.incident, required this.responsive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(incident.priority);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(responsive.sp(12), responsive.sp(6), responsive.sp(12), responsive.sp(6)),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(responsive.sp(12)),
          border: Border.all(color: AppTheme.greySoft),
        ),
        child: Row(
          children: [
            // Priority colour bar
            Container(
              width: responsive.sp(4),
              height: responsive.sp(80),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(responsive.sp(12))),
              ),
            ),
            SizedBox(width: responsive.sp(12)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.sp(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(incident.title,
                              style: TextStyle(fontSize: responsive.sp(14), fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: responsive.sp(7), vertical: responsive.sp(2)),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(responsive.sp(20)),
                          ),
                          child: Text(incident.category,
                              style: TextStyle(fontSize: responsive.sp(10), color: color, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.sp(4)),
                    Text(incident.snippet,
                        style: TextStyle(fontSize: responsive.sp(12), color: AppTheme.textSecondary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: responsive.sp(6)),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: responsive.sp(12), color: AppTheme.greyMedium),
                        SizedBox(width: responsive.sp(3)),
                        Text(incident.time, style: TextStyle(fontSize: responsive.sp(11), color: AppTheme.greyMedium)),
                        SizedBox(width: responsive.sp(12)),
                        Icon(Icons.people_outline, size: responsive.sp(12), color: AppTheme.greyMedium),
                        SizedBox(width: responsive.sp(3)),
                        Text('${incident.reports} reports', style: TextStyle(fontSize: responsive.sp(11), color: AppTheme.greyMedium)),
                        const Spacer(),
                        Icon(Icons.chevron_right, size: responsive.sp(16), color: AppTheme.greyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: responsive.sp(8)),
          ],
        ),
      ),
    );
  }
}
