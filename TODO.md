# TODO List

## Combat Mode UI/UX Improvements

### 1. First-Time User Guide
- [ ] Add onboarding guide for first-time users
- [ ] Explain combat, and solo mode features
- [ ] Tutorial for hosting and joining rooms
- [ ] Nearby Connections permission explanations
- 

### 2. Distance Warning for Bluetooth Connection
- [x] Add note in host room screen: "Make sure devices are within 10 meters distance"
- [x] Add note in join room screen: "Make sure devices are within 10 meters distance"
- [x] Display distance requirements before starting connection

### 3. Title Shadow Enhancement
- [x] Improve title text shadow for better contrast
- [x] Update SliverAppBar titles with better visibility
- [x] Apply consistent shadow styling across all screens

### 4. Combat Navigator Improvements
- [x] Update combat navigator for better pop behavior
- [x] Handle back navigation properly
- [x] Prevent accidental exits during gameplay
- [x] Add confirmation dialogs for navigation actions

### 5. Design System Updates
- [ ] Implement better overall design patterns
- [ ] Update color scheme for better accessibility
- [ ] Improve layout consistency across combat screens
- [ ] Enhance spacing and padding standards

### 6. Alert Dialog Template
- [ ] Create standardized Alert dialog template
- [ ] Apply template to all existing dialogs
- [ ] Ensure consistent dialog styling
- [ ] Add proper icon and button layouts

### 7. TextStyle Consistency
- [ ] Create custom TextStyle constants
- [ ] Apply consistent typography throughout the app
- [ ] Update all text widgets to use standard styles
- [ ] Document TextStyle usage guidelines

### 8. Firework Animation Timing
- [ ] Fix firework animation to not appear immediately on opponent's screen
- [ ] Add delay to allow user to prepare for next turn
- [ ] Notify user when it's their turn to play
- [ ] Improve turn transition feedback

### 9. Settings and About Screen Consistency
- [ ] Update settings screen UI to match setdifficulty screen style
- [ ] Apply consistent UI patterns to about screen
- [ ] Ensure uniform layout and styling across configuration screens
- [ ] Standardize button and card designs

### 10. iOS Bluetooth Package Compatibility
- [ ] Check nearby_connections package iOS compatibility
- [ ] Verify Bluetooth permissions for iOS
- [ ] Test Nearby Connections on iOS devices
- [ ] Review iOS-specific Bluetooth limitations
- [ ] Update documentation for iOS requirements

### 11. Device Localization Detection
- [ ] Implement automatic locale detection from user device
- [ ] Add support for multiple languages based on device settings
- [ ] Configure default language fallback mechanism
- [ ] Test localization with different device language settings
### 12. Real-time Typing Synchronization
- [ ] Update the required string to the opponent after each correct input
- [ ] Synchronize typing progress to help opponent prepare for their turn
- [ ] Implement real-time progress tracking for both players
- [ ] Ensure low-latency updates for typing status
<!-- Update the required string into the opponent after each time the user typing correctly, easier to let the opponent catchup the typing statement of the user, let them get more ready for their turn -->

### 13. Play Again in Play Screen
- [ ] Add "Play Again" button to the menu in `play_screen.dart`
- [ ] Implement logic to reset game state and start a new match
- [ ] Ensure consistency with existing UI buttons and layouts
- [ ] Verify that all game resources are re-initialized correctly



# TODO List

## Combat Mode UI/UX Improvements

### 1. First-Time User Guide
- [ ] Add onboarding guide for first-time users
- [ ] Explain combat mode features
- [ ] Tutorial for hosting and joining rooms
- [ ] Nearby Connections permission explanations

### 2. Distance Warning for Bluetooth Connection
- [ ] Add note in host room screen: "Make sure devices are within 3 meters distance"
- [ ] Add note in join room screen: "Make sure devices are within 3 meters distance"
