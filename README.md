# Nucatch with-bloc



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
## Released on: <today>
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