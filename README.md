# Tanga iOS App
See Android version here: https://github.com/rygelouv/Tanga

---

![screenshots-tanga-min-1.png](images/screenshots-tanga-min-1.png)

---

## **We are 90% complete on the MVP** 🚀🚀
Here is our latest major additions:

* Tanga Account Deletion by @rygelouv in https://github.com/rygelouv/Tanga-iOS/pull/17
* Implemented support for Push Notifications by @rygelouv in https://github.com/rygelouv/Tanga-iOS/pull/15
* Implemented Apple Sign in by @rygelouv in https://github.com/rygelouv/Tanga-iOS/pull/11
* Added RevenueCat and implement support for subscription purchases by @rygelouv in https://github.com/rygelouv/Tanga-iOS/pull/9
* Build summary Audio Player by @rygelouv in https://github.com/rygelouv/Tanga-iOS/pull/7

The other projects can be found here:
- [Tanga Projects](https://github.com/rygelouv?tab=projects)

### What is remaining for the MVP?
* Implement Protected Actions (i.e listen to summary audio without a subscription or without an account)
* Add analytics tracker
* Enable Weekly summary
* Improve Error tracking

## Code organization
Tanga follows an MVVM architectural pattern in the implementation of most features. We use an observable ViewModel that emits variations of state elements. We also use a repository pattern on the 
data layer to access firebase firestore resources.
Note: some decision and aspect of the code and implementations could look a bit strange to pure iOS engineers because the main developer working on Tanga (me Rygel) has strong Kotlin/Android background. Feel free to prvovide feedback

![mvvm-screenshot.png](images/mvvm-screenshot.png)

## Infrastructure 
Tanga relies almost entirely on Firebase for its infrastructure. We use Firebase for:
- Authentication
- Firestore Database
- Analytics
- Crashlytics Error Tracking
- Remote Config for feature flags
- Performance Monitoring
- Messaging for push notifications
- Storage for images and other files such as audio and graphics

We also use Sentry for extra error tracking and monitoring (not added yet). We use RevenueCat for in-app purchases and subscriptions.

![tanga_infra_02.png](images/tanga_infra_02.png)

### Automation Infrastructure  work
We have left out many things since we are focusing on the MVP and getting the app out on the store to keep up wiht Android on a product standpoint.
- [ ] Add Unit tests
- [ ] Add full iOS build on Github Action workflow
- [ ] Add SwiftLint and/or other static code analysic tool
- [ ] Add SonarCloud
- [ ] Add dependabot
- [ ] Add Codecov for test coverage tracking - minor
- [ ] Add git hooks that run linting on each commit/push

## License
 Copyright 2025 Rygel Louv

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

