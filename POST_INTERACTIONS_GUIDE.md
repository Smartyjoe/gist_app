# 📱 Post Interactions Guide - Comments, View, Share & Translation

## 🎉 Overview

This guide documents the complete post interaction system inspired by Facebook and Instagram, including:
- 💬 **Commenting System** - Nested comments with replies
- 📖 **Post Detail View** - Full-screen post view
- 🔗 **Share Widget** - Multi-platform sharing
- 🌐 **Translation UI** - Multi-language translation overlay

---

## 📁 File Structure

```
lib/
├── models/
│   └── comment.dart                              # Comment data model
├── screens/
│   └── post/
│       └── post_detail_screen.dart               # Full post view with comments
├── widgets/
│   ├── comment/
│   │   ├── comment_item.dart                     # Individual comment UI
│   │   └── comment_input.dart                    # Comment input field
│   └── post/
│       ├── post_card.dart                        # Updated with interactions
│       ├── share_bottom_sheet.dart               # Share options modal
│       └── translation_overlay.dart              # Translation dialog
```

---

## 💬 Commenting System

### **Comment Model**
Location: `lib/models/comment.dart`

**Features:**
- User information (ID, name, avatar)
- Comment content and timestamp
- Like count and liked state
- Nested replies support
- Parent comment tracking

**Key Properties:**
```dart
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;
  final List<Comment> replies;  // Nested comments
  final String? parentCommentId;
}
```

**Helper Methods:**
- `formattedDate` - Returns "Just now", "2h ago", "3d ago", or full date
- `copyWith()` - Immutable updates
- `getMockComments()` - Test data generator

---

### **Comment Item Widget**
Location: `lib/widgets/comment/comment_item.dart`

**UI Design:**
```
┌─────────────────────────────────────┐
│ 👤 [Avatar]  ┌─────────────────────┐│
│              │ User Name           ││
│              │ Comment text here...││
│              └─────────────────────┘│
│              2h ago  Like ❤️ 5  Reply│
│                                     │
│    👤 [Nested Reply]               │
│       ┌────────────────┐           │
│       │ Reply text... │            │
│       └────────────────┘            │
└─────────────────────────────────────┘
```

**Features:**
- ✅ Circular avatar with fallback
- ✅ Rounded bubble design (Instagram-style)
- ✅ Timestamp with smart formatting
- ✅ Like button with count
- ✅ Reply button (hidden for nested replies)
- ✅ Nested reply indentation
- ✅ Heart icon for likes
- ✅ Responsive sizing

**Interactions:**
- Tap "Like" → Toggle like state
- Tap "Reply" → Show reply input
- Supports infinite nesting (UI shows 1 level)

---

### **Comment Input Widget**
Location: `lib/widgets/comment/comment_input.dart`

**UI Design:**
```
┌─────────────────────────────────────┐
│ [Replying to John Doe]           ✕  │
├─────────────────────────────────────┤
│ 👤  ┌──────────────────────┐  ➤    │
│     │ Write a comment...   │ Send  │
│     │                      │  😊   │
│     └──────────────────────┘       │
└─────────────────────────────────────┘
```

**Features:**
- ✅ User avatar display
- ✅ Expandable text field (1-5 lines)
- ✅ Reply indicator banner
- ✅ Emoji button (placeholder)
- ✅ Send button (enabled when has text)
- ✅ Safe area support
- ✅ Fixed at bottom of screen

**States:**
- **Normal:** Write a comment...
- **Replying:** Shows "Replying to [User]" banner with cancel
- **Has Text:** Send button turns green
- **Empty:** Send button disabled (gray)

---

## 📖 Post Detail Screen

Location: `lib/screens/post/post_detail_screen.dart`

### **Layout Structure:**

