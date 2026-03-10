import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  
  List<String> _recentSearches = [
    'Broken streetlight',
    'Community event',
    'Road repair',
  ];
  
  List<String> _trendingTopics = [
    '#Infrastructure',
    '#Security',
    '#Environment',
    '#HealthCare',
    '#Education',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchField(responsive),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: responsive.sp(16)),
            
            // Recent searches
            if (_recentSearches.isNotEmpty) ...[
              _buildSectionHeader('Recent Searches', responsive),
              _buildRecentSearches(responsive),
              SizedBox(height: responsive.sp(24)),
            ],
            
            // Trending topics
            _buildSectionHeader('Trending Topics', responsive),
            _buildTrendingTopics(responsive),
            
            SizedBox(height: responsive.sp(24)),
            
            // Categories
            _buildSectionHeader('Categories', responsive),
            _buildCategories(responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(Responsive responsive) {
    return Container(
      height: responsive.sp(40),
      decoration: BoxDecoration(
        color: AppTheme.greySoft.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: TextStyle(
          fontSize: responsive.sp(16),
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search posts, users, topics...',
          hintStyle: TextStyle(
            fontSize: responsive.sp(14),
            color: AppTheme.greyMedium,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: responsive.sp(20),
            color: AppTheme.greyMedium,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: responsive.sp(20),
                    color: AppTheme.greyMedium,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: responsive.sp(10),
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: responsive.sp(18),
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildRecentSearches(Responsive responsive) {
    return Column(
      children: _recentSearches.map((search) {
        return ListTile(
          leading: Icon(
            Icons.history,
            color: AppTheme.greyMedium,
            size: responsive.sp(20),
          ),
          title: Text(
            search,
            style: TextStyle(
              fontSize: responsive.sp(15),
              color: AppTheme.textPrimary,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              size: responsive.sp(18),
              color: AppTheme.greyMedium,
            ),
            onPressed: () {
              setState(() {
                _recentSearches.remove(search);
              });
            },
          ),
          onTap: () {
            _searchController.text = search;
            // TODO: Perform search
          },
        );
      }).toList(),
    );
  }

  Widget _buildTrendingTopics(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
      child: Wrap(
        spacing: responsive.sp(8),
        runSpacing: responsive.sp(8),
        children: _trendingTopics.map((topic) {
          return InkWell(
            onTap: () {
              _searchController.text = topic;
              // TODO: Perform search
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.sp(16),
                vertical: responsive.sp(10),
              ),
              decoration: BoxDecoration(
                color: AppTheme.greenPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.greenPrimary.withOpacity(0.3),
                ),
              ),
              child: Text(
                topic,
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.greenPrimary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategories(Responsive responsive) {
    final categories = [
      {'icon': Icons.business, 'name': 'Infrastructure', 'color': Colors.blue},
      {'icon': Icons.security, 'name': 'Security', 'color': Colors.orange},
      {'icon': Icons.park, 'name': 'Environment', 'color': Colors.green},
      {'icon': Icons.local_hospital, 'name': 'Healthcare', 'color': Colors.red},
      {'icon': Icons.school, 'name': 'Education', 'color': Colors.purple},
      {'icon': Icons.event, 'name': 'Events', 'color': Colors.pink},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: responsive.sp(12),
          mainAxisSpacing: responsive.sp(12),
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              // TODO: Filter by category
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: responsive.sp(32),
                    color: category['color'] as Color,
                  ),
                  SizedBox(height: responsive.sp(8)),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
