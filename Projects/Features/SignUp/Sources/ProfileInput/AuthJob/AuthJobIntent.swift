//
//  AuthJobIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/17/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore

//MARK: - Intent
class AuthJobIntent {
    private weak var model: AuthJobModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthJobModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthJobIntent {
    protocol Intentable {
        // content
        func onTapJobOccupation(selectedAllJobs: [JobOccupation], selectedJob: JobOccupation)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthJobIntent: AuthJobIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapJobOccupation(
        selectedAllJobs: [JobOccupation],
        selectedJob: JobOccupation
    ) {
        var result = selectedAllJobs
        if let index = result.firstIndex(where: { $0 == selectedJob }) {
            result.remove(at: index)
        } else {
            result.append(selectedJob)
        }
        fetchResult(result)
    }
    
    func fetchResult(_ resultJobs: [JobOccupation]) {
        model?.setSelectedJobArray(resultJobs)
    }
    
    func onTapNextButton() {
        Task {
            await pushNextView()
        }
    }
    
    @MainActor
    func pushNextView() {
        AppCoordinator.shared.push(.signUp(.authRegion))
    }
}