```
┌─────────────────────────────────────┐
│ ← John Doe                      ⋮   │ App Bar
├─────────────────────────────────────┤
│ 👤 John Doe              [Emergency]│ Header
│    🌐 Public                        │
├─────────────────────────────────────┤
│                                     │
│ Post content text here...           │ Content
│                                     │
│ 📍 Location Name                    │
│ [Category]                          │
├─────────────────────────────────────┤
│ [────── Image ──────]               │ Media
├─────────────────────────────────────┤
│ ❤️ 45        23 comments • 5 shares│ Stats
├─────────────────────────────────────┤
│ [Like] [Comment] [Share] [Translate]│ Actions
├─────────────────────────────────────┤
│ Comments                            │
│                                     │
│ 💬 Comment 1                        │
│ 💬 Comment 2                        │
│ 💬 Comment 3                        │
│    └─ Reply to comment 3            │
│                                     │
└─────────────────────────────────────┘
│ 👤 [Write a comment...]        ➤   │ Fixed Input
└─────────────────────────────────────┘
```

### **Features:**

**Post Display:**
- ✅ Full post content (no truncation)
- ✅ Priority badge (color-coded)
- ✅ Location with icon
- ✅ Category chips
- ✅ Media display (images, videos)
- ✅ Engagement statistics

**Interactions:**
- ✅ Like post (toggle with animation)
- ✅ Share post (opens bottom sheet)
- ✅ Translate post (opens overlay)
- ✅ Add comment (fixed input at bottom)
- ✅ Reply to comment
- ✅ Like comment
- ✅ Scroll through comments
- ✅ Back navigation

**State Management:**
- Live updates for likes/comments
- Reply mode tracking
- Translation state
- Comment list updates

---

## 🔗 Share Bottom Sheet

Location: `lib/widgets/post/share_bottom_sheet.dart`

### **UI Design:**

```
┌─────────────────────────────────────┐
│          Share Post              ✕  │
├─────────────────────────────────────┤
│                                     │
│  📱      📘      ✈️      🐦        │
│ WhatsApp Facebook Telegram Twitter │
│                                     │
│  ✉️      💬      🔗      ⋯         │
│  Email    SMS   Copy Link  More    │
│                                     │
├─────────────────────────────────────┤
│ 👤 Send to a Friend              →  │
│    Share with someone in the app    │
├─────────────────────────────────────┤
│ 🚩 Report Post                   →  │
│    Report inappropriate content     │
└─────────────────────────────────────┘
```

### **Features:**

**Platform Sharing:**
- ✅ WhatsApp (green icon)
- ✅ Facebook (blue icon)
- ✅ Telegram (light blue icon)
- ✅ Twitter (blue icon)
- ✅ Email (gray icon)
- ✅ SMS (green icon)
- ✅ Copy Link (clipboard)
- ✅ More options

**Additional Actions:**
- ✅ Send to a friend (in-app sharing)
- ✅ Report post (inappropriate content)

**Interactions:**
- Tap platform → Share via that platform
- Copy Link → Copies to clipboard
- Report → Shows confirmation dialog
- Drag handle for dismissal

**Visual Design:**
- Rounded top corners
- Color-coded platform icons
- Icon + label format
- Smooth slide-up animation
- Backdrop blur effect

---

## 🌐 Translation Overlay

Location: `lib/widgets/post/translation_overlay.dart`

### **UI Design:**

```
┌─────────────────────────────────────┐
│ 🌐 Translation                  ✕   │
├─────────────────────────────────────┤
│ [English ▼]  ⇄  [Yoruba ▼]         │
├─────────────────────────────────────┤
│ ORIGINAL                            │
│ ┌─────────────────────────────────┐ │
│ │ The streetlight is broken and   │ │
│ │ needs urgent repair...          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ TRANSLATION                  Copy   │
│ ┌─────────────────────────────────┐ │
│ │ Fitila opopona ti bajẹ ati pe   │ │
│ │ o nilo atunṣe kiakia...         │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ ℹ️ Translations are powered by AI   │
│   and may not be 100% accurate     │
└─────────────────────────────────────┘
```

### **Features:**

**Language Selection:**
- ✅ Source language dropdown
- ✅ Target language dropdown
- ✅ Swap languages button (⇄)
- ✅ Supported: English, Yoruba, Hausa, Igbo, French, Arabic

**Display:**
- ✅ Original text (gray background)
- ✅ Translated text (green background with border)
- ✅ Copy translation button
- ✅ Disclaimer about AI accuracy

**Interactions:**
- Select language → Updates translation
- Swap button → Reverses source/target
- Copy button → Copies to clipboard
- Close (X) → Dismisses overlay
- Tap outside → Closes dialog

