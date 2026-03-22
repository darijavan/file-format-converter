# App Screenshots & UI Mockup

## Main Screen Layout

```
┌─────────────────────────────────────────────────────┐
│  File Format Converter                      ⚙️ 📱   │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │  📁 Select Video File                         │ │
│  │                                               │ │
│  │  Selected: vacation_video.mp4                 │ │
│  │                                               │ │
│  │  [📂 Pick Video File]                         │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │  🎯 Select Output Format                      │ │
│  │                                               │ │
│  │  From: [MP4]  ────────>  To: [AVI ▼]         │ │
│  │                                               │ │
│  │  Options: MP4, AVI, MOV, MKV, WebM, FLV       │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │           🎬 Convert Video                     │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │  ⚡ Conversion Progress                        │ │
│  │                                               │ │
│  │  🔄 Converting...                             │ │
│  │                                               │ │
│  │  ████████████████░░░░░░░░░░░░░  65.3%        │ │
│  │                                               │ │
│  │  Input:  vacation_video.mp4                   │ │
│  │  Output: vacation_video.avi                   │ │
│  │  Format: MP4 → AVI                            │ │
│  │                                               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Conversion States

### 1. Initial State (No File Selected)
```
┌─────────────────────────────────────┐
│  📁 Select Video File               │
│                                     │
│  [📂 Pick Video File]               │
└─────────────────────────────────────┘

Status: No active conversion
```

### 2. File Selected State
```
┌─────────────────────────────────────┐
│  📁 Select Video File               │
│  Selected: my_video.mp4             │
│  [📂 Pick Video File]               │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  🎯 Select Output Format            │
│  From: [MP4] ──> To: [AVI ▼]       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  🎬 Convert Video                   │
└─────────────────────────────────────┘
```

### 3. Converting State
```
┌─────────────────────────────────────┐
│  ⚡ Conversion Progress              │
│  🔄 Converting...                   │
│  ████████░░░░░░░░░░░░  42.5%       │
│                                     │
│  Input:  my_video.mp4               │
│  Output: my_video.avi               │
│  Format: MP4 → AVI                  │
└─────────────────────────────────────┘
```

### 4. Completed State
```
┌─────────────────────────────────────┐
│  ⚡ Conversion Progress              │
│  ✅ Completed                       │
│  ████████████████████████  100%    │
│                                     │
│  Input:  my_video.mp4               │
│  Output: my_video.avi               │
│  Format: MP4 → AVI                  │
│                                     │
│  ✓ File saved to:                   │
│  /storage/converted_files/          │
│  my_video.avi                       │
└─────────────────────────────────────┘
```

### 5. Failed State
```
┌─────────────────────────────────────┐
│  ⚡ Conversion Progress              │
│  ❌ Failed                          │
│  ████████░░░░░░░░░░░░░  45%        │
│                                     │
│  Input:  corrupted.mp4              │
│  Output: corrupted.avi              │
│  Format: MP4 → AVI                  │
│                                     │
│  ⚠️ Error: Invalid video stream     │
└─────────────────────────────────────┘
```

## Color Scheme

### Material Design 3 Theme
- **Primary Color**: Deep Purple (seedColor)
- **Secondary**: Purple shades
- **Success**: Green (#4CAF50)
- **Warning**: Orange (#FF9800)
- **Error**: Red (#F44336)
- **Background**: White / Light Grey

### Status Colors
- 🟢 **Completed**: Green
- 🔵 **Processing**: Blue (Primary)
- 🟠 **Pending**: Orange
- 🔴 **Failed**: Red
- ⚫ **Cancelled**: Grey

## Icons Used

| Element | Icon | Purpose |
|---------|------|---------|
| File Selection | 📂 | Open file picker |
| Video File | 🎬 | Video indicator |
| Converting | 🔄 | Processing animation |
| Success | ✅ | Completion |
| Error | ❌ | Failure |
| Progress | ⚡ | Active conversion |
| Format | 🎯 | Format selection |

## User Flow

```
Start
  ↓
[Pick Video File]
  ↓
File Selected → Display in UI
  ↓
[Select Output Format]
  ↓
Format Selected → Update dropdown
  ↓
[Tap Convert Button]
  ↓
Start Conversion
  ↓
Show Progress (0% → 100%)
  │
  ├─→ Success → Show completion message
  │             Show output file location
  │             Enable new conversion
  │
  └─→ Error → Show error message
              Enable retry
```

## Responsive Design

### Portrait Mode (Default)
- Single column layout
- Full-width cards
- Stacked components
- Easy thumb reach

### Landscape Mode (Tablet)
- Two-column layout possible
- Side-by-side file picker and format selector
- Progress at bottom
- Better use of space

## Accessibility Features

- ✅ Large touch targets (48dp minimum)
- ✅ Clear status indicators with icons
- ✅ High contrast colors
- ✅ Readable font sizes (14-18sp)
- ✅ Screen reader support (semantic labels)
- ✅ Progress announcements

## Animation & Feedback

1. **File Selection**: Bounce animation on selected file
2. **Progress Bar**: Smooth animation (0-100%)
3. **Status Changes**: Fade transition between states
4. **Button Press**: Ripple effect (Material Design)
5. **Completion**: Celebration animation (optional)

## Example Conversion Journey

```
Step 1: User opens app
        ↓
        Sees clean, empty interface
        "No active conversion" message

Step 2: User taps "Pick Video File"
        ↓
        System file picker opens
        User selects "birthday.mp4"
        ↓
        File name appears in UI

Step 3: User sees format selector appear
        ↓
        "From: MP4" automatically set
        "To: AVI" default selection

Step 4: User changes to "MOV"
        ↓
        Dropdown updates selection

Step 5: User taps "Convert Video"
        ↓
        Button becomes disabled
        Progress card appears
        Status: "Converting..."
        Progress bar: 0%

Step 6: Conversion in progress
        ↓
        Progress bar moves: 0% → 10% → 25% → 50% → 75% → 100%
        Status updates in real-time

Step 7: Conversion completes
        ↓
        Status: "Completed" ✅
        Progress: 100%
        Output path shown
        Button re-enabled for new conversion

Step 8: User can start a new conversion
        ↓
        Repeat from Step 2
```

## Platform-Specific Features

### Android
- Material Design 3 components
- Floating Action Button (optional)
- Bottom navigation (if multiple sections)
- System back button support

### iOS
- Cupertino-style navigation (optional)
- iOS native file picker
- Haptic feedback on actions
- System gestures support

## Future UI Enhancements

1. **Dark Mode** - System theme support
2. **Batch Mode** - List of multiple conversions
3. **History** - Previous conversions list
4. **Settings** - Quality presets, codec options
5. **Queue** - Multiple files in queue
6. **Themes** - Custom color schemes
7. **Animations** - More visual feedback
8. **Shortcuts** - Quick access to recent files

---

**Note**: This is a text-based mockup. The actual Flutter app uses Material Design 3 components for a polished, native look and feel on both platforms.
