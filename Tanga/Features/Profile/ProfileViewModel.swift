//
//  ProfileViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var fullName: String?
    @Published var firstName: String?
    @Published var photoUrl: String?

    private var userRepository: UserRepository
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
    }
    
    func loadProfileData() {
        Task {
            let result = await userRepository.getUser(byId: sessionId)
            switch result {
            case .success(let user):
                print("Fetched user: \(user.fullName)")
                DispatchQueue.main.async {
                    self.fullName = user.fullName
                    self.firstName = user.firstName
                    self.photoUrl = user.photoUrl
                }
            case .failure(let error):
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        }
    }
}