**Animations:**
- ✅ Scale animation (0.8 → 1.0)
- ✅ Fade in effect
- ✅ Smooth entrance/exit
- ✅ Backdrop blur

---

## 🎨 Updated Post Card

Location: `lib/widgets/post/post_card.dart`

### **Changes Made:**

**From StatelessWidget → StatefulWidget:**
- Now manages its own state
- Handles like/comment/share/translate internally
- No longer requires callback props

**New Features:**
- ✅ **Tap card** → Opens PostDetailScreen
- ✅ **Like button** → Toggles like state (updates count)
- ✅ **Comment button** → Opens PostDetailScreen
- ✅ **Share button** → Opens ShareBottomSheet
- ✅ **Translate button** → Shows TranslationOverlay
- ✅ **Translation state** → Shows translated text in card
- ✅ **Dynamic button labels** → "Translate" ↔ "Original"

**Before:**
```dart
PostCard(
  post: post,
  onLike: () => handleLike(),
  onComment: () => handleComment(),
  onShare: () => handleShare(),
  onTranslate: () => handleTranslate(),
)
```

**After:**
```dart
PostCard(post: post)  // Self-contained!
```

---

## 🎯 User Interaction Flows

### **1. View Post Details**

```
User taps on post card
        ↓
PostDetailScreen opens
        ↓
Shows full post content
        ↓
Displays all comments
        ↓
User can scroll, like, share, translate
```

### **2. Comment on Post**

```
User taps "Comment" button
        ↓
PostDetailScreen opens
        ↓
Comment input is visible at bottom
        ↓
User types comment
        ↓
Send button turns green
        ↓
User taps send
        ↓
Comment appears at top of list
        ↓
Comment count updates
```

### **3. Reply to Comment**

```
User taps "Reply" on a comment
        ↓
Reply banner appears: "Replying to [User]"
        ↓
User types reply
        ↓
User taps send
        ↓
Reply appears nested under parent comment
        ↓
Reply banner dismisses
```

### **4. Share Post**

```
User taps "Share" button
        ↓
ShareBottomSheet slides up
        ↓
User sees platform options
        ↓
User taps WhatsApp (for example)
        ↓
Share dialog closes
        ↓
Success message appears
        ↓
Native share intent opens (in production)
```

### **5. Translate Post**

```
User taps "Translate" button
        ↓
TranslationOverlay fades in
        ↓
Shows original and translated text
        ↓
User can swap languages
        ↓
User can copy translation
        ↓
User taps X or outside to close
        ↓
Overlay fades out
        ↓
Button label changes to "Original"
```

### **6. Like Post/Comment**

```
User taps "Like"
        ↓
Heart icon fills (or empties)
        ↓
Color changes to red/orange
        ↓
Like count updates (+1 or -1)
        ↓
State persists in UI
```

---

## 🎨 Design Patterns Used

### **1. Instagram-Style Comments**
- Rounded speech bubbles
- Nested indentation for replies
- Timestamp + Like + Reply actions below
- Avatar on the left

### **2. Facebook-Style Sharing**
- Grid of platform icons
- Color-coded platforms
- Additional actions below
- Bottom sheet modal

### **3. Modern Translation UI**
- Card-based overlay
- Language switcher at top
- Original vs Translation comparison
- Copy functionality
- AI disclaimer

### **4. Smooth Animations**
- Scale transitions (0.8 → 1.0)
- Fade effects (0.0 → 1.0)
- Slide animations (bottom sheets)
- Color transitions (like button)

---

## 📊 Component Interactions

```
PostCard
   ├─→ Tap Card ─→ PostDetailScreen
   ├─→ Like Button ─→ Update State
   ├─→ Comment Button ─→ PostDetailScreen
   ├─→ Share Button ─→ ShareBottomSheet
   └─→ Translate Button ─→ TranslationOverlay

PostDetailScreen
   ├─→ Comment Input ─→ Add Comment
   ├─→ Reply Button ─→ Set Reply Mode
   ├─→ Like Comment ─→ Update Comment
   ├─→ Share Button ─→ ShareBottomSheet
   └─→ Translate Button ─→ TranslationOverlay

ShareBottomSheet
   ├─→ Platform Icons ─→ Share Action
   ├─→ Copy Link ─→ Clipboard
   ├─→ Send to Friend ─→ User List (TODO)
   └─→ Report Post ─→ Report Dialog

TranslationOverlay
   ├─→ Language Dropdowns ─→ Update Translation
   ├─→ Swap Button ─→ Reverse Languages
   ├─→ Copy Button ─→ Clipboard
   └─→ Close Button ─→ Dismiss
```

