//
//  DreamPartnerJobIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore
import Model

//MARK: - Intent
class DreamPartnerJobIntent {
    private weak var model: DreamPartnerJobModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: DreamPartnerJobModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension DreamPartnerJobIntent {
    protocol Intentable {
        // content
        func onTapJobOccupation(selectedAllJobs: [JobOccupation], selectedJob: JobOccupation)
        func onTapNextButton(state: DreamPartnerJobModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension DreamPartnerJobIntent: DreamPartnerJobIntent.Intentable {
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
    
    func onTapNextButton(state: DreamPartnerJobModel.Stateful) {
        Task {
            var payload = input.input
            payload.dreamPartner?.jobOccupations = state.selectedJobArray.map { $0.requestValue }
            await pushNextView(payload: payload)
        }
    }
    
    @MainActor
    func pushNextView(payload: SignUpFormDomain) {
        AppCoordinator.shared.push(.signUp(.dreamPartnerDistance(input: payload)))
    }
}
