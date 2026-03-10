# 🎨 Three-Section Create Post Structure

## ✅ Implementation Complete

The Create Post page is now clearly divided into **three major sections** with distinct responsibilities and visual separation.

---

## 📐 Layout Structure

```
┌─────────────────────────────────────────────────────┐
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ SECTION 1: TOP NAVIGATION BAR (Fixed)              │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ ✕         Create Post                   [Post]     │ ← 56px height
│                                                     │
├─────────────────────────────────────────────────────┤
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ SECTION 2: CONTENT EDITOR AREA (Scrollable)        │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                     │
│ 👤 You                                             │ ← User Identity
│    🌐 Public ▾  🌐 English ▾                      │   (80px)
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │ ← Divider
│                                                     │
│ What's happening around you?                       │ ← Borderless Text
│                                                     │   (Expandable)
│ [User types here - NO BORDERS!]                   │
│                                                     │
│ ┌──────┐ ┌──────┐ ┌──────┐                        │ ← Media Preview
│ │ 📷  │ │ 📷  │ │ 🎥  │                        │   (Conditional)
│ └──────┘ └──────┘ └──────┘                        │
│                                                     │
│          ↓ Scrollable Content ↓                    │
│                                                     │
├─────────────────────────────────────────────────────┤
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ SECTION 3: EXPANDABLE BOTTOM ACTION SHEET (Fixed)  │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                     │
│                    ──────                          │ ← Drag Handle
│  🟢  Photo/video                                   │
│  🔵  Add Audio                                     │
│  🟢  Category: Infrastructure                      │ ← 420px (expanded)
│  🟠  Priority: Normal                              │   or 250px (collapsed)
│  🔴  Add Location                                  │
│  🟦  Background colour                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🔧 SECTION 1: TOP NAVIGATION BAR

### **Purpose:**
Fixed header with navigation and post action

### **Layout:**
```
┌─────────────────────────────────────┐
│ [✕]    Create Post         [Post]   │
│  ↑           ↑                ↑      │
│ Left      Center           Right     │
└─────────────────────────────────────┘
```

### **Components:**

#### **Left: Close Button**
```dart
IconButton(
  icon: Icon(Icons.close),
  onPressed: () => Navigator.pop(context),
  padding: EdgeInsets.all(16),
)
```
- Icon: `Icons.close`
- Size: 24sp
- Color: Dark text
- Padding: 16px all sides
- Action: Dismiss screen

#### **Center: Title**
```dart
Text(
  'Create Post',
  style: TextStyle(
    fontSize: 18sp,
    fontWeight: FontWeight.w600,
  ),
)
```
- Text: "Create Post"
- Centered in app bar
- Font size: 18sp
- Font weight: 600 (semibold)

#### **Right: Post Button**
```dart
ElevatedButton(
  onPressed: _hasContent ? _handlePost : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: _hasContent 
      ? AppTheme.greenPrimary    // Green when enabled
      : AppTheme.greyMedium,     // Gray when disabled
  ),
  child: Text('Post'),
)
```
- Text: "Post"
- **State-aware:**
  - Gray + disabled when no content
  - Green + enabled when has content
- Padding: 20px horizontal, 10px vertical
- Border radius: 8px
- No elevation

### **Specifications:**
- Height: 56px (standard app bar)
- Background: White
- Elevation: 0 (flat design)
- Padding: 16px horizontal on both sides
- Sticky: Fixed at top (doesn't scroll)

---

## 📝 SECTION 2: CONTENT EDITOR AREA

### **Purpose:**
Main area for composing post content

### **Layout:**
```
┌─────────────────────────────────────┐
│ User Identity Section               │
├─────────────────────────────────────┤ ← Divider
│                                     │
│ Borderless Text Input               │
│ (Expandable)                        │
│                                     │
├─────────────────────────────────────┤
│ Media Preview (if any)              │
└─────────────────────────────────────┘
```

### **Sub-sections:**

#### **A. User Identity Section**
```dart
Container(
  color: AppTheme.white,
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      // Avatar + Name row
      Row(
        children: [
          CircleAvatar(radius: 20),
          SizedBox(width: 12),
          Text('You', fontWeight: bold),
        ],
      ),
      SizedBox(height: 12),
      
      // Control chips
      Wrap(
        spacing: 8,
        children: [
          ControlChip(icon: public, label: 'Public'),
          ControlChip(icon: language, label: 'English'),
          ControlChip(icon: location, label: 'Location'),
        ],
      ),
    ],
  ),
)
```

**Components:**
- **Avatar:** 40px circular
- **Name:** Bold, 16sp
- **Control Chips:**
  - 🌐 Audience (Public/Followers/Private)
  - 🌐 Language (English/Yoruba/Hausa/Igbo)
  - 📍 Location (when set)
- **Height:** ~80px
- **Background:** White
- **Padding:** 16px all sides

#### **B. Divider**
```dart
Divider(
  height: 1,
  thickness: 1,
  color: AppTheme.greySoft.withOpacity(0.5),
)
```
- Visual separator
- Light gray color
- 1px thickness

#### **C. Borderless Text Input** ⭐
```dart
BorderlessTextField(
  controller: _textController,
  hintText: "What's happening around you?",
  minLines: 5,
  maxLines: null,  // Unlimited expansion
  backgroundColor: _backgroundColor,
)
```

**Key Features:**
- ✅ **NO borders** - `InputBorder.none`
- ✅ **NO background** - Clean white (or custom color)
- ✅ **NO card container** - Direct on page
- ✅ Feels like blank paper
- ✅ Expandable infinitely
- ✅ Starts with 5 lines minimum
- ✅ Padding: 20px horizontal, 16px vertical

**This is the signature feature!**

#### **D. Media Preview (Conditional)**
```dart
if (_attachments.isNotEmpty)
  Container(
    height: 130,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _attachments.length,
      itemBuilder: (context, index) {
        return MediaPreviewItem(
          media: _attachments[index],
          onRemove: () => _removeAttachment(id),
        );
      },
    ),
  )