---

## 🔧 Implementation Details

### **State Management:**
- **PostCard:** Manages like/translate state
- **PostDetailScreen:** Manages comments, likes, reply mode
- **CommentInput:** Manages text input, send button state
- **TranslationOverlay:** Manages language selection

### **Navigation:**
- **Push:** PostDetailScreen
- **Modal:** ShareBottomSheet, TranslationOverlay
- **Pop:** Back to previous screen

### **Data Flow:**
- Parent → Child: Post data
- Child → Parent: N/A (self-contained)
- State updates: Local setState()

### **Mock Data:**
- Comments: `Comment.getMockComments()`
- Translation: Simulated with "Translated: " prefix
- Share: Shows snackbar (native in production)

---

## 🎯 Features Summary

| Feature | Status | Platform Support |
|---------|--------|------------------|
| View Post Detail | ✅ Complete | All |
| Add Comment | ✅ Complete | All |
| Reply to Comment | ✅ Complete | All |
| Like Post | ✅ Complete | All |
| Like Comment | ✅ Complete | All |
| Share to WhatsApp | ✅ UI Ready | Needs native integration |
| Share to Facebook | ✅ UI Ready | Needs native integration |
| Share to Telegram | ✅ UI Ready | Needs native integration |
| Share to Twitter | ✅ UI Ready | Needs native integration |
| Share via Email | ✅ UI Ready | Needs native integration |
| Share via SMS | ✅ UI Ready | Needs native integration |
| Copy Link | ✅ Complete | All |
| Translate Post | ✅ UI Ready | Needs translation API |
| Report Post | ✅ UI Ready | Needs backend |
| Nested Comments | ✅ Complete | All |
| Comment Likes | ✅ Complete | All |

---

## 🚀 Next Steps (Optional Enhancements)

### **Backend Integration:**
- [ ] Connect to real API for comments
- [ ] Implement actual translation service
- [ ] Add native share functionality
- [ ] Implement report system

### **Features:**
- [ ] Edit comment
- [ ] Delete comment
- [ ] Load more comments (pagination)
- [ ] Comment reactions (😂😮😢)
- [ ] Mention users (@username)
- [ ] Image/GIF in comments
- [ ] Pin comments
- [ ] Sort comments (newest, top)

### **UI Enhancements:**
- [ ] Skeleton loading for comments
- [ ] Pull-to-refresh
- [ ] Swipe actions (like, reply)
- [ ] Long-press menu
- [ ] Read more/less for long comments
- [ ] Link preview in comments

---

## 📝 Usage Example

```dart
// In your screen (e.g., HomeScreen, ExploreScreen)
PostCard(post: myPost)  // That's it!

// The card handles everything:
// - Tapping → Opens detail view
// - Liking → Updates UI
// - Commenting → Opens detail with input
// - Sharing → Shows share options
// - Translating → Shows translation
```

---

## 🎨 Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Like (Active) | Orange/Red | `#FF6B35` |
| Like Icon | Orange | `#FF6B35` |
| Primary Action | Green | `#0F9D58` |
| Comment Bubble BG | Light Gray | `#F5F5F5` |
| Translation BG | Light Green | `#0F9D580D` (10% opacity) |
| Share Icons | Platform Colors | Various |

---

## ✅ Testing Checklist

- [x] Post card tap opens detail screen
- [x] Like button toggles state
- [x] Like count updates correctly
- [x] Comment button opens detail screen
- [x] Share button shows bottom sheet
- [x] Translate button shows overlay
- [x] Comment input appears at bottom
- [x] Comments display correctly
- [x] Reply mode works
- [x] Nested replies show indented
- [x] Copy link works
- [x] Language swap works
- [x] Animations are smooth
- [x] Responsive on all screen sizes
- [x] No overflow errors

---

**🎉 Your community reporting app now has world-class post interactions! 🎉**

Built with Flutter 💙 | Inspired by Facebook & Instagram 📱
