//
//  ProfileViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//

import OSLog
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var fullName: String?
    @Published var firstName: String?
    @Published var photoUrl: String?
    @Published var profileStatus: UserProfileStatus?

    private var userRepository: UserRepository
    private var revenueCatController: RevenueCatController
    
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    init(userRepository: UserRepository = UserRepository(), revenueCatController: RevenueCatController) {
        self.userRepository = userRepository
        self.revenueCatController = revenueCatController
    }
    
    func observeSubscriberInfoChanges() {
        Task {
            await revenueCatController.observeCustomerInfo { subscriberInfo in
                guard let subsriberInfo = subscriberInfo else { return }
                
                if subsriberInfo.hasActiveSubscription {
                    DispatchQueue.main.async {
                        self.profileStatus = .premium
                    }
                } else {
                    DispatchQueue.main.async {
                        self.profileStatus = .loggedIn
                    }
                }
            }
        }
    }
    
    func loadProfileData() {
        Task {
            if sessionId.isEmpty {
                DispatchQueue.main.async {
                    self.fullName = "Anonymous"
                    self.firstName = "Anonymous"
                    self.profileStatus = .anonymous
                }
            } else {
                let result = await userRepository.getUser(byId: sessionId)
                switch result {
                case .success(let user):
                    Logger.profile.info("Fetched user: \(user.fullName)")
                    DispatchQueue.main.async {
                        self.fullName = user.fullName
                        self.firstName = user.firstName
                        self.photoUrl = user.photoUrl
                    }
                    observeSubscriberInfoChanges()
                case .failure(let error):
                    Logger.profile.error("Failed to fetch user: \(error.localizedDescription)")
                }
            }
        }
    }
}

enum UserProfileStatus {
    case anonymous
    case loggedIn
    case premium
}