```

**Features:**
- Horizontal scrolling grid
- Thumbnail size: 120×120px
- Remove button on each item
- Margin: 16px horizontal
- Only shows when media added

### **Specifications:**
- Scrollable: Yes (BouncingScrollPhysics)
- Background: White (or custom color)
- Padding: Varies by sub-section
- Expands with content
- Bottom space: Dynamic based on sheet height

---

## 🎯 SECTION 3: EXPANDABLE BOTTOM ACTION SHEET

### **Purpose:**
Provide quick access to post enhancement actions

### **Layout:**
```
┌─────────────────────────────────────┐
│              ──────                 │ ← Handle (40×4px)
│                                     │
│  🟢  Photo/video                    │ ← 56px each
│  🔵  Add Audio                      │
│  🟢  Category: Infrastructure       │
│  🟠  Priority: Normal               │
│  🔴  Add Location                   │
│  🟦  Background colour              │
│                                     │
└─────────────────────────────────────┘
```

### **Components:**

#### **A. Drag Handle**
```dart
Container(
  width: 40,
  height: 4,
  decoration: BoxDecoration(
    color: AppTheme.greyMedium.withOpacity(0.5),
    borderRadius: BorderRadius.circular(2),
  ),
)
```
- Visual affordance for dragging
- Centered at top
- Gray color (50% opacity)

#### **B. Action Items**
```dart
ActionItem(
  icon: Icons.photo_library,
  label: 'Photo/video',
  color: Colors.green,
  onTap: _pickPhotoVideo,
)
```

**Six Actions:**
1. **Photo/video** 🟢 (Green)
   - Opens gallery/camera picker
   
2. **Add Audio** 🔵 (Blue)
   - Opens audio file picker
   
3. **Category** 🟢 (Green)
   - Shows: "Category: [Selected]"
   - Options: Infrastructure, Event, Announcement, Security, Environment, Health
   
4. **Priority** 🟠/🔴 (Color-coded)
   - Shows: "Priority: [Selected]"
   - Normal (green), High Risk (orange), Emergency (red)
   
5. **Add Location** 🔴 (Red)
   - Sets location for post
   
6. **Background colour** 🟦 (Teal)
   - Changes text area background

**Each Row:**
- Height: 56px (touch-friendly)
- Icon: 24px in 40px circular container
- Label: 16sp, medium weight
- Ripple effect on tap

### **Interactive Features:**

#### **Draggable:**
```dart
GestureDetector(
  onVerticalDragUpdate: (details) {
    setState(() {
      _sheetHeight -= details.delta.dy;
      _sheetHeight = _sheetHeight.clamp(200.0, 500.0);
    });
  },
  onVerticalDragEnd: (details) {
    // Snap to position
    if (_sheetHeight < 300) {
      _sheetHeight = 250;  // Collapsed
    } else {
      _sheetHeight = 420;  // Expanded
    }
  },
)
```

**Behavior:**
- User can drag up/down
- Snaps to nearest position:
  - **Collapsed:** 250px (when media added)
  - **Expanded:** 420px (default)
- Smooth animation (200ms)

#### **Auto-Collapse:**
When media is added:
```dart
setState(() {
  _attachments.add(media);
  _sheetHeight = 250;  // Auto-collapse
});
```

### **Specifications:**
- Position: Fixed at bottom
- Background: White
- Border radius: 20px (top corners only)
- Shadow: Elevation with blur
- Height: Dynamic (200px - 500px)
  - Default: 420px
  - Collapsed: 250px
- Animation: 200ms ease-in-out

---

## 🎬 Section Interactions

### **1. Navigation Bar ↔ Content**
```
User types content
    ↓
