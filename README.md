# Nucatch with-bloc

## 🔐 Firebase Anonymous Authentication

This project now supports **Firebase Anonymous Authentication**, allowing users to seamlessly use the app without creating an account. Each user automatically receives a unique Firebase User ID that persists across app sessions.

### Key Features
- ✅ Automatic anonymous sign-in on app launch
- ✅ Persistent user ID across sessions
- ✅ Ready for account upgrade (email/phone/social providers)
- ✅ Integrated with existing username system
- ✅ Secure user data management

### Quick Start

1. **Enable Anonymous Auth in Firebase Console:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Navigate to **Authentication** → **Sign-in method**
   - Enable **Anonymous** authentication

2. **The app automatically handles:**
   - User sign-in on first launch
   - User ID persistence
   - Session management

### Documentation
For detailed implementation guide, security considerations, and upgrade paths, see:
- 📖 [FIREBASE_AUTH_SETUP.md](./FIREBASE_AUTH_SETUP.md) - Complete implementation guide

---

## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/mtuan0111/nucatch-with-bloc.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/mtuan0111/nucatch-with-bloc/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.

# Generating the icons
- References document: https://pub.dev/packages/flutter_launcher_icons

- Command line:
```dart run flutter_launcher_icons```

## Released on: 17/04/2025
### App core:
Version: 1.0.15
[GitHub Repository](https://github.com/macromilldev/app_core.git)

### Custom version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 411          | 3.7.18  |
| iOS      | 267          | 5.6.13  |

### Release note:
- Update ErrorResponseModel to log non-fatal errors to Firebase Crashlytics

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Flutter build for Android`, `Flutter build for iOS`

    `[Builded] Version 3.7.18 - 411 / 5.6.13 - 267 _ Update ErrorResponseModel to log non-fatal errors to Firebase Crashlytics`

    Flutter build for Android
    ```flutter build appbundle --build-name=3.7.18 --build-number=411 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=5.6.13 --build-number=267 --release```

---
## Released on: 07/05/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 35           | 2.0.0  |
| iOS      | 36           | 2.0.0  |

### Release note:
- Build the latest version of the app using Flutter to ensure all updates and enhancements are included.
_ Update README and build.gradle for versioning and signing configuration; add keystore for release builds

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Flutter build for Android`, `Flutter build for iOS`

    `[Builded] Version 2.0.0 - 35 / 2.0.0 - 36 _ Build the latest version of the app using Flutter to ensure all updates and enhancements are included`

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.0 --build-number=35 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.0 --build-number=36 --release```
---
## Released on: 14/05/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 36           | 2.0.1  |
| iOS      | 40           | 2.0.0  |

### Release note:
Update app icons and privacy information; enhance play screen layout

- Replaced multiple app icon images in the iOS asset catalog with updated versions.
- Added PrivacyInfo.xcprivacy file for privacy settings.
- Modified main.dart to disable the debug banner.
- Enhanced play_screen.dart layout for better responsiveness on tablet devices.

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Flutter build for Android`, `Flutter build for iOS`

    `[Builded] Version 2.0.1 - 36 / 2.0.0 - 40 _ Update app icons and privacy information; enhance play screen layout`

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.1 --build-number=36 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.0 --build-number=40 --release```
---
## Released on: 08/06/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 37           | 2.0.2  |
| iOS      | 41           | 2.0.1  |

### Release note:
feat: Add QR code scanning functionality and localization support for scan instructions

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.0.2 - 37 / 2.0.1 - 41 _ Add QR code scanning functionality and localization support for scan instructions

    **Store notices / What's new / Summary:**

    - **English:**  
        - Introduced QR code scanning feature for enhanced user interaction.  
        - Added localization for scan instructions to support multiple languages.  
        - Improved user experience and accessibility.

    - **Tiếng Việt:**  
        - Đã thêm tính năng quét mã QR giúp tương tác người dùng tốt hơn.  
        - Bổ sung đa ngôn ngữ cho hướng dẫn quét mã.  
        - Nâng cao trải nghiệm và khả năng tiếp cận cho người dùng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.2 --build-number=37 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.1 --build-number=41 --release```
    [Builded] Version 2.0.2 - 37 / 2.0.1 - 41 _ Add QR code scanning functionality and localization support for scan instructions

    **Store notices / What's new / Summary:**
    - Introduced QR code scanning feature for enhanced user interaction.
    - Added localization for scan instructions to support multiple languages.
    - Improved user experience and accessibility.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.2 --build-number=37 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.1 --build-number=41 --release```
---
## Released on: 12/06/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 38           | 2.0.3   |
| iOS      | 42           | 2.0.2   |

### Release note:
feat: Replace RankBadge with RankingSortingWidget for improved ranking display; update game over and play screens

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.0.3 - 38 / 2.0.2 - 42 _ Replace RankBadge with RankingSortingWidget for improved ranking display; update game over and play screens

    **Store notices / What's new / Summary:**

    - **English:**  
        - Updated game over and play screens for enhanced user experience.  
        - Improved UI consistency and performance.

    - **Tiếng Việt:**  
        - Cập nhật màn hình kết thúc trò chơi và màn hình chơi để nâng cao trải nghiệm người dùng.  
        - Cải thiện sự nhất quán giao diện và hiệu năng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.3 --build-number=38 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.2 --build-number=42 --release```
---
## Released on: 15/06/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 39           | 2.0.4   |
| iOS      | 43           | 2.0.3   |

### Release note:
feat: 
_ Add save success sound and vibration settings
_ Update event handling for game over
_ Update game over and play screens
_ Modify save recorded event handling
_ Add exit confirmation prompt in English and Vietnamese
_ Update localization and UI handling

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't metion any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.0.4 - 39 / 2.0.3 - 43 _ Add save success sound and vibration settings; update event handling and localization

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added sound and vibration options for save success.  
        - Improved event handling and screen updates.  
        - Enhanced localization and UI prompts.

    - **Tiếng Việt:**  
        - Thêm tùy chọn âm thanh và rung khi lưu thành công.  
        - Cải thiện xử lý sự kiện và cập nhật giao diện.  
        - Nâng cao đa ngôn ngữ và thông báo giao diện.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.4 --build-number=39 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.3 --build-number=43 --release```
---
---
## Released on: 26/07/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 40           | 2.0.5   |
| iOS      | 44           | 2.0.4   |

### Release note:
feat: 
_ Add the animation for the life remaining

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.0.5 - 40 / 2.0.4 - 44 _ Add animation for life remaining

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added animation for remaining lives to enhance visual feedback.

    - **Tiếng Việt:**  
        - Thêm hiệu ứng động cho số mạng còn lại để tăng trải nghiệm hình ảnh.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.0.5 --build-number=40 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.0.4 --build-number=44 --release```
---
---
## Released on: 12/08/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 41           | 2.1.0   |
| iOS      | 45           | 2.1.0   |

### Release note:
feat: 
_ Add the setting the difficult level

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.1.0 - 41 / 2.1.0 - 45 _ Add difficulty level setting

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added option to set difficulty level for a more personalized experience.

    - **Tiếng Việt:**  
        - Thêm tùy chọn thiết lập mức độ khó để cá nhân hóa trải nghiệm người dùng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.1.0 --build-number=41 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.1.0 --build-number=45 --release```
---
---
## Released on: 08/09/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 42           | 2.1.1   |
| iOS      | 46           | 2.1.1   |

### Release note:
feat: Update environment URLs, improve layout responsiveness, and enhance button functionality

### Git note release: 
#### Command for copilot
    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.1.1 - 42 / 2.1.1 - 46 _ Update environment URLs, improve layout responsiveness, and enhance button functionality

    **Store notices / What's new / Summary:**

    - **English:**  
        - Updated environment URLs for improved connectivity.  
        - Enhanced layout responsiveness across devices.  
        - Improved button functionality for better user experience.

    - **Tiếng Việt:**  
        - Cập nhật đường dẫn môi trường để kết nối tốt hơn.  
        - Nâng cao khả năng hiển thị giao diện trên nhiều thiết bị.  
        - Cải thiện chức năng nút bấm cho trải nghiệm người dùng tốt hơn.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.1.1 --build-number=42 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.1.1 --build-number=46 --release```
---
---
## Released on: 16/09/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 43           | 2.1.2   |
| iOS      | 47           | 2.1.2   |

### Release note:
feat: Implement difficulty settings, enhance UI responsiveness, and improve user experience across various screens

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.1.2 - 43 / 2.1.2 - 47 _ Implement difficulty settings, enhance UI responsiveness, and improve user experience across various screens

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added new difficulty settings for more flexible gameplay.  
        - Improved UI responsiveness and user experience on multiple screens.

    - **Tiếng Việt:**  
        - Thêm thiết lập độ khó mới cho trải nghiệm chơi linh hoạt hơn.  
        - Nâng cao khả năng phản hồi giao diện và trải nghiệm người dùng trên nhiều màn hình.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.1.2 --build-number=43 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.1.2 --build-number=47 --release```
---
---
## Released on: 17/09/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 44           | 2.1.3   |
| iOS      | 48           | 2.1.3   |

### Release note:
Update launcher icons and refactor UI components in various screens

- Updated launcher icons for different mipmap densities.
- Refactored the About Screen to improve layout and structure.
- Enhanced the Set Difficulty Screen with better state management and UI responsiveness.
- Improved the Setting Screen by organizing form fields and enhancing user experience.
- Refined the Top Score Details and Top Score Screens for better readability and maintainability.

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.1.3 - 44 / 2.1.3 - 48 _ Update launcher icons and refactor UI components in various screens

    **Store notices / What's new / Summary:**

    - **English:**  
        - Updated launcher icons for improved appearance.  
        - Refactored and enhanced UI components across multiple screens.

    - **Tiếng Việt:**  
        - Cập nhật biểu tượng ứng dụng cho giao diện đẹp hơn.  
        - Cải tiến và sắp xếp lại các thành phần giao diện trên nhiều màn hình.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.1.3 --build-number=44 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.1.3 --build-number=48 --release```
---
---
## Released on: 18/109/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 45           | 2.2.1   |
| iOS      | 49           | 2.2.1   |

### Release note:
Update the top recorded scores to be stored online

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.2.1 - 45 / 2.2.1 - 49 _ Update the top recorded scores to be stored online

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added online score storage for top recorded scores.  
        - Enhanced leaderboard functionality for better competition experience.

    - **Tiếng Việt:**  
        - Thêm tính năng lưu trữ điểm số cao nhất trực tuyến.  
        - Nâng cao chức năng bảng xếp hạng cho trải nghiệm cạnh tranh tốt hơn.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.2.1 --build-number=45 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.2.1 --build-number=49 --release```
---
---
## Released on: 19/10/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 46           | 2.2.2   |
| iOS      | 50           | 2.2.2   |

### Release note:
Update the top recorded scores to be stored online

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.2.2 - 46 / 2.2.2 - 50 _ Update the top recorded scores to be stored online

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced online score storage system for improved performance.  
        - Optimized leaderboard functionality and data synchronization.

    - **Tiếng Việt:**  
        - Nâng cao hệ thống lưu trữ điểm số trực tuyến để hiệu suất tốt hơn.  
        - Tối ưu hóa chức năng bảng xếp hạng và đồng bộ hóa dữ liệu.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.2.2 --build-number=46 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.2.2 --build-number=50 --release```
---
---
## Released on: 23/10/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 48           | 2.2.4   |
| iOS      | 52           | 2.2.4   |

### Release note:
Optimize the application

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`



    [Builded] Version 2.2.4 - 48 / 2.2.4 - 52 _ Optimize the application

    **Store notices / What's new / Summary:**

    - **English:**  
        - Improved application performance and stability.  
        - Enhanced user experience with optimized functionality.

    - **Tiếng Việt:**  
        - Cải thiện hiệu suất và tính ổn định của ứng dụng.  
        - Nâng cao trải nghiệm người dùng với chức năng được tối ưu hóa.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.2.4 --build-number=48 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.2.4 --build-number=52 --release```


---
---
## Released on: 19/10/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 46           | 2.2.2   |
| iOS      | 50           | 2.2.2   |

### Release note:
Update the top recorded scores to be stored online

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.2.2 - 46 / 2.2.2 - 50 _ Update the top recorded scores to be stored online

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced online score storage system for improved performance.  
        - Optimized leaderboard functionality and data synchronization.

    - **Tiếng Việt:**  
        - Nâng cao hệ thống lưu trữ điểm số trực tuyến để hiệu suất tốt hơn.  
        - Tối ưu hóa chức năng bảng xếp hạng và đồng bộ hóa dữ liệu.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.2.2 --build-number=46 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.2.2 --build-number=50 --release```
---
---
## Released on: 23/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 49           | 2.3.1   |
| iOS      | 53           | 2.3.1   |

### Release note:
feat: Implement leaderboard filtering by daily, weekly, and all-time periods; enhance localization support

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    [Builded] Version 2.3.1 - 49 / 2.3.1 - 53 _ Implement leaderboard filtering by daily, weekly, and all-time periods; enhance localization support

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added leaderboard filtering options for daily, weekly, and all-time periods.  
        - Enhanced localization support for better global user experience.

    - **Tiếng Việt:**  
        - Thêm tùy chọn lọc bảng xếp hạng theo ngày, tuần và tất cả thời gian.  
        - Nâng cao hỗ trợ đa ngôn ngữ cho trải nghiệm người dùng toàn cầu tốt hơn.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.3.1 --build-number=49 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.3.1 --build-number=53 --release```


---
---
## Released on: 23/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 50           | 2.3.2   |
| iOS      | 54           | 2.3.2   |

### Release note:
feat: Implement cache management for Firebase data and add refresh functionality

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    [Builded] Version 2.3.2 - 50 / 2.3.2 - 54 _ Implement cache management for Firebase data and add refresh functionality

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added cache management for improved data loading performance.  
        - Implemented refresh functionality for updated content.

    - **Tiếng Việt:**  
        - Thêm quản lý bộ nhớ đệm để cải thiện hiệu suất tải dữ liệu.  
        - Triển khai chức năng làm mới để cập nhật nội dung.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.3.2 --build-number=50 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.3.2 --build-number=54 --release```
---
---
## Released on: 23/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 51           | 2.3.3   |
| iOS      | 55           | 2.3.3   |

### Release note:
 Refactor MenuAlert layout to use Column and improve RankingSortingWidget integration
 Enhance RankingSortingWidget layout with improved padding and border adjustments
 Update TurnRecordedListBloc and TurnRecordedServices to use RankingPeriod enum for period handling

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    [Builded] Version 2.3.3 - 51 / 2.3.3 - 55 _ Improve app layout and user interface design

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced menu layout and ranking widget integration for better user experience.  
        - Improved UI responsiveness and visual consistency.

    - **Tiếng Việt:**  
        - Nâng cao bố cục menu và tích hợp widget xếp hạng để trải nghiệm người dùng tốt hơn.  
        - Cải thiện khả năng phản hồi giao diện và tính nhất quán hình ảnh.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.3.3 --build-number=51 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.3.3 --build-number=55 --release```
---
---
## Released on: 25/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 52           | 2.3.4   |
| iOS      | 56           | 2.3.4   |

### Release note:
feat: Implement Firebase Anonymous Authentication

- Added `firebase_auth: ^6.1.1` dependency to `pubspec.yaml`
- Created `AuthServices` class for handling authentication logic
- Updated `UserModel` to include `firebaseUserId` and `isAnonymous` fields
- Enhanced `UserServices` with `initializeAuth()` method for automatic anonymous sign-in
- Integrated Firebase authentication into `UserBloc`
- Added `FIREBASE_USER_ID` constant to `PreferencesKey` for user ID storage
- Created `AuthDebugWidget` for development testing of authentication status
- Updated macOS and Windows plugin registrants to include Firebase Auth
- Comprehensive documentation added for setup and implementation

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`



    [Builded] Version 2.3.4 - 52 / 2.3.4 - 56 _ Implement Firebase Anonymous Authentication

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added seamless user authentication for enhanced app experience.  
        - Improved user data management and session persistence.  
        - Enhanced app stability and user identification features.

    - **Tiếng Việt:**  
        - Thêm xác thực người dùng liền mạch để nâng cao trải nghiệm ứng dụng.  
        - Cải thiện quản lý dữ liệu người dùng và duy trì phiên làm việc.  
        - Tăng cường tính ổn định ứng dụng và tính năng nhận dạng người dùng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.3.4 --build-number=52 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.3.4 --build-number=56 --release```

---

---
## Released on: 27/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 53           | 2.3.3   |
| iOS      | 55           | 2.3.3   |

### Release note:
feat: Refactor AboutScreen to use CustomElevatedButton for improved UI consistency

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.3.3 - 53 / 2.3.3 - 55 _ Refactor AboutScreen to use CustomElevatedButton for improved UI consistency

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced About screen with improved button design.  
        - Refined user interface for better visual consistency.

    - **Tiếng Việt:**  
        - Nâng cao màn hình Giới thiệu với thiết kế nút bấm được cải tiến.  
        - Tinh chỉnh giao diện người dùng để nhất quán hơn về mặt hình ảnh.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.3.3 --build-number=53 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.3.3 --build-number=55 --release```
    ```
---
## Released on: 29/11/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 54           | 2.4.1   |
| iOS      | 56           | 2.4.1   |

### Release note:
feat: Improved UI consistency

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.4.1 - 54 / 2.4.1 - 56 _ Improved UI consistency

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced user interface for better visual consistency.  
        - Improved overall app design and user experience.

    - **Tiếng Việt:**  
        - Nâng cao giao diện người dùng để nhất quán hơn về mặt hình ảnh.  
        - Cải thiện thiết kế tổng thể và trải nghiệm người dùng của ứng dụng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.1 --build-number=54 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.1 --build-number=56 --release```
    ```
    ---
---
## Released on: 23/12/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 55           | 2.4.2   |
| iOS      | 57           | 2.4.2   |

### Release note:
feat: Improved UI consistency

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.4.2 - 55 / 2.4.2 - 57 _ Improved UI consistency

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced user interface for better visual consistency.  
        - Improved overall app design and user experience.

    - **Tiếng Việt:**  
        - Nâng cao giao diện người dùng để nhất quán hơn về mặt hình ảnh.  
        - Cải thiện thiết kế tổng thể và trải nghiệm người dùng của ứng dụng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.2 --build-number=55 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.2 --build-number=57 --release```
    ```
    ---
---
## Released on: 23/12/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 56           | 2.4.3   |
| iOS      | 58           | 2.4.3   |

### Release note:
feat: Add the Christmas theme

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.4.3 - 56 / 2.4.3 - 58 _ Add the Christmas theme

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added festive Christmas theme for a joyful holiday experience.  
        - Enhanced visual design with seasonal decorations and colors.

    - **Tiếng Việt:**  
        - Thêm chủ đề Giáng sinh lễ hội cho trải nghiệm ngày lễ vui vẻ.  
        - Nâng cao thiết kế hình ảnh với trang trí và màu sắc theo mùa.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.3 --build-number=56 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.3 --build-number=58 --release```
    ```
    ---
---
## Released on: 25/12/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 57           | 2.4.4   |
| iOS      | 59           | 2.4.4   |

### Release note:
feat: Add the Season theme

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.4.4 - 57 / 2.4.4 - 59 _ Add the Season theme

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added seasonal theme for enhanced visual experience.  
        - Improved app design with dynamic theme options.

    - **Tiếng Việt:**  
        - Thêm chủ đề theo mùa để nâng cao trải nghiệm hình ảnh.  
        - Cải thiện thiết kế ứng dụng với các tùy chọn chủ đề linh hoạt.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.4 --build-number=57 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.4 --build-number=59 --release```
    ```
---
## Released on: 25/12/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 58           | 2.4.5   |
| iOS      | 60           | 2.4.5   |

### Release note:
feat: Add the Season theme

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


    ```
    [Builded] Version 2.4.5 - 58 / 2.4.5 - 60 _ Add the Season theme

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added seasonal theme for enhanced visual experience.  
        - Improved app design with dynamic theme options.

    - **Tiếng Việt:**  
        - Thêm chủ đề theo mùa để nâng cao trải nghiệm hình ảnh.  
        - Cải thiện thiết kế ứng dụng với các tùy chọn chủ đề linh hoạt.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.5 --build-number=58 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.5 --build-number=60 --release```
    ```
    ---
---
## Released on: 26/12/2025
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 60           | 2.4.6   |
| iOS      | 61           | 2.4.6   |

### Release note:
feat: Improve UI UX

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`


[Builded] Version 2.4.6 - 60 / 2.4.6 - 61 _ Improve UI UX

**Store notices / What's new / Summary:**

- **English:**  
    - Improved user interface for a smoother experience.  
    - Enhanced overall app design and usability.

- **Tiếng Việt:**  
    - Cải thiện giao diện người dùng để mang lại trải nghiệm mượt mà hơn.  
    - Nâng cao thiết kế và khả năng sử dụng tổng thể của ứng dụng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.4.6 --build-number=60 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.4.6 --build-number=61 --release```
---
## Released on: 5/1/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 61           | 2.5.1   |
| iOS      | 62           | 2.5.1   |

### Release note:
feat: Improve UI UX, add the multiple player

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    ```
    [Builded] Version 2.5.1 - 61 / 2.5.1 - 62 _ Improve UI UX, add the multiple player

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added multiplayer support for more engaging gameplay.  
        - Improved user interface for better visual experience.  
        - Enhanced overall app design and usability.

    - **Tiếng Việt:**  
        - Thêm hỗ trợ chơi nhiều người để trải nghiệm chơi game hấp dẫn hơn.  
        - Cải thiện giao diện người dùng để trải nghiệm hình ảnh tốt hơn.  
        - Nâng cao thiết kế và khả năng sử dụng tổng thể của ứng dụng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.1 --build-number=61 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.1 --build-number=62 --release```
    ```
    ---
---
## Released on: 6/1/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 62           | 2.5.2   |
| iOS      | 63           | 2.5.2   |

### Release note:
feat: Improve UI UX, add the multiple player

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    [Builded] Version 2.5.2 - 62 / 2.5.2 - 63 _ Improve UI UX, add the multiple player

    **Store notices / What's new / Summary:**

    - **English:**  
        - Added multiplayer support for more engaging gameplay.  
        - Improved user interface for better visual experience.  
        - Enhanced overall app design and usability.

    - **Tiếng Việt:**  
        - Thêm hỗ trợ chơi nhiều người để trải nghiệm chơi game hấp dẫn hơn.  
        - Cải thiện giao diện người dùng để trải nghiệm hình ảnh tốt hơn.  
        - Nâng cao thiết kế và khả năng sử dụng tổng thể của ứng dụng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.2 --build-number=62 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.2 --build-number=63 --release```
    ```
    ---
    
---
## Released on: 6/1/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 63           | 2.5.23   |
| iOS      | 63           | 2.5.3   |

### Release note:
feat: feat: Implement opponent life updates and wrong tap animation via BLE communication.

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.23 - 63 / 2.5.3 - 63 _ Implement opponent life updates and wrong tap animation

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced multiplayer interaction with real-time opponent status updates.  
        - Added new visual feedback for gameplay actions.  
        - Improved overall stability and performance.

    - **Tiếng Việt:**  
        - Tăng cường tương tác trong chế độ nhiều người chơi với cập nhật trạng thái đối thủ thời gian thực.  
        - Thêm hiệu ứng hình ảnh mới cho các thao tác trong trò chơi.  
        - Cải thiện độ ổn định và hiệu suất tổng thể.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.23 --build-number=63 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.3 --build-number=63 --release```
    ```
---
## Released on: 21/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 64           | 2.5.24   |
| iOS      | 64           | 2.5.4   |

### Release note:
feat: Fixed timeout issue when adding items to Firestore.

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.24 - 64 / 2.5.4 - 64 _ Fixed data sync timeout issues

    **Store notices / What's new / Summary:**

    - **English:**  
        - Optimized data synchronization for better reliability.
        - General performance improvements and bug fixes.

    - **Tiếng Việt:**  
        - Tối ưu hóa đồng bộ hóa dữ liệu để tăng độ tin cậy.
        - Cải thiện hiệu suất và sửa lỗi tổng thể.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.24 --build-number=64 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.4 --build-number=64 --release```
    
---
## Released on: 22/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 65           | 2.5.5   |
| iOS      | 65           | 2.5.5   |

### Release note:
feat: Fixed timeout issue when adding items to Firestore.

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.5 - 65 / 2.5.5 - 65 _ Fixed data sync timeout issues

    **Store notices / What's new / Summary:**

    - **English:**  
        - Optimized data synchronization for better reliability.
        - General performance improvements and bug fixes.

    - **Tiếng Việt:**  
        - Tối ưu hóa đồng bộ hóa dữ liệu để tăng độ tin cậy.
        - Cải thiện hiệu suất và sửa lỗi tổng thể.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.5 --build-number=65 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.5 --build-number=65 --release```
---
## Released on: 26/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 66           | 2.5.6   |
| iOS      | 66           | 2.5.6   |

### Release note:
feat: Fixed bugs and improve UI

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.6 - 66 / 2.5.6 - 66 _ Fixed bugs and improve UI

    **Store notices / What's new / Summary:**

    - **English:**  
        - General performance improvements and bug fixes.

    - **Tiếng Việt:**  
        - Cải thiện hiệu suất và sửa lỗi tổng thể.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.6 --build-number=66 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.6 --build-number=66 --release```
---
## Released on: 26/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 67           | 2.5.7   |
| iOS      | 67           | 2.5.7   |

### Release note:
feat: Indicated your rank in the top score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.7 - 67 / 2.5.7 - 67 _ feat: Indicated your rank in the top score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View your current rank on the top score screen.

    - **Tiếng Việt:**  
        - Hiển thị thứ hạng của bạn trên màn hình bảng xếp hạng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.7 --build-number=67 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.7 --build-number=67 --release```
---
## Released on: 26/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 67           | 2.5.7   |
| iOS      | 67           | 2.5.7   |

### Release note:
feat: Indicated your rank in the top score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.7 - 67 / 2.5.7 - 67 _ feat: Indicated your rank in the top score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View your current rank on the top score screen.

    - **Tiếng Việt:**  
        - Hiển thị thứ hạng của bạn trên màn hình bảng xếp hạng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.7 --build-number=67 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.7 --build-number=67 --release```
    
---
## Released on: 26/01/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 68           | 2.5.8   |
| iOS      | 68           | 2.5.8   |

### Release note:
feat: Indicated your rank in the top score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`
    
    [Builded] Version 2.5.8 - 68 / 2.5.8 - 68 _ feat: Indicated your rank in the top score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View your current rank on the top score screen.

    - **Tiếng Việt:**  
        - Hiển thị thứ hạng của bạn trên màn hình bảng xếp hạng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.5.8 --build-number=68 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.5.8 --build-number=68 --release```
    
---
## Released on: 04/02/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 69           | 2.6.1   |
| iOS      | 69           | 2.6.1   |

### Release note:
feat: Indicated your rank, and able to set your rank in the top score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.6.1 - 69 / 2.6.1 - 69 _ feat: Indicated your rank, and able to set your rank in the top score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View and manage your rank on the top score screen.

    - **Tiếng Việt:**  
        - Xem và quản lý thứ hạng của bạn trên bảng xếp hạng.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.6.1 --build-number=69 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.6.1 --build-number=69 --release```
---
## Released on: 05/02/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 70           | 2.6.2   |
| iOS      | 70           | 2.6.2   |

### Release note:
feat: Indicated your rank, and able to set your rank in the top score screen, update UI

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.6.2 - 70 / 2.6.2 - 70 _ feat: Indicated your rank, and able to set your rank in the top score screen, update UI

    **Store notices / What's new / Summary:**

    - **English:**  
        - View and manage your rank on the top score screen with UI improvements.

    - **Tiếng Việt:**  
        - Xem và quản lý thứ hạng trên bảng xếp hạng cùng giao diện mới.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.6.2 --build-number=70 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.6.2 --build-number=70 --release```
    
---
## Released on: 06/02/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 71           | 2.7.1   |
| iOS      | 71           | 2.7.1   |

### Release note:
feat: Indicated your rank, and able to set your rank in the top score screen, update UI, update the instant score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.7.1 - 71 / 2.7.1 - 71 _ feat: Indicated your rank, and able to set your rank in the top score screen, update UI, update the instant score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View and manage your rank on the leaderboard with UI updates and an enhanced instant score screen.

    - **Tiếng Việt:**  
        - Xem và quản lý thứ hạng trên bảng xếp hạng, cập nhật giao diện và cải thiện màn hình điểm số tức thì.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.7.1 --build-number=71 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.7.1 --build-number=71 --release```
---
## Released on: 06/02/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 72           | 2.7.2   |
| iOS      | 72           | 2.7.2   |

### Release note:
feat: Indicated your rank, and able to set your rank in the top score screen, update UI, update the instant score screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.7.2 - 72 / 2.7.2 - 72 _ feat: Indicated your rank, and able to set your rank in the top score screen, update UI, update the instant score screen

    **Store notices / What's new / Summary:**

    - **English:**  
        - View and manage your rank on the leaderboard with UI updates and an enhanced instant score screen.

    - **Tiếng Việt:**  
        - Xem và quản lý thứ hạng trên bảng xếp hạng, cập nhật giao diện và cải thiện màn hình điểm số tức thì.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.7.2 --build-number=72 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.7.2 --build-number=72 --release```
    
---
## Released on: 01/03/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 73           | 2.7.3   |
| iOS      | 73           | 2.7.3   |

### Release note:
feat: Utilize the pick right mode

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

    [Builded] Version 2.7.3 - 73 / 2.7.3 - 73 _ feat: Utilize the pick right mode

    **Store notices / What's new / Summary:**

    - **English:**  
        - Experience the new "Pick Right" mode with optimized gameplay and performance.

    - **Tiếng Việt:**  
        - Trải nghiệm chế độ "Chọn Đúng" mới với lối chơi và hiệu suất được tối ưu hóa.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.7.3 --build-number=73 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.7.3 --build-number=73 --release```

    
---
## Released on: 02/03/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 74           | 2.7.4   |
| iOS      | 74           | 2.7.4   |

### Release note:
feat: Utilize the pick right mode

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

```markdown
    [Builded] Version 2.7.4 - 74 / 2.7.4 - 74 _ feat: Utilize the pick right mode

    **Store notices / What's new / Summary:**

    - **English:**  
        - Enhanced gameplay experience with the new Pick Right mode and performance improvements.

    - **Tiếng Việt:**  
        - Nâng cao trải nghiệm với chế độ Chọn Đúng mới và cải thiện hiệu suất.

    Flutter build for Android
    ```flutter build appbundle --build-name=2.7.4 --build-number=74 --release```

    Flutter build for iOS
    ```flutter build ios --build-name=2.7.4 --build-number=74 --release```
```
    
---
## Released on: 04/03/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 75           | 2.7.5   |
| iOS      | 75           | 2.7.5   |

### Release note:
feat: Update the UI of the game screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

```markdown
[Builded] Version 2.7.5 - 75 / 2.7.5 - 75 _ feat: Update the UI of the game screen

**Store notices / What's new / Summary:**

- **English:**  
    - Improved game screen UI for a more polished and intuitive user experience.

- **Tiếng Việt:**  
    - Cải thiện giao diện màn hình trò chơi để mang lại trải nghiệm người dùng tốt hơn.

Flutter build for Android
```flutter build appbundle --build-name=2.7.5 --build-number=75 --release```

Flutter build for iOS
```flutter build ios --build-name=2.7.5 --build-number=75 --release```
```
---
## Released on: 04/03/2026
### Version:
| Platform | Build Number | Version |
|----------|--------------|---------|
| Android  | 76           | 2.7.6   |
| iOS      | 76           | 2.7.6   |

### Release note:
feat: Update the UI of the game screen

### Git note release: 
#### Command for copilot

    Generate the message using the `Git message template`, `Store notices, what is news? sumarry and more general message, in vi and en, brief it short and summary, don't mention any things could make the concern by information security converning, which could be risk in Apple Store, and Play Store` , `Flutter build for Android`, `Flutter build for iOS`

```markdown
[Builded] Version 2.7.6 - 76 / 2.7.6 - 76 _ feat: Update the UI of the game screen

**Store notices / What's new / Summary:**

- **English:**  
    - Enhanced game screen UI for a more intuitive and seamless user experience.

- **Tiếng Việt:**  
    - Cập nhật giao diện màn hình trò chơi giúp trải nghiệm người dùng trực quan và mượt mà hơn.

Flutter build for Android
```flutter build appbundle --build-name=2.7.6 --build-number=76 --release```

Flutter build for iOS
```flutter build ios --build-name=2.7.6 --build-number=76 --release```
```