Post button turns green
    ↓
User taps Post
    ↓
Validation + Submit
```

### **2. Content ↔ Action Sheet**
```
User taps "Photo/video" in sheet
    ↓
Media picker opens
    ↓
User selects media
    ↓
Preview appears in content area
    ↓
Sheet auto-collapses to 250px
```

### **3. Action Sheet Dragging**
```
User drags handle down
    ↓
Sheet follows finger
    ↓
User releases
    ↓
Sheet snaps to nearest position
    (250px or 420px)
```

---

## 📊 Section Responsibilities

| Section | Responsibility | Scrollable | Height |
|---------|---------------|------------|--------|
| **1. Navigation Bar** | Close / Title / Post action | No (Fixed) | 56px |
| **2. Content Editor** | User identity, text input, media | Yes | Variable |
| **3. Action Sheet** | Post enhancement options | No (Fixed) | 250-420px |

---

## 🎨 Visual Hierarchy

```
┌─────────────────────────────────────┐
│ 1. TOP BAR (Most Important)         │ ← Post action
├─────────────────────────────────────┤
│ 2. CONTENT (Primary Focus)          │ ← What user creates
│                                     │
│    [Large borderless text area]    │ ← Inviting
│                                     │
├─────────────────────────────────────┤
│ 3. ACTIONS (Supporting)             │ ← Enhancement tools
└─────────────────────────────────────┘
```

### **Design Principles:**

1. **Navigation First** - Always visible, quick exit
2. **Content Centered** - Largest, most breathable area
3. **Actions Accessible** - Fixed bottom, always reachable
4. **Clear Separation** - Visual dividers between sections
5. **Smooth Interactions** - Animations between states

---

## ✅ Key Features Per Section

### **Section 1: Navigation Bar**
✅ Centered title
✅ Equal padding (16px both sides)
✅ State-aware Post button
✅ Clean, minimal design
✅ No elevation (flat)

### **Section 2: Content Editor**
✅ User identity with control chips
✅ Borderless text input (premium feel)
✅ Unlimited text expansion
✅ Horizontal media preview
✅ Generous padding (20px)
✅ Bouncing scroll physics

### **Section 3: Action Sheet**
✅ Draggable with gesture
✅ Snap-to-position behavior
✅ Color-coded actions
✅ Touch-friendly (56px rows)
✅ Auto-collapse on media add
✅ Smooth animations

---

## 🚀 Code Organization

### **File Structure:**
```dart
class CreatePostScreenV2 extends StatefulWidget {
  @override
  State<CreatePostScreenV2> createState() => _CreatePostScreenV2State();
}

class _CreatePostScreenV2State extends State<CreatePostScreenV2> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SECTION 1: TOP NAVIGATION BAR
      appBar: _buildAppBar(responsive),
      
      body: Stack(
        children: [
          // SECTION 2: CONTENT EDITOR AREA
          SingleChildScrollView(...),
          
          // SECTION 3: EXPANDABLE BOTTOM ACTION SHEET
          Positioned(bottom: 0, ...),
        ],
      ),
    );
  }
  
  // ============================================================
  // SECTION 1: TOP NAVIGATION BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar(Responsive responsive) { ... }
  
  // ============================================================
  // SECTION 2: CONTENT EDITOR AREA
  // ============================================================
  Widget _buildUserIdentity(Responsive responsive) { ... }
  Widget _buildMediaPreview(Responsive responsive) { ... }
  
  // ============================================================
  // SECTION 3: EXPANDABLE BOTTOM ACTION SHEET
  // ============================================================
  Widget _buildActionSheet(Responsive responsive) { ... }
}
```

### **Clear Comments:**
- Section headers with visual separators
- Sub-section labels
- Clear purpose descriptions

---

## 📐 Measurements Summary

| Element | Height | Width | Padding |
|---------|--------|-------|---------|
| **Navigation Bar** | 56px | 100% | 16px H |
| **User Identity** | ~80px | 100% | 16px all |
| **Divider** | 1px | 100% | - |
| **Text Input** | Variable | 100% | 20px H, 16px V |
| **Media Preview** | 130px | 100% | 16px H |
| **Action Sheet** | 250-420px | 100% | 20px H, 16px V |
| **Action Row** | 56px | 100% | 20px H |
| **Drag Handle** | 4px | 40px | 8px top |

---

## 🎉 Result

A **professional, well-structured Create Post interface** with three clearly defined sections:

1. **Fixed Navigation** - Always accessible
2. **Flexible Content** - Expands with user input
3. **Docked Actions** - Fixed but expandable

This creates a **Facebook-quality experience** while maintaining all Gistly features!

---

Built with Flutter 💙 | Inspired by Facebook 📘 | Designed for Gistly 🟢
